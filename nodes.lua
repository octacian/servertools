-- servertools/nodes.lua

-- normal air
minetest.register_node("servertools:air", {
  drawtype = "airlike",
  description = "[ServerTools] Air",
  paramtype = "light",
	sunlight_propagates = true,
  buildable_to = true,
  pointable = false,
  walkable = false,
  diggable = false,
	groups = {not_in_creative_inventory = 1},
})

-- pointable air
minetest.register_node("servertools:air_pointable", {
  drawtype = "airlike",
  description = "[Pointable] Air",
  paramtype = "light",
	sunlight_propagates = true,
  buildable_to = true,
  pointable = true,
  walkable = false,
  diggable = false,
	groups = {not_in_creative_inventory = 1},
})

-- no build air
minetest.register_node("servertools:air_nobuild", {
  drawtype = "airlike",
  description = "[No Build] Air",
  paramtype = "light",
	sunlight_propagates = true,
  buildable_to = false,
  pointable = false,
  walkable = false,
  diggable = false,
	groups = {not_in_creative_inventory = 1},
})

-- pointable no build air
minetest.register_node("servertools:air_nobuild_pointable", {
  drawtype = "airlike",
  description = "[Pointable, No Build] Air",
  paramtype = "light",
	sunlight_propagates = true,
  buildable_to = false,
  pointable = true,
  walkable = false,
  diggable = false,
	groups = {not_in_creative_inventory = 1},
})

-- solid air
minetest.register_node("servertools:air_solid", {
  drawtype = "airlike",
  description = "Solid Air",
  paramtype = "light",
	sunlight_propagates = true,
  buildable_to = true,
  pointable = false,
  walkable = true,
  diggable = false,
	groups = {not_in_creative_inventory = 1},
})

-- pointable solid air
minetest.register_node("servertools:air_solid_pointable", {
  drawtype = "airlike",
  description = "[Pointable] Solid Air",
  paramtype = "light",
	sunlight_propagates = true,
  buildable_to = true,
  pointable = true,
  walkable = true,
  diggable = false,
	groups = {not_in_creative_inventory = 1},
})

-- no build solid air
minetest.register_node("servertools:air_solid_nobuild", {
  drawtype = "airlike",
  description = "[No Build] Solid Air",
  paramtype = "light",
	sunlight_propagates = true,
  buildable_to = false,
  pointable = false,
  walkable = true,
  diggable = false,
	groups = {not_in_creative_inventory = 1},
})

-- pointable no build solid air
minetest.register_node("servertools:air_solid_nobuild_pointable", {
  drawtype = "airlike",
  description = "[Pointable, No Build] Solid Air",
  paramtype = "light",
	sunlight_propagates = true,
  buildable_to = false,
  pointable = true,
  walkable = true,
  diggable = false,
	groups = {not_in_creative_inventory = 1},
})

servertools.log("Nodes Loaded")
