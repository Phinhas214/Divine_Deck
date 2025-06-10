
require "src/cardEffects"


GameBoard = Class{}

function GameBoard:init()
  self.playerDeck = {}
  self.AIDeck = {}
  
  self.playArea = {}
  self.hands = {}
  self.discardPile = {}
  
  self.AIPlayArea = {}
  self.AIHands = {}
  -- self.AIPlayArea = {}
  
  self.pickedUpCards = {}
  self.cardPickedUp = false
  
  self.hoveredCard = nil
  self.currentGameState = TURN_STATE.PLAYER
  
  self.playerMana = 1
  self.AIMana = 1
  self.playerPoints = 0
  self.AIPoints = 0
  
  self.turnNum = 1
  
  self.playerBonusManaNextTurn = 0
  self.AIBonusManaNextTurn = 0
  
  self:generatePlayerDeck()
  self:generateAIDeck()
  self:generatePlayerHand()
  self:generateAIHand()
  
end

function GameBoard:generatePlayerHand()
  for i=1, 3 do
    local card = table.remove(self.playerDeck)
    card.x = LOCATION_PLAYER_HAND[i][1]
    card.y = LOCATION_PLAYER_HAND[i][2]
    card.hidden = false
    card.originalPile = self.hands
    card.location = LOCATION_LIST.HAND
    table.insert(self.hands, card)
  end
end

function GameBoard:generateAIHand()
  for i=1, 3 do
    local card = table.remove(self.AIDeck)
    card.x = LOCATION_AI_HAND[i][1]
    card.y = LOCATION_AI_HAND[i][2]
    card.hidden = true
    card.originalPile = self.AIHands
    card.location = LOCATION_LIST.AIHAND
    table.insert(self.AIHands, card)
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
  
  for i = 1, #self.AIHands do
    self.AIHands[i]:draw()
  end
  
  for i = 1, #self.discardPile do
    self.discardPile[i]:draw()
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
    for i, card in ipairs(self.AIHands) do
      if checkMouseOver(mouseX, mouseY, card.x, card.y) then
        self.hoveredCard = card
        break
      end
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
  
  if self.currentGameState == TURN_STATE.CLEANUP then
    self:cleanUp()
  end
  
  
  if #self.playerDeck > 0 then
    for i=#self.playerDeck, 1, -1 do
      self.playerDeck[i]:update()
    end
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
  local locationList = {
    {LOCATION_AI_1, 1}, 
    {LOCATION_AI_2, 2}, 
    {LOCATION_AI_3, 3} 
  }
  
  local tries = 0
  local maxTries = 48
  
  while tries < maxTries do
    local randSeed = math.random(1, 3)
    local randIndex = math.random(1, 4)
    
    local locationSet, locationID = unpack(locationList[randSeed])
    local pos = locationSet[randIndex]
    
    local occupied = false
    for _, card in ipairs(self.AIPlayArea) do
      if card.x == pos[1] and card.y == pos[2] then
        occupied = true
      end
    end
    
    if not occupied then
      return pos, locationID
    end
    
    tries = tries + 1
  end
  
  print("WARNING: Could not find unoocupied random AI location.")
  return nil, nil
end

function GameBoard:randomPlayerLocation()
  local locationList = {
    {LOCATION_PLAYER_1, 1}, 
    {LOCATION_PLAYER_2, 2}, 
    {LOCATION_PLAYER_3, 3} 
  }
  
  local tries = 0
  local maxTries = 48
  
  while tries < maxTries do
    local randSeed = math.random(1, 3)
    local randIndex = math.random(1, 4)
    
    local locationSet, locationID = unpack(locationList[randSeed])
    local pos = locationSet[randIndex]
    
    local occupied = false
    for _, card in ipairs(self.playArea) do
      if card.x == pos[1] and card.y == pos[2] then
        occupied = true
      end
    end
    
    if not occupied then
      return pos, locationID
    end
    
    tries = tries + 1
  end
  
  print("WARNING: Could not find unoocupied random player location.")
  return nil, nil
end


function GameBoard:randomHandLocation()
  local locationID = LOCATION_LIST.HAND
  
  local tries = 0
  local maxTries = 48
  
  while tries < maxTries do
    local randIndex = math.random(1, 7)
    local pos = LOCATION_PLAYER_HAND[randIndex]
    
    local occupied = false
    for _, card in ipairs(self.hands) do
      if card.x == pos[1] and card.y == pos[2] then
        occupied = true
        break
      end
    end
    

    if not occupied then
      return pos, locationID
    end
    
    tries = tries + 1
  end
  
  print("WARNING: Could not find unoocupied random hand location.")
  return nil, nil
end

function GameBoard:randomAIHandLocation()
  local locationID = LOCATION_LIST.AIHAND
  
  local tries = 0
  local maxTries = 48
  
  while tries < maxTries do
    local randIndex = math.random(1, 7)
    local pos = LOCATION_AI_HAND[randIndex]
    
    local occupied = false
    for _, card in ipairs(self.AIHands) do
      if card.x == pos[1] and card.y == pos[2] then
        occupied = true
        break
      end
    end
    

    if not occupied then
      return pos, locationID
    end
    
    tries = tries + 1
  end
  
  print("WARNING: Could not find unoocupied random hand location.")
  return nil, nil
end



function GameBoard:discardCard(card)
  if card == nil then
    print("Warning: nil card passed to discardCard()")
    return
  end
  
  
  if card.id == "hydra" then
    CardEffects[card.id](card, self)
  end
  card.x = LOCATION_DISCARD[1]
  card.y = LOCATION_DISCARD[2]
  card.location = LOCATION_LIST.DISCARD
  card.originalPile = self.discardPile
  card.hidden = false
  table.insert(gameBoard.discardPile, card)
  
  for i=1, #gameBoard.discardPile do
    print("discarded card: " .. gameBoard.discardPile[i].id)
  end
  
end


-- AI Logic here
function GameBoard:submitTurn()
  -- 1. flip player cards face down before AI plays
  for _, card in ipairs(self.playArea) do
    card.hidden = true
  end
  
  
  -- 2. Try to find a valid card the AI can afford
  local validCard = nil
  local maxAttempts = #self.AIHands + 10
  local attempts = 0
  
  while attempts < maxAttempts do
    local index = math.random(#self.AIHands)
    local candidate = self.AIHands[index]
    
    if candidate.cost <= self.AIMana then
      validCard = table.remove(self.AIHands, index)
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
  local randomLocation, locationID = self:randomAILocation()
  local locationTries = 0
  
  if #self.AIPlayArea == 12 then
    print("AI play area full. Can't place more cards.")
    table.insert(self.AIHands, validCard)
    
    self.currentGameState = TURN_STATE.REVEAL
    return
  end
  
  -- check if there's already a card placed at randomLocation
  while self:inArray(self.AIPlayArea, randomLocation) and #self.AIPlayArea < 12 do
    randomLocation, locationID = self:randomAILocation()
    locationTries = locationTries + 1
  end
  
  
  -- 4. place card in random Location and finalize
  validCard.x, validCard.y = randomLocation[1], randomLocation[2]
  validCard.hidden = true
  validCard.location = locationID
  -- print("ai loc: " .. locationID)
  validCard.originalPile = self.AIPlayArea 
  
  table.insert(self.AIPlayArea, validCard)
  self.AIMana = self.AIMana - validCard.cost
  
  self.currentGameState = TURN_STATE.REVEAL
  
end

function GameBoard:revealCards()
  local playerPoints = 0
  local AIPoints = 0
  
  for _, card in ipairs(self.playArea) do 
    card.hidden = false
  end
  
  for _, card in ipairs(self.AIPlayArea) do 
    card.hidden = false
  end
  
  -- process card effects here
  print("process player card effects here")
  for i=1, #self.playArea do
    local card = self.playArea[i]
    if card ~= nil then
      CardEffects[card.id:lower()](card, gameBoard)
    end
    
  end
  
  
  print("process AI card effects here")
  for i=1, #self.AIPlayArea do
    local card = self.AIPlayArea[i]
    if card ~= nil then
      print("ID: " .. card.id)
      CardEffects[card.id:lower()](card, gameBoard)
    end
  end
  
  
  for _, card in ipairs(self.playArea) do
    playerPoints = playerPoints + card.power
  end
  
  for _, card in ipairs(self.AIPlayArea) do
    AIPoints = AIPoints + card.power
  end
  
  local totalPoints = playerPoints - AIPoints
  if totalPoints > 0 then
    self.playerPoints = self.playerPoints + totalPoints
  elseif totalPoints < 0 then
    self.AIPoints = self.AIPoints + math.abs(totalPoints)
  end
  
  
  self.turnNum = self.turnNum + 1
  self.playerMana = self.turnNum
  self.AIMana = self.turnNum
  
  self.playerMana = self.playerMana + self.playerBonusManaNextTurn
  self.AIMana = self.AIMana + self.AIBonusManaNextTurn
  
  self.playerBonusManaNextTurn = 0
  self.AIBonusManaNextTurn = 0
  -- print("go to cleanup state")
  
  self.currentGameState = TURN_STATE.CLEANUP
end


function GameBoard:cleanUp()
  -- if card power is zero, then discard the card
  for i=#self.AIPlayArea, 1, -1 do
    if self.AIPlayArea[i].power <= 0 then
      self:discardCard(self.AIPlayArea[i])
      table.remove(self.AIPlayArea, i)
    end
  end
  
  
  for i=#self.playArea, 1, -1 do
    if self.playArea[i].power <= 0 then
      self:discardCard(self.playArea[i])
      table.remove(self.playArea, i)
    end
  end
  
  
  -- Add a card to hand pile before every turn
  local pos, locationID = self:randomHandLocation()
  
  if pos == nil or locationID == nil then
    self.currentGameState = TURN_STATE.PLAYER
    return
  end
  
  
  local transferCard = table.remove(self.playerDeck)
  table.insert(self.hands, transferCard)
  
  
  
  transferCard.x = pos[1]
  transferCard.y = pos[2]
  transferCard.location = locationID
  transferCard.originalPile = self.hands 
  transferCard.hidden = false
  
  self.currentGameState = TURN_STATE.PLAYER
  
  local AIPos, AILocationID = self:randomAIHandLocation()
  
  if AIPos == nil or AILocationID == nil then
    self.currentGameState = TURN_STATE.PLAYER
    return
  end
  
  
  local AItransferCard = table.remove(self.AIDeck)
  table.insert(self.AIHands, AItransferCard)
  
  
  
  AItransferCard.x = AIPos[1]
  AItransferCard.y = AIPos[2]
  AItransferCard.location = AILocationID
  AItransferCard.originalPile = self.AIHands 
  AItransferCard.hidden = true
  
  self.currentGameState = TURN_STATE.PLAYER
  
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
  
  self:renderAIHands()
  
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
  love.graphics.line(0, 450, 900, 450)
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

function GameBoard:renderAIHands()
  for i=1, 7 do
    local x = LOCATION_AI_HAND[i][1]
    local y = LOCATION_AI_HAND[i][2]
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
    self.playerDeck[i].location = LOCATION_LIST.DECK
    self.playerDeck[i].originalPile = self.playerDeck
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
    self.AIDeck[i].location = LOCATION_LIST.DECK
    self.AIDeck[i].originalPile = self.AIDeck
    self.AIDeck[i].hidden = true
  end
end