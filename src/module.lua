local module = {}

local cell = {[1] = {[1] = 1}}
local width, height = love.window.getDesktopDimensions()
local screenSize = {['x'] = width, ['y'] = height}
local camera = {pos = {['x'] = 0, ['y'] = 0}, speed = 25}
local cellSize = 10

local isRunning = false

function module.load()
end

function module.update(dt, isRunning)
    -- Update logic based on isRunning
end

function countCells()
    local count = 0
    for y, row in pairs(cell) do
        for x, value in pairs(row) do
            if value == 1 then
                count = count + 1
            end
        end
    end
    return count
end

function module.debug(isRunning)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(tostring(love.timer.getFPS()) .. " fps", 10, height - 40)
    love.graphics.print("V0.0.1", 10, height - 20)
    love.graphics.print("Camera Speed: " .. camera.speed, 10, height - 60)
    love.graphics.print("Camera X: " .. camera.pos.x .. ", Camera Y: " .. camera.pos.y, 10, height - 80)
    love.graphics.print("Population: " .. countCells(), 10, height - 100)
    love.graphics.print("isRunning: " .. tostring(isRunning), 10, height - 120)
end

function grid()
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
end

function module.draw()
    for y, row in pairs(cell) do
        for x, value in pairs(row) do
            module.DrawTile(x, y)
        end
    end

    grid()
end

function module.DrawTile(x, y)
    if cell[y][x] == 1 then
        love.graphics.setColor(0, 1, 0)
    end
    love.graphics.rectangle("fill", (x * cellSize) - camera.pos.x + (screenSize.x / 2), (y * cellSize) - camera.pos.y + (screenSize.y / 2), cellSize, cellSize)
end

function module.wheelmoved(x, y)
    local oldcellSize = cellSize

    if y > 0 and cellSize < 100 then
        cellSize = cellSize + 1
    elseif y < 0 and cellSize > 1 then
        cellSize = cellSize - 1
    end

    local scaleFactor = cellSize / oldcellSize
    camera.pos.x = camera.pos.x * scaleFactor
    camera.pos.y = camera.pos.y * scaleFactor
end

function module.clearCells()
    for y, row in pairs(cell) do
        for x, _ in pairs(row) do
            cell[y][x] = nil
        end
    end
end

function module.Camera()
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

    if love.keyboard.isDown('lshift') then
        camera.speed = 50
    else
        camera.speed = 25
    end
end

function module.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
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

function module.setRunning(state)
    isRunning = state
end

return module