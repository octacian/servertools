servertools = {}
local modpath = minetest.get_modpath("servertools")
-- Load Modules
dofile(modpath.."/functions.lua")
dofile(modpath.."/privs.lua")
dofile(modpath.."/genesis.lua")
dofile(modpath.."/misc.lua")
dofile(modpath.."/filter.lua")

minetest.log("action", "[ServerTools] Enabled Modules Loaded!") --print to log enabled modules loaded
