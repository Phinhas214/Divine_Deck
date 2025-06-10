--[[
  Author: Phineas Asmelash
  Greek Cards
]]--

io.stdout:setvbuf("no")

require "src/dependencies"

local gameWon = false
local gameLost = false


function love.load()
  
  love.window.setTitle('Divine Deck')
  -- love.graphics.setBackgroundColor(0.1, 0.7, 1)
  love.graphics.setBackgroundColor(0.35, 0.11, 0.16, 1)
  font = love.graphics.newFont(25)
  
  love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)
  
  love.mouse.buttonsPressed = {}
  love.mouse.buttonsReleased = {}
  
  gameBoard = GameBoard()
  
end


function love.update(dt)
  if not gameWon and not gameLost then
    gameBoard:update()
    -- reset mouse flags at the end of each update cycle
    love.mouse.buttonsPressed = {}
    love.mouse.buttonsReleased = {}
    
  end
  
  -- win condition check
  if gameBoard.playerPoints >= 1000 and gameBoard.AIPoints >= 1000 then
    if gameBoard.playerPoints > gameBoard.AIPoints then
      gameWon = true
    elseif gameBoard.AIPoints > gameBoard.playerPoints then
      gameLost = true
    end
    
  elseif gameBoard.playerPoints >= 1000 then
    gameWon = true
  elseif gameBoard.AIPoints >= 1000 then
    gameLost = true
  end

  
  
end

function love.draw()
  
  love.graphics.push()
--  love.graphics.scale(0.85, 0.85)

  gameBoard:draw()

  love.graphics.pop()
  
  -- gameBoard:draw()
  
  if gameWon then
    love.graphics.draw(you_win, 100, 0, 0, 0.75, 0.75)
  elseif gameLost then
    love.graphics.draw(you_lost, 0, 0, 0, 1.2, 1)
  end
  
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == "r" then
      gameWon = false
      gameLost = false
      love.load()
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



