local Game = require("Game")
local SelectedElementUI = {}

-- todo: use the windows and the ui lib for this

function SelectedElementUI.displaySelectedTile()
  if Game.selectedTile ~= nil then
    ---@type Tile
    local tile = Game.selectedTile
    love.graphics.print(
      "Selected Tile: " .. tile:toString(),
      10,
      10
    )
  end
end


function SelectedElementUI.displayUI()
  SelectedElementUI.displaySelectedTile()
end



return SelectedElementUI

