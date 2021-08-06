--entity

Entity = Object:extend()

function Entity:new(x,y,image_path)
    self.x = x
    self.y = y
    self.image = love.graphics.newImage(image_path)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.last = {}
    self.last.x = self.x
    self.last.y = self.y

    self.strength = 0
    self.tempStrength = 0
end

function Entity:update(dt)
    self.last.x = self.x
    self.last.y = self.y
    --reset the strength
    self.tempStrength = self.strength
end

function Entity:wasVerticallyAligned(e)
    --it's basically the collisionCheck func, but with the x and width path removed
    --it uses the last.y because we want to know this from the previous position
    return self.last.y < e.last.y + e.height and self.last.y + self.height > e.last.y
end

function Entity:wasHorizontallyAligned(e)
    --basically the collisionCheck func, but with the y and height part removed
    --uses last.x bc we want to know this from the previous position
    return self.last.x < e.last.x + e.width and self.last.x + self.width > e.last.x
end

function Entity:resolveCollision(e)
    -- Compare the tempStrength
    if self.tempStrength > e.tempStrength then
        -- We need to return the value that this method returns
        -- Else it will never reach main.lua
        ---- ADD THIS
        return e:resolveCollision(self)
        -------------
    end

    if self:checkCollision(e) then
        self.tempStrength = e.tempStrength
        if self:wasVerticallyAligned(e) then
            if self.x + self.width/2 < e.x + e.width/2 then
                local pushback = self.x + self.width - e.x
                self.x = self.x - pushback
            else
                local pushback = e.x + e.width - self.x
                self.x = self.x + pushback
            end
        elseif self:wasHorizontallyAligned(e) then
            if self.y + self.height/2 < e.y + e.height/2 then
                local pushback = self.y + self.height - e.y
                self.y = self.y - pushback
            else
                local pushback = e.y + e.height - self.y
                self.y = self.y + pushback
            end
        end
        -- There was collision! After we've resolved the collision return true
        ---- ADD THIS
        return true
        -------------
    end
    -- There was NO collision, return false
    -- (Though not returning anything would've been fine as well)
    -- (Since returning nothing would result in the returned value being nil)
    ---- ADD THIS
    return false
    -------------
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