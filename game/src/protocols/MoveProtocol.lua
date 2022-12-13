--- @class MoveProtocolInstance
--- @field x
--- @field y
--- @field speed
--- @field direction number
--- @field can_move boolean
--- @field stop_at_target boolean
--- @field on_move_target_hit function
--- @field move_target

--- MOvetarget can be a simple table of two values or a other mob or object ...
--- Evene a waipoint or a route for better navigation
--- @class MoveTarget
--- @field x
--- @field y

--- @param instance MoveProtocolInstance
--- This Protocol handles moving to a target and further
function MoveProtocol(instance, delta_frame)

  -- todo move protocol asserts asserts

  if instance.can_move then

    if instance.x <= instance.move_target_x or not instance.stop_at_target then
      instance.x = instance.x + (math.cos(instance.direction) * instance.speed * delta_frame)
    end

    if instance.y <= instance.move_target_y or not instance.stop_at_target then
      instance.y = instance.y + (math.sin(instance.direction) * instance.speed * delta_frame)
    end

    if instance.x >= instance.move_target_x and instancey >= instance.move_target_y then
      instance:on_move_target_hit()
    end

  end

end