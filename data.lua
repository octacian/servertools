-- mods/servertools/data.lua
-- data storage api

-- global path variables
servertools.worldpath = minetest.get_worldpath() -- worldpath
servertools.datapath = servertools.worldpath.."/servertools" -- path for general servertools data
-- local path variables
local modpath = servertools.modpath
local worldpath = servertools.worldpath
local datapath = servertools.datapath

-- check if servertools world folder exists
function servertools.initdata()
  local f = io.open(datapath)
  if not f then
    if minetest.mkdir then
      minetest.mkdir(datapath) -- create directory if minetest.mkdir is available
      return
    else
      os.execute('mkdir "'..datapath..'"') -- create directory with os mkdir command
      return
    end
  end
  f:close() -- close file
end

servertools.initdata() -- initialize world data directory

-- check if file exists
function servertools.check_file(path)
  local f = io.open(path, "r") -- open file
  if f ~= nil then f:close() return true else return false end
end

-- create file
function servertools.create_file(path)
  -- check if file already exists
  if servertools.check_file(path) == true then
    servertools.log("File ("..path..") already exists.") -- log
    return true -- exit and return
  end
  local f = io.open(path, "w") -- create file
  f:close() -- close file
  servertools.log("Created file "..path) -- log
end

-- write to file
function servertools.write_file(path, data, serialize)
  if not serialize then local serialize = true end -- if blank serialize = true
  local f = io.open(path, "w") -- open file for writing
  if serialize == true then local data = minetest.serialize(data) end -- serialize data
  f:write(data) -- write data
  f:close() -- close file
  servertools.log('Wrote "'..data..'" to '..path) -- log
end

-- load file
function servertools.load_file(path, deserialize)
  if not deserialize then local deserialize = true end -- if blank deserialize = true
  local f = io.open(path, "r") -- open file for reading
  local data = f:read() -- read and store file data in variable data
  if deserialize == true then local data = minetest.deserialize(data) end -- deserialize data
  return data -- return file contents
end

-- write table to file
function servertools.write_table(path, table)
  local table = minetest.serialize(table) -- serialize table
  local f = io.open(path, "w") -- open file for writing
  f:write(table) -- write table
  f:close() -- close file
  servertools.log("Wrote table to "..path)
end

-- load table from file
function servertools.load_table(path)
  local f = io.open(path, "r") -- open file for reading
  local table = minetest.deserialize(f:read()) -- deserialize and read table
  f:close() -- close file
  return table
end

-- dofile
function servertools.dofile(path)
  -- check if file exists
  if servertools.check_file(path) == true then
    dofile(path)
    return true -- return true, successful
  else
    servertools.log("File "..path.." does not exist.")
    return false -- return false, unsuccessful
  end
end
