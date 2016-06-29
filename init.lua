-- global variables
servertools = {}
st = servertools -- shortcut for servertools functions and variables
-- global path variables
servertools.modpath = minetest.get_modpath("servertools") -- modpath
-- local variables
local modpath = servertools.modpath

-- logger
function servertools.log(content, log_type)
  if log_type == nil then log_type = "action" end
  minetest.log(log_type, "[ServerTools] "..content)
end

-- load default modules
dofile(modpath.."/data.lua")
dofile(modpath.."/functions.lua")
dofile(modpath.."/privs.lua")

dofile(modpath.."/genesis.lua")
dofile(modpath.."/misc.lua")
dofile(modpath.."/filter.lua")

minetest.log("action", "[ServerTools] Enabled Modules Loaded!") --print to log enabled modules loaded
