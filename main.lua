--[[
  Author: Phineas Asmelash
  Greek Cards
]]--

io.stdout:setvbuf("no")

require "src/dependencies"

gameBoard = GameBoard()

function love.load()
  
  love.window.setTitle('Divine Deck')
  love.graphics.setBackgroundColor(0.1, 0.7, 1)
  --love.graphics.setBackgroundColor(0.35, 0.11, 0.16, 1)
  font = love.graphics.newFont(25)
  
  love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)
  
  love.mouse.buttonsPressed = {}
  love.mouse.buttonsReleased = {}
  
end


function love.update(dt)
  gameBoard:update()
  
  
  -- reset mouse flags at the end of each update cycle
  love.mouse.buttonsPressed = {}
  love.mouse.buttonsReleased = {}
end

function love.draw()
  
  gameBoard:draw()
  
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    --[[elseif key == "r" then
      gameWon = false
      love.load()
    ]]--
    end
end

function love.mousepressed(x, y, button)
  love.mouse.buttonsReleased[button] = false
  love.mouse.buttonsPressed[button] = true
end

function love.mousereleased(x, y, button)
  love.mouse.buttonsPressed[button] = false
  love.mouse.buttonsReleased[button] = true
end

function love.mouse.wasButtonPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.mouse.wasButtonReleased(button)
    return love.mouse.buttonsReleased[button]
end



