-- [CHAT COMMAND] Clear Inventory - /clear
minetest.register_chatcommand("clear", {
	description = 'Clear your inventory.',
	params = "<playername> | name of player (optional)",
	privs = {},
	func = clearinventory
})

-- [CHAT COMMAND] Heal - /heal param
minetest.register_chatcommand("heal", {
	description = "Restore full health to anyone.",
	privs = {heal = true},
	func = function(name, param)
	--Check if sender wants to heal someone other than himself
	if param == "" or param == nil then
		--If he dosn't, heal the sender
		local player = minetest.env:get_player_by_name(name)
		player:set_hp(20)
		minetest.chat_send_player(name, "You have been healed.")
		minetest.log("action", "[Server_Tools] "..name.." healed themself.") --print to log
	else
		--If he is healing someone else, check and see if that someone exists.
		local player = minetest.env:get_player_by_name(param)
		if player == "" or player == nil then
			minetest.chat_send_player(name, "Invalid player!")
			minetest.log("action", "[Server_Tools] "..name.." attempted to heal invalid player "..param) --print to log
		else
			--If player exists, set his HP to 20 and notify him and the sender.
			player:set_hp(20)
			minetest.chat_send_player(param, "You have been healed.")
			minetest.chat_send_player(name, "You have healed "..param.."")
			minetest.log("action", "[Server_Tools] "..name.." healed "..param) --print to log
		end
	end
end
})

-- Time Commands
-- [CHAT COMMAND] Morning (0.22) - /morning
minetest.register_chatcommand("morning", {
	params = "",
	privs = {settime = true},
	description = "Set time to morning",
	func = function(name, param)
		local player = minetest.env:get_player_by_name(name)
		if not player then
			return
		end
		minetest.env:set_timeofday(0.22)
		minetest.log("action", "[Server_Tools] "..player:get_player_name().." set the time to morning.") --print to log
	end,
})
-- [CHAT COMMAND] Noon (0.5) - /noon
minetest.register_chatcommand("noon", {
	params = "",
	privs = {settime = true},
	description = "Set time to noon",
	func = function(name, param)
		local player = minetest.env:get_player_by_name(name)
		if not player then
			return
		end
		minetest.env:set_timeofday(0.5)
		minetest.log("action", "[Server_Tools] "..player:get_player_name().." set the time to noon.") --print to log
	end,
})
-- [CHAT COMMAND] Evening (0.77) - /evening
minetest.register_chatcommand("evening", {
	params = "",
	privs = {settime = true},
	description = "Set time to evening",
	func = function(name, param)
		local player = minetest.env:get_player_by_name(name)
		if not player then
			return
		end
		minetest.env:set_timeofday(0.77)
		minetest.log("action", "[Server_Tools] "..player:get_player_name().." set the time to evening.") --print to log
	end,
})
-- [CHAT COMMAND] Night (0) - /night
minetest.register_chatcommand("night", {
	params = "",
	privs = {settime = true},
	description = "Set time to night",
	func = function(name, param)
		local player = minetest.env:get_player_by_name(name)
		if not player then
			return
		end
		minetest.env:set_timeofday(0)
		minetest.log("action", "[Server_Tools] "..player:get_player_name().." set the time to night.") --print to log
	end,
})

minetest.log("action", "[Server_Tools] Miscellaneous Module Loaded") --print to log module loaded
