local PlayerAttack = {}
PlayerAttack.__index = PlayerAttack
PlayerAttack.playerAttack = true

---
-- Create a new Player
-- @param collider
-- @return Player
function PlayerAttack.new(collider,plyr)

    local attack = {}

    setmetatable(attack, PlayerAttack)

    attack.width = 5
    attack.height = 5
    attack.radius = 10
    attack.collider = collider
    attack.bb = collider:addCircle(plyr.position.x+attack.width/2,(plyr.position.y+28)+attack.height/2,attack.width,attack.radius)
    attack.bb.node = attack
    attack.damage = 1
    attack.player = plyr
    attack:deactivate()

    return attack
end

function PlayerAttack:update()
    local player = self.player
    if player.character.direction=='right' then
        self.bb:moveTo(player.position.x + 24 + 20, player.position.y+28)
    else
        self.bb:moveTo(player.position.x + 24 - 20, player.position.y+28)
    end
end

function PlayerAttack:collide(node, dt, mtv_x, mtv_y)
    if not node then return end
    if self.dead then return end

    --implement hug button action
    if node.isPlayer then return end

    if node.hurt then
        node:hurt(self.damage)
        self:deactivate()
    end
end

function PlayerAttack:activate()
    self.dead = false
    self.collider:setSolid(self.bb)
end

function PlayerAttack:deactivate()
    self.dead = true
    self.collider:setGhost(self.bb)
end

return PlayerAttack