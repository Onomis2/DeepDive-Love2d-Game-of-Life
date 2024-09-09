local module = require("module")

function love.load()
    module.load()
end

function love.update(dt)
    module.update(dt)
end

function love.draw()
    module.draw()
end

function love.wheelmoved(x, y)
    module.wheelmoved(x, y)
end

function love.mousepressed(x, y, button, istouch, presses)
    module.mousepressed(x, y, button, istouch, presses)
end