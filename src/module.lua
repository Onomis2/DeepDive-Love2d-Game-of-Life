local module = {}

cell = {[1] = {[1] = 1}}
local width, height = love.window.getDesktopDimensions()
local screenSize = {['x'] = width, ['y'] = height}
local camera = {pos = {['x'] = 0, ['y'] = 0}, speed = 25}
local cellSize = 10
local isPlacing = false
local isRemoving = false
local generation = 0
local isGridVisible = true

local place = love.audio.newSource("sfx/place.wav", "static")
local remove = love.audio.newSource("sfx/remove.wav", "static")
local select = love.audio.newSource("sfx/select.wav", "static")
local clear = love.audio.newSource("sfx/clear.wav", "static")

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

function module.debug(isRunning, sfx, pauseOnPlace, showHelpMenu)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(tostring(love.timer.getFPS()) .. " fps", 10, height - 40)
    love.graphics.print("Camera Speed: " .. camera.speed, 10, height - 60)
    love.graphics.print(string.format("Zoom Level: %.2fx", cellSize / 10), 10, height - 80)
    love.graphics.print("Camera X: " .. camera.pos.x .. ", Camera Y: " .. camera.pos.y, 10, height - 100)
    love.graphics.print("Population: " .. countCells(), 10, height - 120)
    love.graphics.print("Generation: " .. generation, 10, height - 140)
    love.graphics.print("isRunning: " .. tostring(isRunning), 10, height - 160)
    love.graphics.print("SFX: " .. tostring(sfx), 10, height - 180)
    love.graphics.print("Pause on Place: " .. tostring(pauseOnPlace), 10, height - 200)
    love.graphics.print("isGridVisible: " .. tostring(isGridVisible), 10, height - 220)
    love.graphics.print("showHelpMenu: " .. tostring(showHelpMenu), 10, height - 240)
    love.graphics.setColor(1, 1, 0)
    love.graphics.print("DEBUG MENU", 10, height - 260)
    love.graphics.setColor(1, 1, 1)
end

function module.helpMenu()
    love.graphics.setColor(0.68, 0.85, 0.90)
    love.graphics.print("Help Menu", width - 150, height - 240)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("M1: Place cells", width - 150, height - 220)
    love.graphics.print("M2: Delete cells", width - 150, height - 200)
    love.graphics.print("ESC: Exit game", width - 150, height - 180)
    love.graphics.print("N: Hide help menu", width - 150, height - 160)
    love.graphics.print("C: Clear all cells", width - 150, height - 140)
    love.graphics.print("H: Hide Debug Menu", width - 150, height - 120)
    love.graphics.print("SPACE: Start/Pause", width - 150, height - 100)
    love.graphics.print("M: Mute Sfx", width - 150, height - 80)
    love.graphics.print("R: Reset camera pos", width - 150, height - 60)
    love.graphics.print("P: Pause when placing", width - 150, height - 40)
    love.graphics.print("G: Hide/Show grid", width - 150, height - 20)
end

function grid()
    if not isGridVisible then return end
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
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("V0.0.1", 10, height - 20)
end

function module.DrawTile(x, y)
    if cell[y][x] == 1 then
        love.graphics.setColor(0, 1, 0) -- Alive cell (green)
    else
        love.graphics.setColor(0, 0, 0) -- Dead cell (black)
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
    cell = {}
end

function module.Camera()
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

    if love.keyboard.isDown('lshift') then
        camera.speed = 37.5
    elseif love.keyboard.isDown('lctrl') then
        camera.speed = 5
    else
        camera.speed = 25
    end
end

local function placeCell(x, y, sfx)
    local cellX = math.floor((x - (screenSize.x / 2) + camera.pos.x) / cellSize)
    local cellY = math.floor((y - (screenSize.y / 2) + camera.pos.y) / cellSize)

    if not cell[cellY] then
        cell[cellY] = {}
    end

    if cell[cellY][cellX] ~= 1 then
        cell[cellY][cellX] = 1
        if sfx then
            love.audio.play(place)
        end
    end
end

local function removeCell(x, y, sfx)
    local cellX = math.floor((x - (screenSize.x / 2) + camera.pos.x) / cellSize)
    local cellY = math.floor((y - (screenSize.y / 2) + camera.pos.y) / cellSize)

    if cell[cellY] and cell[cellY][cellX] == 1 then
        cell[cellY][cellX] = 0
        if sfx then
            love.audio.play(remove)
        end
    end
end

function module.mousepressed(x, y, button, istouch, presses, sfx)
    if button == 1 then
        isPlacing = true
        placeCell(x, y, sfx)
    elseif button == 2 then
        isRemoving = true
        removeCell(x, y, sfx)
    end
end

function module.mousereleased(x, y, button, istouch, presses)
    if button == 1 then
        isPlacing = false
    elseif button == 2 then
        isRemoving = false
    end
end

function module.mousemoved(x, y, dx, dy, istouch, sfx)
    if isPlacing then
        placeCell(x, y, sfx)
    elseif isRemoving then
        removeCell(x, y, sfx)
    end
end

function module.setRunning(state)
    isRunning = state
end

function module.mute(state)
    sfx = state
end

function module.toggleGridVisibility()
    isGridVisible = not isGridVisible
end

function module.playSFX(sfx, sound)
    if sfx and sound == "select" then
        love.audio.play(select)
    elseif sfx and sound == "clear" then
        love.audio.play(clear)
    end
end

function module.updateCells()
    local newCells = {}
    for x, row in pairs(cell) do
        for y, _ in pairs(row) do
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

    cell = newCells
    generation = generation + 1
end

function module.resetCamera()
    camera.pos.x = 0
    camera.pos.y = 0
end

return module