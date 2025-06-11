

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
  local file = nil
  
  local success, contents = pcall(love.filesystem.read, "data/cardData.csv")
  
  if not success or not contents then
    print("Error: could not read CSV file")
  else
    
    file = csv.openstring(contents)
  end
  
  

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
    print("ERROR: " .. contents)
  end
  
  
  for id, _ in pairs(cardData) do
    -- print(id)
    if id ~= "Card Name" then
      local fileName = string.format("assets/card_sprites/%s.png", id)
      cardImages[id] = love.graphics.newImage(fileName)
    end
  end
  
  
  backImage = love.graphics.newImage("assets/back.png")
  you_win = love.graphics.newImage("assets/you_win.png")
  you_lost = love.graphics.newImage("assets/you_lost.png")
  
  
  