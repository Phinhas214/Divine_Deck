

GameBoard = Class{}

function GameBoard:init()
  self.playerDeck = {}
  self.AIDeck = {}
  
  self.playArea = {}
  self.hands = {}
  self.discardPile = {}
  
  self.AIPlayArea = {}
  self.AIHand = {}
  self.AIPlayArea = {}
  
  self.pickedUpCards = {}
  self.cardPickedUp = false
  
  self.hoveredCard = nil
  self.currentGameState = TURN_STATE.PLAYER
  
  self:generatePlayerDeck()
  self:generateAIDeck()
  
end

-- returns if x val is in array
function GameBoard:inArray(area, location)
  for _, card in ipairs(area) do
    if card.x == location[1] and card.y == location[2] then
      return true
    end
  end
  
  return false
end



function GameBoard:draw()
  
  self:drawBackground()
  
  -- TODO: if mouse hover over card set text to card info
  -- TODO: pass card as a parameter
  local tempCard = {
    cost = "",
    power = "",
    text = "Hover over any card to show details."
  }
  self:setText(self.hoveredCard or tempCard)
  
  -- draw deck pile
  for i=1, #self.playerDeck do
    self.playerDeck[i]:draw()
  end
  
  -- draw cards in the three user play locations
  for i=1, #self.playArea do
    self.playArea[i]:draw()
  end
  
  -- draw cards in the three AI play locations
  if #self.AIPlayArea > 0 then
    for i=1, #self.AIPlayArea do
      self.AIPlayArea[i]:draw()
    end
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
  self.hoveredCard = nil -- reset before checking
  
  -- check hover over hand cards and play area cards
  -- TODO: extend this functionality later to AI cards too
  local mouseX, mouseY = love.mouse.getPosition()
  for _, card in ipairs(self.hands) do
    if checkMouseOver(mouseX, mouseY, card.x, card.y) then
      self.hoveredCard = card
      break
    end
  end
  
  if not self.hoveredCard then
    for i, card in ipairs(self.playArea) do
      if checkMouseOver(mouseX, mouseY, card.x, card.y) then
        self.hoveredCard = card
        break
      end
    end
  end
  
  if not self.hoveredCard then
    for i=#self.playerDeck, 1, -1 do
      local card = self.playerDeck[i]
      if checkMouseOver(mouseX, mouseY, card.x, card.y) then
        self.hoveredCard = card
        break
      end
    end
  end
  

  
  if not self.hoveredCard then
    for i, card in ipairs(self.AIPlayArea) do
      if checkMouseOver(mouseX, mouseY, card.x, card.y) then
        self.hoveredCard = card
        break
      end
    end
  end
  
  if self:isSubmitClicked(mouseX, mouseY) then
    self:submitTurn()
  end
  
  
  if #self.playerDeck > 0 then
    self.playerDeck[#self.playerDeck]:update()
  end

  
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

  
end

function GameBoard:isSubmitClicked(mouseX, mouseY)
  love.graphics.rectangle("fill", 950, 615, 200, 70)
  local buttonX = 950
  local buttonY = 615
  local buttonWidth = 200
  local buttonHeight = 70
  
  local isHover = mouseX >= buttonX and mouseX <= buttonX + buttonWidth and mouseY >= buttonY and mouseY <= buttonY + buttonHeight
  
  if isHover and love.mouse.wasButtonPressed(1) then
    print("submit button clicked!!!")
    return true
  end
  
  return false
end

function GameBoard:randomAILocation()
  local randSeed = math.random(1, 3)
  local randIndex = math.random(1, 4)
  
  if randSeed == 1 then
    return LOCATION_AI_1[randIndex]
  elseif randSeed == 2 then
    return LOCATION_AI_2[randIndex]
  elseif randSeed == 3 then
    return LOCATION_AI_3[randIndex]
  end
  
end

function GameBoard:submitTurn()
  -- flip player cards face down before AI plays
  for _, card in ipairs(self.playArea) do
    card.hidden = true
  end
  
  -- AI selects random cards from its hand
  local randomIndex = math.random(#self.AIDeck)
  local card = table.remove(self.AIDeck, randomIndex)
   -- pick a random AI location 
  local randomLocation = self:randomAILocation()
  local maxTries = 12
  local tries = 0
  
   -- check if there's already a card placed at randomLocation
  while self:inArray(self.AIPlayArea, randomLocation) and #self.AIPlayArea < 12 do
    randomLocation = self:randomAILocation()
    tries = tries + 1
  end
  
  if #self.AIPlayArea > 11 then
    print("AI Location Full!!")
  end
  
  -- place card in random Location
  card.x, card.y = randomLocation[1], randomLocation[2]
  table.insert(self.AIPlayArea, card)
  
end


function GameBoard:setText(card)
  love.graphics.setColor(1, 1, 1)
  
  
  
  local cardCost = card.cost
  local cardPower = card.power
  local description = card.text
  
  
  love.graphics.setFont(font)
  
  love.graphics.printf("Player", 915, 10, 275, 'left')
  love.graphics.printf("Enemy", 905, 10, 275, 'right')
  local playerPoints = 0
  local AIPoints = 0
  love.graphics.printf(playerPoints, 915, 50, 275, 'left')
  love.graphics.printf(AIPoints, 905, 50, 275, 'right')
  
  love.graphics.printf("Mana", 915, 110, 275, 'left')
  local playerMana = 0
  love.graphics.printf(playerMana, 915, 150, 275, 'left')
  
  love.graphics.printf("Turn", 905, 110, 275, 'right')
  local turnNum = 0
  love.graphics.printf(turnNum, 905, 150, 275, 'right')
  
  
  love.graphics.setColor(0.7, 0.7, 1)
  love.graphics.rectangle("fill", 950, 615, 200, 70)
  love.graphics.setColor(1, 1, 1)
  love.graphics.printf("Submit Play", 900, 630, 300, 'center')
  
  
  love.graphics.printf("Cost", 915, 208, 275, 'left')
  love.graphics.printf("Power", 905, 208, 275, 'right')
  love.graphics.printf("Card Description", 915, 315, 275, 'center')
  
  if card.hidden == true then
    return
  end
  
  love.graphics.printf(cardCost, 915, 248, 275, 'left')
  
  love.graphics.printf(cardPower, 905, 248, 275, 'right')
  
  love.graphics.printf(description, 915, 350, 275, 'left')
  
end

function GameBoard:drawBackground()
  
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
  -- love.graphics.setColor(1, 1, 1)
  love.graphics.setColor(0.35, 0.21, 0.36, 1)
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
  love.graphics.setColor(0.35, 0.21, 0.36, 1)
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


function GameBoard:generateAIDeck()
  -- insert 20 cards
  local initialDeck = Deck()
  self.AIDeck = initialDeck.cards
  
  for i=1, CARDS_PER_DECK do
    local x = LOCATION_DECK[1]
    local y = LOCATION_DECK[2]
    self.AIDeck[i].x = x
    self.AIDeck[i].y = y
  end
end