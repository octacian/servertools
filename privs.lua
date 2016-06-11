-- /mods/servertools/privs.lua

minetest.register_privilege("admin", "Permission to use server_tools admin functions.")
minetest.register_privilege("heal", "Permission to use /heal command.")
minetest.register_privilege("update", "Permission to use /update command.")

print("[ServerTools] Privileges Loaded")
