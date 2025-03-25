collisions = {}

collisions.collisionCheckFunctions = {
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

function collisions.createRectHB(x1, y1, w, h)
    local hb = {}
    hb.type = 'rect'
    hb.x1 = math.min(x1, x1+w)
    hb.y1 = math.min(y1, y1+h)
    hb.x2 = math.max(x1, x1+w)
    hb.y2 = math.max(y1, y1+h)
    return hb

end

function collisions.createCircHB(x, y, r)
    local hb = {}
    hb.type = 'circ'
    hb.x = x
    hb.y = y
    hb.r = r
    return hb

end

function collisions.checkCollision(hb1, hb2)
    local coll = false
    for _, h1 in ipairs(hb1) do
        for _, h2 in ipairs(hb2) do
            coll = coll or collisions.collisionCheckFunctions[h1.type .. h2.type](h1, h2)
        end
    end
    return coll
end