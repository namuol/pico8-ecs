local ecs = {}

function containsAll(e, keys)
  for _,name in pairs(keys) do
    if not e[name] then
      return false
    end
  end
  
  return true
end

function ecs.entitiesWith(entities, componentNames)
  local results = {}
  for id,entity in pairs(entities) do
    if containsAll(entity, componentNames) then
      results[#results+1] = entity
    end
  end

  return results
end

function ecs.world()
  local world = {}

  local componentsByName = {}
  function world.component(name)
    if not componentsByName[name] then
      componentsByName[name] = componentsByName.size
    end

    return componentsByName[name]
  end

  local entities = {}
  function world.addEntity(components)
    local id = #entities+1
    entities[id] = components
    
    return id
  end

  function world.invoke(funcs)
    for n,func in pairs(funcs) do
      entities = func(entities)
    end
  end

  return world
end

return ecs