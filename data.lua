-- mods/servertools/data.lua
-- data storage api

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

-- check for path
local function check_path(name, path)
  if path then name = path.."/"..name else name = modpath.."/"..name end
  return name -- return completed name
end

-- check if file exists
function servertools.check_file(name, path)
  check_path(name, path) -- check path
  local f = io.open(name, "r") -- open file
  if f ~= nil then io.close(f) return true else return false end
end

-- create file
function servertools.create_file(name, path)
  check_path(name, path) -- check path
  -- check if file already exists
  if st.check_file(name) == true then
    st.log("File ("..name..") already exists.") -- log
    return true -- exit and return
  end
  local f = io.open(name, "w") -- create file
  f:close() -- close file
  st.log("Created file "..name) -- log
end

-- write to file
function servertools.write_file(data, name, path)
  check_path(name, path) -- check path
  local f = io.open(name, "w") -- open file for writing
  minetest.serialize(data) -- serialize data
  f:write(data) -- write data
  f:close() -- close file
  st.log('Wrote "'..data..'" to '..name) -- log
end

-- load file
function servertools.load_file(name, path)
  check_path(name, path) -- check path
  local f = io.open(name, "r") -- open file for reading
  local data = f:read() -- read and store file data in variable data
  minetest.deserialize(data)
  return data -- return file contents
end

-- dofile
function servertools.dofile(name, path)
  -- check if file exists
  if servertools.check_file(name, path) == true then
    dofile(path..name)
    return true -- return true, successful
  else
    st.log("File"..path.."/"..name.." does not exist."
    return false -- return false, unsuccessful
  end
end
