local module = require("module")
local ui = require("ui")

cell = {}

local debug = true
local isRunning = false
local sfx = true
local pauseOnPlace = false
local showHelpMenu = true

local brush = 1
local tickSpeed = 1
local tickCount = 0.0

-- Kleurenset voor de achtergrond
local colors = {
    {0, 0, 0}, -- zwart
    {0.1, 1, 0.1}, -- Groen
    {0.2, 0.2, 1}, -- Blauw
    {1, 0.2, 0.2}, -- Rood
    {1, 0.6, 0.2}, -- Oranje
    {1, 1, 0.1}, -- Geel
    {0.8, 0.2, 0.8}, -- Paars
    {0.2, 1, 1}, -- Cyaan
    {1, 1, 1} -- Wit
}

local standaardColorIndex = 1 -- Standaard kleurindex voor de achtergrond

function love.update(dt)
    ui.buttons()
    module.Camera()
    isRunning = ui.controls(isRunning)
    if isRunning and tickSpeed >= 1 then
        for i = 1,tickSpeed do
            module.updateCells()
        end
    elseif isRunning and tickSpeed < 1 then
        tickCount = tickCount + tickSpeed
        if tickCount >= 1 then
            tickCount = 0.0
            module.updateCells()
        end
    end
end

function love.draw()
    -- Stel de achtergrondkleur in op basis van de huidige kleur
    love.graphics.clear(colors[standaardColorIndex])

    -- Teken de rest van de elementen
    module.draw()
    ui.draw(brush)

    if showHelpMenu then
        module.helpMenu()
    end
    if debug then
        module.debug(isRunning, sfx, pauseOnPlace, showHelpMenu, tickSpeed, tickCount)
    end
end

function love.wheelmoved(x, y)
    module.wheelmoved(x, y)
end

function love.mousepressed(x, y, button, istouch, presses)
    if pauseOnPlace and isRunning then
        isRunning = false
        module.setRunning(isRunning)
    end
    local uiBool = ui.returnUI()
    module.mousepressed(x, y, button, istouch, presses, sfx, uiBool, brush)
end

function love.mousereleased(x, y, button, istouch, presses)
    module.mousereleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
    module.mousemoved(x, y, dx, dy, istouch, sfx, brush)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "c" then
        module.clearCells()
        module.playSFX(sfx, "clear")
    elseif key == "h" then
        debug = not debug
        module.playSFX(sfx, "select")
    elseif key == "space" then
        ui.changePlayPauseButton(isRunning)
        isRunning = not isRunning
        module.setRunning(isRunning)
        module.playSFX(sfx, "select")
    elseif key == "m" then
        sfx = not sfx
        module.mute(sfx)
    elseif key == "r" then
        module.resetCamera()
        module.playSFX(sfx, "select")
    elseif key == "p" then
        pauseOnPlace = not pauseOnPlace
        module.playSFX(sfx, "select")
    elseif key == "g" then
        module.toggleGridVisibility()
        module.playSFX(sfx, "select")
    elseif key == "n" then
        showHelpMenu = not showHelpMenu
        module.playSFX(sfx, "select")
    elseif key == "e" then
        module.cycleColor()
        module.playSFX(sfx, "select")
    elseif key == "1" or key == "2" or key == "3" or key == "4" or key == "5" or key == "6" or key == "7" or key == "8" or key == "9" then
        brush = tonumber(key)
    elseif key == "up" then
        if tickSpeed > 1 then
            tickSpeed = tickSpeed + 1
        else
            tickSpeed = tickSpeed * 2
        end
    elseif key == "down" then
        if tickSpeed > 1 then
            tickSpeed = tickSpeed - 1
        else
            tickSpeed = tickSpeed / 2
        end
    elseif key == "b" then
        standaardColorIndex = standaardColorIndex % #colors + 1
    end
end

function setBrush(variable)

    brush = variable

end
