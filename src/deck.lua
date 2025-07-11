

Deck = Class{}

function Deck:init()
  self.cards = {}
  
  
  for id, data in pairs(cardData) do
    -- import sprites
    local cost = tonumber(data[1])
    local power = tonumber(data[2])
    local text = data[3]
    table.insert(self.cards, Card(id, 50, 50, LOCATION_LIST.DECK, nil, cost, power, text))
    
  end
  
  self:shuffle()
  
end


function Deck:shuffle()
  for i = CARDS_PER_DECK, 2, -1 do
    local randomIndex = math.random(1, i)
    self.cards[i], self.cards[randomIndex] = self.cards[randomIndex], self.cards[i]
  end
end


function Deck:draw()
  if #self.cards == 0 then
    return
  end
  
  local cardIndex = math.random(#self.cards)
  local cardFromDeck = self.cards[cardIndex]
  local cardToReturn = Card(cardFromDeck.id)
  
  table.remove(self.cards, cardIndex)
  
  return cardToReturn
end




