local dwelling3 = {
    identifier = "Dwelling-3",
    title = "Dwelling-3: Gravity",
    theme = THEME.DWELLING,
    width = 3,
    height = 7,
    file_name = "Dwelling-3.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

dwelling3.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity.flags = set_flag(entity.flags, 14)
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_SKULL)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.DECORATION_HANGING_HIDE)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible thorn vine
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_THORN_VINE)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ACTIVEFLOOR_FALLING_PLATFORM)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_PICKUP_SKELETON_KEY)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible wood floor
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_MINEWOOD)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible floor
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_GENERIC)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Allow Snake to stand on thorns
		entity:give_powerup(ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_SNAKE)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Remove bait from snap trap + interactable with semisolids
		entity.flags = set_flag(entity.flags, 14)
		local gold = get_entity(entity.bait_uid)
		gold:destroy()
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_SNAP_TRAP)

	local laser = {}
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		laser[#laser + 1] = entity
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_HORIZONTAL_FORCEFIELD)

	local frames = 0
	local laser_on = false
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()	
		if laser[1].timer > 0 and laser_on == false then
			laser_on = true
		end
		
		if laser_on == true then
			for i = 1,#laser do
				laser[i].timer = 2 -- Keep forcefield on
			end
		end
		frames = frames + 1
    end, ON.FRAME)
	
	toast(dwelling3.title)
end

dwelling3.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return dwelling3