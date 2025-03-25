require 'collisions'
require 'vector'

Enemy = {}

function Enemy.createEnemy(position, vel_dir)
    local enemy = {}
    enemy.hp = 20
    enemy.name = 'Enemy'
    enemy.size = 10
    enemy.tags = {enemy = true, drawable = true, movable = true, collidable = true}
    enemy.position = position or {0, 0}
    enemy.speed = 40
    enemy.vel_dir = vector.normVector(vel_dir) or {1, 0}
    function enemy.vel()
        return vector.multVector(enemy.vel_dir, enemy.speed)
    end
    function enemy.hitbox()
        return {collisions.createCircHB(enemy.position[1], enemy.position[2], enemy.size)}
    end
    function enemy.onCollision(obj) end
    function enemy.draw()
        love.graphics.circle("line", enemy.position[1], enemy.position[2], enemy.size)
    end
    function enemy.takeDamage(dmg)
        enemy.hp = enemy.hp - dmg
    end

    return enemy
end

function Enemy.createQuickEnemy(position, vel_dir)
    local enemy = Enemy.createEnemy(position, vel_dir)
    enemy.hp = 8
    enemy.name = 'QuickEnemy'
    enemy.size = 7
    enemy.speed = 90
    function enemy.draw()
        local vers = {
            10, 0,
            -5, -6.93,
            -5, 6.93,
        }
        local angle = math.atan2(enemy.vel_dir[2], enemy.vel_dir[1])
        love.graphics.translate(enemy.position[1], enemy.position[2])
        love.graphics.rotate(angle)
        love.graphics.polygon("line", vers)
        love.graphics.origin()
    end

    return enemy
end

function Enemy.createArmouredEnemy(position, vel_dir)
    local enemy = Enemy.createEnemy(position, vel_dir)
    enemy.hp = 20
    enemy.armour = 2
    enemy.name = 'ArmouredEnemy'
    enemy.size = 13
    enemy.speed = 25
    function enemy.draw()
        local vers = {
            -6, -6,
            6, -6,
            6, 6,
            -6, 6,
        }
        local angle = math.atan2(enemy.vel_dir[2], enemy.vel_dir[1])
        love.graphics.translate(enemy.position[1], enemy.position[2])
        love.graphics.rotate(angle)
        love.graphics.polygon("line", vers)
        love.graphics.origin()
    end
    function enemy.takeDamage(dmg)
        local dmg = dmg - enemy.armour
        if dmg < 0 then dmg = 0 end
        enemy.hp = enemy.hp - dmg
    end

    return enemy
end