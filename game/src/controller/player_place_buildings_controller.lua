local PlayerPlaceBuildingsController = {}

function PlayerPlaceBuildingsController.init()


end

function PlayerPlaceBuildingsController.update()

  if love.keyboard.isDown("b") and Player.number_cool_down <= 0 then
    if GameData.ui == "place_buildings" then
      GameData.ui = "hud"
      love.mouse.setCursor(GameData.cursor.cursor_target, 16, 16)
    else
      GameData.ui = "place_buildings"
      love.mouse.setCursor(GameData.cursor.cursor_arrow, 0, 0)
    end
    Player.number_cool_down = 0.2
  end

  if GameData.ui == "place_buildings" then
    if love.mouse.isDown(1) and Player.number_cool_down <= 0 then
      local x = love.mouse.getX() + GameData.settings.screen_x_view_factor
      local y = love.mouse.getY() + GameData.settings.screen_y_view_factor
      Building:new(
        x, y, 64, GameData.textures.building_textures.wall
      )
      Player.number_cool_down = 0.2
    end
  end

end

function PlayerPlaceBuildingsController.draw()
  if GameData.ui == "place_buildings" then


    -- todo draw building menu


    for x = 0, GameData.settings.world_w-32, 32 do
      for y = 0, GameData.settings.world_h-32, 32 do
        local t = Tile.get(x, y)
        local b = Tile.get(x, y).building
        if b == nil and t.passable then
          love.graphics.setColor(0, 1, 0, 0.4)
          love.graphics.rectangle(
            "fill",
            x - GameData.settings.screen_x_view_factor,
            y - GameData.settings.screen_y_view_factor,
            32,
            32
          )
        else
          love.graphics.setColor(1, 0, 0, 0.4)
          love.graphics.rectangle(
            "fill",
            x - GameData.settings.screen_x_view_factor,
            y - GameData.settings.screen_y_view_factor,
            32,
            32
          )
        end
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle(
          "line",
          x - GameData.settings.screen_x_view_factor,
          y - GameData.settings.screen_y_view_factor,
          32,
          32
        )
      end
    end
  end
end

return PlayerPlaceBuildingsController