

CardEffects = {
  -- TODP: fix sapcing issue when read from cardData.csv
  wooden_cow = function(card, gameBoard)
    print("wooden cow")
    print("vanilla")
    return
  end,
  
  pegasus = function(card, gameBoard)
    print("pegasus")
    print("vanilla")
    return
  end,
  
  minotaur = function(card, gameBoard)
    print("minotaur")
    print("vanilla")
    return
  end,
  
  titan = function(card, gameBoard)
    print("titan")
    print("vanilla")
    return
  end,
  
  zeus = function(card, gameBoard)
    print("zeus")
    print("When Revealed: Lower the power of each card in your opponent’s locations by 1.")
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
    print("ares")
    print("When Revealed: Gain +2 power for each enemy card here.")
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
    print("medusa")
    print("When ANY other card is played here, lower that card’s power by 1.")
    
    for i=1, #gameBoard.playArea do
      if gameBoard.playArea[i].location == card.location then
        gameBoard.playArea[i].power = gameBoard.playArea[i].power - 1
      end
    end
    for i=1, #gameBoard.AIPlayArea do
      if gameBoard.AIPlayArea[i].location == card.location then
        gameBoard.AIPlayArea[i].power = gameBoard.AIPlayArea[i].power - 1
      end
    end
  end,
  
  cyclops = function(card, gameBoard)
    print("cyclops")
    print("When Revealed: Discard your other cards here, gain +2 power for each discarded.")
    local powerGained = 0
    
    if card.originalPile == gameBoard.AIPlayArea then
      for i=1, #gameBoard.AIPlayArea do
        if gameBoard.AIPlayArea[i].location == card.location then
          gameBoard.discardCard(gameBoard.AIPlayArea[i])
          table.remove(gameBoard.AIPlayArea, i)
          
          powerGained = powerGained + 2
        end
      end
      
    elseif card.originalPile == gameBoard.playArea then
      for i=1, #gameBoard.playArea do
        if gameBoard.playArea[i].location == card.location and gameBoard.playArea[i] ~= card then
          gameBoard.discardCard(gameBoard.playArea[i])
          table.remove(gameBoard.playArea, i)
          
          powerGained = powerGained + 2
        end
      end
    end
    
    card.power = card.power + powerGained
  end,
  
  
  poseidon = function(card, gameBoard)
    print("poseidon")
    print("When Revealed: Move away an enemy card here with the lowest power.")
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
    gameBoard:discardCard(card)
    table.remove(minPowerCard.originalPile, i)
  end,
  
  artemis = function(card, gameBoard)
    print("artemis")
    print("When Revealed: Gain +5 power if there is exactly one enemy card here.")
    
    if card.originalPile == gameBoard.AIPlayArea then
      if #gameBoard.playArea == 1 then
        card.power = card.power + 5
      end
    elseif card.originalPile == gameBoard.playArea then
      if #gameBoard.playArea == 1 then
        card.power = card.power + 5
      end
    end
  end,
  
  hera = function(card, gameBoard)
    print("hera")
    print("When Revealed: Give cards in your hand +1 power.")
    
    if card.originalPile == gameBoard.AIPlayArea then
      for i=1, #gameBoard.AIPlayArea do
        gameBoard.AIPlayArea[i].power = gameBoard.AIPlayArea[i].power + 1
      end
    elseif card.originalPile == gameBoard.playArea then
      for i=1, #gameBoard.hands do
        gameBoard.hands[i].power = gameBoard.hands[i].power + 1
      end
    end
  end,
  
  hades = function(card, gameBoard)
    print("hades")
    print("When Revealed: Gain +2 power for each card in the discard pile.")
    
    local powerGained = 0
    
    for i=1, #gameBoard.discardPile do
      powerGained = powerGained + 2
    end
    
    card.power = card.power + powerGained
    
  end,
  
  hercules = function(card, gameBoard)
    print("hercules")
    print("When Revealed: Doubles its power if it’s the strongest card here.")
    
    for i=1, #gameBoard.AIPlayArea do
      if card.location == gameBoard.AIPlayArea[i].location then
        if card.power <= gameBoard.AIPlayArea[i].power then
          return
        end
      end
    end
    
    for i=1, #gameBoard.playArea do
      if card.location == gameBoard.playArea[i].location then
        if card.power <= gameBoard.playArea[i].power then
          return
        end
      end
    end
    
    card.power = card.power * 2
    
  end,
  
  dionysus = function(card, gameBoard)
    print("dionysus")
    print("When Revealed: Gain +2 power for each of your other cards here.")
    
    local powerGained = 0
    
    if card.originalPile == gameBoard.AIPlayArea then
      for i=1, #gameBoard.AIPlayArea do
        powerGained = powerGained + 2
      end
    elseif card.originalPile == gameBoard.playArea then
      for i=1, #gameBoard.playArea do
        powerGained = powerGained + 2
      end
    end
    
    if powerGained > 2 then
      powerGained = powerGained - 2
    end
    
    card.power = card.power + powerGained
    
  end,
  
  hermes = function(card, gameBoard)
    print("hermes")
    print("When Revealed: Moves to another location.")
    
    local randPosition = nil
    local randomLocation = nil
    
    if card.originalPile == gameBoard.playArea then
      randPosition, randomLocation = gameBoard.randomPlayerLocation()
      
      card.location = randomLocation
      card.x = randomPosition.x
      card.y = randomPosition.y
      
    elseif card.originalPile == gameBoard.AIPlayArea then
      randPosition, randomLocation = gameBoard.randomAILocation()
      
      card.location = randomLocation
      card.x = randPosition.x
      card.y = randPosition.y
    end
    
  end,
  
  hydra = function(card, gameBoard)
    print("hydra")
    print("Add two copies to your hand when this card is discarded.")
    
     -- we'll clone the card and insert into hand
    if card.originalPile == gameBoard.playArea then
      for i=1, 2 do
        local clone = card:clone()
        local tries = 0
        
        local randIndex = math.random(1, 7)
        local handPos = LOCATION_PLAYER_HAND[randIndex]
        while gameBoard.inArray(gameBoard.hands, handPos) and #gameBoard.hands < 7 do
          randIndex = math.random(1, 7)
          tries = tries + 1
        end
        
        if #gameBoard.hands == 7 then
          print("hand area full. Can't place more cards.")
          return
        end
        
        clone.x = handPos.x
        clone.y = handPos.y
        
        clone.hidden = false
        clone.originalPile = gameBoard.hands 
        clone.location = LOCATION_LIST.HAND
        
        table.insert(gameBoard.hands, clone)
      end
      
    elseif card.originalPile == gameBoard.AIPlayArea then
      for i=1, 2 do
        local clone = card:clone()
        table.insert(gameBoard.AIDeck, clone)
      end
    end
    
  end,
  
  
  aphrodite = function(card, gameBoard)
    print("aphrodite")
    print("When Revealed: Lower the power of each enemy card here by 1.")
    
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
    print("apollo")
    print("When Revealed: Gain +1 mana next turn.")
    
    if card.originalPile == gameBoard.playArea then
      gameBoard.playerBonusManaNextTurn = gameBoard.playerBonusManaNextTurn + 1
    elseif card.originalPile == gameBoard.AIPlayArea then
      gameBoard.AIBonusManaNextTurn = gameBoard.AIBonusManaNextTurn + 1
    end
    
  end,
  
  persephone = function(card, gameBoard)
    print("persephone")
    print("When Revealed: Discard the lowest power card in your hand.")
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
      for i=1, #gameBoard.AIDeck do
        if gameBoard.AIDeck[i].power < minPower then
          minPower = gameBoard.AIDeck[i].power 
          minPowerIndex = i
        end
      end 
      
      gameBoard:discardCard(gameBoard.AIDeck[minPowerIndex])
      table.remove(gameBoard.AIDeck, minPowerIndex)
    end
    
  end,
  
  prometheus = function(card, gameBoard)
    print("prometheus")
    print("When Revealed: Draw a card from your opponent’s deck.")
    
    if card.originalPile == gameBoard.playArea then
      local stolenCard = table.remove(gameBoard.AIDeck)
      table.insert(gameBoard.playerDeck, stolenCard)
      
    elseif card.originalPile == gameBoard.AIPlayArea then
      local stolenCard = table.remove(gameBoard.playerDeck)
      table.insert(gameBoard.AIDeck, stolenCard)
    end
    
  end
  
}
