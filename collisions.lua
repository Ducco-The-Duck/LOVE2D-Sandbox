
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

-----------------------
-- Collision Manager --
-----------------------

CollisionManager = {}
CollisionManager.__index = CollisionManager

function CollisionManager:new()
    self = setmetatable({}, CollisionManager)
    self.quadtree = QuadtreeNode(0, 0, love.graphics.getPixelWidth(), love.graphics.getPixelHeight(), 10, self)
    self.collisions = {}
end

function CollisionManager:checkCollision()
    self.collisions = {}
    self.quadtree.checkCollision()
    for _, value in pairs(self.collisions) do
        -- handle collisions
        print(value[1].id, value[2].id)
    end
end

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

--------------
-- Quadtree --
--------------

QuadtreeNode = {}
QuadtreeNode.__index = QuadtreeNode

function QuadtreeNode:new(x, y, w, h, cap, collmanager)
    self = setmetatable({}, QuadtreeNode)
    self.x1, self.y1, self.w, self.h = x, y, w, h
    self.collider = Collider({RectCollider(x, y, w, h)})
    self.collisionManager = collmanager
    self.cap = cap
    self.objects = {}
    self.leaf = true
    self.children = {}
end

function QuadtreeNode:insert(obj)
    if self.collider:checkCollision(obj) then
        self.objects[obj.id] = obj
        if #self.objects > self.cap then
            self:divide()
        end
        if not self.leaf then for _, child in ipairs(self.children) do child:insert(obj) end end
    end
end

function QuadtreeNode:delete(obj)
    self.objects[obj.id] = nil
    if #self.objects <= self.cap then
        self:rejoin()
    end
    if not self.leaf then for _, child in ipairs(self.children) do child:delete(obj) end end
end

function QuadtreeNode:rejoin()
    if not self.leaf then
        self.children = {}
        self.leaf = true
    end
end

function QuadtreeNode:divide()
    if self.leaf then
        local q1, q2, q3, q4 =
            QuadtreeNode:new(self.x           , self.y           , self.w/2, self.h/2, self.cap),
            QuadtreeNode:new(self.x + self.w/2, self.y           , self.w/2, self.h/2, self.cap),
            QuadtreeNode:new(self.x           , self.y + self.h/2, self.w/2, self.h/2, self.cap),
            QuadtreeNode:new(self.x + self.w/2, self.y + self.h/2, self.w/2, self.h/2, self.cap)
        self.leaf = false
        self.children = {q1, q2, q3, q4}
        for _, child in ipairs(self.children) do
            for _, obj in ipairs(self.objects) do
                child:insert(obj)
            end
        end
    end
end

function QuadtreeNode:checkCollision()
    if self.leaf then
        for _, obj1 in ipairs(self.objects) do
            for _, obj2 in ipairs(self.objects) do
                if obj1 ~= obj2 and
                    (self.collisionManager.collisions[obj1.id .. obj2.id] or self.collisionManager.collisions[obj2.id .. obj1.id]) and
                    obj1.collider.checkCollision(obj2.collider) then
                    self.collisionManager.collisions[obj1.id .. obj2.id] = {obj1, obj2}
                end
            end
        end
    else
        for _, child in ipairs(self.children) do
            child:checkCollision()
        end
    end
end
