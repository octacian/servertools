server_tools = {}

-- Load Modules
dofile(minetest.get_modpath("server_tools").."/privs.lua")
dofile(minetest.get_modpath("server_tools").."/genesis.lua")
dofile(minetest.get_modpath("server_tools").."/misc.lua")

minetest.log("action", "[Server_Tools] Enabled Modules Loaded!") --print to log enabled modules loaded
