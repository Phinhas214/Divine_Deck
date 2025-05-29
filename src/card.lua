

Card = Class{}

function Card:init(id, x, y, loc, pile, cost, power, text)
  self.id = id
  
  self.x = x
  self.y = y
  
  self.location = loc
  
  self.hidden = false
  self.pickedUp = false
  
  self.originalX = self.x
  self.originalY = self.y
  
  self.originalPile = pile or nil
  
  self.cost = cost
  self.power = power
  self.text = text

end

function Card:setPileLocToDeck()
  self.originalPile = gameBoard.playerDeck
end

function Card:update()
  
  if self.pickedUp then
    self.x, self.y = love.mouse.getPosition()
    self.x = self.x - CARD_WIDTH/2
    self.y = self.y - CARD_HEIGHT/2
  end
  
  local x, y = love.mouse.getPosition()
  
  if not self.pickedUp and love.mouse.wasButtonPressed(1) then
    
    
    
    if checkMouseOver(x, y, self.x, self.y) and not gameBoard.cardPickedUp then
      local pileFrom = self:translatePositionToPile(self.location)
      if self.originalPile == nil then
        self:setPileLocToDeck()
      end
      self:pickUp(self.location, pileFrom)
    end
    
    
  elseif self.pickedUp and love.mouse.wasButtonReleased(1) then
    self.pickedUp = false
    gameBoard.cardPickedUp = false 
    
    local isValid, pos, locationToSnap = self:isValidPosition(x, y) -- 1 = position is valid, 0 = position is not valid
    
    -- print("is Valid: " .. isValid .. " at position: " .. pos[1] .. ", " .. pos[2] .. " card Location: " .. locationToSnap)
    
    self:placeDown(isValid, pos, locationToSnap)
  end
  
  
end

function Card:draw()
  
  if cardImages[self.id] then
    love.graphics.draw(cardImages[self.id], self.x, self.y)
  else
    print("Missing image for card ID:", self.id)
  end
end




function Card:pickUp(cardLocation, pile)
  
  self.pickedUp = true
  gameBoard.cardPickedUp = true
  
  self.originalX = self.x
  self.originalY = self.y
  self.originalPile = pile
  
  table.insert(gameBoard.pickedUpCards, self)
  -- table.remove(gameBoard.playerDeck, #gameBoard.playerDeck)
  if cardLocation == LOCATION_LIST.DECK then
    removeValue(gameBoard.playerDeck, self)
    
  elseif cardLocation == LOCATION_LIST.HAND then
    removeValue(gameBoard.hands, self)
  end
  

end

-- returns 1 if placment is found valid, and 0 otherwise
-- also returns the position coordinate array
-- also returns the location of the card to be snapped
function Card:isValidPosition(x, y)

  for i, pos in ipairs(LOCATION_PLAYER_1) do
    if checkMouseOver(x, y, pos[1], pos[2]) then
      return 1, pos, LOCATION_LIST.LOC1
    end
  end
  
  for i, pos in ipairs(LOCATION_PLAYER_2) do
    if checkMouseOver(x, y, pos[1], pos[2]) then
      return 1, pos, LOCATION_LIST.LOC2
    end
  end
  
  for i, pos in ipairs(LOCATION_PLAYER_3) do
    if checkMouseOver(x, y, pos[1], pos[2]) then
      return 1, pos, LOCATION_LIST.LOC3
    end
  end
  
  for i, pos in ipairs(LOCATION_PLAYER_HAND) do
    if checkMouseOver(x, y, pos[1], pos[2]) then
      return 1, pos, LOCATION_LIST.HAND
    end
  end
  
  return 0, nil
  
end


function Card:translatePositionToPile(cardLocation)
  
  if cardLocation == LOCATION_LIST.DECK then
    return gameBoard.playerDeck
  elseif cardLocation == LOCATION_LIST.HAND then
    return gameBoard.hands
    
  elseif cardLocation == LOCATION_LIST.LOC1 then
   return gameBoard.playArea
  elseif cardLocation == LOCATION_LIST.LOC2 then
    return gameBoard.playArea
  elseif cardLocation == LOCATION_LIST.LOC3 then
    return gameBoard.playArea
  elseif cardLocation == LOCATION_LIST.DISCARD then
    return gameBoard.discardPile
  end
  
end

function Card:placeDown(valid, pos, cardLocation)
  local mouseX, mouseY = love.mouse.getPosition()
  
  local cardPile = self:translatePositionToPile(cardLocation)
  
  
  -- return card to original position is mouse position is not valid
  if valid ~= 1 then
    self.x = self.originalX
    self.y = self.originalY
    
    table.insert(self.originalPile, self)
    -- table.insert(gameBoard.playerDeck, self)
    removeValue(gameBoard.pickedUpCards, self)
    
    return
  end
  
  local x = pos[1]
  local y = pos[2]
  
  -- check if there's a card in the pile that has the same self.x and self.y values as x and y
  
  for i=1, #cardPile do
    if cardPile[i].x == x and cardPile[i].y == y then
      self.x = self.originalX
      self.y = self.originalY
      
      table.insert(self.originalPile, self)
      -- table.insert(gameBoard.playerDeck, self)
      removeValue(gameBoard.pickedUpCards, self)
      
      return
    end
  end
  
  self.x = x
  self.y = y
  self.location = cardLocation
  
  self.originalX = self.x
  self.originalY = self.y
  self.originalPile = cardPile
  

  if cardLocation == LOCATION_LIST.DECK then
    table.insert(gameBoard.playerDeck, self)
    
  elseif cardLocation == LOCATION_LIST.HAND then
    table.insert(gameBoard.hands, self)
    
    
  elseif cardLocation == LOCATION_LIST.LOC1 then
    table.insert(gameBoard.playArea, self)
    
  elseif cardLocation == LOCATION_LIST.LOC2 then
    table.insert(gameBoard.playArea, self)
    
  elseif cardLocation == LOCATION_LIST.LOC3 then
    table.insert(gameBoard.playArea, self)
    
  end
  
--  print("deck: " .. #gameBoard.playerDeck)
--  print("hand: " .. #gameBoard.hands)
--  print("play locations: " .. #gameBoard.playArea)

  removeValue(gameBoard.pickedUpCards, self)
  
end







