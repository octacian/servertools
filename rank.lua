-- servertools/rank.lua
-- variables
local modpath = servertools.modpath -- modpath pointer
local worldpath = minetest.get_worldpath() -- get worldpath
local rankDB = worldpath.."/rank.db" -- rankDB path
dofile(modpath.."/config.txt")

-- create rankDB file
if datalib.exists(rankDB) == false then
  datalib.create(rankDB)
end

-- read files
datalib.dofile(modpath.."/rank.conf")
local mem = datalib.table.read(rankDB)
-- if not mem, create blank table
if not mem or type(mem) ~= "table" then mem = {} end

-- FUNCTIONS
-- get rank
function servertools.get_player_rank(name)
  -- find rank entry
  for _,i in ipairs(mem) do
    if i.name == name then return i.rank end
  end
end

-- get rank privileges
function servertools.get_rank_privs(rank)
  for _, i in ipairs(st.ranks) do
    if i.name == rank then
      return i.privs
    end
  end
end

-- get rank level
function servertools.get_rank_level(rank)
  for _,i in ipairs(st.ranks) do -- find rank
    if i.name == rank then
      return i.level -- return level
    end
  end
end

-- get highest rank level
function servertools.get_rank_high(list)
  local high = 0 -- high variable
  for _,i in ipairs(st.ranks) do -- iterate through st.ranks
    if i.level > high then high = i.level end -- if level is greater than high, set high to value of level
  end
  return high -- return high value
end

-- get rank value
function servertools.get_rank_value(rank, value)
  for _,i in ipairs(st.ranks) do -- find rank
    if i.name == rank then
      -- if value exists, return
      if i[value] then return i[value] end -- return value
    end
  end
end

-- does rank have capability to
function servertools.player_can(player, capability)
  -- find rank entry
  for _,i in ipairs(st.ranks) do
    if i.name == servertools.get_player_rank(player) then
      -- if i.can and i.can is table, find capability entry
      if i.can and type(i.can) == "table" then
        for _,i in pairs(i.can) do
          if i == capability then return true end -- player can
        end
      end
    end
  end
end

-- update nametag
function servertools.update_nametag(name)
  local player = minetest.get_player_by_name(name) -- get player obj

  local rank = servertools.get_player_rank(name) -- get rank
  local prefix = servertools.get_rank_value(rank, 'prefix') -- get prefix
  local colour = servertools.get_rank_value(rank, 'colour') -- get colour

  local function getColour()
    if not colour then return "#ffffff"
    else return colour end
  end

  if not rank then return false end
  if not prefix then local prefix = ""
  else prefix = prefix.." " end

  local colour = getColour()

  player:set_nametag_attributes({
    color = colour,
    text = prefix..name,
  })
end

-- set rank
function servertools.set_player_rank(from, name, newrank)
  -- check params
  if not servertools.get_player_rank(name) then
    return "Invalid player ("..name..")"
  elseif not newrank then
    return "New rank field required."
  end

  local rank_privs = servertools.get_rank_privs(newrank) -- get rank privileges
  -- check that rank exists
  if not rank_privs or type(rank_privs) ~= "table" then
    return "Rank nonexistent."
  end

  -- define variables for next operation
  local from_rank = servertools.get_player_rank(from)
  local from_level = servertools.get_rank_level(from_rank)
  local new_level = servertools.get_rank_level(newrank)
  local level_high = servertools.get_rank_high()
  -- check level
  if from_level < new_level and from_level ~= level_high then
    return "You cannot set the rank of "..name.." to a rank of higher level than your own."
  elseif from_level == new_level and from_level ~= level_high then
    return "You cannot set the rank of "..name.." to your own."
  end

  -- update player privileges
  if minetest.set_player_privs(name, rank_privs) then return "Failed to set privileges." end -- unsuccessful
  -- update nametag
  servertools.update_nametag(name)
  -- update database
  for _, i in ipairs(mem) do
    if i.name == name then -- find in rankDB
      i.rank = newrank -- set new rank value
      datalib.table.write(rankDB, mem) -- write updated table
      servertools.log(name.."'s rank set to "..newrank..".")
    end
  end
end

-- MINETEST EVENTS
-- on prejoin
minetest.register_on_prejoinplayer(function(name, ip)
  -- if not ranked, rank
  if not servertools.get_player_rank(name) then
    local rank -- define rank for later use
    if name == minetest.setting_get("name") then rank = "owner" else rank = st.ranks.default end -- set default rank
    local insert = { name = name, rank = rank } -- data in proper format for insertion
    table.insert(mem, insert) -- insert data
    datalib.table.write(rankDB, mem) -- write table
    servertools.log("Giving new player "..name.." the "..rank.." rank.") -- log
  end

  -- check that the player has all privileges in their rank
  for _, i in ipairs(mem) do
    if i.name == name then -- find in rankDB
      local privs = minetest.get_player_privs(name) -- get privileges
      local player_rank = servertools.get_player_rank(name) -- get rank
      local has, missing_privs = minetest.check_player_privs(name, servertools.get_rank_privs(player_rank)) -- check privs
      -- if missing privs, grant
      if missing_privs ~= "" then
        for _,i in pairs(missing_privs) do -- grant each missing priv
          privs[i] = true
        end
        minetest.set_player_privs(name, privs) -- update privs
        servertools.log("Granting "..name.." of rank "..player_rank.." missing privileges: "..dump(missing_privs)) -- log
      end
    end
  end
end)

-- on join (nametag)
minetest.register_on_joinplayer(function(player)
  servertools.update_nametag(player:get_player_name()) -- update nametag
end)

-- on chat message
if rank_chat == true then
  minetest.register_on_chat_message(function(name, message)
    -- ignore chatcommands
    if message:sub(1, 1) ~= "/" then
      local players = {} -- players table
      local p1 = minetest.get_connected_players() -- get players
      -- get player names
      for _,i in pairs(p1) do
        local player = i:get_player_name() -- get player name
        -- if not player who triggered call back, insert name record
        if player ~= name then
          table.insert(players, player) -- insert record
        end
      end

      local rank = servertools.get_player_rank(name) -- get rank
      local prefix = servertools.get_rank_value(rank, 'prefix') -- get prefix
      local colour = servertools.get_rank_value(rank, 'colour') -- get prefix
      if not prefix or prefix == '' then prefix = nil end -- check prefix

      -- send message
      if prefix and colour then
        -- send message to players
        for _,i in pairs(players) do
          minetest.chat_send_player(i, core.colorize(colour, prefix).." <"..name.."> "..message)
        end
      elseif prefix and not colour then
        -- send message to players
        for _,i in pairs(players) do
          minetest.chat_send_player(i, prefix.." <"..name.."> "..message)
        end
      elseif not prefix and not colour then
        return false -- show message normally
      end

      return true -- prevent message from being shown
    end
  end)
end

-- COMMANDS
-- /rank
minetest.register_chatcommand("rank", {
  description = "Set / Get Player Rank.",
  params = "/rank <player> <newrank> | player username (returns rank without <newrank>), rank to give player.",
  func = function(name, param)
    local target, newrank = string.match(param, "^([^ ]+) *(.*)$") -- separate
    -- check params
    if target and newrank == "" then newrank = nil end
    -- if player can set rank, give advanced functionality
    if servertools.player_can(name, "setrank") then
      -- if not newrank, return rank
      if target and not newrank then
        local rank = servertools.get_player_rank(target)
        -- if not rank, return error
        if not rank then
          return false, "Invalid player ("..target..")"
        else
          return true, target.." is ranked as a "..rank.."."
        end
      elseif not newrank and not target then -- if no newrank and target given, return current player rank
        return true, "You are ranked as a "..servertools.get_player_rank(name).."."
      elseif newrank and not target then -- if newrank and no target, require target
        return true, "Please enter a valid target username and new rank."
      elseif newrank and target then -- if fields available, continue operation
        -- if new rank does not exist, return error
        local set_rank = servertools.set_player_rank(name, target, newrank)
        if set_rank then -- if unsuccessful, return error
          return false, set_rank
        else -- else, return success message
          return true, target.."'s rank set to "..newrank.."."
        end
      end
    else -- else, limit functionality
      if target and newrank then
        local missing
        if not servertools.player_can("getrank") then missing = "getrank, setrank" else missing = "setrank" end
        return false, "You don't have the rankPriv to execute this command. (missing: "..missing..")"
      elseif not target and newrank then
        return false, "Please enter a target player."
      elseif target and not newrank then
        if servertools.player_can("getrank") then
          return true, target.." is ranked as a "..servertools.get_player_rank(target).."."
        else
          return false, "You don't have the rankPriv to execute this command. (missing: getrank)"
        end
      elseif not target and not newrank then
        return true, "You are ranked as a "..servertools.get_player_rank(name).."."
      end
    end
  end,
})

-- rank-specific commands
if rank_specific_commands == true then
  for _,i in ipairs(st.ranks) do
    -- if command specified, register
    if i.cmd then
      -- register
      minetest.register_chatcommand(i.cmd, {
        description = "Set player rank to "..i.name..".",
        params = "<player>",
        func = function(name, param)
          -- if player can set rank, move on
          if servertools.player_can(name, "setrank") then
            -- if not param, return usage
            if not param then return "Usage: /"..i.cmd.." <player>" end
            -- if error while setting rank, return message
            local set_rank = servertools.set_player_rank(name, param, i.name)
            if set_rank then
              return false, set_rank
            else -- else, return success message
              return true, param.."'s rank set to "..i.name.."."
            end
          else
            local missing
            if not servertools.player_can("getrank") then missing = "getrank, setrank" else missing = "getrank" end
            return false, "You don't have the rankPriv to execute this command. (missing: "..missing..")"
          end
        end,
      })
    end
  end
end
