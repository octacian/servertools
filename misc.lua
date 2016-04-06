function clearinventory(name, param)
	if param == nil or param == "" then
		local playername = minetest.env:get_player_by_name(name)
		local inventory = {}
		playername:get_inventory():set_list("main", inventory)
		print(name.." has cleared his inventory.")
		minetest.chat_send_player(name, 'Inventory Cleared!')
	return
elseif minetest.check_player_privs(name, {admin=true}) then
		local playername = minetest.env:get_player_by_name(param)
		local inventory = {}
		playername:get_inventory():set_list("main", inventory)
		print(name.." has cleared " ..param.."'s inventory.")
		minetest.chat_send_player(name, 'Inventory Cleared!')
	return
	else
		minetest.chat_send_player(name, 'You do not have the priveleges necessary to clear another\'s inventory')
		return false;
	end
end
minetest.register_chatcommand('clear',{
	description = 'Clear your inventory.',
	params = "<playername> | name of player (optional)",
	privs = {},
	func = clearinventory
})

--Heal command
minetest.register_chatcommand('heal',{
	description = 'Restore full health to anyone.',
	privs = {heal = true},
	func = function(name, param)

	--Check if sender wants to heal someone other than himself
	if param == "" or param == nil then

		--If he dosn't, heal the sender
		local player = minetest.env:get_player_by_name(name)
		player:set_hp(20)
		minetest.chat_send_player(name, "You have been healed.")
	else
		--If he is healing someone else, check and see if that someone exists.
		local player = minetest.env:get_player_by_name(param)
		if player == "" or player == nil then
			minetest.chat_send_player(name, "Invalid player name!")
		else
			--If player exists, set his HP to 20 and notify him and the sender.
			player:set_hp(20)
			minetest.chat_send_player(param, "You have been healed.")
			minetest.chat_send_player(name, "You have healed "..param.."")
		end
	end
end
})

--Time commands. I won't document these. Figure them out yourself :P
minetest.register_chatcommand("morning",{
	params = "",
	privs = {settime = true},
	description = "Set time to morning",
	func = function(name, param)
		local player = minetest.env:get_player_by_name(name)
		if not player then
			return
		end
		minetest.env:set_timeofday(0.2)
	end,
})
minetest.register_chatcommand("noon",{
	params = "",
	privs = {settime = true},
	description = "Set time to noon",
	func = function(name, param)
		local player = minetest.env:get_player_by_name(name)
		if not player then
			return
		end
		minetest.env:set_timeofday(0.5)
	end,
})
minetest.register_chatcommand("evening",{
	params = "",
	privs = {settime = true},
	description = "Set time to evening",
	func = function(name, param)
		local player = minetest.env:get_player_by_name(name)
		if not player then
			return
		end
		minetest.env:set_timeofday(0.77)
	end,
})
minetest.register_chatcommand("night",{
	params = "",
	privs = {settime = true},
	description = "Set time to night",
	func = function(name, param)
		local player = minetest.env:get_player_by_name(name)
		if not player then
			return
		end
		minetest.env:set_timeofday(0)
	end,
})

print("[Server_Tools] Miscellaneous Module Loaded")
