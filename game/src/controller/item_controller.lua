local ItemController = {
  amounts = {}  --  name mapped on instance of InventoryItem
}

function ItemController.init()

end


--- Called ever frame

function ItemController.update(delta_frame)
  if FrameController.is_100 then  --- only 10 times per second
    for i = 0, #Item.instances do
      local item = Item.instances[item]
      if Utils.collision(item, Player.currently_controlled) then
        item:pickup_callback()
      end
    end
  end
end

function ItemController.draw()

  for i = 0, #Item.instances do
    local item = Item.instances[item]
    DrawProtocol(item)
    -- Print the amount in the right corner of any item on the screen
    love.graphics.print(
      tostring(item.amount),
      item.x + 26 - GameData.settings.screen_x_view_factor,
      item.y + 26 - GameData.settings.screen_y_view_factor,
      0,
      1,
      1
    )
  end
end

return ItemController