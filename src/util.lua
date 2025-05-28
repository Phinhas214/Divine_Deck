

--[[
  recursively prints a table
  credit: https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console
]]
function Dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. Dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end


function checkMouseOver(mouseX, mouseY, cardX, cardY)
  return mouseX >= cardX and mouseX <= cardX + CARD_WIDTH and mouseY >= cardY and mouseY <= cardY + CARD_HEIGHT
end


function removeValue(tbl, val)
  
  for i=#tbl, 1, -1 do
    if tbl[i] == val then
      table.remove(tbl, i)
      return
    end
  end
  
end



function GameBoard:cleanInvalidCards()
  for i = #self.hands, 1, -1 do
    if self.hands[i] == nil or type(self.hands[i].update) ~= "function" then
      print("Removing invalid hand at index", i)
      table.remove(self.hands, i)
    end
  end
end