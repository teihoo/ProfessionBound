function init(args)
  entity.setInteractive(true)
end

function onInteraction()
    world.spawnMonster("petrobotchicken", entity.toAbsolutePosition({ 0.0, 1.0 }), { level = 3 })
	entity.smash()
end