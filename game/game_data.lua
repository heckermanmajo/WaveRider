--[[
  All important config and the global state.
]]
return {
  current_game_view = {},
  non_interaction_objects = {},
  first_aid = {},
  zombies = {},
  bullets = {},
  ammo = {},
  towers = {},
  moneys = {},
  trooper = {},
  aircraft = {},
  ui = {
    canvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight())
  },
  interna = {
    -- buffer_canvas = love.graphics.newCanvas(love.graphics.getWidth()+20, love.graphics.getHeight())
    -- here put the update counter, so we can execute some functions
    -- only 2 times per second or so
  },
  settings = {
    -- fixme: why + 20px??
    screen_w = love.graphics.getWidth() + 20,
    screen_h = love.graphics.getHeight(),
    world_w = 3200,
    world_h = 3200,
    screen_x_view_factor = 0,
    screen_y_view_factor = 0
  },
  zombie_config = {
    start_wave_amount = 20,
    wave_timer = 0,
    wave_space_between_time = 5,
    wave_counter = 0
  },
  sounds = {
    weapon = {
      pistol = "sound/shot.wav",
      explosion = "sound/explosion.ogg",
      reload_shotgun = "sound/reload_shotgun.wav",
      reload_pistol = "sound/reload_pistol.wav",
      empty = "sound/empty.wav",

    },
    player = {
      pickup_ammo = "sound/reload.wav",
      pickup_healing = "sound/heal.wav",
      pickup_money = "sound/coin.wav",
      hurt = "sound/hurt.wav"
    },
    zombie = {
      impact = "sound/impact_zombie.wav",
      aggro = "sound/growl.wav"
    },
  },
  cursor = {
    cursor_target = love.mouse.newCursor("images/cursor_target.png", 16, 16),
    cursor_arrow = love.mouse.newCursor("images/cursor_arrow.png", 0, 0)
  },
  textures = {
    menu = {
      start = "images/menu/start.png",
      controls = "images/menu/controls.png",
      continue = "images/menu/continue.png",
      exit = "images/menu/exit.png",
      load = "images/menu/load.png",
      map = "images/map.png",
      ork ="images/campaign/ork.png"
    },
    tiles = {
      gras = "images/gras.png"
    },
    building_textures = {
      wall = "images/wall.png",
      stairs = "images/stairs.png",
      big_wall = "images/big_wall.png"
    },
    zombie_textures = {
      basic = "images/zombie.png",
      dead = "images/zombie_dead.png",
      zombie_blood = "images/zombie_blood.png",
      dark_zombie = "images/dark_zombie.png",
      dark_zombie_dead = "images/dark_zombie_dead.png",
      big_zombie = "images/big_zombie.png",
      big_zombie_dead = "images/big_zombie_dead.png",
      read_zombie = "images/red_zombie.png",
      read_zombie_dead = "images/red_zombie_dead.png"
    },
    player_textures = {
      basic = "images/naked.png",
      hands = "images/hands.png",
      gun = "images/gun.png",
      rifle = "images/player_rifle.png",
      shotgun = "images/player_shotgun.png",
      rgp = "images/player_rpg.png",
      computer = "images/player_computer.png",
    },
    projectile_textures = {
      bullet = "images/shot.png",
      fire = "images/fire.png",
      smoke = "images/smoke.png",
      granate = "images/granate.png"
    },
    object_textures = {
      ammo = "images/ammo.png",
      first_aid = "images/first_aid.png",
      granates_box = "images/granates_box.png",
      tank = "images/tank.png",
      money = "images/money.png",
      shotgun_ammo = "images/shotgun_ammo.png",
      gas = "images/gas.png"
    },
    trooper = {
      trooper = "images/trooper.png",
      dead = "images/trooper_dead.png",
      shotgun_trooper = "images/shotgun_trooper.png",
      rpg_trooper = "images/rpg_trooper.png"
    },

    campaign_tiles = {
      test_tile = "images/campaign/test_tile_state.png",
      gras_tile = "images/campaign/gras_tile.png",
      ice_tile = "images/campaign/ice_tile.png",
      sand_tile = "images/campaign/sand_tile.png",
      step_tile = "images/campaign/step_tile.png",
      stone_tile = "images/campaign/stone_tile.png",
      water_tile = "images/campaign/water.png",
      forest_tile ="images/campaign/forest.png",
      mountain_tile = "images/campaign/mountain.png"
    },
  },
  -- all classes so we can access them from within via the data
  player = Player,
  zombie = Zombie,
  bullet = Bullet,
  first_aid = FirstAid,
  non_interaction_objects = NonInteractionObject,
  game_mode = "wave", --- surrival
  pause = false,
  ui_mode = "hud",

  campaign_data = {
    campaign_world_x = 12800,
    campaign_world_y = 12800,
    screen_x_view_factor = 0,
    screen_y_view_factor = 0,
    tile_view_mode = "normal",   --- owner_relation, details
    selected_tile = nil,
    round = 0,
    path_to_current_game_files = ""  -- what game is currently loaded
  },

  game_view_mode = "main_menu",

}