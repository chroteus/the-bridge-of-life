local SCALE = 3

-- Clothing and hair
local images = {}
images.hair = {}
images.head = {}
images.upper_body = {}
images.lower_body = {}

for dir,v in pairs(images) do
    images[dir] = love.filesystem.getDirectoryItems("assets/images/"..dir)
end

for dir,_ in pairs(images) do
    for k_img,img_str in pairs(_) do
        images[dir][k_img] = love.graphics.newImage("assets/images/"..dir.."/"..img_str)
        images[dir][k_img]:setFilter("nearest")
    end
end

local function randomFrom(t)
    return t[math.random(#t)]
end

------------------------------------------------------------------------

Entity = Base:subclass "Entity"

function Entity:initialize(arg)
    local arg = arg or {}
    for k,v in pairs(images) do
        self[k] = arg[k] or randomFrom(images[k])
    end
    
    self.hp = arg.hp or 10
    self.max_hp = self.hp
    
    self.width = 16*SCALE
    self.height = 32*SCALE
    
    Base.initialize(self, arg)
end

function Entity:loseHP(hp)
    self.hp = self.hp - hp
end

function Entity:add()
    -- should NEVER be used to add Player
    
    local last = game.entities[#game.entities]
    
    if last == nil then
        self:setPos(800, game.player.y - 20)
    else
        self:setPos(last.x + 400, last.y)
    end
    
    table.insert(game.entities, self)
    
    return self
end

function Entity:update(dt)
end

local base = love.graphics.newImage("assets/images/base.png")
base:setFilter("nearest")

local path = "assets/images/hurt/"
local hurt = {
    [90] = path .. "90.png",
    [75]  = path .. "75.png",
    [50]  = path .. "50.png",
    [25]  = path .. "25.png",
}
for k,img_str in pairs(hurt) do 
    hurt[k] = love.graphics.newImage(img_str) 
    hurt[k]:setFilter("nearest")
end

local function foot(x,y)
    love.graphics.rectangle("fill", x,y, 10, 5)
end

function Entity:draw()
    local scaleX = SCALE
    local scaleY = scaleX
    if self:isInstanceOf(Player) then scaleX = scaleX * -1 end
    
    love.graphics.draw(base, self.x, self.y, 0, scaleX, scaleY)
    for k,v in pairs(images) do
        love.graphics.draw(self[k], self.x, self.y, 0, scaleX, scaleY)
    end
    
    local hp_perc = self.hp/self.max_hp*100
    local function draw(img) love.graphics.draw(img, self.x, self.y, 0, scaleX, scaleY) end
    
    if     hp_perc < 90 and hp_perc >= 80 then draw(hurt[90])
    elseif hp_perc < 80 and hp_perc >= 60 then draw(hurt[75])
    elseif hp_perc < 60 and hp_perc >= 40 then draw(hurt[50])
    elseif hp_perc < 40                   then draw(hurt[25])
    end
    
    if not self:isInstanceOf(Player) then
        love.graphics.setColor(20,20,20)
        foot(self.x+10, self.y+self.height); foot(self.x+self.width-20, self.y+self.height) 
        love.graphics.setColor(255,255,255)
    end
end
