local tall_grass = "tall_grass:tall_grass"
local seeds = "tall_grass:seeds"

-- Semi
minetest.register_craftitem(seeds, {
	description = "Seeds",
	inventory_image = "seeds.png",
})

-- Erba alta
minetest.register_node(tall_grass, {
	description = "Tall Grass",

	drawtype = "plantlike",

	tiles = {
		"tall_grass.png"
	},

	inventory_image = "tall_grass.png",
	wield_image = "tall_grass.png",

	paramtype = "light",
	sunlight_propagates = true,

	walkable = false,
	buildable_to = true,

	groups = {
    wood = 2
	},

	drop = {
		items = {
			{
				items = {seeds},
				rarity = 3
			}
		}
	},

	sounds = default.node_sound_leaves,

	selection_box = {
		type = "fixed",
		fixed = {
			{-0.3, -0.5, -0.3, 0.3, 0.5, 0.3}
		}
	}
})

-- Generazione naturale
minetest.register_decoration({
	deco_type = "simple",

	place_on = {
		"default:dirt_with_grass"
	},

	sidelen = 16,

	fill_ratio = 0.025,

	decoration = tall_grass,
})
