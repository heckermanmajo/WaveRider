

local InventoryController = {
  selected_item = nil
}

function field(x,y)
  love.graphics.setColor(0, 0, 0, 0.9)
  love.graphics.rectangle(
    "fill",
    x,
    y,
    32,
    32
  )

  love.graphics.setColor(1, 1, 1, 1)
end



function InventoryController.init()

end


function InventoryController.update()

  if love.keyboard.isDown("i") and Player.number_cool_down <= 0 then
    if GameData.ui == "inventory" then
      GameData.ui = "hud"
      GameData.pause = false
      love.mouse.setCursor(GameData.cursor.cursor_target, 16, 16)
    else
      GameData.ui = "inventory"
      GameData.pause = true
      love.mouse.setCursor(GameData.cursor.cursor_arrow, 0, 0)
    end
    Player.number_cool_down = 0.2
  end

end


function InventoryController.draw()

  if GameData.ui == "inventory" then

    love.graphics.setColor(0, 0, 0, 0.3)
    love.graphics.rectangle(
      "fill",
      200,
      200,
      GameData.settings.screen_w - 400,
      GameData.settings.screen_h - 400
    )

    love.graphics.setColor(1, 1, 1, 1)

    for i =0,6 do
      field(i  * 40 + 230, 230)
    end

    love.graphics.print("Inventar", 500, 500,0, 1, 1)

  end

end

return InventoryController