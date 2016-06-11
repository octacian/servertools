-- mods/servertools/functions.lua

-- Clear Inventory
function servertools.clearinv(name, param)
	if param == nil or param == "" then
		local playername = minetest.get_player_by_name(name)
		local inventory = {}
		playername:get_inventory():set_list("main", inventory)
		minetest.log("action", "[ServerTools] "..name.." cleared their inventory.") --print to log
		minetest.chat_send_player(name, 'Inventory Cleared!')
	return
elseif minetest.check_player_privs(name, {servertools=true}) then
	--If he is healing someone else, check and see if that someone exists.
	local player = minetest.get_player_by_name(param)
	if player == "" or player == nil then
		minetest.chat_send_player(name, "Invalid player!")
		minetest.log("action", "[ServerTools] "..name.." attempted to clear the inventory of invalid player "..param) --print to log
	else
		local playername = minetest.get_player_by_name(param)
		local inventory = {}
		playername:get_inventory():set_list("main", inventory)
		minetest.log("action", "[ServerTools] "..name.." cleared "..param.."'s inventory.")
		minetest.chat_send_player(name, param.."'s Inventory has been Cleared!")
	return
	end
	else
		minetest.chat_send_player(name, "You have insufficient privileges to clear "..param.."'s inventory.")
		minetest.log("action", "[ServerTools] "..name.." tried to clear "..param.."'s inventory with insufficient privileges.") --print to log
		return false;
	end
end

-- Update Block
function servertools.update_node(name, param)
  -- variables
  local player = minetest.get_player_by_name(name) -- player name
	local node, p = string.match(param, "^([^ ]+) *(.*)$")
	local p = minetest.string_to_pos(p)

	-- confirm node param
	if minetest.registered_items[node] == nil then
		minetest.chat_send_player(name, "Please enter a valid item string.") --print to chat
		minetest.log("action", "[ServerTools] "..name.." tried to update a node with an invalid item string.") --print to log
	else
		local item_string_type = minetest.registered_items[node].type -- item string type
		-- make sure item string is not a craftitem or tool
		if item_string_type == "tool" or item_string_type == "craft" then
			minetest.chat_send_player(name, "Item string is of invalid type "..item_string_type..".") --print to chat
			minetest.log("action", "[ServerTools] "..name.." tried to update to "..item_string_type..".") --print to log
		else
			if p == nil or p == "" then
				minetest.chat_send_player(name, "Please enter valid coordinates.") --print to chat
				minetest.log("action", "[ServerTools] "..name.." tried to update a node with invalid coordinates.") --print to log
				return
			end
			-- confirm position params
		  if p.x == nil or p.y == nil or p.y == nil or p.z == nil then
		    -- print error to chat and log
		    minetest.chat_send_player(name, "Please enter valid coordinates.") -- print to chat
		    minetest.log("action", "[ServerTools] "..name.." tried to update a node with invalid coordinates.") --print to log
		  else
		    -- update node
				minetest.set_node(p, {name = node})
		  end
		end
	end
end

minetest.log("action", "[ServerTools] Functions Loaded!") -- print to log
