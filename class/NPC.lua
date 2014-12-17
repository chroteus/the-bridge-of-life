NPC = Entity:subclass "NPC"

function NPC:initialize(arg)
    local arg = arg or {}
    self.onCollideFunc = arg[1] or function() end
    
    Entity.initialize(self, arg)

    self.not_collided = true
end

function NPC:update(dt)
    self.x = self.x - 100*dt

    if self.x < -100 then
        table.remove(game.entities, 1)
        self = nil
    end
end

function NPC:onCollide(player)
    if self.not_collided then
        self.not_collided = false
        self.onCollideFunc()
    end
end

function NPC:draw()
    Entity.draw(self)
end
