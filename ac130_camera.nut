HookController <- {}
IncludeScript("HookController", HookController)
HookController.RegisterHooks(this)

getroottable()["button_name"] <- "airsupport_trigger"

local explosionEntity = SpawnEntityFromTable("env_explosion", {
	iRadiusOverride = 200
	fireballsprite = "sprites/zerogxplode.spr"
	ignoredClass = 0
	iMagnitude = 150
	rendermode = 5
	spawnflags = 2 | 64 // Repeatable | No Sound
})

local explosionParticle = SpawnEntityFromTable("info_particle_system", {
	effect_name = "explosion_huge"
	start_active = 0
	render_in_front = 0
	targetname = "cannon_explosion_particle2"
})

local explosionEntity2 = SpawnEntityFromTable("env_explosion", {
	iRadiusOverride = 100
	fireballsprite = "sprites/zerogxplode.spr"
	ignoredClass = 0
	iMagnitude = 35
	rendermode = 5
	spawnflags = 2 | 64 // Repeatable | No Sound
})

local user = null
local useTime = 0

function OnTick(){
	if(user != null){
		if(Time() > useTime + 10 && user.GetButtonMask() & HookController.Keys.USE){
			DoEntFire("disable_gunship", "Trigger", "", 0, user, user)
			DoEntFire("airsupport_trigger2", "Unlock", "", 0, user, user)
			user = null
			return
		}
		Ent("camera_3").SetAngles(user.EyeAngles())
	}
}

function UseAC130(ent){
	user = ent
	useTime = Time()
}

function FireAC130(){
	local traceTable = {
		start = Ent("camera_3").GetOrigin()
		end = Ent("camera_3").GetAngles().Forward() * 99999
		ignore = Ent("camera_3")
	}
	TraceLine(traceTable)
	if(traceTable["hit"]){
		explosionEntity.SetOrigin(traceTable.pos)
		explosionParticle.SetOrigin(traceTable.pos)
	}
}

function FireAC1302(){
	local traceTable = {
		start = Ent("camera_3").GetOrigin()
		end = Ent("camera_3").GetAngles().Forward() * 99999
		ignore = Ent("camera_3")
	}
	TraceLine(traceTable)
	if(traceTable["hit"]){
		explosionEntity.SetOrigin(traceTable.pos)
	}
}

function ExplodeTarget(){
	DoEntFire("!self", "Explode", "", 0, user, explosionEntity)
	DoEntFire("!self", "Start", "", 0, user, explosionParticle)
	DoEntFire("!self", "Stop", "", 1, user, explosionParticle)
}

function ExplodeTarget2(){
	DoEntFire("!self", "Explode", "", 0, user, explosionEntity)
}