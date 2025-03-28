require 'components'

Bullet = {}
Bullet.__index = Bullet

function Bullet:new(position, velocity, dmg, size)
    self = setmetatable({}, Bullet)
    self.dmg = dmg
    self.name = 'bullet'
    self.size = size
    self.tags = {drawable = true, movable = true, collidable = true, bullet = true}
    self.Position = Position:new(position[1], position[2])
    self.Velocity = Velocity:new(velocity[1], velocity[2])
    return self
end

function Bullet:getHitbox()
    return {collisions.createCircHB(self.position[1], self.position[2], self.size)}
end

function Bullet:draw()
    love.graphics.circle("fill", self.position[1], self.position[2], self.size)
end

function Bullet:onCollisionEnemy(enemy)
    enemy.takeDamage(self.dmg)
end