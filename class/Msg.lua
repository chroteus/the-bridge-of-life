MsgMgr = {}
MsgMgr.list = {}

function MsgMgr.show()
    local last = MsgMgr.list[1]
    
    if last and #last.concat_text == #last.text then
        table.remove(MsgMgr.list, 1)
    end
    
    last = MsgMgr.list[1]
    if last then
        last:show()
    end
end

function MsgMgr.add(msg)
    if msg.isInstanceOf and msg:isInstanceOf(Msg) then
        table.insert(MsgMgr.list, msg)
         if #MsgMgr.list == 1 then MsgMgr.show() end
    else
        for _,m in pairs(msg) do
            MsgMgr.add(m)
        end
    end
end

------------------------------------------------------------------------
Msg = Class "Msg"

function Msg:initialize(text, onFinish)
    self.text = text
    self.onFinish = onFinish
    self.concat_text = ""
    
    self.timer = Timer.new()
    self.state = {}

    function self.state.update(state, dt)
        self.timer:update(dt)
    end

    
    function self.state.draw(state)
        self.previous_state:draw()

        love.graphics.setFont(FONT[24])
        love.graphics.setColor(60,60,60)
        love.graphics.printf(self.concat_text, 2,
                             302, the.screen.width, "center")
        love.graphics.setColor(255,255,255)
        love.graphics.printf(self.concat_text, 0,
                             300, the.screen.width, "center")
        love.graphics.setFont(FONT["default"])
    end
    
    function self.state.keypressed(state, key)
        if key == " " then
            self:_onPass()
        end
    end
    
    function self.state.mousepressed(state, x,y,btn)
        if btn == "l" then
            self:_onPass()
        end
    end
end

function Msg:show()
    self.previous_state = Gamestate.current
    Gamestate.switch(self.state, "none")
    
    local letter_count = 1
    self.timer:addPeriodic(0.02,
        function()
            if #self.concat_text ~= #self.text then
                self.concat_text = self.concat_text..self.text:sub(letter_count, 
                                                                   letter_count)
                letter_count = letter_count+1
            end
        end)
end

function Msg:_onPass()
    if #self.concat_text ~= #self.text then
        self.concat_text = self.text
    else
        self:_onFinish()
    end
end

function Msg:_onFinish()
    TEsound.play("assets/sounds/click.wav", "sfx", 0.6)
    Gamestate.switch(self.previous_state, "none")
    if self.onFinish then self.onFinish() end
    
    MsgMgr.show()
    self = nil
end
