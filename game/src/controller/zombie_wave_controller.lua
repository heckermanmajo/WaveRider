local ZombieWaveController = {}


function ZombieWaveController.wave()
  --- only waves if all enemies are done

  if #GameData.zombies > 600 then
    GameData.game_mode = "wave"
  end

  if GameData.game_mode == "wave" then
    if #GameData.zombies ~= 0 then
      WaveGame.delay(Zombie.make_wave, 5)
      return
    end
  end

  local zombies_of_wave = {}

  local composition = {
    n = 1,
    b = 0.05,
    d = 0.0,
    r = 0.0
  }

  --- change the wave composition over time
  if GameData.zombie_config.wave_counter > 5 then
    composition.b = 0.1
    composition.d = 0.05
    composition.r = 0.03
  end

  if GameData.zombie_config.wave_counter > 10 then
    composition.b = 0.2
    composition.d = 0.1
    composition.r = 0.05
  end

  if GameData.zombie_config.wave_counter > 15 then
    composition.b = 0.3
    composition.d = 0.1
    composition.r = 0.15
  end

  if GameData.zombie_config.wave_counter > 20 then
    composition.b = 0.5
    composition.d = 0.1
    composition.r = 0.1
  end

  if GameData.zombie_config.wave_counter > 25 then
    composition.b = 0.5
    composition.d = 0.05
    composition.r = 0.05
  end

  if GameData.zombie_config.wave_counter > 30 then
    composition.b = 0.5
    composition.d = 0.05
    composition.r = 0.1
  end

  --if #GameData.zombies > 200 then
  --- less normalos
  --composition.n = composition.n * 0.333
  --elseif #GameData.zombies < 50 then
  --- more nomalos
  --composition.n = composition.n * 2
  --end

  local normal_zombie_amount = math.floor(GameData.zombie_config.start_wave_amount * composition.n)
  local black_zombie_amount = math.floor(GameData.zombie_config.start_wave_amount * composition.d)
  local big_zombie_amount = math.floor(GameData.zombie_config.start_wave_amount * composition.b)
  local red_zombie_amount = math.floor(GameData.zombie_config.start_wave_amount * composition.r)

  for i = 0, normal_zombie_amount do
    local z = Zombie.new(0, math.random(0, GameData.settings.world_h), math.random(30, 50))
    z.state = "hunting"
    table.insert(GameData.zombies, z)
    table.insert(zombies_of_wave, z)
  end

  for i = 0, big_zombie_amount do
    local z = Zombie.new(
      0,
      math.random(0, GameData.settings.world_h),
      math.random(20, 30),
      GameData.textures.zombie_textures.big_zombie,
      GameData.textures.zombie_textures.big_zombie_dead,
      64,
      64,
      500, -- 10 schüsse
      true
    )
    z.state = "hunting"
    table.insert(GameData.zombies, z)
  end

  for i = 1, black_zombie_amount do
    local z = Zombie.new(
      0,
      math.random(0, GameData.settings.world_h),
      math.random(120, 150),
      GameData.textures.zombie_textures.dark_zombie,
      GameData.textures.zombie_textures.dark_zombie_dead,
      32,
      32,
      100, -- 2 schüsse
      true
    )
    z.state = "hunting"
    table.insert(GameData.zombies, z)
  end

  for i = 1, red_zombie_amount do
    local z = Zombie.new(
      0,
      math.random(0, GameData.settings.world_h),
      math.random(70, 90),
      GameData.textures.zombie_textures.read_zombie,
      GameData.textures.zombie_textures.read_zombie_dead,
      64,
      64,
      400,
    true-- 20 schüsse
    )
    z.state = "hunting"
    table.insert(GameData.zombies, z)
  end

  --- some zombies focus some troopers
  if #GameData.trooper ~= 0 then
    local counter = 0
    for i = 0, #GameData.zombies / 2 do
      GameData.zombies[math.random(1, #GameData.zombies)].target = GameData.trooper[math.random(1, #GameData.trooper)]
      counter = counter + 1
      if counter > #GameData.trooper * 10 then
        break
      end
    end
  end

  --- some zombies wander off before they attacking the player or a soldier
  local counter = 0
  local wanderer = 0
  for key, zombie in ipairs(GameData.zombies) do
    counter = counter + 1
    if counter % 2 == 0 then
      wanderer = wanderer + 1
      zombie.wander_off = true
    end

    -- max 200 wanderer
    if wanderer > 200 then
      break
    end
  end

  GameData.zombie_config.start_wave_amount = (
    GameData.zombie_config.start_wave_amount
      + 10
  )
  GameData.zombie_config.wave_counter = GameData.zombie_config.wave_counter + 1
  GameData.zombie_config.wave_space_between_time = GameData.zombie_config.wave_space_between_time + 0.2
  GameData.zombie_config.wave_timer = GameData.zombie_config.wave_space_between_time
  WaveGame.delay(Zombie.make_wave, GameData.zombie_config.wave_space_between_time)

end


return ZombieWaveController