--Set Genesis Command
minetest.register_chatcommand("setgenesis", {
	params = "",
	privs = {admin = true},
	description = "Set the Genesis point (beginning).",
	func = function(name, param)
		--Check for proper player [forbids console commands, not really needed]
		local player = minetest.get_player_by_name(name)
		if not player then
			return
		end
		--Get player position and set genesis just below that just because it looks cooler.
		local pos = vector.round(player:getpos())
		pos.y = pos.y + 0.5
		
		local pos_str = minetest.pos_to_string(pos)
		minetest.setting_set("static_genesis", pos_str)

		--Notify admin who set genesis.
		minetest.chat_send_player(name, "Genesis point set to position "..pos_str);
		--Print to Log
		minetest.log("action", "[ServerTools] Genesis point set to position "..pos_str.." by "..name) --print to log
	end,
})

--Make sure player initializes at set genesis when he hurts himself badly if it exists.
minetest.register_on_respawnplayer(function(player)
	if not player then
		return
	end
	local genesis_pos = minetest.string_to_pos(minetest.setting_get("static_genesis"))
	if not genesis_pos then
		return
	end
	player:setpos(genesis_pos)
end)

--Make sure player initializes at set genesis when he joins if it exists.
minetest.register_on_newplayer(function(player)
	if not player then
		return
	end
	local genesis_pos = minetest.string_to_pos(minetest.setting_get("static_genesis"))
	if not genesis_pos then
		return
	end
	player:setpos(genesis_pos)
end)

--Make /genesis go to a genesis point set by admins if it exists.
minetest.register_chatcommand("genesis", {
	params = "",
	privs = {},
	description = "Initialize transportation to the Genesis.",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return
		end
		local genesis = minetest.setting_get("static_genesis")
		local genesis_pos = minetest.string_to_pos(genesis)
		if not genesis_pos then
			return
		end
		player:setpos(genesis_pos)
		minetest.chat_send_player(name, "Initializing transportation to the Genesis point...");
		--Print to Log
		minetest.log("action", "[ServerTools] "..name.." transported to the genesis at "..genesis) --print to log
	end
})

minetest.log("action", "[ServerTools] Genesis Module Loaded") --print to log module loaded
