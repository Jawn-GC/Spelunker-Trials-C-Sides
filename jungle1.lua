local jungle1 = {
    identifier = "Jungle-1",
    title = "Jungle-1: Hat Trick",
    theme = THEME.JUNGLE,
    width = 4,
    height = 4,
    file_name = "Jungle-1.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

jungle1.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible thorn vine
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_THORN_VINE)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible Jungle Floor
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_MINEWOOD)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Allow Snake to stand on thorns
		entity:give_powerup(ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_SNAKE)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity:give_powerup(ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES)
		entity.flags = set_flag(entity.flags, 6)
		entity.flags = clr_flag(entity.flags, 12)
		entity.flags = clr_flag(entity.flags, ENT_FLAG.FACING_LEFT)
		entity.x = entity.x + 0.5
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_HORNEDLIZARD)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity:give_powerup(ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_SNAKE)

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = set_flag(entity.flags, 14)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_SKULL)

	--pushblock for removing skull
	local block
	local block_x
	local block_y
	define_tile_code("delete_skull")
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		block_x = x
		block_y = y
		block = get_entity(block_id)
	end, "delete_skull")

	--indicators for rope
	local unrolled_rope = {}
	define_tile_code("unrolled_rope")
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn_unrolled_player_rope(x, y, layer, 290, 0)
		unrolled_rope[#unrolled_rope + 1] = get_entity(block_id)
		unrolled_rope[#unrolled_rope].color:set_rgba(100, 100, 100, 215)
		unrolled_rope[#unrolled_rope].flags = clr_flag(unrolled_rope[#unrolled_rope].flags, 9)
	end, "unrolled_rope")

	local frames = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
		if frames == 0 then
			block:destroy()
			spawn(ENT_TYPE.ITEM_PICKUP_ROPEPILE, block_x, block_y, 0, 0, 0)
		end
        frames = frames + 1
    end, ON.FRAME)
	
	toast(jungle1.title)
end

jungle1.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return jungle1