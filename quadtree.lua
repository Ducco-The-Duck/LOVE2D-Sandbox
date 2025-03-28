require 'collisions'

QuadtreeNode = {}
QuadtreeNode.__index = QuadtreeNode

function QuadtreeNode:new(x, y, w, h, cap)
    self = setmetatable({}, QuadtreeNode)
    self.x1, self.y1, self.w, self.h = x, y, w, h
    self.collider = Collider({RectCollider(x, y, w, h)})
    self.cap = cap
    self.objects = {}
    self.leaf = true
    self.children = {}
end

function QuadtreeNode:insert(obj)
    if self.collider:checkCollision(obj) then
        table.insert(self.objects, obj)
        if ~self.leaf then for _, child in ipairs(self.children) do child:insert(obj) end end
        if #self.objects > self.cap then
            self:divide()
        end
    end
end

function QuadtreeNode:delete(obj)
    if self.collider:checkCollision(obj) then

        table.insert(self.objects, obj)
        if ~self.leaf then for _, child in ipairs(self.children) do child:insert(obj) end end
        if #self.objects > self.cap then
            self:divide()
        end
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


