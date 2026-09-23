------------------------------------------------------------
-- CLASSIC PLUS - AUTUMN BIOME
-- The Autumn Update - 1.1.0
------------------------------------------------------------

local S = minetest.get_translator("autumn_biome")


------------------------------------------------------------
-- AUTUMN GRASS
------------------------------------------------------------

minetest.register_node("autumn_biome:autumn_grass", {
    description = S("Autumn Grass"),

    tiles = {
        "autumn_grass.png",
        "mud.png",
        "autumngrass_side.png"
    },

    groups = {
        dirt = 2,
        crumbly = 3,
    },

    drop = "default:dirt",

    sounds = default.node_sound_grass,
})


------------------------------------------------------------
-- AUTUMN GRASS WITH FOOTSTEPS
------------------------------------------------------------

minetest.register_node("autumn_biome:autumn_grass_footsteps", {
    description = S("Autumn Grass and Footsteps"),

    tiles = {
        "autumngrass_footsteps.png",
        "mud.png",
        "autumngrass_side.png"
    },

    groups = {
        dirt = 2,
        crumbly = 3,
        not_in_creative_inventory = 1,
    },

    drop = "default:dirt",

    sounds = default.node_sound_grass,
})


------------------------------------------------------------
-- AUTUMN LEAVES
------------------------------------------------------------

minetest.register_node("autumn_biome:autumn_leaves", {
    description = S("Autumn Leaves"),

    tiles = {
        "autumn_leaves.png"
    },

    special_tiles = {
        "autumn_leaves.png"
    },

    groups = {
        wood = 2,
        leafdecay = 3,
    },

    drawtype = "allfaces_optional",

    paramtype = "light",

    is_ground_content = false,

    waving = default.modernize.node_waving and 2 or nil,

    drop = {
        items = {
            {
                items = {"default:sapling"},
                rarity = 20
            },
            {
                items = {"default:leaves"}
            }
        }
    },

    sounds = default.node_sound_leaves,
})


------------------------------------------------------------
-- AUTUMN PUMPKIN
------------------------------------------------------------

minetest.register_node("autumn_biome:pumpkin", {
    description = S("Pumpkin"),

    tiles = {
        "pumpkin_top.png",
        "pumpkin_top.png",
        "pumpkin_side.png",
        "pumpkin_side.png",
        "pumpkin_side.png",
        "pumpkin_side.png"
    },

    groups = { wood = 6 },

    sounds = default.node_sound.wood,
})


------------------------------------------------------------
-- AUTUMN BIOME NOISE
------------------------------------------------------------

local noise_params = {
    offset = 0,
    scale = 1,

    spread = {
        x = 250,
        y = 250,
        z = 250
    },

    seed = 9876,

    octaves = 2,
    persist = 0.6,
    lacunarity = 2.0
}


------------------------------------------------------------
-- AUTUMN TREE
------------------------------------------------------------

local function make_autumn_tree(vm, p0)

    local n_tree = {
        name = "default:tree"
    }

    local n_leaves = {
        name = "autumn_biome:autumn_leaves"
    }


    --------------------------------------------------------
    -- Random tree height
    --------------------------------------------------------

    local trunk_h = math.random(4, 6)


    --------------------------------------------------------
    -- Main trunk
    --------------------------------------------------------

    local p1 = vector.new(
        p0.x,
        p0.y,
        p0.z
    )

    for i = 1, trunk_h do

        vm:set_node_at(p1, n_tree)

        p1.y = p1.y + 1
    end


    --------------------------------------------------------
    -- Top of trunk
    --------------------------------------------------------

    p1.y = p1.y - 1


    --------------------------------------------------------
    -- Place leaf
    --------------------------------------------------------

    local function place_leaf(x, y, z)

        local p = {
            x = p1.x + x,
            y = p1.y + y,
            z = p1.z + z
        }

        local node = vm:get_node_at(p)

        if node.name == "air" or node.name == "ignore" then
            vm:set_node_at(p, n_leaves)
        end
    end


    --------------------------------------------------------
    -- Short side branches
    --------------------------------------------------------

    if trunk_h >= 5 then

        -- East
        if math.random(0, 99) < 45 then

            vm:set_node_at({
                x = p1.x + 1,
                y = p1.y - 2,
                z = p1.z
            }, n_tree)

            place_leaf(2, -2, 0)
            place_leaf(1, -2, 1)
            place_leaf(1, -2, -1)
        end


        -- West
        if math.random(0, 99) < 45 then

            vm:set_node_at({
                x = p1.x - 1,
                y = p1.y - 2,
                z = p1.z
            }, n_tree)

            place_leaf(-2, -2, 0)
            place_leaf(-1, -2, 1)
            place_leaf(-1, -2, -1)
        end


        -- South
        if math.random(0, 99) < 35 then

            vm:set_node_at({
                x = p1.x,
                y = p1.y - 2,
                z = p1.z + 1
            }, n_tree)

            place_leaf(0, -2, 2)
            place_leaf(1, -2, 1)
            place_leaf(-1, -2, 1)
        end


        -- North
        if math.random(0, 99) < 35 then

            vm:set_node_at({
                x = p1.x,
                y = p1.y - 2,
                z = p1.z - 1
            }, n_tree)

            place_leaf(0, -2, -2)
            place_leaf(1, -2, -1)
            place_leaf(-1, -2, -1)
        end
    end


    --------------------------------------------------------
    -- Lower canopy
    --------------------------------------------------------

    for x = -2, 2 do

        for z = -2, 2 do

            if math.abs(x) + math.abs(z) <= 3 then
                place_leaf(x, -1, z)
            end

        end
    end


    --------------------------------------------------------
    -- Middle canopy
    --------------------------------------------------------

    for x = -2, 2 do

        for z = -2, 2 do

            if math.abs(x) + math.abs(z) <= 3 then

                if math.random(0, 99) < 90 then
                    place_leaf(x, 0, z)
                end
            end
        end
    end


    --------------------------------------------------------
    -- Upper canopy
    --------------------------------------------------------

    for x = -1, 1 do

        for z = -1, 1 do

            if math.random(0, 99) < 90 then
                place_leaf(x, 1, z)
            end

        end
    end


    --------------------------------------------------------
    -- Tree top
    --------------------------------------------------------

    place_leaf(0, 2, 0)


    --------------------------------------------------------
    -- Small random extensions
    --------------------------------------------------------

    if math.random(0, 99) < 50 then
        place_leaf(-2, 0, 0)
    end

    if math.random(0, 99) < 50 then
        place_leaf(2, 0, 0)
    end

    if math.random(0, 99) < 50 then
        place_leaf(0, 0, -2)
    end
end


------------------------------------------------------------
-- AUTUMN TERRAIN
------------------------------------------------------------

minetest.register_on_generated(function(minp, maxp, blockseed)

    --------------------------------------------------------
    -- Ignore chunks outside the biome height range
    --------------------------------------------------------

    if maxp.y < 0 or minp.y > 100 then
        return
    end


    --------------------------------------------------------
    -- Get voxelmanip
    --------------------------------------------------------

    local vm, emin, emax =
        minetest.get_mapgen_object("voxelmanip")

    if not vm then
        return
    end


    --------------------------------------------------------
    -- Voxel area
    --------------------------------------------------------

    local area = VoxelArea:new({
        MinEdge = emin,
        MaxEdge = emax
    })

    local data = vm:get_data()


    --------------------------------------------------------
    -- Generate noise map
    --------------------------------------------------------

    local sidelen = maxp.x - minp.x + 1

    local perlin_map = minetest.get_perlin_map(
        noise_params,
        {
            x = sidelen,
            y = sidelen
        }
    )

    local noise = perlin_map:get_2d_map_flat({
        x = minp.x,
        y = minp.z
    })


    --------------------------------------------------------
    -- Content IDs
    --------------------------------------------------------

    local grass_id =
        minetest.get_content_id("default:dirt_with_grass")

    local grass_footsteps_id =
        minetest.get_content_id(
            "default:dirt_with_grass_footsteps"
        )

    local autumn_grass_id =
        minetest.get_content_id(
            "autumn_biome:autumn_grass"
        )

    local autumn_footsteps_id =
        minetest.get_content_id(
            "autumn_biome:autumn_grass_footsteps"
        )


    --------------------------------------------------------
    -- Convert terrain to Autumn Grass
    --------------------------------------------------------

    local index = 1

    for z = minp.z, maxp.z do

        for x = minp.x, maxp.x do

            local n = noise[index]

            if n > 0.20 and n <= 0.45 then

                for y = minp.y, maxp.y do

                    local vi = area:index(x, y, z)

                    if data[vi] == grass_id then

                        data[vi] = autumn_grass_id

                    elseif data[vi] == grass_footsteps_id then

                        data[vi] = autumn_footsteps_id
                    end
                end
            end

            index = index + 1
        end
    end


    --------------------------------------------------------
    -- Write terrain
    --------------------------------------------------------

    vm:set_data(data)
    vm:write_to_map()


    --------------------------------------------------------
    -- Generate Autumn trees
    --------------------------------------------------------

    math.randomseed(blockseed)

    for i = 1, 4 do

        local x = math.random(minp.x, maxp.x)
        local z = math.random(minp.z, maxp.z)

        ----------------------------------------------------
        -- Find Autumn Grass
        ----------------------------------------------------

        local y

        for search_y = maxp.y, minp.y, -1 do

            local node = minetest.get_node({
                x = x,
                y = search_y,
                z = z
            })

            if node.name == "autumn_biome:autumn_grass"
                or node.name ==
                    "autumn_biome:autumn_grass_footsteps" then

                y = search_y
                break
            end
        end


        ----------------------------------------------------
        -- Create tree
        ----------------------------------------------------

        if y then

            local above = minetest.get_node({
                x = x,
                y = y + 1,
                z = z
            })

            if above.name == "air" then

                local tree_vm =
                    minetest.get_voxel_manip()

                local p1 = {
                    x = x - 3,
                    y = y + 1,
                    z = z - 3
                }

                local p2 = {
                    x = x + 3,
                    y = y + 8,
                    z = z + 3
                }

                tree_vm:read_from_map(p1, p2)

                make_autumn_tree(
                    tree_vm,
                    {
                        x = x,
                        y = y + 1,
                        z = z
                    }
                )

                tree_vm:write_to_map()
            end
        end
    end
end)


------------------------------------------------------------
-- AUTUMN PUMPKINS
------------------------------------------------------------

minetest.register_on_generated(function(minp, maxp, blockseed)

    math.randomseed(blockseed + 1)

    local pumpkin_count = 4

    for i = 1, pumpkin_count do

        local x = math.random(minp.x, maxp.x)
        local z = math.random(minp.z, maxp.z)


        ----------------------------------------------------
        -- Find Autumn Grass
        ----------------------------------------------------

        local y

        for search_y = maxp.y, minp.y, -1 do

            local node = minetest.get_node({
                x = x,
                y = search_y,
                z = z
            })

            if node.name == "autumn_biome:autumn_grass"
                or node.name ==
                    "autumn_biome:autumn_grass_footsteps" then

                y = search_y
                break
            end
        end


        ----------------------------------------------------
        -- Place pumpkin
        ----------------------------------------------------

        if y then

            local pumpkin_pos = {
                x = x,
                y = y + 1,
                z = z
            }

            local above = minetest.get_node(pumpkin_pos)

            if above.name == "air" then

                minetest.set_node(
                    pumpkin_pos,
                    {
                        name = "autumn_biome:pumpkin"
                    }
                )
            end
        end
    end
end)


------------------------------------------------------------
-- LOAD MESSAGE
------------------------------------------------------------

minetest.log(
    "action",
    "[autumn_biome] Autumn biome loaded"
)
