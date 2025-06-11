

CardEffects = {
  -- TODO: fix sapcing issue when read from cardData.csv
  wooden_cow = function(card, gameBoard)
    return
  end,
  
  pegasus = function(card, gameBoard)
    return
  end,
  
  minotaur = function(card, gameBoard)
    return
  end,
  
  titan = function(card, gameBoard)
    return
  end,
  
  zeus = function(card, gameBoard)
    if card.originalPile == gameBoard.playArea then
      for i=1, #gameBoard.AIPlayArea do
        gameBoard.AIPlayArea[i].power = gameBoard.AIPlayArea[i].power - 1
      end
    elseif card.originalPile == gameBoard.AIPlayArea then
      for i=1, #gameBoard.playArea do
        gameBoard.playArea[i].power = gameBoard.playArea[i].power - 1
      end 
    end
    
  end,

  ares = function(card, gameBoard)
    local powerGained = 0
    
    if card.originalPile == gameBoard.AIPlayArea then
      for i=1, #gameBoard.playArea do
        if gameBoard.playArea[i].location == card.location then
          powerGained = powerGained + 2
        end
      end
      
    elseif card.originalPile == gameBoard.playArea then
      for i=1, #gameBoard.AIPlayArea do
        if gameBoard.AIPlayArea[i].location == card.location then
          powerGained = powerGained + 2
        end
      end
      
    end
    
    card.power = card.power + powerGained
  end,
  
  medusa = function(card, gameBoard)
    
    for i=1, #gameBoard.playArea do
      if gameBoard.playArea[i].location == card.location and gameBoard.playArea[i] ~= card then
        gameBoard.playArea[i].power = gameBoard.playArea[i].power - 1
      end
    end
    for i=1, #gameBoard.AIPlayArea do
      if gameBoard.AIPlayArea[i].location == card.location and gameBoard.AIPlayArea[i] ~= card then
        gameBoard.AIPlayArea[i].power = gameBoard.AIPlayArea[i].power - 1
      end
    end
  end,
  
  cyclops = function(card, gameBoard)
    local powerGained = 0
    
    if card.originalPile == gameBoard.AIPlayArea then
      for i = #gameBoard.AIPlayArea, 1, -1 do
        local c = gameBoard.AIPlayArea[i]
        if c.location == card.location and c ~= card then
          gameBoard:discardCard(c)
          table.remove(gameBoard.AIPlayArea, i)
          
          powerGained = powerGained + 2
        end
      end
      
    elseif card.originalPile == gameBoard.playArea then
      for i = #gameBoard.playArea, 1, -1 do
        local c = gameBoard.playArea[i]
        if c.location == card.location and c ~= card then
          gameBoard:discardCard(c)
          table.remove(gameBoard.playArea, i)
          
          powerGained = powerGained + 2
        end
      end
    end
    
    card.power = card.power + powerGained
  end,
  
  
  poseidon = function(card, gameBoard)
    local minPower = 999
    local minPowerCard = nil
    local minPowerIndex = nil
    
    if card.originalPile == gameBoard.AIPlayArea then
      for i=1, #gameBoard.playArea do
        if gameBoard.playArea[i].location == card.location then
          if gameBoard.playArea[i].power < minPower then
            minPower = gameBoard.playArea[i].power
            minPowerCard = gameBoard.playArea[i]
            minPowerIndex = i
          end
        end
      end
      
    elseif card.originalPile == gameBoard.playArea then
      for i=1, #gameBoard.AIPlayArea do
        if gameBoard.AIPlayArea[i].location == card.location then
          if gameBoard.AIPlayArea[i].power < minPower then
            minPower = gameBoard.AIPlayArea[i].power
            minPowerCard = gameBoard.AIPlayArea[i]
            minPowerIndex = i
          end
        end
      end
    end
    
    if minPowerCard ~= nil then
      gameBoard:discardCard(minPowerCard)
      table.remove(minPowerCard.originalPile, minPowerIndex)
    end
    
  end,
  
  artemis = function(card, gameBoard)
    
    local counter = 0
    
    if card.originalPile == gameBoard.AIPlayArea then
      for i=1, #gameBoard.playArea do
        if gameBoard.playArea[i].location == card.location then
          counter = counter + 1
        end
      end
      
    elseif card.originalPile == gameBoard.playArea then
      for i=1, #gameBoard.AIPlayArea do
        if gameBoard.AIPlayArea[i].location == card.location then
          counter = counter + 1
        end
      end
    end
    
    if counter == 1 then
      card.power = card.power + 5
    end
  end,
  
  hera = function(card, gameBoard)
    
    if card.originalPile == gameBoard.AIPlayArea then
      for i=1, #gameBoard.AIHands do
        gameBoard.AIHands[i].power = gameBoard.AIHands[i].power + 1
      end
    elseif card.originalPile == gameBoard.playArea then
      for i=1, #gameBoard.hands do
        gameBoard.hands[i].power = gameBoard.hands[i].power + 1
      end
    end
  end,
  
  hades = function(card, gameBoard)
    
    local powerGained = 0
    
    for i=1, #gameBoard.discardPile do
      powerGained = powerGained + 2
    end
    
    card.power = card.power + powerGained
    
  end,
  
  hercules = function(card, gameBoard)
    
    for i=1, #gameBoard.AIPlayArea do
      if card.location == gameBoard.AIPlayArea[i].location then
        if gameBoard.AIPlayArea[i].power >= card.power and gameBoard.AIPlayArea[i] ~= card then
          return
        end
      end
    end
    
    for i=1, #gameBoard.playArea do
      if card.location == gameBoard.playArea[i].location then
        if gameBoard.playArea[i].power >= card.power and gameBoard.playArea[i] ~= card then
          return
        end
      end
    end
    
    card.power = card.power * 2
    
  end,
  
  dionysus = function(card, gameBoard)
    
    local powerGained = 0
    
    if card.originalPile == gameBoard.AIPlayArea then
      for i=1, #gameBoard.AIPlayArea do
        if gameBoard.AIPlayArea[i].location == card.location and gameBoard.AIPlayArea[i] ~= card then
          powerGained = powerGained + 2
        end
      end
    elseif card.originalPile == gameBoard.playArea then
      for i=1, #gameBoard.playArea do
        if gameBoard.playArea[i].location == card.location and gameBoard.playArea[i] ~= card then
          powerGained = powerGained + 2
        end
      end
    end
    
    card.power = card.power + powerGained
    
  end,
  
  hermes = function(card, gameBoard)
    
    local randPosition = nil
    local locationID = nil
    
    if card.originalPile == gameBoard.playArea then
      randPosition, locationID = gameBoard:randomPlayerLocation()
      

      
      card.location = locationID
      card.x = randPosition[1]
      card.y = randPosition[2]
      
    elseif card.originalPile == gameBoard.AIPlayArea then
      randPosition, locationID = gameBoard:randomAILocation()
      
      card.location = locationID
      card.x = randPosition[1]
      card.y = randPosition[2]
    end
    
  end,
  
  aphrodite = function(card, gameBoard)
    
    if card.originalPile == gameBoard.playArea then
      for i=1, #gameBoard.AIPlayArea do
        if gameBoard.AIPlayArea[i].location == card.location then
          gameBoard.AIPlayArea[i].power = gameBoard.AIPlayArea[i].power - 1
        end
      end
      
    elseif card.originalPile == gameBoard.AIPlayArea then
      for i=1, #gameBoard.playArea do
        if gameBoard.playArea[i].location == card.location then
          gameBoard.playArea[i].power = gameBoard.playArea[i].power - 1
        end
      end 
    end
    
  end,
  
  apollo = function(card, gameBoard)
    
    if card.originalPile == gameBoard.playArea then
      gameBoard.playerBonusManaNextTurn = gameBoard.playerBonusManaNextTurn + 1
    elseif card.originalPile == gameBoard.AIPlayArea then
      gameBoard.AIBonusManaNextTurn = gameBoard.AIBonusManaNextTurn + 1
    end
    
  end,
  
  persephone = function(card, gameBoard)
    local minPower = 999
    local minPowerIndex = nil
    if card.originalPile == gameBoard.playArea then
      for i=1, #gameBoard.hands do
        if gameBoard.hands[i].power < minPower then
          minPower = gameBoard.hands[i].power 
          minPowerIndex = i
        end
      end 
      
      gameBoard:discardCard(gameBoard.hands[minPowerIndex])
      table.remove(gameBoard.hands, minPowerIndex)
      
    elseif card.originalPile == gameBoard.AIPlayArea then
      for i=1, #gameBoard.AIHands do
        if gameBoard.AIHands[i].power < minPower then
          minPower = gameBoard.AIDeck[i].power 
          minPowerIndex = i
        end
      end 
      
      gameBoard:discardCard(gameBoard.AIHands[minPowerIndex])
      table.remove(gameBoard.AIHands, minPowerIndex)
    end
    
  end,
  
  prometheus = function(card, gameBoard)
    
    if card.originalPile == gameBoard.playArea then
      local stolenCard = table.remove(gameBoard.AIDeck)
      table.insert(gameBoard.playerDeck, stolenCard)
      stolenCard.x = LOCATION_DECK[1]
      stolenCard.y = LOCATION_DECK[2]
      stolenCard.location = LOCATION_LIST.DECK
      stolenCard.originalPile = gameBoard.playerDeck
      stolenCard.hidden = true
      
    elseif card.originalPile == gameBoard.AIPlayArea then
      local stolenCard = table.remove(gameBoard.playerDeck)
      stolenCard.location = LOCATION_LIST.DECK
      stolenCard.originalPile = gameBoard.AIDeck
      stolenCard.hidden = true
      table.insert(gameBoard.AIDeck, stolenCard)
    end
    
  end, 
  
  midas = function(card, gameBoard)
    
    for i=1, #gameBoard.playArea do
      if gameBoard.playArea[i].location == card.location then
        gameBoard.playArea[i].power = 3
      end
    end
    
    for i=1, #gameBoard.AIPlayArea do
      if gameBoard.AIPlayArea[i].location == card.location then
        gameBoard.AIPlayArea[i].power = 3
      end
    end
    
  end,
  
  athena = function(card, gameBoard)
    
    if card.originalPile == gameBoard.playArea then
      for i=1, #gameBoard.playArea do
        if gameBoard.playArea[i].location == card.location then
          card.power = card.power + 1
        end
      end
      
    elseif card.originalPile == gameBoard.AIPlayArea then
      for i=1, #gameBoard.AIPlayArea do
        if gameBoard.AIPlayArea[i].location == card.location then
          card.power = card.power + 1
        end
      end
    end
    
  end,
  
  hephaestus = function(card, gameBoard)
    local firstCard = nil
    local secondCard = nil
    if card.originalPile == gameBoard.playArea then
      if #gameBoard.hands >= 2 then
        gameBoard.hands[1].cost = gameBoard.hands[1].cost - 1
        gameBoard.hands[2].cost = gameBoard.hands[2].cost - 1
      else 
        print("Warning: less than two cards in player hand so card effect skipped")
        return
      end
    
    elseif card.originalPile == gameBoard.AIPlayArea then
      if #gameBoard.AIHands >= 2 then
        gameBoard.AIHands[1].cost = gameBoard.AIHands[1].cost - 1
        gameBoard.AIHands[2].cost = gameBoard.AIHands[2].cost - 1
      else 
        print("Warning: less than two cards in AI hand so card effect skipped")
        return
      end
    end
    
  end, 
  
  pandora = function(card, gameBoard)
    local allyCardCount = 0
    if card.originalPile == gameBoard.playArea then
      for i=1, #gameBoard.playArea do
        if gameBoard.playArea[i].location == card.location and gameBoard.playArea[i] ~= card then
          allyCardCount = allyCardCount + 1
        end
      end
      
      if allyCardCount == 0 then
        card.power = card.power - 5
      end
      
    elseif card.originalPile == gameBoard.AIPlayArea then
      for i=1, #gameBoard.AIPlayArea do
        if gameBoard.AIPlayArea[i].location == card.location and gameBoard.AIPlayArea[i] ~= card then
          allyCardCount = allyCardCount + 1
        end
      end
      
      if allyCardCount == 0 then
        card.power = card.power - 5
      end
    end
    
    
    
  end,
  
  nyx = function(card, gameBoard)
    
    local powerGained = 0
    
    if card.originalPile == gameBoard.AIPlayArea then
      for i = #gameBoard.AIPlayArea, 1, -1 do
        local c = gameBoard.AIPlayArea[i]
        if c.location == card.location and c ~= card then
          powerGained = powerGained + c.power
          gameBoard:discardCard(c)
          table.remove(gameBoard.AIPlayArea, i)
        end
      end
      
    elseif card.originalPile == gameBoard.playArea then
      for i = #gameBoard.playArea, 1, -1 do
        local c = gameBoard.playArea[i]
        if c.location == card.location and c ~= card then
          powerGained = powerGained + c.power
          gameBoard:discardCard(c)
          table.remove(gameBoard.playArea, i)
        end
      end
    end
    
    card.power = card.power + powerGained
    
  end
  
  
  
}
