

Card = Class{}

function Card:init(id, x, y, loc)
  self.id = id
  
  self.x = x
  self.y = y
  
  self.location = loc
  
  self.hidden = false
  self.pickedUp = false
  
  self.originalX = self.x
  self.originalY = self.y
  
end

function Card:update()
  
  if self.pickedUp then
    self.x, self.y = love.mouse.getPosition()
    self.x = self.x - CARD_WIDTH/2
    self.y = self.y - CARD_HEIGHT/2
  end
  
  if not self.pickedUp and love.mouse.wasButtonPressed(1) then
    
    local x, y = love.mouse.getPosition()
    
    if checkMouseOver(x, y, self.x, self.y) and not gameBoard.cardPickedUp then
      self:pickUp()
    end
    
    
  elseif self.pickedUp and love.mouse.wasButtonReleased(1) then
    self.pickedUp = false
    gameBoard.cardPickedUp = false 
    self:placeDown()
  end
  
  
end

function Card:draw()
  
  if cardImages[self.id] then
    love.graphics.draw(cardImages[self.id], self.x, self.y)
  else
    print("Missing image for card ID:", self.id)
  end
end




function Card:pickUp()
  
  self.pickedUp = true
  gameBoard.cardPickedUp = true
  
  self.originalX = self.x
  self.originalY = self.y
  
  table.insert(gameBoard.pickedUpCards, self)
  -- table.remove(gameBoard.playerDeck, #gameBoard.playerDeck)
  removeValue(gameBoard.playerDeck, self)

end

-- returns 1 if placment is found valid, and 0 otherwise
-- also returns the position coordinate array
function Card:isValidPosition(x, y)

  for i, pos in ipairs(LOCATION_PLAYER_1) do
    if checkMouseOver(x, y, pos[1], pos[2]) then
      return 1, pos
    end
  end
  
  for i, pos in ipairs(LOCATION_PLAYER_2) do
    if checkMouseOver(x, y, pos[1], pos[2]) then
      return 1, pos
    end
  end
  
  for i, pos in ipairs(LOCATION_PLAYER_3) do
    if checkMouseOver(x, y, pos[1], pos[2]) then
      return 1, pos
    end
  end
  
  return 0, nil
  
end

function Card:placeDown()
  local mouseX, mouseY = love.mouse.getPosition()
  
  local isValid, pos = self:isValidPosition(mouseX, mouseY) -- 1 = position is valid, 0 = position is not valid
  
  
  if isValid == 1 then
    local x = pos[1]
    local y = pos[2]
    
    self.x = x
    self.y = y
    
    self.originalX = self.x
    self.originalY = self.y
    
    table.insert(gameBoard.playArea, self)
    removeValue(gameBoard.pickedUpCards, self)
    
  else 
    self.x = self.originalX
    self.y = self.originalY
    
    table.insert(gameBoard.playerDeck, self)
    removeValue(gameBoard.pickedUpCards, self)
  end
  
  gameBoard.pickedUpCards = {}
  
end







