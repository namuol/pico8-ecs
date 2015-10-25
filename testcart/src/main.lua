local ecs = require('ecs')
world = nil

function applyVelocity(entities)
  for n,entity in pairs(ecs.entitiesWith(entities, {"vel", "pos"})) do
    entity.pos.x += entity.vel.x
    entity.pos.y += entity.vel.y
  end

  return entities
end

local gravity = 0.2
function applyGravity(entities)
  for n,entity in pairs(ecs.entitiesWith(entities, {"vel"})) do
    entity.vel.y += gravity
  end

  return entities
end

local floor = 127
local left_wall = 0
local right_wall = 127
function bounce(entities)
  for n,entity in pairs(ecs.entitiesWith(entities, {"vel", "pos", "radius"})) do
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
  for n,entity in pairs(ecs.entitiesWith(entities, {"draw"})) do
    entity.draw(entity)
  end

  return entities
end

function drawCircle(e)
  circfill(e.pos.x,e.pos.y, e.radius, e.color)
end

function drawSquare(e)
  rectfill(e.pos.x,e.pos.y, e.pos.x+e.size,e.pos.y+e.size, e.color)
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

function tween(entities)
  for n,entity in pairs(ecs.entitiesWith(entities, {"target_pos", "pos"})) do
    entity.pos.x += (entity.target_pos.x - entity.pos.x) * 0.1
    entity.pos.y += (entity.target_pos.y - entity.pos.y) * 0.1
  end

  return entities
end

function randomize_positions(entities)
  if rnd(1) < 0.01 then
    for n,entity in pairs(ecs.entitiesWith(entities, {"target_pos"})) do
      entity.target_pos.x = rnd(128)
      entity.target_pos.y = rnd(128)
    end
  end
  return entities
end

function random_square()
  return {
    draw=drawSquare,
    tween=tween,
    pos={x=rnd(128),y=rnd(128)},
    target_pos={x=rnd(128),y=rnd(128)},
    size=4+flr(rnd(8)),
    color=1+flr(rnd(15))
  }
end

function _init()
  world = ecs.world()
  for i=1,10 do
    world.addEntity(random_ball())
  end

  for i=1,10 do
    world.addEntity(random_square())
  end
end

function _update()
  world.invoke({
    applyGravity,
    applyVelocity,
    bounce,
    randomize_positions,
    tween,
  })
end

function _draw()
  cls()

  world.invoke({
    draw,
  })
end