<<<<<<< HEAD
-- Initialise variables
local cell = {[1] = {[1] = 1}} -- cell[x][y][cellType]
local width,height = love.window.getDesktopDimensions()
local screenSize = {['x'] = width, ['y'] = height} -- screenSize[axis]
local camera = {pos = {['x'] = 0, ['y'] = 0}, speed = 25} -- camera[property][axis/value][value]
local cellSize = 50
local paused = true

=======
local module = require("module")
>>>>>>> test

local debug = true
local isRunning = false

function love.load()
    module.load()
end

function love.update(dt)
<<<<<<< HEAD
    -- Game
    Controls()
    if paused == false then
        local newCells = {}
        cell = UpdateCells(newCells)
    end

    -- Debugging
    if debug == true then
        local veryTempX, veryTempY = love.mouse.getPosition()
        tileX = math.floor((veryTempX - (screenSize.x / 2) + camera.pos.x) / cellSize)
        tileY = math.floor((veryTempY - (screenSize.y / 2) + camera.pos.y) / cellSize)

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


=======
    module.Camera()
    module.update(dt, isRunning)
>>>>>>> test
end

function love.draw()
    module.draw()
    if debug then module.debug(isRunning) end
end

<<<<<<< HEAD
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

    function love.keypressed( key, scancode, isrepeat )

        if scancode == "space" then
            paused = not paused
        end

    end

    -- Debugging keybinds
    if love.keyboard.isDown('h') and debug == true then
        camera.pos.x,camera.pos.y = 10800000,10800000
    end

=======
function love.wheelmoved(x, y)
    module.wheelmoved(x, y)
>>>>>>> test
end

function love.mousepressed(x, y, button, istouch, presses)
    module.mousepressed(x, y, button, istouch, presses)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "c" then
        module.clearCells()
    elseif key == "h" then
        debug = not debug
    elseif key == "space" then
        isRunning = not isRunning
        module.setRunning(isRunning)
    end

end

function DrawTile(x, y)
    -- If a tile was found, set color to 1
    if cell[y][x] == 1 then
        love.graphics.setColor(1, 1, 1)
    end
    -- Fill location of tile with rectangle and resize it accordingly
    love.graphics.rectangle("fill", (x * cellSize) - camera.pos.x + (screenSize.x / 2), (y * cellSize) - camera.pos.y + (screenSize.y / 2), cellSize, cellSize)
end

function UpdateCells(newCells)

    for a,b in ipairs(cell) do
        local population = 0
        for x = -1,1 do
            for y = -1,1 do
                if not x == 0 and y == 0 and cell[x][y] == 1 then
                    population = population + 1
                end
            end
        end
        if population == 2 or population == 3 or
    end


end