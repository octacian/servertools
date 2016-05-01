--Set Genesis Command
minetest.register_chatcommand("setgenesis", {
	params = "",
	privs = {admin = true},
	description = "Set the Genesis point (beginning).",
	func = function(name, param)
		--Check for proper player [forbids console commands, not really needed]
		local player = minetest.env:get_player_by_name(name)
		if not player then
			return
		end
		--Get player position and set genesis just below that just because it looks cooler.
		local pos = player:getpos()
		pos.x = math.floor(0.5+pos.x)
		pos.z = math.floor(0.5+pos.z)
		minetest.setting_set("static_spawnpoint", minetest.pos_to_string(pos))

		--Notify admin who set genesis.
		minetest.chat_send_player(name, "Genesis point set at "..minetest.setting_get("static_spawnpoint"));
		--Print to Log
		minetest.log("action", "[Server_Tools] Genesis point set at "..minetest.setting_get("static_spawnpoint")..", by "..player:get_player_name()) --print to log
	end,
})

--Make sure player initializes at set genesis when he hurts himself badly if it exists.
minetest.register_on_respawnplayer(function(player)
	if not player then
		return
	end
	if minetest.setting_get("static_spawnpoint") == nil or minetest.setting_get("static_spawnpoint") == "" then
		return
	end
	player:setpos(minetest.string_to_pos(minetest.setting_get("static_spawnpoint")))
end)

--Make sure player initializes at set genesis when he joins if it exists.
minetest.register_on_newplayer(function(player)
	if not player then
		return
	end
	if minetest.setting_get("static_spawnpoint") == nil or minetest.setting_get("static_spawnpoint") == "" then
		return
	end
	player:setpos(minetest.string_to_pos(minetest.setting_get("static_spawnpoint")))
end)

--Make /genesis go to a genesis point set by admins if it exists.
minetest.register_chatcommand("genesis", {
	params = "",
	privs = {},
	description = "Initialize transportation to the Genesis.",
	func = function(name, param)
	local player = minetest.env:get_player_by_name(name)
		if not player then
			return
		end
		if minetest.setting_get("static_spawnpoint") == nil or minetest.setting_get("static_spawnpoint") == "" then
			return
		end
		player:setpos(minetest.string_to_pos(minetest.setting_get("static_spawnpoint")))
		minetest.chat_send_player(name, "Initializing transportation to the Genesis point...");
		--Print to Log
		minetest.log("action", "[Server_Tools] "..player:get_player_name().." transported to the genesis at "..minetest.setting_get("static_spawnpoint")) --print to log
	end
})

minetest.log("action", "[Server_Tools] Genesis Module Loaded") --print to log module loaded
