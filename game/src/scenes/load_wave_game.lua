---[[
--- This function loads a wave game mission.
--- Since all stuff we safe is proper lua code
--- we can just require it.
---
---
---
---]]
-- todo: as a first example we just create is just loading the tiles
return function(mission_folder_path)
  -- step one read the data
  local tiles = require(mission_folder_path.."/tiles.lua")
  for i in 0,#tiles do
    local raw_tile_data = tiles[i]
    -- now make the
  end

end

