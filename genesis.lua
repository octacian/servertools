-- create file
datalib.create(datalib.datapath.."/genesis.txt")

-- Set Genesis Command
minetest.register_chatcommand("setgenesis", {
	params = "",
	privs = {servertools = true},
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
		datalib.write(datalib.datapath.."/genesis.txt", pos_str, false)

		--Print to Log
		servertools.log("Genesis point set to position "..pos_str.." by "..name) --print to log
		--Notify admin who set genesis.
		return true, "Genesis point set to position "..pos_str
	end,
})

-- Make sure player initializes at set genesis when he hurts himself badly if it exists.
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

-- Make sure player initializes at set genesis when he joins if it exists.
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

-- Make /genesis go to a genesis point set by admins if it exists.
minetest.register_chatcommand("genesis", {
	params = "",
	privs = {},
	description = "Initialize transportation to the Genesis.",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if not player then
			return
		end
		local genesis = datalib.read(datalib.datapath.."/genesis.txt", false)
		local genesis_pos = minetest.string_to_pos(genesis)
		if not genesis_pos then
			return false, "Static genesis point is not set or improperly formatted."
		end
		--Print to Log
		servertools.log(name.." transported to the genesis at "..genesis) --print to log

		player:setpos(genesis_pos)
		return true, "Initializing transportation to the Genesis point..."
	end
})

servertools.log("Genesis Module Loaded") --print to log module loaded
