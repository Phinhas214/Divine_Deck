

Class = require "lib/class"

require "src/constants"

require "src/gameBoard"

require "src/card"

require "src/deck"

require "src/util"


-- import card Data from csv file

cardData = {}
cardImages = {}
backImage = {}
  
  local csv = require "lib/csv" 
  local dataFile = string.format("data/cardData.csv")
  local file = csv.open(dataFile)

  -- parse all the lines
  if file then
    local headerSkipped = false
    
    for fields in file:lines() do
      if not headerSkipped then
        headerSkipped = true
      else
        local name = fields[1]
        local cost = fields[2]
        local power = fields[3]
        local text = fields[4]
        
        if name ~= "Card Name" then
          cardData[name] = {cost, power, text}
          cardImages[name] = {}
        end
        
      end
    end
    
    -- close file
    file:close()
  else
    print("ERROR: " .. dataFile)
  end
  
--  for id, _ in pairs(cardData) do
--    if id == "Card Name" then
--      table.remove(cardData, id)
--    end
--  end
  
  
  for id, _ in pairs(cardData) do
    -- print(id)
    if id ~= "Card Name" then
      local fileName = string.format("assets/card_sprites/%s.png", id)
      cardImages[id] = love.graphics.newImage(fileName)
    end
  end
  
  
  backImage = love.graphics.newImage("assets/card_sprites/back.png")
  you_win = love.graphics.newImage("assets/you_win.png")
  you_lost = love.graphics.newImage("assets/you_lost.png")
  
  
  