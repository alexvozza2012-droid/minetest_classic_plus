local MOD = "bed"

local BED_PILLOW = MOD .. ":bed_pillow"
local BED_FOOT = MOD .. ":bed_foot"

local bed_box = {
    type = "fixed",
    fixed = {
        {-0.5, -0.5, -0.5, 0.5, 0.0, 0.5}
    }
}

local bed_top_tiles = {
    "bed_top1.png",
    "bed_top2.png"
}

local bed_bottom_tiles = {
    "bed_bottom.png"
}

local bed_pillow_tiles = {
    bed_top_tiles[1],
    bed_bottom_tiles[1],
    "bed_bed1.png",
    "bed_bed3.png",
    "bed_front.png",
    "bed_front.png"
}

local bed_foot_tiles = {
    bed_top_tiles[2],
    bed_bottom_tiles[1],
    "bed_bed2.png",
    "bed_bed4.png",
    "bed_bed2.png",
    "bed_bed2.png"
}

local function is_bed(name)
    return name == BED_PILLOW or name == BED_FOOT
end

local function get_other_pos(pos, param2)
    local dir = minetest.facedir_to_dir(param2)

    return {
        x = pos.x + dir.x,
        y = pos.y,
        z = pos.z + dir.z
    }
end

local function remove_other_half(pos, node)
    if not node then
        return
    end

    local other_pos = get_other_pos(pos, node.param2)
    local other_node = minetest.get_node_or_nil(other_pos)

    if other_node and is_bed(other_node.name) then
        minetest.swap_node(other_pos, {
            name = "air"
        })
    end
end

minetest.register_node(BED_PILLOW, {
    description = "Bed",

    drawtype = "nodebox",
    node_box = bed_box,

    tiles = bed_pillow_tiles,

    paramtype = "light",
    paramtype2 = "facedir",

    sunlight_propagates = true,

    groups = {
        wood = 5
    },

    sounds = default.node_sound.wood,

    on_destruct = remove_other_half
})

minetest.register_node(BED_FOOT, {
    description = "Bed",

    drawtype = "nodebox",
    node_box = bed_box,

    tiles = bed_foot_tiles,

    paramtype = "light",
    paramtype2 = "facedir",

    sunlight_propagates = true,

    groups = {
        wood = 5
    },

    sounds = default.node_sound.wood,

    on_destruct = remove_other_half
})

minetest.register_craftitem(MOD .. ":bed", {
    description = "Bed",

    inventory_image = bed_top_tiles[1],

    on_place = function(itemstack, placer, pointed_thing)
        if not placer then
            return itemstack
        end

        if pointed_thing.type ~= "node" then
            return itemstack
        end

        local pos = pointed_thing.above
        local player_name = placer:get_player_name()

        if minetest.is_protected(pos, player_name) then
            minetest.record_protection_violation(pos, player_name)
            return itemstack
        end

        local look_dir = placer:get_look_dir()
        local facedir

        if math.abs(look_dir.x) > math.abs(look_dir.z) then
            if look_dir.x > 0 then
                facedir = 1
            else
                facedir = 3
            end
        else
            if look_dir.z > 0 then
                facedir = 2
            else
                facedir = 0
            end
        end

        local dir = minetest.facedir_to_dir(facedir)

        local second_pos = {
            x = pos.x + dir.x,
            y = pos.y,
            z = pos.z + dir.z
        }

        local first_node = minetest.get_node(pos)
        local second_node = minetest.get_node(second_pos)

        local first_def = minetest.registered_nodes[first_node.name]
        local second_def = minetest.registered_nodes[second_node.name]

        if not first_def or not second_def then
            return itemstack
        end

        if not first_def.buildable_to or not second_def.buildable_to then
            return itemstack
        end

        if minetest.is_protected(second_pos, player_name) then
            minetest.record_protection_violation(
                second_pos,
                player_name
            )
            return itemstack
        end

        minetest.set_node(pos, {
            name = BED_PILLOW,
            param2 = facedir
        })

        minetest.set_node(second_pos, {
            name = BED_FOOT,
            param2 = facedir
        })

        if not minetest.settings:get_bool("creative_mode") then
            itemstack:take_item()
        end

        return itemstack
    end
})

minetest.register_craft({
    output = MOD .. ":bed",

    recipe = {
        {"", ""},
        {"", ""},
        {"", ""}
    }
})
