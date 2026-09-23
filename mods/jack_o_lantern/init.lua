local S = minetest.get_translator("jack_o_lantern")


-- CARVED PUMPKIN

minetest.register_node("jack_o_lantern:carved_pumpkin", {
    description = S("Carved Pumpkin"),

    tiles = {
        "pumpkin_top.png",
        "pumpkin_top.png",
        "carved_pumpkin.png",
        "carved_pumpkin.png",
        "carved_pumpkin.png",
        "carved_pumpkin.png"
    },

    groups = {
        wood = 6
    },

    sounds = default.node_sound.wood,

    drop = "autumn_biome:pumpkin"
})


-- SHEARS

minetest.register_tool("jack_o_lantern:shears", {
    description = S("Shears"),
    inventory_image = "shears.png",
})


-- CARVING

minetest.override_item("autumn_biome:pumpkin", {
    on_rightclick = function(pos, node, clicker, itemstack)

        if itemstack:get_name() == "jack_o_lantern:shears" then

            minetest.set_node(pos, {
                name = "jack_o_lantern:carved_pumpkin"
            })

            return itemstack
        end

        return itemstack
    end,
})
