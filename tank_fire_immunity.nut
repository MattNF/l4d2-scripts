local timer = SpawnEntityFromTable("logic_timer",{RefireTime = 0.01})
timer.ValidateScriptScope()
timer.GetScriptScope()["scope"] <- this
timer.GetScriptScope()["func"] <- function(){
	scope.TankFireImmunity_OnTick()
}
timer.ConnectOutput("OnTimer", "func")
EntFire("!self","Enable",null,0,timer)

local IMMUNITY_TIME = 10

local immunityStart = -1
local immunityStarted = false

function StartImmunity(){
	immunityStarted = true
	immunityStart = Time()
}

function StopImmunity(){
	immunityStarted = false
}

function TankFireImmunity_OnTick(){
	if(Time() > immunityStart + IMMUNITY_TIME){
		StopImmunity()
	}
	if(immunityStarted){
		local player = null
		while(player = Entities.FindByClassname(player, "player")){
			if(player.GetZombieType() == 8 && player.IsOnFire()){
				player.Extinguish()
			}
		}
	}
}