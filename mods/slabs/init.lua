local slab_box = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5, -0.5, 0.5, 0, 0.5}
	}
}

-- Wooden Slab
minetest.register_node("slabs:wood", {
	description = "Wooden Slab",

	tiles = {
		"wood.png"
	},

	inventory_image = "wood.png",
	wield_image = "wood.png",

	drawtype = "nodebox",
	node_box = slab_box,

	paramtype = "light",

	groups = {
		wood = 5
	},

	sounds = default.node_sound.wood,
})

minetest.register_craft({
	output = "slabs:wood 6",
	recipe = {
		{"default:wood", "default:wood", "default:wood"}
	}
})

-- Stone Slab
minetest.register_node("slabs:stone", {
	description = "Stone Slab",

	tiles = {
		"stone.png"
	},

	inventory_image = "stone.png",
	wield_image = "stone.png",

	drawtype = "nodebox",
	node_box = slab_box,

	paramtype = "light",

	groups = {
		stone = 4
	},

	sounds = default.node_sound.stone,
})

minetest.register_craft({
	output = "slabs:stone 6",
	recipe = {
		{"default:stone", "default:stone", "default:stone"}
	}
})

-- Cobblestone Slab
minetest.register_node("slabs:cobble", {
	description = "Cobblestone Slab",

	tiles = {
		"cobble.png"
	},

	inventory_image = "cobble.png",
	wield_image = "cobble.png",

	drawtype = "nodebox",
	node_box = slab_box,

	paramtype = "light",

	groups = {
		stone = 3
	},

	sounds = default.node_sound.stone,
})

minetest.register_craft({
	output = "slabs:cobble 6",
	recipe = {
		{"default:cobble", "default:cobble", "default:cobble"}
	}
})

-- Sandstone Slab
minetest.register_node("slabs:sandstone", {
	description = "Sandstone Slab",

	tiles = {
		"sandstone.png"
	},

	inventory_image = "sandstone.png",
	wield_image = "sandstone.png",

	drawtype = "nodebox",
	node_box = slab_box,

	paramtype = "light",

	groups = {
		dirt = 2
	},

	sounds = default.node_sound.stone,
})

minetest.register_craft({
	output = "slabs:sandstone 6",
	recipe = {
		{"default:sandstone", "default:sandstone", "default:sandstone"}
	}
})

minetest.register_craft({
	output = "slabs:sandstone 6",
	recipe = {
		{"default:sandstone", "default:sandstone", "default:sandstone"}
	}
})
