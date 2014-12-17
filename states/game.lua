game = {}

function game.finish()
    menu.last_stats = {}
    for k,stat_v in pairs(game.player.stats) do
        menu.last_stats[k] = stat_v
    end
    
    local s = game.player.stats
    local a = game.achievements
    
    if s.happiness == 0 then a.miserable = true
    elseif s.happiness == 10 then a.smiley = true
    end
   
    if s.karma == 0 then a.satan = true
    elseif s.karma == 10 then a.god = true
    end
    
    if s.confidence == 0 then a.wimp = true
    elseif s.confidence == 10 then a.macho = true
    end
    
    if s.confidence == 10 and s.happiness == 10 then a.psycho = true end
    
    a.firstPlay = false

    Timer.add(0.5, function() 

        game.player = Player{x = 200, y = 400}
        game.entities = nil
        game.entities = {}
        
        local generateLife = require "life"
        generateLife()
    end)
    
    game.save()
    
    Gamestate.switch(menu)
end

function game:init()
    game.bg = love.graphics.newImage("assets/images/bg.png")
    game.bridge = love.graphics.newImage("assets/images/bridge.png")
    game.bridge_x = {0, 800}
    
    game.entities = {}
    game.player = Player{x = 200, y = 400}
    
    game.achievements = {
        -- karma
        satan = false,
        god = false,
        
        -- confidence
        wimp = false,
        macho = false,
        
        -- happiness
        miserable = false,
        smiley = false,
        
        -- full happiness and confidence
        psycho = false,
        
        -- not an achievement, but that doesn't cause problems
        firstPlay = true,
    }
    
    local generateLife = require "life"
    generateLife()
    
    TEsound.playLooping("assets/sounds/music.ogg", "bgm", math.huge, 0.85)
    
    game.load()
end

------------------------
function game.save()
    local str = "return {"
    for ach,v in pairs(game.achievements) do
        str = str .. ach .. "=" .. tostring(v) .. ","
    end
    str = str .. "}"
    
    love.filesystem.write("bol_save.lua", str)
end

function game.load()
    local f = love.filesystem.load("bol_save.lua") 
    if f ~= nil then
        game.achievements = f() -- call return
    end
end

-----------------------

function game:update(dt)
    for k,bridge_x in pairs(game.bridge_x) do
        game.bridge_x[k] = bridge_x - 100*dt
        if bridge_x+800 <= 0 then game.bridge_x[k] = 800 end
    end
    
    game.player:update(dt)
        
    for _,entity in pairs(game.entities) do
        entity:update(dt)
    end
end

function game:draw()
    love.graphics.draw(game.bg, 0,0)

    love.graphics.draw(game.bridge, game.bridge_x[1],-50)
    love.graphics.draw(game.bridge, game.bridge_x[2],-50)
        
    for _,entity in pairs(game.entities) do
        entity:draw()
    end
    
    game.player:draw()
end

function game:keypressed(key)
end
