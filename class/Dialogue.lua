Dialogue = Class "Dialogue"

Dialogue.width = 350
Dialogue.x = love.window.getWidth() - Dialogue.width
local padding = 100

function Dialogue:initialize(text, choices)
    self.text = tostring(text)
    self.btn = GUI.Container(1, "dynamic")
    :setElementSize(Dialogue.width, 60)
    :setPos(0,0)
    
    for _,choice in pairs(choices) do
        self.btn:add(
            GUI.Button(choice[1])
            :setFunc(
                function()
                    self:hide()
                    choice[2]()
                end)
        )
    end
  
    self.state = {}

    self.btn:center()
    self.btn:setPos(the.screen.width - Dialogue.width - padding, self.btn.y)
    self.btn:attachToState(self.state)
    self.y = self.btn.y

    function self.state.update(state, dt)
        self.btn:update(dt)
    end
    
    function self.state.draw(state)
        if self.previous_state then self.previous_state:draw() end
        
        love.graphics.setFont(FONT[24])
        love.graphics.setColor(60,60,60)
        love.graphics.printf(self.text, the.screen.width - Dialogue.width - padding, 
                             self.y - 50, Dialogue.width, "center")
        love.graphics.setColor(255,255,255)
        self.btn:draw()
        love.graphics.setFont(FONT["default"])
    end
end


function Dialogue:show()
    self.previous_state = Gamestate.current
    Gamestate.switch(self.state, "none")
end

function Dialogue:hide()
    Gamestate.switch(self.previous_state, "none")
end
