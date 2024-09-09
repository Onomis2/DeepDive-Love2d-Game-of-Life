local Cells = {}
local cellSize = 10
local isMouseDown = false
local isSimulationRunning = false
local timeAccumulator = 0
local generation = 0

local maxSpeed = 10000
local minSpeed = 50
local speed = minSpeed

local screenSize = {['x'] = 800, ['y'] = 600}
local camera = {pos = {['x'] = 0, ['y'] = 0}, speed = 25}

function love.load()
    love.graphics.setBackgroundColor(0.13, 0.13, 0.13)
end
-- grid broke because simon camerar :/
-- function Grid()
--     local screenWidth = screenSize.x
--     local screenHeight = screenSize.y

--     love.graphics.setColor(0.2, 0.2, 0.2)

--     for x = -camera.pos.x % cellSize, screenWidth, cellSize do
--         love.graphics.line(x, 0, x, screenHeight)
--     end

--     for y = -camera.pos.y % cellSize, screenHeight, cellSize do
--         love.graphics.line(0, y, screenWidth, y)
--     end
-- end

function love.draw()
    love.graphics.push()
    love.graphics.translate(-camera.pos.x, -camera.pos.y)

    -- Grid()

    for _, cell in ipairs(Cells) do
        drawPixelInCell(cell.x, cell.y, cellSize)
    end

    love.graphics.pop()

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("V.0.0.1", 10, 10)
    love.graphics.print("Fps: " .. love.timer.getFPS(), 10, 30)
    love.graphics.print("Generation: " .. generation, 10, 50)
    love.graphics.print("Population: " .. #Cells, 10, 70)
    love.graphics.print("Speed: " .. speed .. "X", 10, 90)
end

function drawPixelInCell(cellX, cellY, cellSize)
    local x = cellX * cellSize
    local y = cellY * cellSize

    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", x, y, cellSize, cellSize)
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        isMouseDown = true
        addCell(x + camera.pos.x, y + camera.pos.y)
    end
end

function love.mousereleased(x, y, button, istouch, presses)
    if button == 1 then
        isMouseDown = false
    end
end

function love.update(dt)
    Controls()

    if isMouseDown then
        local x, y = love.mouse.getPosition()
        addCell(x + camera.pos.x, y + camera.pos.y)
    end

    if isSimulationRunning then
        timeAccumulator = timeAccumulator + dt * speed
        if timeAccumulator >= 1 then
            updateCells()
            timeAccumulator = timeAccumulator - 1
        end
    end
end

function addCell(x, y)
    local cellX = math.floor(x / cellSize)
    local cellY = math.floor(y / cellSize)
    table.insert(Cells, {x = cellX, y = cellY})
end

function updateCells()
    local newCells = {}
    local cellMap = {}

    for _, cell in ipairs(Cells) do
        cellMap[cell.x .. "," .. cell.y] = true
    end

    local function countNeighbors(x, y)
        local count = 0
        for dx = -1, 1 do
            for dy = -1, 1 do
                if not (dx == 0 and dy == 0) and cellMap[(x + dx) .. "," .. (y + dy)] then
                    count = count + 1
                end
            end
        end
        return count
    end

    local checkedCells = {}

    for _, cell in ipairs(Cells) do
        for dx = -1, 1 do
            for dy = -1, 1 do
                local x = cell.x + dx
                local y = cell.y + dy
                if not checkedCells[x .. "," .. y] then
                    checkedCells[x .. "," .. y] = true
                    local neighbors = countNeighbors(x, y)
                    if cellMap[x .. "," .. y] then
                        if neighbors == 2 or neighbors == 3 then
                            table.insert(newCells, {x = x, y = y})
                        end
                    else
                        if neighbors == 3 then
                            table.insert(newCells, {x = x, y = y})
                        end
                    end
                end
            end
        end
    end

    Cells = newCells
    generation = generation + 1
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "c" then
        Cells = {}
    elseif key == "space" then
        isSimulationRunning = not isSimulationRunning
    elseif key == "q" then
        speed = math.max(minSpeed, speed - 10)
    elseif key == "e" then
        speed = math.min(maxSpeed, speed + 10)
    end
end

function Controls()
    if love.keyboard.isDown('w') then
        camera.pos.y = camera.pos.y - camera.speed
    end
    if love.keyboard.isDown('s') then
        camera.pos.y = camera.pos.y + camera.speed
    end
    if love.keyboard.isDown('a') then
        camera.pos.x = camera.pos.x - camera.speed
    end
    if love.keyboard.isDown('d') then
        camera.pos.x = camera.pos.x + camera.speed
    end
end