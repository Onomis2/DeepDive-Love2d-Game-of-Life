local module = require("module")
local ui = require("ui")

local debug = true
local isRunning = false
local sfx = true
local pauseOnPlace = false
local showHelpMenu = true

local tickSpeed = 1
local tickCount = 0.0

function love.update(dt)
    module.Camera()
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
    module.draw()
    if showHelpMenu then module.helpMenu() end
    if debug then module.debug(isRunning, sfx, pauseOnPlace, showHelpMenu, tickSpeed, tickCount) end
end

function love.wheelmoved(x, y)
    module.wheelmoved(x, y)
end

function love.mousepressed(x, y, button, istouch, presses)
    if pauseOnPlace and isRunning then
        isRunning = false
        module.setRunning(isRunning)
    end
    module.mousepressed(x, y, button, istouch, presses, sfx)
end

function love.mousereleased(x, y, button, istouch, presses)
    module.mousereleased(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
    module.mousemoved(x, y, dx, dy, istouch, sfx)
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
    elseif key == "1" then
        local x, y = love.mouse.getPosition()
        module.placeCell(x, y, sfx)
    elseif key == "2" then
        local x, y = love.mouse.getPosition()
        module.placeGlider(x, y, sfx)
    elseif key == "3" then
        local x, y = love.mouse.getPosition()
        module.placeHWSS(x, y, sfx)
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
    end
end