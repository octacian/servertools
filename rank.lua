-- servertools/rank.lua
-- variables
local modpath = servertools.modpath

-- read files
datalib.dofile(modpath.."/rank.conf")
local mem = datalib.table.read(modpath.."/rank.db")
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

-- set rank
function servertools.set_player_rank(name, newrank)
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

  -- update player privileges
  if minetest.set_player_privs(name, rank_privs) then return "Failed to set privileges." end -- unsuccessful
  -- TODO: fix setting table value
  -- update database
  for _, i in ipairs(mem) do
    if i.name == name then -- find in rankDB
      i.rank = newrank -- set new rank value
      datalib.table.write(modpath.."/rank.db", mem) -- write updated table
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
    datalib.table.write(modpath.."/rank.db", mem) -- write table
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


-- on chat message
minetest.register_on_chat_message(function(name, message)
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
end)

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
        local set_rank = servertools.set_player_rank(target, newrank)
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
          local set_rank = servertools.set_player_rank(param, i.name)
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
