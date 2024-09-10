local module = require("module")

local debug = true
local isRunning = false

function love.update(dt)
    module.Camera()
end

function love.draw()
    module.draw()
    if debug then module.debug(isRunning) end
end

function love.wheelmoved(x, y)
    module.wheelmoved(x, y)
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