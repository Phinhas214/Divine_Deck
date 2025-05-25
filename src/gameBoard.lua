

GameBoard = Class{}

function GameBoard:init()
--  self.playerDeck = Deck()
--  self.AIDeck = Deck()
  
  self.pickedUpCards = {}
  --self.
end

function GameBoard:draw()
  
end

function GameBoard:drawBackground()
  
end




function GameBoard:draw()
  
  for index, pos in ipairs(LOCATIONS) do
    love.graphics.setColor(1, 1, 1, 1) -- White
    local x = pos[1]
    local y = pos[2]
    
    -- player side
    -- love.graphics.rectangle("line", x, y, SCREEN_WIDTH/3, SCREEN_HEIGHT/3, 2)
    
    --mid line
    -- love.graphics.line(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/2)
    
    -- AI side
    -- love.graphics.rectangle("line", x, 115, SCREEN_WIDTH/3, SCREEN_HEIGHT/3, 2)
  end
  
  -- love.graphics.setColor(0.78, 0.05, 0.87, 1)
  
  self:renderAILocations()
  
  self:renderPlayerLocations()
  
  -- AI Draw pile
  -- love.graphics.rectangle("fill", 100, 15, CARD_WIDTH, CARD_HEIGHT, 2)
  -- Player Draw pile
  -- love.graphics.rectangle("fill", 100, 600, CARD_WIDTH, CARD_HEIGHT, 2)
  
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
    local x = LOCATION_Player_1[i][1]
    local y = LOCATION_Player_1[i][2]
    love.graphics.rectangle("fill", x, y, CARD_WIDTH, CARD_HEIGHT, 2)
  end
  
  for i=1, 4 do
    local x = LOCATION_Player_2[i][1]
    local y = LOCATION_Player_2[i][2]
    love.graphics.rectangle("fill", x, y, CARD_WIDTH, CARD_HEIGHT, 2)
  end
  
  for i=1, 4 do
    local x = LOCATION_Player_3[i][1]
    local y = LOCATION_Player_3[i][2]
    love.graphics.rectangle("fill", x, y, CARD_WIDTH, CARD_HEIGHT, 2)
  end
end



