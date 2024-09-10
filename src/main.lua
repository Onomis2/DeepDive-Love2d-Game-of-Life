-- Initialise variables
cell = {} -- cell[x][y][cellType]
local width,height = love.window.getDesktopDimensions()
local screenSize = {['x'] = width, ['y'] = height} -- screenSize[axis]
local camera = {pos = {['x'] = 0, ['y'] = 0}, speed = 25} -- camera[property][axis/value][value]
local text = {}
local cellSize = 50
local paused = true


local debug = true
local isRunning = false

function love.load()
end

function love.update(dt)
    -- Game
    Controls()
    if paused == false then
        cell,text[8] = UpdateCells()
    end

    -- Debugging
    if debug == true then
        local veryTempX, veryTempY = love.mouse.getPosition()
        tileX = math.floor((veryTempX - (screenSize.x / 2) + camera.pos.x) / cellSize)
        tileY = math.floor((veryTempY - (screenSize.y / 2) + camera.pos.y) / cellSize)

        text[1] = love.timer.getFPS()
        text[2] = screenSize.x .. ":" .. screenSize.y
        text[3] = cellSize
        text[4] = camera.pos.x .. ":" .. camera.pos.y
        text[5] = veryTempX .. ":" .. veryTempY

        -- Check and initialize the cell coordinate if necessary
        if cell[tileY] and cell[tileY][tileX] then
            text[6] = cell[tileY][tileX]
        else
            text[6] = "Dead"
        end

        text[7] = tostring(paused)
    end


end

function love.draw()
    --module.draw()
    if debug then 
        --module.debug(isRunning, sfx) 
     end

        -- Required
        for y, row in pairs(cell) do
            for x, value in pairs(row) do
                DrawTile(x, y)
            end
        end
    
        love.graphics.setColor(0.1, 0.1, 0.1)
        local gridSize = cellSize >= 10 and cellSize or cellSize * 10
        for i = 0, screenSize.x / gridSize do
            local lineX = (i * gridSize) - camera.pos.x % gridSize + (screenSize.x / 2) % gridSize
            love.graphics.line(lineX, 0, lineX, screenSize.y)
        end
        for i = 0, screenSize.y / gridSize do
            local lineY = (i * gridSize) - camera.pos.y % gridSize + (screenSize.y / 2) % gridSize
            love.graphics.line(0, lineY, screenSize.x, lineY)
        end
    
        -- Debugging
        if debug == true then
            for a, b in pairs(text) do
                love.graphics.setColor(1, 1, 1)
                love.graphics.print(b, 10, a * 10, 0, 1, 1)
            end
        end
    
    end

-- Functions

function love.wheelmoved(x, y, cell)
    local oldcellSize = cellSize

    -- Zoom in
    if y > 0 and cellSize < 100 then
        cellSize = cellSize + 1
    -- Zoom out
    elseif y < 0 and cellSize > 1 then
        cellSize = cellSize - 1
    end

    -- Calculate camera position to smoothen zoom
    local scaleFactor = cellSize / oldcellSize
    camera.pos.x = camera.pos.x * scaleFactor
    camera.pos.y = camera.pos.y * scaleFactor
end

function Controls()

    --Movement keybinds
    if love.keyboard.isDown('w') then
        camera.direction = 'up'
        camera.pos.y = camera.pos.y - camera.speed
    end

    if love.keyboard.isDown('s') then
        camera.direction = 'down'
        camera.pos.y = camera.pos.y + camera.speed
    end

    if love.keyboard.isDown('a') then
        camera.direction = 'left'
        camera.pos.x = camera.pos.x - camera.speed
    end

    if love.keyboard.isDown('d') then
        camera.direction = 'right'
        camera.pos.x = camera.pos.x + camera.speed
    end

    -- Debugging keybinds
    if love.keyboard.isDown('h') and debug == true then
        camera.pos.x,camera.pos.y = 10800000,10800000
    end

end

function love.mousepressed(x, y, button, istouch, presses)

    -- Check left mouse press
    if button == 1 then

        -- Calculate where to place pixel
        local cellX = math.floor((x - (screenSize.x / 2) + camera.pos.x) / cellSize)
        local cellY = math.floor((y - (screenSize.y / 2) + camera.pos.y) / cellSize)

        if not cell[cellY] then
            cell[cellY] = {}
        end

        if not cell[cellY][cellX] then
            cell[cellY][cellX] = 1
        end
    end

end

function DrawTile(x, y)
    -- If a tile was found, set color to 1
    if cell[y][x] == 1 then
        love.graphics.setColor(math.random(1,0.1), math.random(1,0.1), math.random(1,0.1))
    end
    love.graphics.rectangle("fill", (x * cellSize) - camera.pos.x + (screenSize.x / 2), (y * cellSize) - camera.pos.y + (screenSize.y / 2), cellSize, cellSize)

end

function love.mousereleased(x, y, button, istouch, presses)
    --module.mousereleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
    --module.mousemoved(x, y, dx, dy, istouch, sfx)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "c" then
        module.clearCells()
    elseif key == "h" then
        debug = not debug
    elseif key == "space" then
        paused = not paused
        --module.setRunning(isRunning)
    elseif key == "m" then
        sfx = not sfx
        module.mute(sfx)
    end
    -- Fill location of tile with rectangle and resize it accordingly
    --module.mousepressed(x, y, button, istouch, presses, sfx)
end

function UpdateCells()
    local newCells = {}
    local count = 0

    for x, row in pairs(cell) do
        for y, _ in pairs(row) do
            count = count + 1
            for dx = -1, 1 do
                for dy = -1, 1 do
                    local nx, ny = x + dx, y + dy
                    if not newCells[nx] then newCells[nx] = {} end

                    local population = 0
                    for ddx = -1, 1 do
                        for ddy = -1, 1 do
                            local nnx, nny = nx + ddx, ny + ddy
                            if not (ddx == 0 and ddy == 0) and cell[nnx] and cell[nnx][nny] == 1 then
                                population = population + 1
                            end
                        end
                    end

                    if cell[nx] and cell[nx][ny] == 1 then
                        newCells[nx][ny] = (population == 2 or population == 3) and 1 or 0
                    else
                        newCells[nx][ny] = (population == 3) and 1 or 0
                    end
                end
            end
        end
    end

    for x, row in pairs(newCells) do
        for y, value in pairs(row) do
            if value == 0 then
                newCells[x][y] = nil
            end
        end
        if next(newCells[x]) == nil then
            newCells[x] = nil
        end
    end

    return newCells,count
end