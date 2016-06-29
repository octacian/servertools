-- [command] Clear Inventory - /clear
minetest.register_chatcommand("clear", {
	description = 'Clear your inventory.',
	params = "<playername> | name of player (optional)",
	privs = {},
	func = servertools.clearinv
})

-- [command] Heal - /heal param
minetest.register_chatcommand("heal", {
	description = "Restore full health to anyone.",
	privs = {heal = true},
	func = function(name, param)
	--Check if sender wants to heal someone other than himself
	if param == "" or param == nil then
		--If he dosn't, heal the sender
		local player = minetest.get_player_by_name(name)
		player:set_hp(20)
		minetest.chat_send_player(name, "You have been healed.")
		minetest.log("action", "[ServerTools] "..name.." healed themself.") --print to log
	else
		--If he is healing someone else, check and see if that someone exists.
		local player = minetest.get_player_by_name(param)
		if player == "" or player == nil then
			minetest.chat_send_player(name, "Invalid player!")
			minetest.log("action", "[ServerTools] "..name.." attempted to heal invalid player "..param) --print to log
		else
			--If player exists, set his HP to 20 and notify him and the sender.
			player:set_hp(20)
			minetest.chat_send_player(param, "You have been healed.")
			minetest.chat_send_player(name, "You have healed "..param.."")
			minetest.log("action", "[ServerTools] "..name.." healed "..param) --print to log
		end
	end
end
})

-- Time Commands
-- [command] Morning (0.22) - /morning
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
		minetest.log("action", "[ServerTools] "..player:get_player_name().." set the time to morning.") --print to log
	end,
})
-- [command] Noon (0.5) - /noon
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
		minetest.log("action", "[ServerTools] "..player:get_player_name().." set the time to noon.") --print to log
	end,
})
-- [command] Evening (0.77) - /evening
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
		minetest.log("action", "[ServerTools] "..player:get_player_name().." set the time to evening.") --print to log
	end,
})
-- [command] Night (0) - /night
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
		minetest.log("action", "[ServerTools] "..player:get_player_name().." set the time to night.") --print to log
	end,
})

-- [command] Update node - /update x y z modname:nodename
minetest.register_chatcommand("update", {
	description = "Place/Update a node at a coordinate.",
	params = "<new_nodename> <x> <y> <z> | item string of new node, coordinates",
	privs = {update = true},
	func = servertools.update_node,
})

-- [command] IP (get IP of player)- /ip player
minetest.register_chatcommand("ip", {
	privs = { server = true },
	description = "Get IP of any player.",
	params = "/update <player> | player username",
	func = servertools.get_ip,
})

-- [command] Bring Player to your Location - /bring player
minetest.register_chatcommand("bring", {
	privs = { bring = true },
	description = "Bring a player to your location.",
	params = "/bring <player> | player username",
	func = function(name, param)
		local bring = minetest.get_player_by_name(name) -- get player who executed command
		local pos = bring:getpos() -- get bring position
		local player = minetest.get_player_by_name(param) -- get player to teleport
		-- check if player is logged in or not an IRC user
		if not player then
			minetest.chat_send_player(name, param.." is not a valid player.")
		else
			player:setpos(pos) -- set position
			minetest.chat_send_player(name, "Brought "..param..".") -- notify player
			servertools.log(name.." brought "..param.." to "..pos.x..", "..pos.y..", "..pos.z..".") -- log
		end
	end
})

minetest.log("action", "[ServerTools] Miscellaneous Module Loaded") --print to log module loaded
