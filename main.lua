Battleground = {}
Battleground.__index = Battleground

function Battleground:new()
    self = setmetatable({}, Battleground)
    self.top = {}
    self.bot = {}
    self.position = {100, 100}
    return self
end

function Battleground:draw()
    love.graphics.rectangle("line", 0, 0, 400, 220)
    love.graphics.push()
    love.graphics.translate(25, 25)
    for _, slot in ipairs(self.top) do
        slot:draw()
        love.graphics.translate(50, 0)
    end
    love.graphics.pop()
    love.graphics.translate(25, 135)
    for _, slot in ipairs(self.bot) do
        slot:draw()
        love.graphics.translate(50, 0)
    end
    love.graphics.origin()
end


BattlegroundSlot = {}
BattlegroundSlot.__index = BattlegroundSlot

function BattlegroundSlot:new(bg)
    self = setmetatable({}, BattlegroundSlot)
    self.bg = bg
    return self
end

function BattlegroundSlot:draw()
    love.graphics.rectangle("line", 0, 0, 40, 60)
end

------------------------------------------------------------------
------------------------------------------------------------------
local bg

function love.load()
    bg = Battleground:new()
    local sl1 = BattlegroundSlot:new(bg)
    local sl2 = BattlegroundSlot:new(bg)
    local sl3 = BattlegroundSlot:new(bg)
    table.insert(bg.top, sl1)
    table.insert(bg.bot, sl2)
    table.insert(bg.bot, sl3)
end

function love.update(dt)
end

function love.draw()
    love.graphics.translate(bg.position[1], bg.position[2])
    bg:draw()
end