

local ZombieSpawnController =  {}


function ZombieSpawnController.spawn()

  local fine = false
  repeat
    local x = (GameData.settings.screen_w - 32) * math.random()
    local y = (GameData.settings.screen_h - 32) * math.random()

    if not Utils.CheckCollision(x, y, 32, 32, GameData.player.x - 200, GameData.player.y - 200, 232, 232) then

      table.insert(
        GameData.zombies,
        Zombie.new(
          x,
          y,
          90,
          GameData.textures.zombie_textures.dark_zombie,
          GameData.textures.zombie_textures.dark_zombie_dead,
          32,
          32,
          100 -- 2 schüsse
        )
      )
      fine = true
    end
  until (fine)

  --WaveGame.delay(Zombie.spawn, 5)  -- call spawn again in 5 seconds
end


return ZombieSpawnController