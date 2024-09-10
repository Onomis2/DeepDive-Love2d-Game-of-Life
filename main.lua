function love.load()
    height = love.graphics.getHeight()
    width = love.graphics.getWidth()

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
    if width <= 800 and height <= 600 then
        love.graphics.print("hide UI", width - 225, height - 580)
        love.graphics.draw(resetImage, width - 175, height - 580, 0, 0.4, 0.4)
        love.graphics.draw(button, width - 125, height - 580, 0, 0.4, 0.4)
    elseif width >= 801 and height >= 601 then
        love.graphics.print("hide UI", width - 225, height - 820)
        love.graphics.draw(resetImage, width - 175, height - 820, 0, 0.4, 0.4)
        love.graphics.draw(button, width - 125, height - 820, 0, 0.4, 0.4)
    end
    local mouseX, mouseY = love.mouse.getPosition()
    love.graphics.print("Mouse X: " .. mouseX, 10, 10)
    love.graphics.print("Mouse Y: " .. mouseY, 10, 30)
end

function love.keypressed(key)
    if key == "f" then
        love.event.quit()
    end
end