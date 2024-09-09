function love.load()
    height = love.graphics.getHeight() - 580
    width = love.graphics.getWidth() - 100
    widthReset = love.graphics.getWidth() - 150
    widthUI = love.graphics.getWidth() - 200
    gameStarted = false
end

function love.update(dt)
    if gameStarted == false then
        if love.keyboard.isDown("return") then
            gameStarted = true
        end
        button = "start"
    else
        if love.keyboard.isDown("escape") then
            gameStarted = false
        end
        button = "pause"
    end
    
end

function love.draw()
    love.graphics.print("hide UI", widthUI, height)
    love.graphics.print("reset", widthReset, height)
    love.graphics.print(button, width, height)
end