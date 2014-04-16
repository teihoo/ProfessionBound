function init(virtual)
  self.placed = not virtual
end

function main()
  if self.placed then
    world.spawnMonster(entity.configParameter("monsterType"), entity.position(), {persistent = true})
    entity.smash()
  end
end