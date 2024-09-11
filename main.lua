local debounce = false

function love.load()
    height = love.graphics.getHeight()
    width = love.graphics.getWidth()

    pauseImage = love.graphics.newImage("picture/pause.png")
    playImage = love.graphics.newImage("picture/play.png")
    resetImage = love.graphics.newImage("picture/reset.png")

    play = false
    pause = true
    UI = false
    darkened = false
    darkeningReset = false
end

function love.update(dt)
    if play == false then
        button = playImage
    elseif pause == false then
        button = pauseImage
    end

    if UI == false then
        hide = "hide UI"
    elseif UI == true then
        hide = "show UI"
    end
end

function love.draw()
    local mouseX, mouseY = love.mouse.getPosition()

    if darkened then
        love.graphics.setColor(0.5, 0.5, 0.5)
    else
        love.graphics.setColor(1, 1, 1)
    end

    love.graphics.print(hide, width - 225, 50)
    if UI == false then
        love.graphics.draw(resetImage, width - 175, 50, 0, 0.4, 0.4)
        love.graphics.draw(button, width - 125, 50, 0, 0.4, 0.4)
        if love.mouse.isDown(1) and not debounce then
            debounce = true
            if mouseX >= width - 175 and mouseX <= width - 145 and mouseY >= 50 and mouseY <= 70 then --reset
                darkened = true
                darkeningReset = true
            elseif mouseX >= width - 125 and mouseX <= width - 95 and mouseY >= 50 and mouseY <= 70 then
                if play == false then --play
                    play = true
                    pause = false
                elseif play == true then --pause
                    play = false
                    pause = true
                end
            elseif mouseX >= width - 225 and mouseX <= width - 185 and mouseY >= 50 and mouseY <= 60 then --hide UI
                UI = not UI
            end
        elseif not love.mouse.isDown(1) then
            debounce = false
        end

        if darkeningReset and not love.mouse.isDown(1) then
            love.load()
            darkened = false
            darkeningReset = false
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