require 'vector'

Position = {}
Position.__index = Position
function Position:new(x, y)
    return setmetatable(Vector:new(x or 0, y or 0), Position)
end

Velocity = {}
Velocity.__index = Velocity
function Velocity:new(dx, dy)
    return setmetatable(Vector:new(dx or 0, dy or 0), Velocity)
end

Health = {}
Health.__index = Health
function Health:new(hp)
    return setmetatable({hp = hp or 1}, Health)
end