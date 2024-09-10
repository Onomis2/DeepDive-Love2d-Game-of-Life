function love.load()
    height = love.graphics.getHeight() - 580
    width = love.graphics.getWidth() - 100
    widthReset = love.graphics.getWidth() - 150
    widthUI = love.graphics.getWidth() - 200

    pauseImage = love.graphics.newImage("picture/pause.png")
    playImage = love.graphics.newImage("picture/play.png")
    resetImage = love.graphics.newImage("picture/reset.png")

    gameStarted = false
end

function love.update(dt)
    if gameStarted == false then
        if love.keyboard.isDown("return") then
            gameStarted = true
        end
        button = playImage
    else
        if love.keyboard.isDown("escape") then
            gameStarted = false
        end
        button = pauseImage
    end
end

function love.draw()
    love.graphics.print("hide UI", widthUI, height)
    love.graphics.draw(resetImage, widthReset, height, 0, 0.4, 0.4)
    love.graphics.draw(button, width, height, 0, 0.4, 0.4)
    local mouseX, mouseY = love.mouse.getPosition()
    love.graphics.print("Mouse X: " .. mouseX, 10, 10)
    love.graphics.print("Mouse Y: " .. mouseY, 10, 30)
end

function love.keypressed(key)
    if key == "f" then
        love.event.quit()
    end
end