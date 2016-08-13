-- servertools/rank.lua
-- variables
local modpath = servertools.modpath

-- read files
datalib.dofile(modpath.."/rank.conf")
local mem = datalib.table.read(modpath.."/rank.db")

-- FUNCTIONS
-- get rank
function servertools.get_player_rank(name)
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

-- MINETEST EVENTS
-- on prejoin
minetest.register_on_prejoinplayer(function(name, ip)
  -- if not ranked, rank
  if not servertools.get_player_rank(name) then
    local rank -- define rank for later use
    if name == minetest.setting_get("admin") then rank = "owner" else rank = st.ranks.default end -- set default rank
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
  for _,i in ipairs(mem) do
    if i.name == name then
      for _,i2 in ipairs(st.ranks) do
        if i.rank == i2.name then
          if i2.prefix ~= "" and i2.colour then
            minetest.chat_send_all(core.colorize(i2.colour, i2.prefix).." <"..name.."> "..message)
          elseif i2.prefix ~= "" and not i2.colour or i2.colour == "" then
            minetest.chat_send_all(i2.prefix.." <"..name.."> "..message)
          else
            minetest.chat_send_all("<"..name.."> "..message)
          end
        end
        break -- exit loop
      end
    end
    break -- exit loop
  end
  return true -- prevent message from being shown
end)
