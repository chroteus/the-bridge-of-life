menu = {}

function menu:init()
    game:init()
    game.init = nil
    
    menu.btn = GUI.Container(1, "dynamic"):setElementSize(150,50)
    menu.btn:add{
        GUI.Button("Start"):setFunc(function() Gamestate.switch(game, "none") end),
    }
    
    menu.btn:center()

    menu.credits = [[ 
        Code, art, music by: Chroteus
        Website: OrangeDirigible.wordpress.com
        
        Made for Indies vs. PewDiePie jam
    ]]
    
    menu.btn:attachToState(menu)
end


local bar_width = 100
local bar_height = 30
local function barRect(text, x,y, width)
    love.graphics.rectangle("line", x,y,bar_width,bar_height)
    love.graphics.rectangle("fill", x,y,width,bar_height)
    love.graphics.setColor(128,128,128)
    love.graphics.print(text, x+5, 
                        y + bar_height/2-love.graphics.getFont():getHeight()/2 + 2)
    love.graphics.setColor(255,255,255)
end

local function achDraw(text, var, x,y,align)
    if game.achievements[var] == false then
        love.graphics.setColor(40,40,40, 50)
    else
        love.graphics.setColor(40,40,40)
    end
    
    love.graphics.printf(text, x,y, 200,align)
    love.graphics.setColor(255,255,255)
end

function menu:draw()
    game:draw()
    
    love.graphics.setFont(FONT[36])
    bgPrintf('The Bridge Of Life', 0, menu.btn.y - 80, the.screen.width, "center")
    love.graphics.setFont(FONT[20])
    bgPrintf(menu.credits, 0, the.screen.height-170, the.screen.width, "center")

    
    if menu.last_stats then
        love.graphics.setFont(FONT["default"])
        bgPrintf("Last game", 20, 50 + bar_height/2 - FONT["default"]:getHeight()/2,
                 the.screen.width, "left")
        barRect("Happiness", 10 + bar_width, 50, 
                (bar_width/game.player.stats_limit)*menu.last_stats.happiness)
        barRect("Karma", 20 + bar_width*2, 50,
                (bar_width/game.player.stats_limit)*menu.last_stats.karma)
        barRect("Confidence", 30 + bar_width*3, 50,
                (bar_width/game.player.stats_limit)*menu.last_stats.confidence)
    end
    
    if not game.achievements.firstPlay then
        love.graphics.setFont(FONT[32])
        bgPrintf("Achievements", 0, 40 + bar_height/2 - FONT["default"]:getHeight()/2,
                the.screen.width - 30, "right")
                
        love.graphics.setFont(FONT[18])
        
        local x = the.screen.width-230
        local y = 80
        achDraw("Satan", "satan",     x, y,    "left")
        achDraw("D-g",   "god",       x, y+25, "left")

        achDraw("Wimp",  "wimp",      x, y,    "center")
        achDraw("Macho", "macho",     x, y+25, "center")
        
        achDraw("Russia", "miserable",x, y,    "right")
        achDraw("Nassau", "smiley",   x, y+25, "right")
        
        achDraw("Happy Psychopath", "psycho",   x, y+50, "center")
        
        love.graphics.setFont(FONT["default"])
    end
end
