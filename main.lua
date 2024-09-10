function love.load()
    height = love.graphics.getHeight()
    width = love.graphics.getWidth()

    pauseImage = love.graphics.newImage("picture/pause.png")
    playImage = love.graphics.newImage("picture/play.png")
    resetImage = love.graphics.newImage("picture/reset.png")

    play = false
    pause = true
end

function love.update(dt)
    if play == false then
        button = playImage
    elseif pause == false then
        button = pauseImage
    end
end

function love.draw()
    local mouseX, mouseY = love.mouse.getPosition()
    if width <= 800 and height <= 600 then
        love.graphics.print("hide UI", width - 225, height - 580)
        love.graphics.draw(resetImage, width - 175, height - 580, 0, 0.4, 0.4)
        love.graphics.draw(button, width - 125, height - 580, 0, 0.4, 0.4)
        if love.mouse.isDown(1) and mouseX >= 675 and mouseX <= 710 and mouseY >= 18 and mouseY <= 51 and play == false then
            play = true
            pause = false
            love.timer.sleep(0.5)
        elseif love.mouse.isDown(1) and mouseX >= 675 and mouseX <= 710 and mouseY >= 18 and mouseY <= 51 and play == true then
            play = false
            pause = true
            love.timer.sleep(0.5)
        end
    elseif width >= 801 and height >= 601 then
        love.graphics.print("hide UI", width - 225, height - 820)
        love.graphics.draw(resetImage, width - 175, height - 820, 0, 0.4, 0.4)
        love.graphics.draw(button, width - 125, height - 820, 0, 0.4, 0.4)
        if love.mouse.isDown(1) and mouseX >= 1410 and mouseX <= 1445 and mouseY >= 42 and mouseY <= 75 and play == false then
            play = true
            pause = false
            love.timer.sleep(0.5)
        elseif love.mouse.isDown(1) and mouseX >= 1410 and mouseX <= 1445 and mouseY >= 42 and mouseY <= 75 and play == true then
            play = false
            pause = true
            love.timer.sleep(0.5)
        end
    end
    
    
    love.graphics.print("Mouse X: " .. mouseX, 10, 10)
    love.graphics.print("Mouse Y: " .. mouseY, 10, 30)
end

function love.keypressed(key)
    if key == "f" then
        love.event.quit()
    end
end