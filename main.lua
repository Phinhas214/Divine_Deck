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
  
  love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)
  
  
end

function love.update(dt)
  
end

function love.draw()
  
  local currCard = "persephone"
  local randCard = string.format("assets/%s.png", currCard)
  local zeus = love.graphics.newImage(randCard)
  
  
  gameBoard:draw()
  love.graphics.draw(zeus, 50, 50)
  
end



