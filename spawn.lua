--Set spawn command
minetest.register_chatcommand("setspawn", {
	params = "",
	privs = {admin = true},
	description = "Set the spawn point.",
	func = function(name, param)
		--Check for proper player [forbids console commands, not really needed]
		local player = minetest.env:get_player_by_name(name)
		if not player then
			return
		end
		--Get player position and set spawn just below that just because it looks cooler.
		local pos = player:getpos()
		pos.x = math.floor(0.5+pos.x)
		pos.z = math.floor(0.5+pos.z)
		minetest.setting_set("static_spawnpoint", minetest.pos_to_string(pos))

		--Notify admin who set spawn.
		minetest.chat_send_player(name, "Spawn set at, "..minetest.setting_get("static_spawnpoint"));
	end,
})

--Make sure player spawns at set spawnpoint when he dies if it exists.
minetest.register_on_respawnplayer(function(player)
	if not player then
		return
	end
	if minetest.setting_get("static_spawnpoint") == nil or minetest.setting_get("static_spawnpoint") == "" then
		return
	end
	player:setpos(minetest.string_to_pos(minetest.setting_get("static_spawnpoint")))
end)

--Make sure player spawns at set spawnpoint when he joins if it exists.
minetest.register_on_newplayer(function(player)
	if not player then
		return
	end
	minetest.chat_send_all(Welcome_String.." "..player:get_player_name().."!")
	if minetest.setting_get("static_spawnpoint") == nil or minetest.setting_get("static_spawnpoint") == "" then
		return
	end
	player:setpos(minetest.string_to_pos(minetest.setting_get("static_spawnpoint")))
end)

--Make /spawn go to a spawnpoint set by admins if it exists.
minetest.register_chatcommand("spawn", {
	params = "",
	privs = {se_player = true},
	description = "Set the spawn point.",
	func = function(name, param)
	local player = minetest.env:get_player_by_name(name)
		if not player then
			return
		end
		if minetest.setting_get("static_spawnpoint") == nil or minetest.setting_get("static_spawnpoint") == "" then
			return
		end
		player:setpos(minetest.string_to_pos(minetest.setting_get("static_spawnpoint")))
	end
})

print("[Server_Tools] Player Spawn Module Loaded")
