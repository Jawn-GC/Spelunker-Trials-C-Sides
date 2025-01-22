local sound = require('play_sound')

local tidepool3 = {
    identifier = "Tidepool-3",
    title = "Tidepool-3: Boss Fight",
    theme = THEME.TIDE_POOL,
    width = 3,
    height = 3,
    file_name = "Tidepool-3.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

tidepool3.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_PICKUP_SKELETON_KEY)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible thorn vine
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_THORN_VINE)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_PAGODA)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible floor
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_GENERIC)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.x = entity.x + 0.5
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_EXCALIBUR)

	local cape_x
	local cape_y
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		cape_x = entity.x
		cape_y = entity.y
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_VLADS_CAPE)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        -- Remove Hermitcrabs
        local x, y, layer = get_position(entity.uid)
        local floor = get_entities_at(0, MASK.ANY, x, y, layer, 1)
        if #floor > 0 then
            entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
            entity:destroy()
        end
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_HERMITCRAB)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity)
		entity:destroy()
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_SCARAB)
	
	local kingu
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity)
		kingu = entity
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_KINGU)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity)
		entity:destroy()
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FX_KINGU_PLATFORM)

	local frames = 0
	local key_spawned = false
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
		if frames == 0 then
			players[1].flags = clr_flag(players[1].flags, 14) 
		end
		
		kingu.monster_spawn_timer = 3 --Prevent Kingu from spawning enemies
		
		--Makes Kingu climb faster
		if kingu.climb_pause_timer > 90 then
			kingu.climb_pause_timer = 90
		end
		
		--Spawn key after Kingu is killed
		if test_flag(kingu.flags, 29) and key_spawned == false then
			spawn(ENT_TYPE.ITEM_KEY, cape_x, cape_y, 0, 0, 0)
			sound.play_sound(VANILLA_SOUND.UI_SECRET)
			key_spawned = true
		end
		
		frames = frames + 1
    end, ON.FRAME)

	toast(tidepool3.title)
end

tidepool3.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return tidepool3
