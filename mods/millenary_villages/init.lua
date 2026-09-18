--------------------------------------------------
-- MILLENARY VILLAGES
-- Minetest Classic Plus
--------------------------------------------------


--------------------------------------------------
-- CERCA TERRENO PIANEGGIANTE
--------------------------------------------------

local function find_flat_position(center, radius)

    local best_pos = nil
    local best_score = math.huge

    for dx = -radius, radius do
        for dz = -radius, radius do

            local x = center.x + dx
            local z = center.z + dz

            local heights = {}

            -- Controlla una zona 5x5
            for ox = -2, 2 do
                for oz = -2, 2 do

                    local top = nil

                    for y = center.y + 20,
                              center.y - 20,
                              -1 do

                        local node =
                            minetest.get_node({
                                x = x + ox,
                                y = y,
                                z = z + oz
                            })

                        if node.name ~= "air"
                            and node.name ~= "ignore" then

                            top = y
                            break
                        end
                    end

                    if top then
                        table.insert(
                            heights,
                            top
                        )
                    end
                end
            end

            if #heights == 25 then

                local min_y = heights[1]
                local max_y = heights[1]

                for _, h in ipairs(heights) do

                    if h < min_y then
                        min_y = h
                    end

                    if h > max_y then
                        max_y = h
                    end
                end

                local difference =
                    max_y - min_y

                local score =
                    difference * 100
                    + math.abs(dx)
                    + math.abs(dz)

                if difference <= 2
                    and score < best_score then

                    best_score = score

                    best_pos = {
                        x = x,
                        y = min_y + 1,
                        z = z
                    }
                end
            end
        end
    end

    return best_pos
end


--------------------------------------------------
-- GENERA UNA CASA
--------------------------------------------------

local function place_house(pos, width, depth)

    local height = 3

    local half_w =
        math.floor(width / 2)

    local half_d =
        math.floor(depth / 2)


    local minp = {
        x = pos.x - half_w - 1,
        y = pos.y - 2,
        z = pos.z - half_d - 1
    }

    local maxp = {
        x = pos.x + half_w + 1,
        y = pos.y + 8,
        z = pos.z + half_d + 1
    }


    local vm =
        minetest.get_voxel_manip()

    local emin, emax =
        vm:read_from_map(
            minp,
            maxp
        )


    local area =
        VoxelArea:new({
            MinEdge = emin,
            MaxEdge = emax
        })


    local data =
        vm:get_data()


    --------------------------------------------------
    -- TROVA TERRENO
    --------------------------------------------------

    local ground_y = nil

    for y = emax.y, emin.y, -1 do

        local vi =
            area:index(
                pos.x,
                y,
                pos.z
            )

        local name =
            minetest.get_name_from_content_id(
                data[vi]
            )

        if name ~= "air"
            and name ~= "ignore" then

            ground_y = y
            break
        end
    end


    if not ground_y then
        return false
    end


    local base_y =
        ground_y + 1


    --------------------------------------------------
    -- CONTENT ID
    --------------------------------------------------

    local wood =
        minetest.get_content_id(
            "default:wood"
        )

    local cobble =
        minetest.get_content_id(
            "default:cobble"
        )


    --------------------------------------------------
    -- PAVIMENTO
    --------------------------------------------------

    for x = -half_w, half_w do

        for z = -half_d, half_d do

            local vi =
                area:index(
                    pos.x + x,
                    base_y,
                    pos.z + z
                )

            data[vi] = wood
        end
    end


    --------------------------------------------------
    -- PARETI
    --------------------------------------------------

    for y = 1, height do

        for x = -half_w, half_w do

            for z = -half_d, half_d do

                local wall =
                    x == -half_w
                    or x == half_w
                    or z == -half_d
                    or z == half_d


                if wall then

                    -- Porta
                    local door =
                        z == -half_d
                        and x == 0
                        and (
                            y == 1
                            or y == 2
                        )


                    if not door then

                        local vi =
                            area:index(
                                pos.x + x,
                                base_y + y,
                                pos.z + z
                            )

                        data[vi] = wood
                    end
                end
            end
        end
    end


    --------------------------------------------------
    -- TETTO
    --------------------------------------------------

    for x = -half_w, half_w do

        for z = -half_d, half_d do

            local vi =
                area:index(
                    pos.x + x,
                    base_y + height + 1,
                    pos.z + z
                )

            data[vi] = cobble
        end
    end


    --------------------------------------------------
    -- SCRIVE LA CASA
    --------------------------------------------------

    vm:set_data(data)

    vm:write_to_map()

    vm:update_map()


    return true
end


--------------------------------------------------
-- CREA PIAZZETTA
--------------------------------------------------

local function place_square(center)

    local radius = 3

    for x = -radius, radius do

        for z = -radius, radius do

            local p = {
                x = center.x + x,
                y = center.y - 1,
                z = center.z + z
            }


            local node =
                minetest.get_node(p)


            if node.name ==
                    "default:dirt_with_grass"
                or node.name ==
                    "default:dirt"
                or node.name ==
                    "default:grass" then

                minetest.set_node(
                    p,
                    {
                        name = "default:dirt"
                    }
                )
            end
        end
    end
end


--------------------------------------------------
-- CREA SENTIERO
--------------------------------------------------

local function place_path(from_pos, to_pos)
    local x = from_pos.x
    local z = from_pos.z

    local path_points = {}


    --------------------------------------------------
    -- PRIMA X
    --------------------------------------------------

    while x ~= to_pos.x do
        table.insert(
            path_points,
            {
                x = x,
                z = z
            }
        )


        if x < to_pos.x then
            x = x + 1
        else
            x = x - 1
        end
    end


    --------------------------------------------------
    -- POI Z
    --------------------------------------------------

    while z ~= to_pos.z do
        table.insert(
            path_points,
            {
                x = x,
                z = z
            }
        )


        if z < to_pos.z then
            z = z + 1
        else
            z = z - 1
        end
    end


    table.insert(
        path_points,
        {
            x = to_pos.x,
            z = to_pos.z
        }
    )


    --------------------------------------------------
    -- CREA TERRENO BATTUTO
    --------------------------------------------------

    for _, point in ipairs(path_points) do
        local y = from_pos.y


        for check_y = from_pos.y + 5,
        from_pos.y - 5,
        -1 do
            local node =
                minetest.get_node({
                    x = point.x,
                    y = check_y,
                    z = point.z
                })


            if node.name ~= "air"
                and node.name ~= "ignore" then
                y = check_y
                break
            end
        end


        -- Lascia qualche interruzione
        -- per renderlo naturale

        if math.random(1, 100) <= 85 then
            minetest.set_node(
                {
                    x = point.x,
                    y = y,
                    z = point.z
                },
                {
                    name = "default:dirt"
                }
            )
        end
    end
end

--------------------------------------------------
-- POZZO MILLENARIO
--------------------------------------------------

local function place_well(center)

    local x = center.x
    local y = center.y
    local z = center.z

    local cobble = "default:cobble"
    local water = "default:water_source"

    -- Base 3x3
    for dx = -1, 1 do
        for dz = -1, 1 do

            minetest.set_node(
                {
                    x = x + dx,
                    y = y,
                    z = z + dz
                },
                {
                    name = cobble
                }
            )
        end
    end

    -- Acqua centrale
    minetest.set_node(
        {
            x = x,
            y = y + 1,
            z = z
        },
        {
            name = water
        }
    )

    -- Bordo del pozzo
    local border = {
        {x = -1, z = 0},
        {x = 1,  z = 0},
        {x = 0,  z = -1},
        {x = 0,  z = 1}
    }

    for _, p in ipairs(border) do

        minetest.set_node(
            {
                x = x + p.x,
                y = y + 1,
                z = z + p.z
            },
            {
                name = cobble
            }
        )
    end

    print(
        "[Millenary Villages] "
        .. "Ancient well generated at "
        .. x .. ", " .. z
    )
end


--------------------------------------------------
-- VILLAGGIO MILLENARIO
--------------------------------------------------

local function place_village(center)

    local houses =
        math.random(3, 5)


    --------------------------------------------------
    -- POSIZIONI CASE
    --------------------------------------------------

    local positions = {

        {x = 0,  z = -12},

        {x = 12, z = 0},

        {x = -12, z = 0},

        {x = 0,  z = 12},

        {x = 9,  z = 9}
    }


    --------------------------------------------------
    -- TROVA CENTRO
    --------------------------------------------------

    local village_center =
        find_flat_position(
            center,
            8
        )


    if not village_center then

        print(
            "[Millenary Villages] "
            .. "No suitable terrain found"
        )

        return
    end


    --------------------------------------------------
    -- PIAZZA
    --------------------------------------------------

    place_square(
        village_center
    )

    place_well(
        village_center
    )


    --------------------------------------------------
    -- CASE
    --------------------------------------------------

    local generated = 0


    for i = 1, houses do

        local offset =
            positions[i]


        local target = {

            x =
                village_center.x
                + offset.x,

            y =
                village_center.y,

            z =
                village_center.z
                + offset.z
        }


        --------------------------------------------------
        -- CERCA TERRENO
        --------------------------------------------------

        local house_pos =
            find_flat_position(
                target,
                5
            )


        if house_pos then

            local width =
                math.random(5, 7)

            local depth =
                math.random(5, 7)


            if place_house(
                house_pos,
                width,
                depth
            ) then

                generated =
                    generated + 1


                --------------------------------------------------
                -- SENTIERO
                --------------------------------------------------

                place_path(
                    village_center,
                    house_pos
                )


                print(
                    "[Millenary Villages] "
                    .. "House "
                    .. generated
                    .. ": "
                    .. width
                    .. "x"
                    .. depth
                )
            end
        end
    end


    --------------------------------------------------
    -- LOG FINALE
    --------------------------------------------------

    print(
        "[Millenary Villages] "
        .. "Ancient village generated at "
        .. village_center.x
        .. ", "
        .. village_center.z
        .. " with "
        .. generated
        .. " houses"
    )
end


--------------------------------------------------
-- GENERAZIONE AUTOMATICA
--------------------------------------------------

minetest.register_on_generated(
    function(minp, maxp, blockseed)

        --------------------------------------------------
        -- MOLTO RARO
        --------------------------------------------------

        if math.random(1, 500) ~= 1 then
            return
        end


        --------------------------------------------------
        -- CENTRO CHUNK
        --------------------------------------------------

        local center_x =
            math.floor(
                (minp.x + maxp.x) / 2
            )


        local center_z =
            math.floor(
                (minp.z + maxp.z) / 2
            )


        --------------------------------------------------
        -- DISTANZA SPAWN
        --------------------------------------------------

        local distance =
            math.sqrt(
                center_x * center_x
                + center_z * center_z
            )


        -- Nessun villaggio vicino allo spawn
        if distance < 500 then
            return
        end


        --------------------------------------------------
        -- GENERA
        --------------------------------------------------

        local center = {

            x = center_x,

            y = minp.y,

            z = center_z
        }


        place_village(center)

    end
)


--------------------------------------------------
-- COMANDO DI TEST
--------------------------------------------------

minetest.register_chatcommand(
    "millenary_test",
    {

        description =
            "Genera un villaggio millenario vicino al giocatore",


        privs = {
            server = true
        },


        func = function(name)

            local player =
                minetest.get_player_by_name(
                    name
                )


            if not player then

                return false,
                    "Giocatore non trovato."
            end


            local p =
                player:get_pos()


            local center = {

                x =
                    math.floor(p.x),

                y =
                    math.floor(p.y) - 1,

                z =
                    math.floor(p.z) + 15
            }


            place_village(center)


            return true,
                "Villaggio millenario generato davanti a te!"

        end
    }
)
