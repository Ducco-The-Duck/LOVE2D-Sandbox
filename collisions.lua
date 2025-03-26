
------------------------------------------------------------
-- Collision Checking functions for the 2 basic colliders --
------------------------------------------------------------

local CollisionCheckFunctions = {
    rectrect = function (hb1, hb2)
        local toright = hb1.x2 < hb2.x1
        local toleft = hb1.x1 > hb2.x2
        local todown = hb1.y2 < hb2.y1
        local toup = hb1.y1 > hb2.y2

        return not todown and not toleft and not toright and not toup
    end,
    rectcirc = function (hb1, hb2)
        local rect, circ = hb1, hb2
        local closest = {
            math.min(math.max(rect.x1, circ.x), rect.x2),
            math.min(math.max(rect.y1, circ.y), rect.y2)
        }

        local dist = vector.getMagnitude({circ.x - closest[1], circ.y - closest[2]})

        return dist <= circ.r
    end,
    circrect = function (hb1, hb2)
        local rect, circ = hb2, hb1
        local closest = {
            math.min(math.max(rect.x1, circ.x), rect.x2),
            math.min(math.max(rect.y1, circ.y), rect.y2)
        }

        local dist = vector.getMagnitude({circ.x - closest[1], circ.y - closest[2]})

        return dist <= circ.r
    end,
    circcirc = function (hb1, hb2)
        local dist = vector.getMagnitude({hb1.x - hb2.x, hb1.y - hb2.y})
        return dist <= (hb1.r + hb2.r)
    end
}

-------------------------
-- Two basic colliders --
-------------------------

RectCollider = {}
RectCollider.__index = RectCollider

function RectCollider:new(x1, y1, w, h)
    self = setmetatable({}, RectCollider)
    self.type = 'rect'
    self.x1 = x1
    self.y1 = y1
    self.x2 = x1+w
    self.y2 = y1+h
    return self
end

CircCollider = {}
CircCollider.__index = CircCollider

function CircCollider:new(x, y, r)
    self = setmetatable({}, CircCollider)
    self.type = 'circ'
    self.x = x
    self.y = y
    self.r = r
    return self
end

------------------------------
-- General Collider for use --
------------------------------

Collider = {}
Collider.__index = Collider

function Collider:new(tableOfColliders)
    self = setmetatable({}, Collider)
    self.colliders = tableOfColliders
    self.ABABCollider = nil
    self:calculateABABCollider()
end

function Collider:calculateABABCollider()
    local left, right, up, down = math.huge, 0, math.huge, 0

    for _, collider in ipairs(self.colliders) do

        if collider.type == 'rect' then
            left = math.min(left, collider.x1)
            right = math.max(right, collider.x2)
            up = math.min(up, collider.y1)
            down = math.max(down, collider.y2)

        elseif collider.type == 'circ' then
            left = math.min(left, collider.x - collider.r)
            right = math.max(right, collider.x + collider.r)
            up = math.min(up, collider.y - collider.r)
            down = math.max(down, collider.y + collider.r)
        end
    end

    self.ABABCollider = RectCollider(left, up, right - left, down - up)
end

function Collider:checkCollision(hb)
    local coll = false
    if CollisionCheckFunctions['rectrect'](self.ABABCollider, hb.ABABCollider) then
        for _, h1 in ipairs(self) do
            for _, h2 in ipairs(hb) do
                coll = coll or CollisionCheckFunctions[h1.type .. h2.type](h1, h2)
            end
        end
    end

    return coll
end