-- global variables
servertools = {}
st = servertools -- shortcut for servertools functions
servertools.modname = minetest.get_current_modname() -- modname

-- logger
function servertools.log(content, log_type)
  if log_type == nil then log_type = "action" end
  minetest.log(log_type, "[ServerTools] "..content)
end

-- load modules
dofile(modpath.."/functions.lua")
dofile(modpath.."/privs.lua")
dofile(modpath.."/genesis.lua")
dofile(modpath.."/misc.lua")
dofile(modpath.."/data.lua")

minetest.log("action", "[ServerTools] Enabled Modules Loaded!") --print to log enabled modules loaded
