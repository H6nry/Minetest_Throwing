-- Bow and arrow mod
-- Topic on the forum: http://c55.me/minetest/forum/viewtopic.php?id=687
-- Changed by Henry

ARROW_DAMAGE=1
ARROW_GRAVITY=0 --Original Gravity: 9
ARROW_VELOCITY=19

throwing_shoot_arrow=function (item, player, pointed_thing)
	-- Check if arrows in Inventory and remove one of them
	local i=1
	----Henrys Mod START
	if player:get_inventory():contains_item("main", "throwing:arrow") then
		player:get_inventory():remove_item("main", "throwing:arrow")
		-- Shoot Arrow
		local playerpos=player:getpos()
		local obj=minetest.env:add_entity({x=playerpos.x,y=playerpos.y+1.5,z=playerpos.z}, "throwing:arrow_entity")
		local dir=player:get_look_dir()
		obj:setvelocity({x=dir.x*ARROW_VELOCITY, y=dir.y*ARROW_VELOCITY, z=dir.z*ARROW_VELOCITY})
		obj:setacceleration({x=dir.x*-3, y=-ARROW_GRAVITY, z=dir.z*-3})
		kind=1
	end
	
	if player:get_inventory():contains_item("main", "throwing:arrow_tnt") then
		player:get_inventory():remove_item("main", "throwing:arrow_tnt")
		-- Shoot Arrow
		local playerpos=player:getpos()
		local obj=minetest.env:add_entity({x=playerpos.x,y=playerpos.y+1.5,z=playerpos.z}, "throwing:arrow_entity")
		local dir=player:get_look_dir()
		obj:setvelocity({x=dir.x*ARROW_VELOCITY, y=dir.y*ARROW_VELOCITY, z=dir.z*ARROW_VELOCITY})
		obj:setacceleration({x=dir.x*-3, y=-ARROW_GRAVITY, z=dir.z*-3})
		kind=2
	end
	
	if player:get_inventory():contains_item("main", "throwing:arrow_fire") then
		player:get_inventory():remove_item("main", "throwing:arrow_fire")
		-- Shoot Arrow
		local playerpos=player:getpos()
		local obj=minetest.env:add_entity({x=playerpos.x,y=playerpos.y+1.5,z=playerpos.z}, "throwing:arrow_entity")
		local dir=player:get_look_dir()
		obj:setvelocity({x=dir.x*ARROW_VELOCITY, y=dir.y*ARROW_VELOCITY, z=dir.z*ARROW_VELOCITY})
		obj:setacceleration({x=dir.x*-3, y=-ARROW_GRAVITY, z=dir.z*-3})
		kind=3
	end
	
	if player:get_inventory():contains_item("main", "throwing:arrow_lava") then
		player:get_inventory():remove_item("main", "throwing:arrow_lava")
		-- Shoot Arrow
		local playerpos=player:getpos()
		local obj=minetest.env:add_entity({x=playerpos.x,y=playerpos.y+1.5,z=playerpos.z}, "throwing:arrow_entity")
		local dir=player:get_look_dir()
		obj:setvelocity({x=dir.x*ARROW_VELOCITY, y=dir.y*ARROW_VELOCITY, z=dir.z*ARROW_VELOCITY})
		obj:setacceleration({x=dir.x*-3, y=-ARROW_GRAVITY, z=dir.z*-3})
		kind=4
	end
	--Henrys Mod END
	return
end

throwing_shoot_arrow_continue=function(item, player, pointed_thing)

		return
end

minetest.register_craftitem("throwing:string", {
	inventory_image = "throwing_string.png",
	description = "String",
})

minetest.register_craftitem("throwing:bow", {
	inventory_image = "throwing_bow.png",
    stack_max = 1,
	on_use = throwing_shoot_arrow,
	description = "Bow",
})

minetest.register_craftitem("throwing:arrow", {
	inventory_image = "throwing_arrow.png",
	description = "Arrow",
})
--Henrys Mod START
minetest.register_craftitem("throwing:arrow_tnt",{
	inventory_image = "throwing_arrow_tnt.png",
	description = "TNT arrow",
})

minetest.register_craftitem("throwing:arrow_fire",{
	inventory_image = "throwing_arrow_fire.png",
	description = "Fire arrow",
})

minetest.register_craftitem("throwing:arrow_lava",{
	inventory_image = "throwing_arrow_lava.png",
	description = "Lava arrow",
})
--Henrys Mod END

-- The Arrow Entity

THROWING_ARROW_ENTITY={
	physical = false,
	timer=0,
	textures = {"throwing_arrow_back.png"},
	lastpos={},
	collisionbox = {0,0,0,0,0,0},
}


-- Arrow_entity.on_step()--> called when arrow is moving
THROWING_ARROW_ENTITY.on_step = function(self, dtime)
	self.timer=self.timer+dtime
	local pos = self.object:getpos()
	local node = minetest.env:get_node(pos)

	-- When arrow is away from player (after 0.2 seconds): Cause damage to mobs and players
	if self.timer>0.2 then
		local objs = minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y,z=pos.z}, 2)
		for k, obj in pairs(objs) do
			obj:set_hp(obj:get_hp()-ARROW_DAMAGE)
			if obj:get_entity_name() ~= "throwing:arrow_entity" then
				if obj:get_hp()<=0 then 
					obj:remove()
				end
				self.object:remove() 
			end
		end
	end

	-- Become item when hitting a node
	if self.lastpos.x~=nil then --If there is no lastpos for some reason
		if node.name ~= "air" then
			--Henrys Mod START
			if kind==1 then
			minetest.env:add_item(self.lastpos, 'throwing:arrow')
			end
			if kind==2 then
			minetest.env:add_node(self.lastpos,{name="nuke:iron_tnt"})
			minetest.env:punch_node(self.lastpos)
			end
			if kind==3 then
			minetest.env:add_node(self.lastpos,{name="fire:basic_flame"})
			end
			if kind==4 then
			minetest.env:add_node(self.lastpos,{name="default:lava_source"})
			end
			--Henrys Mod END
			self.object:remove()
		end
	end
	self.lastpos={x=pos.x, y=pos.y, z=pos.z} -- Set lastpos-->Item will be added at last pos outside the node
end

minetest.register_entity("throwing:arrow_entity", THROWING_ARROW_ENTITY)



--CRAFTS
minetest.register_craft({
	output = 'throwing:string',
	recipe = {
		{'default:junglegrass'},
		{'default:junglegrass'},
	}
})

minetest.register_craft({
	output = 'throwing:bow',
	recipe = {
		{'throwing:string', 'default:wood', ''},
		{'throwing:string', '', 'default:wood'},
		{'throwing:string', 'default:wood', ''},
	}
})

minetest.register_craft({
	output = 'throwing:arrow 16',
	recipe = {
		{'default:stick', 'default:stick', 'default:steel_ingot'},
	}
})
--Henrys Code START
minetest.register_craft({
	output = 'throwing:arrow_tnt 16',
	recipe = {
		{'default:stick', 'default:stick', 'nuke:iron_tnt'},
	}
})

minetest.register_craft({
	output = 'throwing:arrow_fire 16',
	recipe = {
		{'default:stick', 'default:stick', 'fire:basic_flame'},
	}
})

minetest.register_craft({
	output = 'throwing:arrow_lava 16',
	recipe = {
		{'default:stick', 'default:stick', 'default:lava_source'},
	}
})
--Henrys Code END
print ("[Throwing_mod] Loaded!")
