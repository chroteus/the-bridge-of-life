require "lib"
require "class"
require "states"

math.random = love.math.random
math.randomseed(os.time())


function love.load()
    love.filesystem.setIdentity("BridgeOfLife")
    Gamestate.registerEvents()
    
    -- the: Shortcuts for often used love funcs.
    the = {}
    the.screen = {}
    the.screen.width, the.screen.height = love.window.getDimensions()
    
    the.mouse = {width = 1, height = 1}
    --------------------------------------------
    
    -- Font handling
    FONT = {}
    local fontHandle = {
        __index = function(t, k)
            FONT[k] =  love.graphics.newFont("assets/gimenells.ttf", k)
            return FONT[k]
        end
    }
    setmetatable(FONT, fontHandle)
    FONT["default"] = FONT[16]
    
    love.graphics.setFont(FONT["default"])
    love.window.setTitle("The Bridge of Life")
    Gamestate.switch(menu)
end

function love.update(dt)
    Timer.update(dt)
    TEsound.cleanup(dt)
    the.mouse.x, the.mouse.y = love.mouse.getPosition()
end

function love.draw()

end



function bgPrintf(text, x,y, limit,align)
    love.graphics.setColor(90,90,90)
    love.graphics.printf(text, x+2, y+2, limit,align)
    love.graphics.setColor(255,255,255)
    love.graphics.printf(text, x, y, limit,align)
end
