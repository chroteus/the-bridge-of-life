Player = Entity:subclass("Player")

function Player:initialize(arg)
    -- stats are different from HP
    self.stats = {
        karma = 5,
        confidence = 5,
        happiness = 5,
    }
    
    self.stats_limit = 10
    
    self.feet_status = false -- moves feet
    self.timer = Timer.new()
    self.timer:addPeriodic(0.5, function()
        if self.feet_status then self.feet_status = false
        else self.feet_status = true end
    end)
    
    self.timer:addPeriodic(3, function()
        self.hp = math.clamp(0, self.hp + 1, self.max_hp)
        
    end)
    
    
    Entity.initialize(self, arg)
end

function Player:changeStat(stat, change)
    self.stats[stat] = math.clamp(0, self.stats[stat] + change, self.stats_limit)
end

function Player:loseHP(change)
    Entity.loseHP(self, change)
end

function Player:update(dt)
    self.timer:update(dt)
    for _,npc in pairs(game.entities) do
        if npc:isInstanceOf(NPC) and self:collidesWith(npc) then
            if npc.not_collided then
                npc:onCollide(self)
                npc.not_collided = false
            end
        end
    end
end


local bar_height = 16
local bar_width  = 100
local function barRect(text, x,y, width)
    love.graphics.rectangle("line", x,y,bar_width,bar_height)
    love.graphics.rectangle("fill", x,y,width,bar_height)
    love.graphics.setColor(128,128,128)
    love.graphics.print(text, x+5, 
                        y + bar_height/2-love.graphics.getFont():getHeight()/2 + 2)
    love.graphics.setColor(255,255,255)
end

local function foot(x,y)
    love.graphics.rectangle("fill", x,y, 10, 5)
end

function Player:draw()
    Entity.draw(self)
    
    if Gamestate.current == game then
        love.graphics.setFont(FONT["default"])
        barRect("HP", 
                5,5, (bar_width/self.max_hp)*self.hp)
        barRect("Happiness", 10 + bar_width, 5, 
                (bar_width/self.stats_limit)*self.stats.happiness)
        barRect("Karma", 15 + bar_width*2, 5,
                (bar_width/self.stats_limit)*self.stats.karma)
        barRect("Confidence", 20 + bar_width*3, 5,
                (bar_width/self.stats_limit)*self.stats.confidence)
        
    end
    
    love.graphics.setColor(20,20,20)
    if self.feet_status == true then
        foot(self.x-self.width+15, self.y+self.height); foot(self.x-25, self.y+self.height)
    else
        foot(self.x+10-self.width, self.y+self.height); foot(self.x-20, self.y+self.height)
    end
    love.graphics.setColor(255,255,255)
end
