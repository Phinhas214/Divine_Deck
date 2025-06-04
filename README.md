




## Programming patterns 
- Prototype pattern: used in cardEffects through card:clone() method
- spacial partition: I'm storing possible card positions in my constants.lua file and I have corresponding data structures (tables) in my gameBoard class to query the positions. 
- Game loop
- Update Method

## Feedback
- Yi Xie: talked about whether I should automatically place cards into player hands or let them drag and drop it after each turn. 
- Prof Zac: gave me guiadance on how to use external libraries. e.g: class.lua
- classmate who I forgot the name of: we saw each other's projects and I decided to implement his design choice of popping the card up on hover for the hand cards. At the moment I'm displaying the entirety of the card but that's taking up a lot of screen space. So for my final project I'll add that polish. 

## Postmortem 

- I'm pretty proud of how this project came along design wise. It took me a lot of time to figure out the layout of everything and I spent more time than I should've for the layout. One reason it took me a lot of time was that I was trying to figure out the layout and code it at the same time. This meant that every small change in the layout meant huge refactors everytime. This was a mistake so in the future I'll "pen and paper" the visual design first before translating that into code. Lastly, I think the component programming pattern might have been a good fit for my gameBoard class and I would've explored if I had more time for refactoring this project. 


## Credits
- class library: https://github.com/vrld/hump 
- recursive printing function for debugging purposes: https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console
- csv reading library: https://github.com/geoffleyland/lua-csv 
- card art assets from chatGPT



