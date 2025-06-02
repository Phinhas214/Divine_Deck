

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
  
  self.playerMana = 1
  self.AIMana = 1
  self.playerPoints = 0
  self.AIPoints = 0
  
  self.turnNum = 1
  
  self:generatePlayerDeck()
  self:generateAIDeck()
  self:generatePlayerHand()
  
end

function GameBoard:generatePlayerHand()
  for i=1, 3 do
    local card = table.remove(self.playerDeck)
    card.x = LOCATION_PLAYER_HAND[i][1]
    card.y = LOCATION_PLAYER_HAND[i][2]
    card.hidden = false
    table.insert(self.hands, card)
  end
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
  
  if self:isSubmitClicked(mouseX, mouseY) and self.currentGameState == TURN_STATE.PLAYER then
    self.currentGameState = TURN_STATE.SUBMITTED
    self:submitTurn()
  end
  
  if self.currentGameState == TURN_STATE.REVEAL then
    self:revealCards()
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
  -- 1. flip player cards face down before AI plays
  for _, card in ipairs(self.playArea) do
    card.hidden = true
    print("hide player cards")
  end
  
  
  -- 2. Try to find a valid card the AI can afford
  local validCard = nil
  local maxAttempts = #self.AIDeck
  local attempts = 0
  
  while attempts < maxAttempts do
    local index = math.random(#self.AIDeck)
    local candidate = self.AIDeck[index]
    
    if candidate.cost <= self.AIMana then
      validCard = table.remove(self.AIDeck, index)
      break
    end
    
    attempts = attempts + 1
  end
  
  if not validCard then
    print("AI has no affordable cards.")
    self.currentGameState = TURN_STATE.REVEAL
    return
  end
  
  -- 3. pick a random location for the card
  local randomLocation = self:randomAILocation()
  local locationTries = 0
  
  -- check if there's already a card placed at randomLocation
  while self:inArray(self.AIPlayArea, randomLocation) and #self.AIPlayArea < 12 do
    randomLocation = self:randomAILocation()
    locationTries = locationTries + 1
  end
  
  if locationTries == 12 then
    print("AI play area full. Can't place more cards.")
    table.insert(self.AIDeck, validCard)
    
    self.currentGameState = TURN_STATE.REVEAL
    return
  end
 
  
  -- 4. place card in random Location and finalize
  validCard.x, validCard.y = randomLocation[1], randomLocation[2]
  validCard.hidden = true
  
  table.insert(self.AIPlayArea, validCard)
  self.AIMana = self.AIMana - validCard.cost
  
  self.currentGameState = TURN_STATE.REVEAL
end

function GameBoard:revealCards()
  local playerPoints = 0
  local AIPoints = 0
  for _, card in ipairs(self.playArea) do
    card.hidden = false
    playerPoints = playerPoints + card.power
    print("reveal player cards")
  end
  
  for _, card in ipairs(self.AIPlayArea) do
    card.hidden = false
    AIPoints = AIPoints + card.power
  end
  
  local totalPoints = playerPoints - AIPoints
  if totalPoints > 0 then
    self.playerPoints = self.playerPoints + totalPoints
  elseif totalPoints < 0 then
    self.AIPoints = self.AIPoints + math.abs(totalPoints)
  end
  
  -- process card effects here
  print("process card effects here")
  
  self.currentGameState = TURN_STATE.PLAYER
  self.turnNum = self.turnNum + 1
  self.playerMana = self.turnNum
  self.AIMana = self.turnNum
  print("go to cleanup state")
end



function GameBoard:setText(card)
  love.graphics.setColor(1, 1, 1)
  
  
  
  local cardCost = card.cost
  local cardPower = card.power
  local description = card.text
  
  
  love.graphics.setFont(font)
  
  love.graphics.printf("Player", 915, 10, 275, 'left')
  love.graphics.printf("Enemy", 905, 10, 275, 'right')
  
  
  love.graphics.printf(self.playerPoints, 915, 50, 275, 'left')
  love.graphics.printf(self.AIPoints, 905, 50, 275, 'right')
  
  love.graphics.printf("Mana", 915, 110, 275, 'left')
  love.graphics.printf(self.playerMana, 915, 150, 275, 'left')
  
  love.graphics.printf("Turn", 905, 110, 275, 'right')
  love.graphics.printf(self.turnNum, 905, 150, 275, 'right')
  
  
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
    self.playerDeck[i].hidden = true
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