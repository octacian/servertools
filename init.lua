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
dofile(modpath.."/functions.lua")
dofile(modpath.."/privs.lua")
dofile(modpath.."/nodes.lua")

-- read config
datalib.dofile(modpath.."/config.txt")

-- optional modules
if genesis == true then dofile(modpath.."/genesis.lua") end
if misc == true then dofile(modpath.."/misc.lua") end
if filter == true then dofile(modpath.."/filter.lua") end
if rank == true then dofile(modpath.."/rank.lua") end
if whitelist == true then dofile(modpath.."/whitelist.lua") end

servertools.log("Enabled Modules Loaded") --print to log enabled modules loaded
