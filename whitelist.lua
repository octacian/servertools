-- servertools/whitelist.lua
-- variables
local modpath = servertools.modpath -- modpath pointer
local data = datalib.datapath -- datapath pointer
local whitelistDB = datalib.worldpath.."/whitelist.db" -- whitelistDB path
local whitelist = {}

-- [function] check conf
function servertools.whitelist_checkconf()
  dofile(data.."/servertools.txt") -- load servertools worldconfig

  -- if whitelist is not true in worldconfig, end
  if whitelist == false then
    servertools.log("Whitelist module NOT loaded, disabled in world conf.")
    return false
  end
end
if servertools.whitelist_checkconf() == false then return false end

-- [function] load whitelist
function servertools.whitelist_load()
  -- if whitelistDB does not exist, create
  if datalib.exists(whitelistDB) == false then
    datalib.create(whitelistDB)
  else -- else, read
    local res = datalib.table.read(whitelistDB) -- read table
    if type(res) == "table" and res ~= whitelist then whitelist = res end
  end
end
servertools.whitelist_load() -- load

-- [function] save whitelist
function servertools.whitelist_save()
  if whitelist then -- if whitelist is populated, write
    datalib.table.write(whitelistDB, whitelist)
  end
end
minetest.register_on_shutdown(servertools.whitelist_save)

-- [privilege] whitelist
minetest.register_privilege("whitelist", "Permission to add/remove players from whitelist.")

-- [function] is whitelisted
function servertools.is_whitelisted(name)
  for _,i in ipairs(whitelist) do -- loop
    if name == i.name then return true end -- find entry
  end
end

-- [function] get whitelist
function servertools.get_whitelist(list_type)
  if list_type == "text" then -- if text list requested, continue
    local list -- list
    local count -- count

    -- loop
    for _,i in ipairs(whitelist) do
      if _ == 1 then list = i.name
      else list = list..", "..i.name
      end
      count = _
    end

    return list, count -- return data
  else -- else, provide table-list
    return whitelist
  end
end

-- [function] whitelist
function servertools.whitelist(name)
  -- if player is already whitelisted, return message
  if servertools.is_whitelisted(name) then return name.." is already whitelisted." end
  local insert = { name = name } -- data for insertion
  table.insert(whitelist, insert) -- insert data
  servertools.whitelist_save() -- save whitelist
  return name.." has been whitelisted."
end

-- [function] unwhitelist
function servertools.unwhitelist(name)
  -- if player not whitelisted, return message
  if not servertools.is_whitelisted(name) then return name.." is already not whitelisted." end
  -- enter loop
  for _,i in ipairs(whitelist) do
    -- find entry
    if name == i.name then
      whitelist[_] = nil -- remove entry
      servertools.whitelist_save() -- save whitelist
      return name.." removed from whitelist." -- return success
    end
  end
end

-- [event] projoinplayer
minetest.register_on_prejoinplayer(function(name)
  -- if admin and not already whitelisted, whitelist
  if name == minetest.setting_get("name") then
    servertools.whitelist(name)
    return -- allow player to join
  end
  servertools.log("name: "..name..", MTname: "..minetest.setting_get("name"))

  -- if whitelisted, allow connection
  if servertools.is_whitelisted(name) then return end

  -- return false to block connections
  return "You are not on the server whitelist. Please contact the administrator to request access."
end)

-- [command] whitelist
minetest.register_chatcommand("whitelist", {
  privs = { whitelist = true },
  description = "Whitelist a player.",
  params = "/whitelist <player> | player username",
  func = function(name, param)
    if not param or param == "" then return true, "Invalid player." end -- check if player name is valid

    -- whitelist player
    local res = servertools.whitelist(param)
    return true, res
  end,
})

-- [command] unwhitelist
minetest.register_chatcommand("unlist", {
  privs = { whitelist = true },
  description = "Remove player from whitelist.",
  params = "/unlist <player> | player username",
  func = function(name, param)
    if not param or param == "" then return "Invalid player." end -- check if player name is valid

    -- kick if logged on
    for _,player in ipairs(minetest.get_connected_players()) do
      local name = player:get_player_name()
      if name == param then
        minetest.kick_player(name, "You have been removed from the server whitelist. Please contact the server owner to request changes.")
      end
    end

    -- remove from whitelist
    local res = servertools.unwhitelist(param)
    return true, res
  end,
})

-- [command] show whitelist
minetest.register_chatcommand("showlist", {
  description = "Show whitelisted players.",
  func = function(name)
    return true, "Whitelisted Players: "..servertools.get_whitelist("text")
  end,
})

servertools.log("Whitelist Module Loaded") -- print to log module loaded
