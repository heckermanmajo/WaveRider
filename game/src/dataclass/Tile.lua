--[[
  No tile protocol, since tiles are always the same in every game modification.
]]

local astar_path = require("lib/astar")

--- @class Tile
--- @field x
--- @field y
--- @field height
--- @field elevator number to which height?
--- @field mob Mob
--- @field building Building  -- onyl one building per tile
--- @field sprites Sprite[]
--- @field passable boolean
--- @field water boolean
--- @field object Object  -- one object per tile
--- @field chunk Chunk
---
local Tile = {
  all = {},
  test_path = {},
  tried_tiles = {},
  --nav_rect_canvas = love.graphics.newCanvas(GameData.settings.screen_w, GameData.settings.screen_h),
  batch_gras = nil  --- set on init
}

function Tile:new(x, y, passable)
  local this = {}
  this.x = x
  this.y = y
  this.w = 32
  this.h = 32
  this.height = 0
  this.elevator = 0
  this.mob = nil
  this.building = nil
  this.sprites = {}
  this.passable = passable
  this.water = false
  this.object = nil
  this.chunk = nil
  this.type = ""
  this.texture = ""
  this.visibility_bucket = nil
  Tile.all[#Tile.all + 1] = this
end

function Tile.init()
  Tile.batch_gras = love.graphics.newSpriteBatch(
    GameData.textures.tiles.gras, 32 * 32
  )
  Tile.batch_gras:clear()
  for y = 0, GameData.settings.world_h-32, 32 do
    for x = 0, GameData.settings.world_w-32, 32 do
      --- for now all gras
      local tile = Tile.get(x, y)
      Tile.batch_gras:add(
        x - GameData.settings.screen_x_view_factor, -- - GameData.settings.screen_x_view_factor,
        y - GameData.settings.screen_x_view_factor -- - GameData.settings.screen_y_view_factor,
      )
      --break
    end
  end
end

--- Use the draw batch function from löve for more speed
function Tile.draw(tiles)
  --[[for y = 1, GameData.settings.world_h-32,32 do
    for x = 1, GameData.settings.world_w-32,32 do
      --- for now all gras
      if Utils.CheckCollision(
        x,
        y,
        32,
        32,
        GameData.settings.screen_x_view_factor,
        GameData.settings.screen_y_view_factor,
        GameData.settings.screen_w,
        GameData.settings.screen_h
      ) then
        --print(x)
        --print(y)
        local tile = Tile.all[x][y]
        love.graphics.draw(
          GameData.textures.tiles.gras,
          x - GameData.settings.screen_x_view_factor,
          y - GameData.settings.screen_y_view_factor
        )
        --[[Tile.batch_gras:add(
          x - GameData.settings.screen_x_view_factor,
          y - GameData.settings.screen_y_view_factor,
          0,
          32,
          32
        )
      end
    end
  end]]

  love.graphics.draw(Tile.batch_gras, math.round(-GameData.settings.screen_x_view_factor), math.round(-GameData.settings.screen_y_view_factor))
  --Tile.batch_gras:clear()


  --[==[love.graphics.setCanvas(Tile.nav_rect_canvas)
  love.graphics.clear()
  for x = 0, GameData.settings.world_w-32, 32 do
    for y = 0, GameData.settings.world_h-32, 32 do
      if Utils.CheckCollision(x, y, 32, 32, GameData.settings.screen_x_view_factor,
                              GameData.settings.screen_y_view_factor, GameData.settings.screen_w,
                              GameData.settings.screen_h) then
       -- local t = Tile.get(x, y)
       -- love.graphics.setColor(1, 1, 1, 1)
        --love.graphics.print(tostring(t.x), x + 5-GameData.settings.screen_x_view_factor, y + 5-GameData.settings.screen_y_view_factor, 0, 0.8, 0.8)
        --love.graphics.print(tostring(t.y), x + 5-GameData.settings.screen_x_view_factor, y + 15-GameData.settings.screen_y_view_factor, 0, 0.8, 0.8)
        --[[if not Tile.get(x, y).passable then

          love.graphics.setColor(1, 0, 0, 1)

          love.graphics.rectangle(
            "line",
            x - GameData.settings.screen_x_view_factor,
            y - GameData.settings.screen_y_view_factor,
            33,
            33
          )
          love.graphics.rectangle(
            "line",
            x - GameData.settings.screen_x_view_factor,
            y - GameData.settings.screen_y_view_factor,
            34,
            34
          )
        end
        ]]--
      end
    end
  end
  love.graphics.setCanvas()  -- close rect cnavas
  love.graphics.draw(Tile.nav_rect_canvas)
  love.graphics.setColor(1, 1, 1, 1)
]==]--
  --[[love.graphics.setColor(1, 1, 0, 1)
  for i, t in ipairs(Tile.tried_tiles) do
    love.graphics.rectangle(
      "line",
      t.x - GameData.settings.screen_x_view_factor,
      t.y - GameData.settings.screen_y_view_factor,
      32,
      32
    )
  end
  love.graphics.setColor(1, 1, 1, 1)
  for i, t in ipairs(Tile.test_path) do
    love.graphics.rectangle(
      "fill",
      t.x - GameData.settings.screen_x_view_factor,
      t.y - GameData.settings.screen_y_view_factor,
      32,
      32
    )
  end]]

end

function Tile.create_all_tiles()
  for y = 0, GameData.settings.world_h-32, 32 do
    for x = 0, GameData.settings.world_w-32, 32 do

      local passable = true
      if math.random(1, 10) < 2 then
        passable = false
      end
      Tile:new(
        x,
        y,
        passable
      )
    end
  end
end

function Tile.is_valid_node(mob)
  --- @param node Tile
  --- @param neighbor Tile
  return function(node, neighbor)
    --- check if there is a difference in height
    --- if so check if the node is a elevator node
    return true

  end
end

function Tile.update()

  local x = love.mouse.getX() + GameData.settings.screen_x_view_factor
  local y = love.mouse.getY() + GameData.settings.screen_y_view_factor
  --Tile.test_path = Tile.get_path(Player.x, Player.y, x, y, nil) or {}
  for i, v in ipairs(Tile.test_path) do
    print(v.x)
    print(v.y)
    print("WAT")
  end
  --os.exit()
  --W print(#Tile.tried_tiles)
  --Tile.test_path = Tile.get_way_around_path(
  -- Tile.all[math.floor(Player.x / 32) * 32][math.floor(Player.y / 32) * 32],
  -- Tile.all[math.floor(x / 32) * 32][math.floor(y / 32) * 32])
  --print(#Tile.test_path)
end

---
---@return Tile[] List of references to the tiles
function Tile.get_path(x, y, t_x, t_y, mob)
  local ignore_cache = true
  return astar_path(
    Tile.get(x, y),
    Tile.get(t_x, t_y),
    Tile.all,
    ignore_cache,
    Tile.is_valid_node
  )
end

---@param start Tile
---@param target Tile
function Tile.get_way_around_path(start, target)
  Tile.tried_tiles = {}
  local current_target = target
  local final_target = target
  local current_pos = start
  local path = { current_pos }
  local edges = {}

  local movement_x = 0
  local movement_y = 0
  local check_pos

  local obstacle_start_pos
  local obstacle_current_pos

  for i = 0, 8 do

    if current_pos.x < current_target.x then
      movement_x = 32
    end
    if current_pos.x > current_target.x then
      movement_x = -32
    end
    if current_pos.y < current_target.y then
      movement_y = 32
    end
    if current_pos.y > current_target.y then
      movement_y = -32
    end

    check_pos = Tile.all[current_pos.x + movement_x][current_pos.y + movement_y]
    table.insert(Tile.tried_tiles, check_pos)
    if check_pos.passable == true then
      table.insert(path, check_pos)
      current_pos = check_pos
    else

      -- look right and left: is there a way down ?

      check_pos = Tile.all[current_pos.x + movement_x][current_pos.y]  -- go right
      table.insert(Tile.tried_tiles, check_pos)
      if check_pos.passable == true then
        table.insert(path, check_pos)
        current_pos = check_pos
      end
    end

    --- go around an obstacle

  end

  return path
end

---@return Tile
function Tile.get(x, y)
  local index = math.abs(
    math.floor(y / 32)
      * math.floor(GameData.settings.world_w / 32)
      + math.floor(x / 32)
  )
  if index <= #Tile.all then
    if Tile.all[index + 1] == nil then
      for key, v in ipairs(Tile.all) do
        print(key)
        print(v)
      end
      print("BAD ERROR")
      print(Tile.all[1])
      print(x)
      print(y)
      print(#Tile.all)
      print(index)
      --os.exit()
    end
    return Tile.all[index +1]
  else
    print(x)
    print(y)
    print(#Tile.all)
    print(index)
    --os.exit()
    return nil
  end
end

return Tile