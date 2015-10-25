local ecs = require('ecs')
world = nil

function applyVelocity(entities)
  for n,entity in pairs(world.entitiesWith({"vel", "pos"})) do
    entity.pos.x += entity.vel.x
    entity.pos.y += entity.vel.y
  end

  return entities
end

local gravity = 0.2
function applyGravity(entities)
  for n,entity in pairs(world.entitiesWith({"vel"})) do
    entity.vel.y += gravity
  end

  return entities
end

local floor = 127
local left_wall = 0
local right_wall = 127
function bounce(entities)
  for n,entity in pairs(world.entitiesWith({"vel", "pos", "radius"})) do
    local bottom = entity.pos.y + entity.radius
    if bottom > floor then
      entity.pos.y = floor - entity.radius
      entity.vel.y *= -1
    end

    local left = entity.pos.x - entity.radius
    if left < left_wall then
      entity.pos.x = left_wall + entity.radius
      entity.vel.x *= -1
    end

    local right = entity.pos.x + entity.radius
    if right > right_wall then
      entity.pos.x = right_wall - entity.radius
      entity.vel.x *= -1
    end
  end

  return entities
end

function draw(entities)
  for n,entity in pairs(world.entitiesWith({"draw"})) do
    entity.draw(entity)
  end

  return entities
end

function drawCircle(e)
  circfill(e.pos.x,e.pos.y, e.radius, e.color)
end

function norm()
  return rnd(2) - 1
end

function random_ball()
  return {
    draw=drawCircle,
    vel={x=norm()*3,y=norm()*3},
    pos={x=rnd(128),y=rnd(128)},
    radius=2+rnd(4),
    color=1+flr(rnd(15))
  }
end

function _init()
  world = ecs.world()
  for i=1,20 do
    world.addEntity(random_ball())
  end
end

function _update()
  world.invoke({
    applyGravity,
    applyVelocity,
    bounce,
  })
end

function _draw()
  cls()

  world.invoke({
    draw,
  })
end