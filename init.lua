server_tools = {}
local modpath = minetest.get_modpath("server_tools")
-- Load Modules
dofile(modpath.."/functions.lua")
dofile(modpath.."/privs.lua")
dofile(modpath.."/genesis.lua")
dofile(modpath.."/misc.lua")

minetest.log("action", "[Server_Tools] Enabled Modules Loaded!") --print to log enabled modules loaded
