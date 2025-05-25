

Card = Class{}

function Card:init(id, x, y)
  self.id = id
  
  self.x = x
  self.y = y
  
  self.hidden = false
  self.pickedUp = false
  
  self.originalX = nil
  self.originalY = nil
  
end


function Card:pickUp()
  self.pickedUp = true
  
  self.originalX = x
  self.originalY = y
  
  -- put card in pickedUpCards
  table.insert(gameBoard.pickedUpCards, self)
  
  -- remove card from current pile
  table.remove()
  
end