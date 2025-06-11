
## Programming Patterns Used
- Prototype pattern: used in cardEffects through card:clone() method
- spacial partition: I'm storing possible card positions in my constants.lua file and I have corresponding data structures (tables) in my gameBoard class to query the positions. 
- Game loop
- Update Method
- singleton: I declared a global gameBoard object in main.lua and used it throughout my codebased (eg. card.lua). 


## Feedback
- Yi Xie: talked about whether I should automatically place cards into player hands or let them drag and drop it after each turn. 
- Prof Zac: gave me guiadance on how to use external libraries. e.g: class.lua
- classmate who I forgot the name of: we saw each other's projects and I decided to implement his design choice of popping the card up on hover for the hand cards. At the moment I'm displaying the entirety of the card but that's taking up a lot of screen space. So for my final project I'll add that polish. 


## Postmortem
- I chose to do this project individually and I'm pretty proud of myself for this project. I got to appreciate the process of building the infrastructure of the project early on and even though that's not the most visible part of the project, it really helped with making things easier when I wanted to scale some aspects of the project. This included adding cards with their respective card effects, and adding placeholders for AI hand pile. For example, because I worked on the separating the logic for card data reading (aka: reading from a CSV file) from card rendering, it made it easy for me to just add more cards to my file and update my CSV file. Those cards all had the same behaviors as the previous ones which made me appreciate the importance of separation of concerns in my code and well built infrastructure for scaling. There were a lot of moving parts in this project that at first I didn't even know how to manage the complexity. This is usually not the case for class projects in my experience as they're well defined and smaller in scope. The open-ended nature of this project taught me a lot about object-oriented-programming more than any previous class as it was project-based learning. This was a pleasant surprise because I wasn't expecting to learn about OOP from this project. I spent a lot of time tinkering with the layout and visual language of the game in the beginning and at that time I felt like I was wasting time. I couldn't bring myself to move on to the logic of the game before settling on the visual design but that really paid off here because the game looks pretty decent aesthetically. The biggest issue was figuring out how to test the card effects. I didn't know how to do this incrementally so I wrote the entire cardEffects.lua file and then began testing the cards. And even then, I still had issues because if I wanted to test a specific card, I had to play the game long enough to get that card and hope another card effect didn't crash my game. I would like to work on something like this in the future because I can learn a good deal about a topic if I build projects and put myself in a position where I have to figure stuff out on the fly. I would esspecially want to learn about differnt data science and more modern software engineering frameworks this way. 


## Credits
- class library: https://github.com/vrld/hump 
- recursive printing function for debugging purposes: https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console
- csv reading library: https://github.com/geoffleyland/lua-csv 
- card art assets from chatGPT



