function init()
  data.holdingJump = false
  data.ranOut = false
  data.holdingUp = false
  data.holdingDown = false
  data.holdingLeft = false
  data.holdingRight = false
  data.speedMultiplier = 1.1
  data.flyingcarpetActivated = false
end

function input(args)
  if args.moves["jump"] and tech.jumping() then
    data.holdingJump = true
  elseif not args.moves["jump"] then
    data.holdingJump = false
  end

  if args.moves["left"] then
    data.holdingLeft = true
  elseif not args.moves["left"] then
    data.holdingLeft = false
  end

  if args.moves["right"] then
    data.holdingRight = true
  elseif not args.moves["right"] then
    data.holdingRight = false
  end

  if args.moves["up"] then
    data.holdingUp = true
  elseif not args.moves["up"] then
    data.holdingUp = false
  end

  if args.moves["down"] then
    data.holdingDown = true
  elseif not args.moves["down"] then
    data.holdingDown = false
  end

	-- Action check
	if args.moves["special"] == 1 then
		data.flyingcarpetActivated = false
    tech.setAnimationState("flyingcarpet", "off")
		tech.setParentAppearance("normal")
    return nil
	end
	
  if not args.moves["jump"] and not args.moves["left"]and not args.moves["right"]and not args.moves["up"]and not args.moves["down"] and not tech.canJump() and not data.holdingJump and data.flyingcarpetActivated then
    return "flyingcarpethover"
  elseif args.moves["jump"] and not tech.canJump() and not data.holdingJump then
    return "flyingcarpet"
  elseif args.moves["left"] and args.moves["right"] and not tech.canJump() and data.flyingcarpetActivated then
    return "flyingcarpethover"
  elseif args.moves["up"] and args.moves["down"] and not tech.canJump() and data.flyingcarpetActivated then
    return "flyingcarpethover"
  elseif (args.moves["jump"] or args.moves["up"]) and args.moves["left"] and not tech.canJump() and not data.holdingRight and data.flyingcarpetActivated then
    return "flyingcarpetleftup"
  elseif (args.moves["jump"] or args.moves["up"]) and args.moves["right"] and not tech.canJump() and not data.holdingLeft and data.flyingcarpetActivated then
    return "flyingcarpetrightup"
  elseif args.moves["down"] and args.moves["left"] and not tech.canJump() and not data.holdingRight and data.flyingcarpetActivated then
    return "flyingcarpetleftdown"
  elseif args.moves["down"] and args.moves["right"] and not tech.canJump() and not data.holdingLeft and data.flyingcarpetActivated then
    return "flyingcarpetrightdown"
  elseif args.moves["left"] and not tech.canJump() and not data.holdingRight and data.flyingcarpetActivated then
    return "flyingcarpetleft"
  elseif args.moves["right"] and not tech.canJump() and not data.holdingLeft and data.flyingcarpetActivated then
    return "flyingcarpetright"
  elseif args.moves["up"] and not tech.canJump() and not data.holdingDown and data.flyingcarpetActivated then
    return "flyingcarpetup"
  elseif args.moves["down"] and not tech.canJump() and not data.holdingUp and data.flyingcarpetActivated then
    return "flyingcarpetdown"
  else
    return nil
  end

 end

function update(args)
  local flyingcarpetSpeed = tech.parameter("flyingcarpetSpeed")
  local flyingcarpetControlForce = tech.parameter("flyingcarpetControlForce")
  local energyUsagePerSecond = tech.parameter("energyUsagePerSecond")
  local energyUsage = energyUsagePerSecond * args.dt

  -- Calculate current angle and flip state
	local diff = world.distance(args.aimPosition, tech.position())
	local aimAngle = math.atan2(diff[2], diff[1])
	local flip = aimAngle > math.pi / 2 or aimAngle < -math.pi / 2

	-- Flip and offset player
	if flip then
		tech.setFlipped(false)
	else
		tech.setFlipped(true)
	end
		
	
  if args.availableEnergy < energyUsage then
    data.ranOut = true
  elseif tech.onGround() or tech.inLiquid() then
    data.ranOut = false
  end

  if args.actions["flyingcarpet"] and not data.ranOut then
    tech.setAnimationState("flyingcarpet", "on")
    tech.yControl(flyingcarpetSpeed, flyingcarpetControlForce, true)
		data.flyingcarpetActivated = true
		tech.setParentAppearance("sit")
    return energyUsage
  elseif args.actions["flyingcarpethover"] and not data.ranOut then
    tech.setAnimationState("flyingcarpet", "on")
    tech.yControl(0, flyingcarpetControlForce, true)
		tech.xControl(0, flyingcarpetControlForce, true)
    return energyUsage
  elseif args.actions["flyingcarpetleft"] and not data.ranOut then
    tech.setAnimationState("flyingcarpet", "on")
		tech.yControl(0, flyingcarpetControlForce, true)
		tech.xControl(-(flyingcarpetSpeed*data.speedMultiplier), flyingcarpetControlForce, true)
    return energyUsage
  elseif args.actions["flyingcarpetleftup"] and not data.ranOut then
    tech.setAnimationState("flyingcarpet", "on")
    tech.yControl(flyingcarpetSpeed, flyingcarpetControlForce, true)
		tech.xControl(-(flyingcarpetSpeed*data.speedMultiplier), flyingcarpetControlForce, true)
    return energyUsage
  elseif args.actions["flyingcarpetleftdown"] and not data.ranOut then
    tech.setAnimationState("flyingcarpet", "on")
    tech.yControl(-(flyingcarpetSpeed)*0.5, flyingcarpetControlForce, true)
		tech.xControl(-(flyingcarpetSpeed*data.speedMultiplier), flyingcarpetControlForce, true)
    return energyUsage
  elseif args.actions["flyingcarpetright"] and not data.ranOut then
    tech.setAnimationState("flyingcarpet", "on")
		tech.yControl(0, flyingcarpetControlForce, true)
		tech.xControl(flyingcarpetSpeed*data.speedMultiplier, flyingcarpetControlForce, true)
    return energyUsage
  elseif args.actions["flyingcarpetrightup"] and not data.ranOut then
    tech.setAnimationState("flyingcarpet", "on")
    tech.yControl(flyingcarpetSpeed, flyingcarpetControlForce, true)
		tech.xControl(flyingcarpetSpeed*data.speedMultiplier, flyingcarpetControlForce, true)
    return energyUsage
  elseif args.actions["flyingcarpetrightdown"] and not data.ranOut then
    tech.setAnimationState("flyingcarpet", "on")
    tech.yControl(-(flyingcarpetSpeed)*0.5, flyingcarpetControlForce, true)
		tech.xControl(flyingcarpetSpeed*data.speedMultiplier, flyingcarpetControlForce, true)
    return energyUsage
  elseif args.actions["flyingcarpetup"] and not data.ranOut then
    tech.setAnimationState("flyingcarpet", "on")
    tech.yControl(flyingcarpetSpeed, flyingcarpetControlForce, true)
		tech.xControl(0, flyingcarpetControlForce, true)
    return energyUsage
  elseif args.actions["flyingcarpetdown"] and not data.ranOut then
    tech.setAnimationState("flyingcarpet", "on")
    tech.yControl(-(flyingcarpetSpeed)*0.5, flyingcarpetControlForce, true)
		tech.xControl(0, flyingcarpetControlForce, true)
    return energyUsage
  else
		data.flyingcarpetActivated = false
    tech.setAnimationState("flyingcarpet", "off")
		tech.setParentAppearance("normal")
    return 0
  end

  return usedEnergy
end
