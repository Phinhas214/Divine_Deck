

GameBoard = Class{}

function GameBoard:init()
  self.playerDeck = {}
  self.AIDeck = {}
  
  self.playArea = {}
  self.hands = {}
  self.discardPile = {}
  
  self.pickedUpCards = {}
  self.cardPickedUp = false
  
  self:generatePlayerDeck()
end

function GameBoard:generatePlayerDeck()
  -- insert 20 cards
  local initialDeck = Deck()
  self.playerDeck = initialDeck.cards
  
  for i=1, CARDS_PER_DECK do
    local x = LOCATION_DECK[1]
    local y = LOCATION_DECK[2]
    self.playerDeck[i].x = x
    self.playerDeck[i].y = y
  end
end


function GameBoard:draw()
  
  self:drawBackground()
  
  -- TODO: if mouse hover over card set text to card info
  -- TODO: pass card as a parameter
  self:setText()
  
  -- draw deck pile
  for i=1, #self.playerDeck do
    self.playerDeck[i]:draw()
  end
  
  -- draw cards in the three play locations
  for i=1, #self.playArea do
    self.playArea[i]:draw()
  end
  
  for i = 1, #self.hands do
    self.hands[i]:draw()
  end
  
  -- draw picked up cards separately
  for i=1, #self.pickedUpCards do
    self.pickedUpCards[i]:draw()
  end
  
end

function GameBoard:update()
  
  self:cleanInvalidCards()
  
  if #self.playerDeck > 0 then
    self.playerDeck[#self.playerDeck]:update()
  end
  
--  for i=1, #self.hands do
--    self.hands[i]:update()
--  end  
  
  for i = 1, #self.hands do
    if self.hands[i] ~= nil then
      self.hands[i]:update()
    else
      print("Warning: self.hands[" .. i .. "] is nil")
    end
  end
  
  for i=1, #self.pickedUpCards do
    self.pickedUpCards[i]:update()
  end
  
  
--  for _, cards in ipairs(self.pickedUpCards) do
--    cards:update()
--  end
  
end


function GameBoard:setText()
  
  love.graphics.setFont(font)
  
  love.graphics.printf("Player", 915, 10, 275, 'left')
  love.graphics.printf("Enemy", 905, 10, 275, 'right')
  local playerPoints = 15
  local AIPoints = 10
  love.graphics.printf(playerPoints, 915, 50, 275, 'left')
  love.graphics.printf(AIPoints, 905, 50, 275, 'right')
  
  love.graphics.printf("Mana", 915, 110, 275, 'left')
  local playerMana = 4
  love.graphics.printf(playerMana, 915, 150, 275, 'left')
  
  love.graphics.printf("Turn", 905, 110, 275, 'right')
  local turnNum = 4
  love.graphics.printf(turnNum, 905, 150, 275, 'right')
  
  
  love.graphics.printf("Cost", 915, 208, 275, 'left')
  local cardCost = 2
  love.graphics.printf(cardCost, 915, 248, 275, 'left')
  
  love.graphics.printf("Power", 905, 208, 275, 'right')
  local cardPower = 3
  love.graphics.printf(cardPower, 905, 248, 275, 'right')
  
  
  local description = "Hover over a card for details."
  love.graphics.printf("Card Description", 915, 315, 275, 'center')
  love.graphics.printf(description, 915, 350, 275, 'left')
  
  love.graphics.setColor(0.7, 0.7, 1)
  love.graphics.rectangle("fill", 950, 615, 200, 70)
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf("Submit Play", 900, 630, 300, 'center')
  
  
  
  
  
  
end

function GameBoard:drawBackground()
  
  love.graphics.setColor(1, 1, 1)
  self:renderLayoutDividers()
  
  self:renderAILocations()
  
  self:renderPlayerLocations()
  
  self:renderPlayerHands()
  
  -- Player Draw pile
  local xPos = LOCATION_DECK[1]
  local yPos = LOCATION_DECK[2]
  love.graphics.rectangle("fill", xPos, yPos, CARD_WIDTH, CARD_HEIGHT, 2)
  
  xPos = LOCATION_DISCARD[1]
  yPos = LOCATION_DISCARD[2]
  love.graphics.rectangle("fill", xPos, yPos, CARD_WIDTH, CARD_HEIGHT, 2)
end


function GameBoard:renderLayoutDividers()
  --dividers
  love.graphics.line(0, 375, 900, 375)
  love.graphics.line(900, 0, 900, 700)
  love.graphics.line(900, 700, SCREEN_WIDTH, 700)
  -- mid point = 1050
  
  love.graphics.line(900, 100, SCREEN_WIDTH, 100)
  love.graphics.line(1050, 100, 1050, 200)
  love.graphics.line(900, 200, SCREEN_WIDTH, 200)
  
  love.graphics.line(1050, 200, 1050, 300)
  love.graphics.line(900, 300, SCREEN_WIDTH, 300)
  
  love.graphics.line(900, 600, SCREEN_WIDTH, 600)
  love.graphics.line(900, 2, SCREEN_WIDTH, 2)
end


function GameBoard:renderAILocations()
  for i=1, 4 do
    local x = LOCATION_AI_1[i][1]
    local y = LOCATION_AI_1[i][2]
    love.graphics.rectangle("fill", x, y, CARD_WIDTH, CARD_HEIGHT, 2)
  end
  
  for i=1, 4 do
    local x = LOCATION_AI_2[i][1]
    local y = LOCATION_AI_2[i][2]
    love.graphics.rectangle("fill", x, y, CARD_WIDTH, CARD_HEIGHT, 2)
  end
  
  for i=1, 4 do
    local x = LOCATION_AI_3[i][1]
    local y = LOCATION_AI_3[i][2]
    love.graphics.rectangle("fill", x, y, CARD_WIDTH, CARD_HEIGHT, 2)
  end
end


function GameBoard:renderPlayerLocations()
  for i=1, 4 do
    local x = LOCATION_PLAYER_1[i][1]
    local y = LOCATION_PLAYER_1[i][2]
    love.graphics.rectangle("fill", x, y, CARD_WIDTH, CARD_HEIGHT, 2)
  end
  
  for i=1, 4 do
    local x = LOCATION_PLAYER_2[i][1]
    local y = LOCATION_PLAYER_2[i][2]
    love.graphics.rectangle("fill", x, y, CARD_WIDTH, CARD_HEIGHT, 2)
  end
  
  for i=1, 4 do
    local x = LOCATION_PLAYER_3[i][1]
    local y = LOCATION_PLAYER_3[i][2]
    love.graphics.rectangle("fill", x, y, CARD_WIDTH, CARD_HEIGHT, 2)
  end
end


function GameBoard:renderPlayerHands()
  for i=1, 7 do
    local x = LOCATION_PLAYER_HAND[i][1]
    local y = LOCATION_PLAYER_HAND[i][2]
    love.graphics.rectangle("fill", x, y, CARD_WIDTH, CARD_HEIGHT, 2)
  end
end



