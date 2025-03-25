ui = {}

function ui.button(position, width, height)
    local button = {}
    button.tags = {drawable = true, button = true}
    button.position = position or {0, 0}
    button.size = {width, height} or {1, 1}
    function button.isMouseOver()
        local mx, my = love.mouse.getPosition()
        return mx > button.position[1] and mx < button.position[1] + button.size[1] and my > button.position[2] and my < button.position[2] + button.size[2]
    end
    function button.onPush() print('button pressed') end
    function button.draw()
        love.graphics.print('button', button.position[1], button.position[2])
        love.graphics.rectangle("line", button.position[1], button.position[2], button.size[1], button.size[2])
    end

    return button
end