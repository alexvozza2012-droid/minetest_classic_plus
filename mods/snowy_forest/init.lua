local snowygrass = "snowy_forest:snowygrass"
local snowy_tree = "snowy_forest:snowy_tree"
local snowy_leaves = "snowy_forest:snowy_leaves"


-- ==========================================
-- SNOWY GRASS
-- ==========================================

minetest.register_node(snowygrass, {
    description = "Snowy Grass",

    tiles = {
        "snowygrass.png",
        "dirt.png",
        "snowygrass_side.png"
    },

    groups = {
        dirt = 2
    },

    drop = "default:dirt",

    sounds = default.node_sound_grass
})


-- ==========================================
-- SNOWY TREE
-- ==========================================

minetest.register_node(snowy_tree, {
    description = "Snowy Tree",

    tiles = {
        "snowytree_top.png",
        "snowytree_top.png",
        "snowy_tree.png",
        "snowy_tree.png",
        "snowy_tree.png",
        "snowy_tree.png"
    },

    groups = {
        wood = 5
    },

    sounds = default.node_sound.wood
})


-- ==========================================
-- SNOWY LEAVES
-- ==========================================

minetest.register_node(snowy_leaves, {
    description = "Snowy Leaves",

    tiles = {
        "snowy_leaves.png"
    },

    special_tiles = {
        "snowy_leaves.png"
    },

    groups = {
        wood = 2
    },

    drawtype = "allfaces_optional",

    waving = default.modernize.node_waving and 2 or nil,

    paramtype = "light",

    is_ground_content = false,

    drop = {
        items = {
            {
                items = {"default:sapling"},
                rarity = 20
            },

            {
                items = {snowy_leaves}
            }
        }
    },

    sounds = default.node_sound.leaves
})


-- ==========================================
-- SNOWY TREEGEN
-- ==========================================

local function make_snowy_tree(vm, p0)

    local n_tree = {
        name = snowy_tree
    }

    local n_leaves = {
        name = snowy_leaves
    }

    local trunk_h = math.random(4, 6)

    local p1 = vector.new(
        p0.x,
        p0.y,
        p0.z
    )


    -- Tronco
    for i = 1, trunk_h do

        vm:set_node_at(p1, n_tree)

        p1.y = p1.y + 1

    end


    p1.y = p1.y - 1


    -- Funzione per piazzare le foglie
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


    -- ==========================================
    -- RAMI
    -- ==========================================

    if trunk_h >= 5 then

        -- Est
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


        -- Ovest
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


        -- Sud
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


        -- Nord
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


    -- ==========================================
    -- STRATO INFERIORE DELLE FOGLIE
    -- ==========================================

    for x = -2, 2 do

        for z = -2, 2 do

            if math.abs(x) + math.abs(z) <= 3 then

                place_leaf(x, -1, z)

            end

        end

    end


    -- ==========================================
    -- STRATO CENTRALE
    -- ==========================================

    for x = -2, 2 do

        for z = -2, 2 do

            if math.abs(x) + math.abs(z) <= 3 then

                if math.random(0, 99) < 90 then

                    place_leaf(x, 0, z)

                end

            end

        end

    end


    -- ==========================================
    -- STRATO SUPERIORE
    -- ==========================================

    for x = -1, 1 do

        for z = -1, 1 do

            if math.random(0, 99) < 90 then

                place_leaf(x, 1, z)

            end

        end

    end


    -- Foglia sulla cima
    place_leaf(0, 2, 0)


    -- Alcune foglie laterali
    if math.random(0, 99) < 50 then
        place_leaf(-2, 0, 0)
    end

    if math.random(0, 99) < 50 then
        place_leaf(2, 0, 0)
    end

    if math.random(0, 99) < 50 then
        place_leaf(0, 0, -2)
    end

    if math.random(0, 99) < 50 then
        place_leaf(0, 0, 2)
    end

end


-- ==========================================
-- TERRAIN NOISE
-- ==========================================

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


-- ==========================================
-- SNOWY FOREST GENERATION
-- ==========================================

minetest.register_on_generated(function(minp, maxp, blockseed)

    -- Solo la superficie del mondo
    if maxp.y < 0 or minp.y > 100 then
        return
    end


    local vm, emin, emax =
        minetest.get_mapgen_object("voxelmanip")

    if not vm then
        return
    end


    local area = VoxelArea:new({
        MinEdge = emin,
        MaxEdge = emax
    })


    local data = vm:get_data()


    local c_grass =
        minetest.get_content_id("default:dirt_with_grass")

    local c_snowygrass =
        minetest.get_content_id(snowygrass)


    local size_x =
        maxp.x - minp.x + 1

    local size_z =
        maxp.z - minp.z + 1


    local noise_map =
        minetest.get_perlin_map(
            noise_params,
            {
                x = size_x,
                y = size_z
            }
        )


    local noise_values =
        noise_map:get_2d_map_flat({
            x = minp.x,
            y = minp.z
        })


    local index = 1


    -- ==========================================
    -- SNOWY GRASS
    -- ==========================================

    for z = minp.z, maxp.z do

        for x = minp.x, maxp.x do

            local noise = noise_values[index]

            index = index + 1


            if noise > 0.45 then

                local surface_y = nil


                for y = maxp.y, minp.y, -1 do

                    local vi =
                        area:index(x, y, z)


                    if data[vi] == c_grass then

                        surface_y = y

                        break

                    end

                end


                if surface_y then

                    local vi =
                        area:index(
                            x,
                            surface_y,
                            z
                        )

                    data[vi] = c_snowygrass

                end

            end

        end

    end


    vm:set_data(data)

    vm:write_to_map()

    vm:update_map()


    -- ==========================================
    -- SNOWY FOREST TREES
    -- ==========================================

    math.randomseed(blockseed)


    for i = 1, 4 do

        local x =
            math.random(
                minp.x + 2,
                maxp.x - 2
            )

        local z =
            math.random(
                minp.z + 2,
                maxp.z - 2
            )


        -- Controlla se il punto è nella Snowy Forest
        local noise =
            minetest.get_perlin_map(
                noise_params,
                {
                    x = 1,
                    y = 1
                }
            ):get_2d_map_flat({
                x = x,
                y = z
            })[1]


        if noise > 0.45 then

            -- Cerca la superficie
            local y = maxp.y


            while y >= minp.y do

                local node =
                    minetest.get_node({
                        x = x,
                        y = y,
                        z = z
                    })


                if node.name == snowygrass then
                    break
                end


                y = y - 1

            end


            if y >= minp.y then

                local above =
                    minetest.get_node({
                        x = x,
                        y = y + 1,
                        z = z
                    })


                if above.name == "air" then

                    -- Area abbastanza grande per l'albero
                    local tree_vm =
                        minetest.get_voxel_manip()


                    local p1 = {
                        x = x - 4,
                        y = y,
                        z = z - 4
                    }


                    local p2 = {
                        x = x + 4,
                        y = y + 8,
                        z = z + 4
                    }


                    tree_vm:read_from_map(
                        p1,
                        p2
                    )


                    -- Il nostro TreeGen innevato
                    make_snowy_tree(
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

    end

end)


print("[Snowy Forest] Loaded")
