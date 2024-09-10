local module = require("module")

local debug = true
local isRunning = false
local sfx = true
local pauseOnPlace = false

function love.update(dt)
    module.Camera()
    if isRunning then
        module.updateCells()
    end
end

function love.draw()
    module.draw()
    if debug then module.debug(isRunning, sfx, pauseOnPlace) end
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
    end
end