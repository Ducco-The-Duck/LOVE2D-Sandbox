-------------------------------------------------------------------------
---                             Utils                                 ---
-------------------------------------------------------------------------
require 'utils'
require 'ui'

-------------------------------------------------------------------------
---                             Vectors                               ---
-------------------------------------------------------------------------

require 'vector'

-------------------------------------------------------------------------

-------------------------------------------------------------------------
---                             Collision                             ---
-------------------------------------------------------------------------
require 'collisions'
-------------------------------------------------------------------------
-- require 'enemy'
-- local objs = {}
-- local tower = {}
-- local id = 0

local function uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

print(_VERSION)
print(os.time())
print(uuid())
print(uuid())
print(uuid())
print(uuid())
print(uuid())

-- local function addObjToGameState(obj)
--     local key = tostring(id)
--     objs[key] = obj
--     obj.id = key
--     id = id + 1
-- end

-- local function resolveCollisions()
--     local collidables = {}
--     for _, obj in pairs(objs) do
--         if obj.tags['collidable'] then
--             table.insert(collidables, obj)
--         end
--     end
--     local collided_indices = {}
--     for i1, obj1 in ipairs(collidables) do
--         for i2, obj2 in ipairs(collidables) do
--             if i1 ~= i2 and not contains(collided_indices, i1) and not contains(collided_indices, i2) then
--                 if collisions.checkCollision(obj1.hitbox(), obj2.hitbox()) then
--                     table.insert(collided_indices, i1)
--                     table.insert(collided_indices, i2)
--                     print(string.format('%s collides with %s', obj1.name, obj2.name))
--                     obj1.onCollision(obj2)
--                     obj2.onCollision(obj1)

--                 end
--             end
--         end
--     end
-- end

-- local function resolveMotion(dt)
--     for _, obj in pairs(objs) do
--         if obj.tags['movable'] then
--             obj.position = vector.addVectors(obj.position, vector.multVector(obj.vel(), dt))
--         end
--     end
-- end

-- local function resolveDeath()
--     for _, obj in pairs(objs) do
--         if obj.hp ~= nil and obj.hp <= 0 then
--             objs[obj.id] = nil
--         end
--     end
-- end

-- local function getUpgrade()
--     local bsize = 100
--     local bsep = 30
--     local centre = {love.graphics.getPixelWidth()/2, love.graphics.getPixelHeight()/2}

--     local b1 = ui.button({centre[1] - 1.5 * bsize - bsep, centre[2] - 0.5 * bsize}, bsize, bsize)
--     local b3 = ui.button({centre[1] + 0.5 * bsize + bsep, centre[2]- 0.5 * bsize}, bsize, bsize)
--     local b2 = ui.button({centre[1] - 0.5 * bsize, centre[2] - 0.5 * bsize}, bsize, bsize)
--     b1.group = {b1, b2, b3}
--     b2.group = {b1, b2, b3}
--     b3.group = {b1, b2, b3}

--     function b1.onPush()
--         print('button pushed')
--         for _, obj in ipairs(b1.group) do
--             objs[obj.id] = nil
--         end
--     end
--     function b2.onPush()
--         print('button pushed')
--         for _, obj in ipairs(b2.group) do
--             objs[obj.id] = nil
--         end
--     end
--     function b3.onPush()
--         print('button pushed')
--         for _, obj in ipairs(b3.group) do
--             objs[obj.id] = nil
--         end
--     end

--     addObjToGameState(b1)
--     addObjToGameState(b2)
--     addObjToGameState(b3)
-- end

-- local function spawnEnemy()
--     enemy_table = {Enemy.createArmouredEnemy, Enemy.createEnemy, Enemy.createQuickEnemy}
--     local enemy = nil
--     if math.random() > 0.5 then
--         local position = {
--             math.random(0, 1) * (love.graphics.getPixelWidth() - 40) + 20,
--             math.random(20, love.graphics.getPixelHeight() - 20)
--         }
--         enemy = enemy_table[math.random(1, 3)](position, vector.subVectors({love.graphics.getPixelWidth()/2, love.graphics.getPixelHeight()/2}, position))
--     else
--         local position = {
--             math.random(20, love.graphics.getPixelWidth() - 20),
--             math.random(0, 1) * (love.graphics.getPixelHeight() - 40) + 20,
--         }
--         enemy = enemy_table[math.random(1, 3)](position, vector.subVectors({love.graphics.getPixelWidth()/2, love.graphics.getPixelHeight()/2}, position))
--     end
--     addObjToGameState(enemy)
-- end


----------------------------------------------------------------------------
---                       LOVE funcs                                     ---
----------------------------------------------------------------------------

-- function love.load()
--     tower.dmg = 5
--     tower.name = 'tower'
--     tower.size = 20
--     tower.tags = {drawable = true}
--     tower.position = {love.graphics.getPixelWidth()/2, love.graphics.getPixelHeight()/2}
--     function tower.draw()
--         love.graphics.circle("line", tower.position[1], tower.position[2], tower.size)
--     end
--     function tower.shoot()
--         local bullet = {}
--         bullet.dmg = tower.dmg
--         bullet.name = 'bullet'
--         bullet.tags = {drawable = true, movable = true, collidable = true, bullet = true}
--         bullet.position = tower.position
--         local mouse_x, mouse_y = love.mouse.getPosition()
--         bullet.speed = 300
--         bullet.vel_dir = vector.addVectors({mouse_x, mouse_y}, vector.multVector(tower.position, -1))
--         function bullet.vel()
--             return vector.multVector(vector.normVector(bullet.vel_dir), bullet.speed)
--         end
--         function bullet.hitbox()
--             return {collisions.createCircHB(bullet.position[1], bullet.position[2], 3)}
--         end
--         function bullet.onCollision(obj)
--             if obj.tags['enemy'] then
--                 obj.takeDamage(bullet.dmg)
--                 objs[bullet.id] = nil
--             end
--         end
--         function bullet.draw()
--             love.graphics.circle("line", bullet.position[1], bullet.position[2], 3)
--         end
--         addObjToGameState(bullet)
--     end

--     local enemy = Enemy.createQuickEnemy({30, 30}, {1, 1})

--     addObjToGameState(tower)
--     addObjToGameState(enemy)

--     local border = {}
--     border.name = 'border'
--     border.tags = {collidable = true}
--     function border.hitbox()
--         return {
--             collisions.createRectHB(0, -1, love.graphics.getPixelWidth(), 1),
--             collisions.createRectHB(0, love.graphics.getPixelHeight(), love.graphics.getPixelWidth(), 1),
--             collisions.createRectHB(-1, 0, 1, love.graphics.getPixelHeight()),
--             collisions.createRectHB(love.graphics.getPixelWidth(), 0, 1, love.graphics.getPixelHeight())
--         }
--     end
--     function border.onCollision(obj)
--         if obj.tags['bullet'] then
--             objs[obj.id] = nil
--         end
--     end

--     addObjToGameState(border)

-- end

-- function love.update(dt)
--     resolveCollisions()
--     resolveMotion(dt)
--     resolveDeath()
-- end

-- function love.keypressed(key)
--     if key == 'space' then
--         tower.shoot()
--     end

--     if key == 'q' then
--         spawnEnemy()
--     end

--     if key == 'u' then
--         getUpgrade()
--     end
-- end

-- function love.mousepressed(x, y, button, istouch, presses)
--     for _, obj in pairs(objs) do
--         if obj.tags['button'] then
--             if obj.isMouseOver() and button == 1 then
--                 obj.onPush()
--             end
--         end
--     end
    
-- end

-- function love.draw()
--     for _, obj in pairs(objs) do
--         if obj.tags['drawable'] then
--             obj.draw()
--         end
--     end
-- end