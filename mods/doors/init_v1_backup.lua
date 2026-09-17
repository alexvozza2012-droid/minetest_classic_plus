local DOOR_BOTTOM = "door:wooden_door_bottom"
local DOOR_TOP = "door:wooden_door_top"

local DOOR_OPEN_BOTTOM = "door:wooden_door_open_bottom"
local DOOR_OPEN_TOP = "door:wooden_door_open_top"

local DOOR_ITEM = "door:wooden_door"


-- ---------------------------------------------------------
-- Utility
-- ---------------------------------------------------------

local function is_door(name)
	return name == DOOR_BOTTOM
		or name == DOOR_TOP
		or name == DOOR_OPEN_BOTTOM
		or name == DOOR_OPEN_TOP
end


local function get_bottom_pos(pos, node)
	if node.name == DOOR_TOP or node.name == DOOR_OPEN_TOP then
		return {
			x = pos.x,
			y = pos.y - 1,
			z = pos.z
		}
	end

	return pos
end


-- ---------------------------------------------------------
-- Apertura / chiusura
-- ---------------------------------------------------------

local function toggle_door(pos)
	local node = minetest.get_node(pos)

	if not is_door(node.name) then
		return
	end

	local bottom_pos = get_bottom_pos(pos, node)
	local bottom_node = minetest.get_node(bottom_pos)

	local top_pos = {
		x = bottom_pos.x,
		y = bottom_pos.y + 1,
		z = bottom_pos.z
	}

	local top_node = minetest.get_node(top_pos)


	-- Porta chiusa -> apri
	if bottom_node.name == DOOR_BOTTOM then

		minetest.swap_node(bottom_pos, {
			name = DOOR_OPEN_BOTTOM,
			param2 = bottom_node.param2
		})

		if top_node.name == DOOR_TOP then
			minetest.swap_node(top_pos, {
				name = DOOR_OPEN_TOP,
				param2 = top_node.param2
			})
		end

	-- Porta aperta -> chiudi
	elseif bottom_node.name == DOOR_OPEN_BOTTOM then

		minetest.swap_node(bottom_pos, {
			name = DOOR_BOTTOM,
			param2 = bottom_node.param2
		})

		if top_node.name == DOOR_OPEN_TOP then
			minetest.swap_node(top_pos, {
				name = DOOR_TOP,
				param2 = top_node.param2
			})
		end
	end
end


-- ---------------------------------------------------------
-- Rimozione dell'altra metà
-- ---------------------------------------------------------

local function remove_other_half(pos, node)
	local other_pos

	if node.name == DOOR_BOTTOM or node.name == DOOR_OPEN_BOTTOM then
		other_pos = {
			x = pos.x,
			y = pos.y + 1,
			z = pos.z
		}
	else
		other_pos = {
			x = pos.x,
			y = pos.y - 1,
			z = pos.z
		}
	end

	local other_node = minetest.get_node(other_pos)

	if is_door(other_node.name) then
		minetest.remove_node(other_pos)
	end
end


-- ---------------------------------------------------------
-- Collisione porta chiusa
-- ---------------------------------------------------------

local closed_box = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5, -0.08, 0.5, 0.5, 0.08}
	}
}


-- ---------------------------------------------------------
-- Collisione porta aperta
-- ---------------------------------------------------------

local open_box = {
	type = "fixed",
	fixed = {
		{-0.08, -0.5, -0.5, 0.08, 0.5, 0.5}
	}
}


-- ---------------------------------------------------------
-- Parte inferiore - porta chiusa
-- ---------------------------------------------------------

minetest.register_node(DOOR_BOTTOM, {
	description = "Wooden Door",

	drawtype = "nodebox",

	tiles = {
		"door_bottom.png"
	},

	paramtype = "light",
	paramtype2 = "facedir",

	sunlight_propagates = true,
	is_ground_content = false,

	groups = {
		choppy = 2,
		oddly_breakable_by_hand = 1
	},

	drop = DOOR_ITEM,

	node_box = closed_box,
	selection_box = closed_box,
	collision_box = closed_box,

	on_rightclick = function(pos, node, clicker, itemstack)
		toggle_door(pos)
		return itemstack
	end,

	on_destruct = remove_other_half
})


-- ---------------------------------------------------------
-- Parte superiore - porta chiusa
-- ---------------------------------------------------------

minetest.register_node(DOOR_TOP, {
	description = "Wooden Door Top",

	drawtype = "nodebox",

	tiles = {
		"door_top.png"
	},

	paramtype = "light",
	paramtype2 = "facedir",

	sunlight_propagates = true,
	is_ground_content = false,

	groups = {
		not_in_creative_inventory = 1
	},

	drop = "",

	node_box = closed_box,
	selection_box = closed_box,
	collision_box = closed_box,

	on_rightclick = function(pos, node, clicker, itemstack)
		toggle_door(pos)
		return itemstack
	end,

	on_destruct = remove_other_half
})


-- ---------------------------------------------------------
-- Parte inferiore - porta aperta
-- ---------------------------------------------------------

minetest.register_node(DOOR_OPEN_BOTTOM, {
	description = "Wooden Door Open",

	drawtype = "nodebox",

	tiles = {
		"door_bottom.png"
	},

	paramtype = "light",
	paramtype2 = "facedir",

	sunlight_propagates = true,
	is_ground_content = false,

	groups = {
		choppy = 2,
		oddly_breakable_by_hand = 1
	},

	drop = DOOR_ITEM,

	node_box = open_box,
	selection_box = open_box,
	collision_box = open_box,

	on_rightclick = function(pos, node, clicker, itemstack)
		toggle_door(pos)
		return itemstack
	end,

	on_destruct = remove_other_half
})


-- ---------------------------------------------------------
-- Parte superiore - porta aperta
-- ---------------------------------------------------------

minetest.register_node(DOOR_OPEN_TOP, {
	description = "Wooden Door Open",

	drawtype = "nodebox",

	tiles = {
		"door_top.png"
	},

	paramtype = "light",
	paramtype2 = "facedir",

	sunlight_propagates = true,
	is_ground_content = false,

	groups = {
		not_in_creative_inventory = 1
	},

	drop = "",

	node_box = open_box,
	selection_box = open_box,
	collision_box = open_box,

	on_rightclick = function(pos, node, clicker, itemstack)
		toggle_door(pos)
		return itemstack
	end,

	on_destruct = remove_other_half
})


-- ---------------------------------------------------------
-- Item door
-- ---------------------------------------------------------

minetest.register_node(DOOR_ITEM, {
	description = "Wooden Door",

	drawtype = "nodebox",

	tiles = {
		"door_bottom.png"
	},

	paramtype = "light",
	paramtype2 = "facedir",

	sunlight_propagates = true,
	is_ground_content = false,

	groups = {
		choppy = 2,
		oddly_breakable_by_hand = 1
	},

	node_box = closed_box,
	selection_box = closed_box,
	collision_box = closed_box,


	-- Posizionamento della porta
	on_place = function(itemstack, placer, pointed_thing)

		if pointed_thing.type ~= "node" then
			return itemstack
		end

		local pos = pointed_thing.above

		local top_pos = {
			x = pos.x,
			y = pos.y + 1,
			z = pos.z
		}

		local node = minetest.get_node(pos)
		local top_node = minetest.get_node(top_pos)

		local node_def = minetest.registered_nodes[node.name]
		local top_def = minetest.registered_nodes[top_node.name]

		if not node_def or not top_def then
			return itemstack
		end

		if node_def.buildable_to ~= true then
			return itemstack
		end

		if top_def.buildable_to ~= true then
			return itemstack
		end

		local player_name = placer:get_player_name()

		if minetest.is_protected(pos, player_name) then
			return itemstack
		end

		if minetest.is_protected(top_pos, player_name) then
			return itemstack
		end


		-- Orientamento
		local look_dir = placer:get_look_dir()
		local facedir = minetest.dir_to_facedir(look_dir)


		-- Parte inferiore
		minetest.set_node(pos, {
			name = DOOR_BOTTOM,
			param2 = facedir
		})


		-- Parte superiore
		minetest.set_node(top_pos, {
			name = DOOR_TOP,
			param2 = facedir
		})


		-- Consuma la porta
		if not minetest.is_creative_enabled(player_name) then
			itemstack:take_item()
		end

		return itemstack
	end,


	on_rightclick = function(pos, node, clicker, itemstack)
		toggle_door(pos)
		return itemstack
	end,

	on_destruct = remove_other_half
})


-- ---------------------------------------------------------
-- Recipe
-- ---------------------------------------------------------

minetest.register_craft({
	output = DOOR_ITEM,

	recipe = {
		{"default:wood", "default:wood"},
		{"default:wood", "default:wood"},
		{"default:wood", "default:wood"}
	}
})
