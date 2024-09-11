local debounce = false

function love.load()
    height = love.graphics.getHeight()
    width = love.graphics.getWidth()

    pauseImage = love.graphics.newImage("picture/pause.png")
    playImage = love.graphics.newImage("picture/play.png")
    resetImage = love.graphics.newImage("picture/reset.png")
    gliderGun = love.graphics.newImage("picture/glider-gun.png")
    glider = love.graphics.newImage("picture/glider.png")
    flyingShip = love.graphics.newImage("picture/flying-ship.png")
    pulsar = love.graphics.newImage("picture/pulsar.png")
    heavyShip = love.graphics.newImage("picture/heavy-ship.png")
    pulsatingGlider = love.graphics.newImage("picture/pulsating-glider.png")
    spaceship = love.graphics.newImage("picture/spaceship.png")
    wheelOfFire = love.graphics.newImage("picture/wheel-of-fire.png")

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


    if UI == false then
        love.graphics.setColor(0.2, 0.2, 0.2)
        love.graphics.rectangle("fill", 0, 0, width, 125)
    end

    if darkened then
        love.graphics.setColor(0.5, 0.5, 0.5)
    else
        love.graphics.setColor(1, 1, 1)
    end

    love.graphics.print(hide, width - 225, 35)
    if UI == false then
        love.graphics.draw(resetImage, width - 175, 25, 0, 0.4, 0.4)
        love.graphics.draw(button, width - 125, 25, 0, 0.4, 0.4)
        love.graphics.draw(gliderGun, width - 1470, 25, 0, 0.24, 0.24)
        love.graphics.draw(glider, width - 1270, 25, 0, 0.25, 0.25)
        love.graphics.draw(flyingShip, width - 1230, 25, 0, 0.23, 0.23)
        love.graphics.draw(pulsar, width - 1110, 25, 0, 0.23, 0.23)
        love.graphics.draw(heavyShip, width - 1030, 25, 0, 0.25, 0.25)
        love.graphics.draw(pulsatingGlider, width - 970, 25, 0, 0.23, 0.23)
        love.graphics.draw(spaceship, width - 900, 25, 0, 0.23, 0.23)
        love.graphics.draw(wheelOfFire, width - 800, 25, 0, 0.23, 0.23)
    end
    
    if love.mouse.isDown(1) and not debounce then
        debounce = true
        if UI == false then
            if mouseX >= width - 175 and mouseX <= width - 145 and mouseY >= 23 and mouseY <= 55 then --reset
                darkened = true
                darkeningReset = true
            elseif mouseX >= width - 125 and mouseX <= width - 95 and mouseY >= 23 and mouseY <= 55 then
                if play == false then --play
                    play = true
                    pause = false
                elseif play == true then --pause
                    play = false
                    pause = true
                end
            end
        end
        if mouseX >= width - 225 and mouseX <= width - 185 and mouseY >= 36 and mouseY <= 46 then --hide UI
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