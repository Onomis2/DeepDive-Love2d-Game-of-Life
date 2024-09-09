local module = {}

local cell = {[1] = {[1] = 1}}
local width, height = love.window.getDesktopDimensions(flags)
local screenSize = {['x'] = width, ['y'] = height}
local camera = {pos = {['x'] = 0, ['y'] = 0}, speed = 25}
local cellSize = 10

local debug = false
local previousDebug = false

function module.load()
end

function module.update(dt)
    module.Controls()
end

function module.draw()
    for y, row in pairs(cell) do
        for x, value in pairs(row) do
            module.DrawTile(x, y)
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

    if debug then
        love.graphics.setColor(1, 1, 1)
        fps = love.timer.getFPS()
        love.graphics.print(fps .. " fps", 10, height - 40)
        love.graphics.print("V0.0.1", 10, height - 20)
    end
end

function module.DrawTile(x, y)
    if cell[y][x] == 1 then
        love.graphics.setColor(0, 1, 0)
    end
    love.graphics.rectangle("fill", (x * cellSize) - camera.pos.x + (screenSize.x / 2), (y * cellSize) - camera.pos.y + (screenSize.y / 2), cellSize, cellSize)
end

function module.wheelmoved(x, y, cell)
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

function module.Controls()
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

    if love.keyboard.isDown('escape') then
        love.event.quit()
    end

    if love.keyboard.isDown('c') then
        module.clearCells()
    end

    local currentDebugState = love.keyboard.isDown('h')
    if currentDebugState and not previousDebug then
        debug = not debug
    end
    previousDebug = currentDebugState
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
return module