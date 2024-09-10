function DrawMenu()
    menuFont = love.graphics.newFont(30)

    --Quit game
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle('fill', 300, 200, 200, 50)
    love.graphics.setColor(0,0,0)
love.graphics.setFont(menuFont)
    love.graphics.print("Quit game",300,200)

    --Save game
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle('fill', 300, 275, 200, 50)
    love.graphics.setColor(0,0,0)
love.graphics.setFont(menuFont)
    love.graphics.print("Save game",300,275)
    
    local mouseX, mouseY = love.mouse.getPosition()
    if love.mouse.isDown(1) and mouseX > 300 and mouseX < 500 and mouseY > 200 and mouseY < 250 then
        love.event.quit()
    elseif love.mouse.isDown(1) and mouseX > 300 and mouseX < 500 and mouseY > 275 and mouseY < 325 then
        SaveGame(map)
    end
    text[8] = mouseX .. ':' .. mouseY
end