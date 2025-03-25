Vector = {}
Vector.__index = Vector

function Vector:new(x, y)
    self = setmetatable({x, y}, Vector)
    return self
end

function Vector:__add(v)
    if getmetatable(v) ~= Vector then error('tried to add vector and non-vector') end
    return Vector:new(self[1] + v[1], self[2] + v[2])
end

function Vector:__mul(s)
    if type(s) ~= 'number' then error('tried to multiply vector by non-number') end
    return Vector:new(self[1] * s, self[2] * s)
end

function Vector:__sub(v)
    if getmetatable(v) ~= Vector then error('tried to subtract vector and non-vector') end
    return Vector:new(self[1] + v[1], self[2] + v[2])
end

function Vector:norm()
    local mg = vector.getMagnitude(self)
    return {self[1]/mg, self[2]/mg}
end

function Vector:getMagnitude()
    return math.sqrt(self[1]^2 + self[2]^2)
end