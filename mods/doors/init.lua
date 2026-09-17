local MOD = "door"

local DOOR_BOTTOM = MOD .. ":wooden_door_bottom"
local DOOR_TOP = MOD .. ":wooden_door_top"

local DOOR_BOTTOM_OPEN = MOD .. ":wooden_door_bottom_open"
local DOOR_TOP_OPEN = MOD .. ":wooden_door_top_open"

local DOOR_ITEM = MOD .. ":wooden_door"


-- =========================================================
-- UTILITA'
-- =========================================================

local function is_door(name)
	return name == DOOR_BOTTOM
		or name == DOOR_TOP
		or name == DOOR_BOTTOM_OPEN
		or name == DOOR_TOP_OPEN
end


local function get_bottom(pos, node)
	if node.name == DOOR_TOP or node.name == DOOR_TOP_OPEN then
		return {
			x = pos.x,
			y = pos.y - 1,
			z = pos.z
		}
	end

	return {
		x = pos.x,
		y = pos.y,
		z = pos.z
	}
end


local function get_top(pos)
	return {
		x = pos.x,
		y = pos.y + 1,
		z = pos.z
	}
end


-- =========================================================
-- BOX DELLA PORTA
-- =========================================================

local closed_box = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5, -0.08, 0.5, 0.5, 0.08}
	}
}

-- Porta aperta:
-- spessore = 0.125 blocchi = 2 pixel
local open_box = {
	type = "fixed",
	fixed = {
		{-0.5, -0.5, -0.0625, -0.375, 0.5, 0.0625}
	}
}


-- =========================================================
-- RIMOZIONE DELLA SECONDA META'
-- =========================================================

local function remove_other_half(pos, node)

	-- Sicurezza nel caso il vecchio engine
	-- non passi il nodo al callback.
	if not node then
		return
	end


	local other


	-- ---------------------------------------------
	-- E' LA PARTE INFERIORE
	-- ---------------------------------------------

	if node.name == DOOR_BOTTOM
		or node.name == DOOR_BOTTOM_OPEN then

		other = {
			x = pos.x,
			y = pos.y + 1,
			z = pos.z
		}


	-- ---------------------------------------------
	-- E' LA PARTE SUPERIORE
	-- ---------------------------------------------

	elseif node.name == DOOR_TOP
		or node.name == DOOR_TOP_OPEN then

		other = {
			x = pos.x,
			y = pos.y - 1,
			z = pos.z
		}

	else
		return
	end


	local other_node = minetest.get_node(other)


	-- Usiamo swap_node invece di remove_node
	-- per evitare di richiamare on_destruct
	-- della seconda meta'.
	if is_door(other_node.name) then

		minetest.swap_node(other, {
			name = "air"
		})

	end
end


-- =========================================================
-- APERTURA / CHIUSURA
-- =========================================================

local function toggle_door(pos)

	local node = minetest.get_node(pos)

	if not is_door(node.name) then
		return
	end


	local bottom = get_bottom(pos, node)
	local top = get_top(bottom)

	local bottom_node = minetest.get_node(bottom)
	local top_node = minetest.get_node(top)


	-- -----------------------------------------------------
	-- CHIUSA -> APERTA
	-- -----------------------------------------------------

	if bottom_node.name == DOOR_BOTTOM then

		minetest.swap_node(bottom, {
			name = DOOR_BOTTOM_OPEN,
			param2 = bottom_node.param2
		})

		if top_node.name == DOOR_TOP then

			minetest.swap_node(top, {
				name = DOOR_TOP_OPEN,
				param2 = top_node.param2
			})

		end


	-- -----------------------------------------------------
	-- APERTA -> CHIUSA
	-- -----------------------------------------------------

	elseif bottom_node.name == DOOR_BOTTOM_OPEN then

		minetest.swap_node(bottom, {
			name = DOOR_BOTTOM,
			param2 = bottom_node.param2
		})

		if top_node.name == DOOR_TOP_OPEN then

			minetest.swap_node(top, {
				name = DOOR_TOP,
				param2 = top_node.param2
			})

		end
	end
end


-- =========================================================
-- PARTE INFERIORE CHIUSA
-- =========================================================

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
		wood = 5
	},

	sounds = default.node_sound.wood,

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


-- =========================================================
-- PARTE SUPERIORE CHIUSA
-- =========================================================

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
		wood = 5,
		not_in_creative_inventory = 1
	},

	sounds = default.node_sound.wood,

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


-- =========================================================
-- PARTE INFERIORE APERTA
-- =========================================================

minetest.register_node(DOOR_BOTTOM_OPEN, {

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
		wood = 5,
		not_in_creative_inventory = 1
	},

	sounds = default.node_sound.wood,

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


-- =========================================================
-- PARTE SUPERIORE APERTA
-- =========================================================

minetest.register_node(DOOR_TOP_OPEN, {

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
		wood = 5,
		not_in_creative_inventory = 1
	},

	sounds = default.node_sound.wood,

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


-- =========================================================
-- OGGETTO PORTA
-- =========================================================

minetest.register_craftitem(DOOR_ITEM, {

	description = "Wooden Door",

	inventory_image = "door_item.png",


	on_place = function(itemstack, placer, pointed_thing)

		if pointed_thing.type ~= "node" then
			return itemstack
		end


		local pos = pointed_thing.above

		local top = {
			x = pos.x,
			y = pos.y + 1,
			z = pos.z
		}


		local node = minetest.get_node(pos)
		local top_node = minetest.get_node(top)


		local node_def =
			minetest.registered_nodes[node.name]

		local top_def =
			minetest.registered_nodes[top_node.name]


		if not node_def or not top_def then
			return itemstack
		end


		if node_def.buildable_to ~= true then
			return itemstack
		end


		if top_def.buildable_to ~= true then
			return itemstack
		end


		local player_name =
			placer:get_player_name()


		if minetest.is_protected(
			pos,
			player_name
		) then
			return itemstack
		end


		if minetest.is_protected(
			top,
			player_name
		) then
			return itemstack
		end


		-- ---------------------------------------------
		-- ORIENTAMENTO
		-- ---------------------------------------------

		local look_dir =
			placer:get_look_dir()

		local facedir =
			minetest.dir_to_facedir(
				look_dir
			)


		-- ---------------------------------------------
		-- POSIZIONAMENTO
		-- ---------------------------------------------

		minetest.set_node(pos, {
			name = DOOR_BOTTOM,
			param2 = facedir
		})


		minetest.set_node(top, {
			name = DOOR_TOP,
			param2 = facedir
		})


		-- ---------------------------------------------
		-- CONSUMO
		-- ---------------------------------------------

		if not minetest.is_creative_enabled(
			player_name
		) then

			itemstack:take_item()

		end


		return itemstack
	end
})


-- =========================================================
-- RICETTA
-- =========================================================

minetest.register_craft({

	output = DOOR_ITEM,

	recipe = {
		{"default:wood", "default:wood"},
		{"default:wood", "default:wood"},
		{"default:wood", "default:wood"}
	}
})
