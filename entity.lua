--entity

Entity = Object:extend()

function Entity:new(x,y,image_path)
    self.x = x
    self.y = y
    self.image = love.graphics.newImage(image_path)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
end

function Entity:update(dt)
    --we'll leave this empty for now
end

function Entity:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

function Entity:checkCollision(e)
    --e will be the other entity with which we check if there is a collision
    -- this is the final compact version from ch.13
    return self.x + self.width > e.x
    and self.x < e.x + e.width
    and self.y + self.height > e.y
    and self.y < e.y + e.height
end