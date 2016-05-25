-- mods/server_tools/functions.lua

-- Clear Inventory
function clearinventory(name, param)
	if param == nil or param == "" then
		local playername = minetest.env:get_player_by_name(name)
		local inventory = {}
		playername:get_inventory():set_list("main", inventory)
		minetest.log("action", "[Server_Tools] "..name.." cleared their inventory.") --print to log
		minetest.chat_send_player(name, 'Inventory Cleared!')
	return
elseif minetest.check_player_privs(name, {admin=true}) then
	--If he is healing someone else, check and see if that someone exists.
	local player = minetest.env:get_player_by_name(param)
	if player == "" or player == nil then
		minetest.chat_send_player(name, "Invalid player!")
		minetest.log("action", "[Server_Tools] "..name.." attempted to clear the inventory of invalid player "..param) --print to log
	else
		local playername = minetest.env:get_player_by_name(param)
		local inventory = {}
		playername:get_inventory():set_list("main", inventory)
		minetest.log("action", "[Server_Tools] "..name.." cleared "..param.."'s inventory.")
		minetest.chat_send_player(name, param.."'s Inventory has been Cleared!")
	return
	end
	else
		minetest.chat_send_player(name, "You have insufficient privileges to clear "..param.."'s inventory.")
		minetest.log("action", "[Server_Tools] "..name.." tried to clear "..param.."'s inventory with insufficient privileges.") --print to log
		return false;
	end
end

-- Update Block
function server_tools.update_node(name, param, x, y, z)
  -- variables
  local player = minetest.get_player_by_name(name) -- player name
	local item_string_type = minetest.registered_items[param].type -- item string type
	-- confirm node param
	if minetest.registered_items[param] == nil or minetest.registered_items[param] == "" then
		minetest.chat_send_player(name, "Invalid item string. Please try again.") --print to chat
		minetest.log("action", "[Server_Tools] "..name.." tried to update a node with invalid item string: "..param) --print to log
	else
		-- make sure item string is not a craftitem of tool
		if item_string_type == "tool" or item_string_type == "craftitem" then
			minetest.chat_send_player(name, "Item string cannot be a "..item_string_type) --print to chat
			minetest.log("action", "[Server_Tools] "..name.." tried to update a node to "..item_string_type) --print to log
		else
			-- confirm position params
		  if x == "" or x == nil or y == "" or z == nil or z == "" or z == nil then
		    -- print error to chat and log
		    minetest.chat_send_player(name, "Invalid position coordinates. Please try again.") -- print to chat
		    minetest.log("action", "[Server_Tools] "..name.." tried to update a node using invalid coordinates, "..x..", "..y..", "..z..".") --print to log
		  else
		    -- update node
				minetest.set_node({x = x, y = y, z = z}, {name = param})
		  end
		end
	end
end
