-- mods/servertools/data.lua
-- data storage api

-- path variables
servertools.modpath = minetest.get_modpath(modname) -- modpath
servertools.worldpath = minetest.get_worldpath(modname) -- worldpath
servertools.datapath = worldpath.."/servertools" -- path for general servertools data

-- check if servertools world folder exists
function servertools.initdata()
  local f = io.open(datapath)
  if not f then
    if minetest.mkdir then
      minetest.mkdir(datapath) -- create directory if minetest.mkdir is available
    else
      os.execute('mkdir "'..datapath..'"') -- create directory with os mkdir command
    end
  end
  f:close() -- close file
end

-- check if file exists
function servertools.check_file(name, path)
  local f = io.open(path.."/"..name, "r") -- open file
  if f ~= nil then io.close(f) return true else return false end
end

-- create file
function servertools.create_file(name, path)
  -- check if file already exists
  if st.check_file(path.."/"..name) == true then
    st.log("File ("..path.."/"..name..") already exists.") -- log
    return true -- exit and return
  end
  local f = io.open(name, "w") -- create file
  f:close() -- close file
  st.log("Created file "..path.."/"..name) -- log
end

-- write to file
function servertools.write_file(data, name, path, serialize)
  local f = io.open(..path.."/"..name, "w") -- open file for writing
  if serialize == true then local data = minetest.serialize(data) end -- serialize data
  f:write(data) -- write data
  f:close() -- close file
  st.log('Wrote "'..data..'" to '..path.."/"..name) -- log
end

-- load file
function servertools.load_file(name, path, deserialize)
  local f = io.open(..path.."/"..name, "r") -- open file for reading
  local data = f:read() -- read and store file data in variable data
  if deserialize == true then local data = minetest.deserialize(data) end -- deserialize data
  return data -- return file contents
end

-- dofile
function servertools.dofile(name, path)
  -- check if file exists
  if servertools.check_file(name, path) == true then
    dofile(..path.."/"..name)
    return true -- return true, successful
  else
    st.log("File "..path.."/"..name.." does not exist."
    return false -- return false, unsuccessful
  end
end
