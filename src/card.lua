

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

function Card:clone()
  return Card(
    self.id, 
    self.x,
    self.y,
    self.location,
    self.originalPile,
    self.originalX,
    self.originalY,
    self.hidden,
    self.pickedUp,
    self.cost,
    self.power,
    self.text
  )
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
    
    self:placeDown(isValid, pos, locationToSnap)
  end
  
  
end

function Card:draw()
  
  if cardImages[self.id] then
    if self.hidden == false then
      love.graphics.draw(cardImages[self.id], self.x, self.y)
    else 
      love.graphics.draw(backImage, self.x, self.y)
    end
  else
    print("Missing image for card ID:", self.id)
  end
end




function Card:pickUp(cardLocation, pile)
  
  self.originalX = self.x
  self.originalY = self.y
  self.originalPile = pile

    
  if cardLocation == LOCATION_LIST.HAND then
    table.insert(gameBoard.pickedUpCards, self)
    removeValue(gameBoard.hands, self)
  end
  
  self.pickedUp = true
  gameBoard.cardPickedUp = true
  

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

function Card:translatePositionToLocation(cardLocation) 
  if cardLocation == 1 then
    return LOCATION_PLAYER_1
  elseif cardLocation == 2 then
    return LOCATION_PLAYER_2
  elseif cardLocation == 3 then
   return LOCATION_PLAYER_3
   
  elseif cardLocation == 4 then
    return LOCATION_DECK
  elseif cardLocation == 5 then
    return LOCATION_PLAYER_HAND
  elseif cardLocation == 6 then
    return LOCATION_DISCARD
  end
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

function Card:revertToOriginal()
  self.x = self.originalX
  self.y = self.originalY
  
  table.insert(self.originalPile, self)
  removeValue(gameBoard.pickedUpCards, self)
end

function Card:placeDown(valid, pos, cardLocation)
  local mouseX, mouseY = love.mouse.getPosition()
  
  local cardPile = self:translatePositionToPile(cardLocation)
  local cardPosToSnap = self:translatePositionToLocation(cardLocation)
  
  -- checks if you can afford the card
  local isPlayArea = (
    cardPosToSnap == LOCATION_PLAYER_1 or 
    cardPosToSnap == LOCATION_PLAYER_2 or 
    cardPosToSnap == LOCATION_PLAYER_3
  )
  
  -- return card to original position is mouse position is not valid or you don't have enough mana
  if valid ~= 1 then
    print("Card slot already occupied.")
    self:revertToOriginal()
    return
  end
  
  -- print("Mana:", gameBoard.playerMana, "Cost:", self.cost)
  -- print("cardLocation: " .. cardLocation)
  if isPlayArea and gameBoard.playerMana < self.cost then
    print("Not enough mana to play this card")
    self:revertToOriginal()
    return
  end
  
 
  
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
  
  local x = pos[1]
  local y = pos[2]
  
  self.x = x
  self.y = y
  self.location = cardLocation
  self.hidden = false
  
  self.originalX = self.x
  self.originalY = self.y
  self.originalPile = cardPile
  

  if cardLocation == LOCATION_LIST.DECK then
    table.insert(gameBoard.playerDeck, self)
    
  elseif cardLocation == LOCATION_LIST.HAND then
    table.insert(gameBoard.hands, self)
    
  elseif cardLocation == LOCATION_LIST.LOC1 then
    table.insert(gameBoard.playArea, self)
    gameBoard.playerMana = gameBoard.playerMana - self.cost
    
  elseif cardLocation == LOCATION_LIST.LOC2 then
    table.insert(gameBoard.playArea, self)
    gameBoard.playerMana = gameBoard.playerMana - self.cost
    
  elseif cardLocation == LOCATION_LIST.LOC3 then
    table.insert(gameBoard.playArea, self)
    gameBoard.playerMana = gameBoard.playerMana - self.cost
    
  end

  removeValue(gameBoard.pickedUpCards, self)
  
end







