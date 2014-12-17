Base = Class("Base")

function Base:initialize(arg)
    local arg = arg or {}
    for k,v in pairs(arg) do self[k] = v end
end

function Base:setSize(width,height)
    self.width = width
    self.height = height or width
    
    return self
end

function Base:setPos(x,y)
    self.x = x
    self.y = y

    return self -- for chain calling of methods
end

function Base:collidesWith(obj)
	return self.x < obj.x  + obj.width   and
           obj.x  < self.x + self.width  and
           self.y < obj.y  + obj.height  and
           obj.y  < self.y + self.height
end

function Base:isInsideOf(obj)
	return self.x >= obj.x 				and
		   self.y >= obj.y 				and
		   self.x <= obj.x + obj.width 	and
		   self.y <= obj.y + obj.height
end

function Base:center()
    return self.x+self.width/2, self.y+self.height/2
end

function Base:getBBox()
    return self.x,self.y,self.width,self.height
end

function Base:draw(...)
    love.graphics.draw(self.image, self.x, self.y, ...)
end
