function love.load()

    map = {
        [1] = {[1] = 1}
    }
    debug = true
    screenSize = {['x'] = 800, ['y'] = 600}
    cellSize = 50
    defaultFont = love.graphics.newFont(12)
	camera = {pos = {['x'] = 0, ['y'] = 0}, speed = 25}

    --Debugging
    text = {}

end

function love.update(dt)
    -- Game
    Controls()

    -- Debugging
    if debug == true then
        local veryTempX, veryTempY = love.mouse.getPosition()
        tileX = math.floor((veryTempX - (screenSize.x / 2) + camera.pos.x) / cellSize)
        tileY = math.floor((veryTempY - (screenSize.y / 2) + camera.pos.y) / cellSize)

        text[2] = screenSize.x .. ":" .. screenSize.y
        text[3] = cellSize
        text[4] = tostring(menu)
        text[6] = camera.direction
        text[7] = camera.pos.x .. ":" .. camera.pos.y
        text[8] = veryTempX .. ":" .. veryTempY

        -- Check and initialize the map coordinate if necessary
        if map[tileY] and map[tileY][tileX] then
            text[9] = map[tileY][tileX]
        else
            text[9] = "Out of bounds"
        end
    end

end


function love.draw()

    love.graphics.setFont(defaultFont)

    -- Required
    for y, row in pairs(map) do
        for x, value in pairs(row) do
            -- Draw only the specified tiles
            DrawTile(x, y)
        end
    end

        -- Debugging
        if debug == true then
            love.graphics.setFont(defaultFont)
            for a, b in pairs(text) do
                love.graphics.setColor(1, 1, 1)
                love.graphics.print(b, 10, a * 10, 0, 1, 1)
            end
        end

end



function DrawTile(x, y)
    local tile = map[y][x]
    if tile then
        if tile == 1 then
            love.graphics.setColor(0, 1, 0, trans)
        elseif tile == "mountain" then
            love.graphics.setColor(0.3, 0.3, 0.3, trans)
        elseif tile == "water" then
            love.graphics.setColor(0, 0, 1, trans)
        else
            love.graphics.setColor(0, 0, 0, trans)
        end
    else
        love.graphics.setColor(0, 0, 0, trans)
    end
    love.graphics.rectangle("fill", (x * cellSize) - camera.pos.x + (screenSize.x / 2), (y * cellSize) - camera.pos.y + (screenSize.y / 2), cellSize, cellSize)
end

function love.wheelmoved(x, y, map)
    local oldcellSize = cellSize

    if y > 0 and cellSize < 100 then
        cellSize = cellSize + 1
    elseif y < 0 and cellSize > 1 then
        cellSize = cellSize - 1
    end

    -- Calculate the difference in the camera's position based on the change in zoom
    local scaleFactor = cellSize / oldcellSize
    camera.pos.x = camera.pos.x * scaleFactor
    camera.pos.y = camera.pos.y * scaleFactor
end

function Controls()

    if love.keyboard.isDown('w') then
        camera.direction = 'up'
        camera.pos.y = camera.pos.y - camera.speed
    elseif love.keyboard.isDown('s') then
        camera.direction = 'down'
        camera.pos.y = camera.pos.y + camera.speed
    end
    
    if love.keyboard.isDown('a') then
        camera.direction = 'left'
        camera.pos.x = camera.pos.x - camera.speed
    elseif love.keyboard.isDown('d') then
        camera.direction = 'right'
        camera.pos.x = camera.pos.x + camera.speed
    end

    if love.keyboard.isDown('h') and debug == true then
        camera.pos.x,camera.pos.y = 10800000,10800000
    end

end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then -- left mouse button
        -- Convert screen coordinates to map coordinates
        local mapX = math.floor((x - (screenSize.x / 2) + camera.pos.x) / cellSize)
        local mapY = math.floor((y - (screenSize.y / 2) + camera.pos.y) / cellSize)
        
        -- Initialize the map at mapY if it doesn't exist
        if not map[mapY] then
            map[mapY] = {}
        end

        -- Initialize the tile at mapY, mapX if it doesn't exist
        if not map[mapY][mapX] then
            map[mapY][mapX] = 1
        end
    end
end