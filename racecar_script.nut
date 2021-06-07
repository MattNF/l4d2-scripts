/* TODO
	Jumping/crouching then getting in lowers position
*/

class CarPassenger {
	constructor(entity){
		this.entity = entity
	}
	
	function SetCurrentView(currentView){
		this.currentView = currentView
	}
	
	function GetCurrentView(){
		return currentView
	}
	
	function SetCarSeat(carSeat){
		this.carSeat = carSeat
	}
	
	function GetCarSeat(){
		return carSeat
	}
	
	function GetEntity(){
		return entity
	}
	
	function SetCameraIndex(cameraIndex){
		this.cameraIndex = cameraIndex
	}
	
	function GetCameraIndex(){
		return cameraIndex
	}
	
	function SetLastTimeExited(lastTimeExited){
		this.lastTimeExited = lastTimeExited
	}
	
	function GetLastTimeExited(){
		return lastTimeExited
	}
	
	cameraIndex = 0
	carSeat = null
	currentView = 1		// 1 = first person, 2 = third person, 3 = far third person
	lastTimeExited = -9999
	entity = null
}

class CarSeat {
	constructor(id, positionParent = null, isOccupied = false){
		this.id = id
		this.positionParent = positionParent
		this.isOccupied = isOccupied
	}
	
	function SetOccupied(bool){
		isOccupied = bool
	}
	
	function IsOccupied(){
		return isOccupied
	}
	
	function SetPassenger(passenger){
		this.passenger = passenger
	}
	
	function GetPassenger(){
		return passenger
	}
	
	function GetPositionParent(){
		return positionParent
	}
	
	function GetId(){
		return id
	}
	
	id = null
	isOccupied = false
	passenger = null
	positionParent = null
}


// Misc functions
function SetPlayerAngles(player, angles){
	local prevPlayerName = player.GetName()
	local playerName = UniqueString()
	NetProps.SetPropString(player, "m_iName", playerName)
	local teleportEntity = SpawnEntityFromTable("point_teleport", {origin = player.GetOrigin(), angles = angles.ToKVString(), target = playerName, targetname = UniqueString()})
	DoEntFire("!self", "Teleport", "", 0, null, teleportEntity)
	DoEntFire("!self", "Kill", "", 0, null, teleportEntity)
	DoEntFire("!self", "AddOutput", "targetname " + prevPlayerName, 0.01, null, player)
}

function FindAngleBetweenPoints(pos1, pos2){
	local yaw = atan2(pos1.y - pos2.y, pos1.x - pos2.x) * (180/PI) + 180
	local pitch = atan2(pos1.z - pos2.z, sqrt(pow(pos1.x - pos2.x, 2) + pow(pos1.y - pos2.y, 2))) * (180/PI)
	
	return QAngle(pitch, yaw, 0)
}

function GetPlayerHeight(ent){
	return ent.EyePosition().z - ent.GetOrigin().z
}
//---------------------


HookController <- {}
IncludeScript("HookController", HookController)

HookController.RegisterHooks(this)

RACECAR_DEBUG <- false

local passengers = []
local seats = [CarSeat("driver", Ent("driver_pos")), CarSeat("passenger_2", Ent("passenger_2_pos")), CarSeat("passenger_3", Ent("passenger_3_pos")), CarSeat("passenger_4", Ent("passenger_4_pos"))]

printl("racecar_script")



function FindSeat(name){
	foreach(seat in seats){
		if(seat.GetId() == name){
			return seat
		}
	}
}

function FindCarPassenger(ent){
	foreach(passenger in passengers){
		if(passenger.GetEntity() == ent){
			return passenger
		}
	}
}

function HandleCameraRotation(passenger){
	if(passenger.GetCarSeat() == null || passenger.GetCurrentView() == 1){
		return
	}
	
	local camera = null
	local cameraOffset = null
	local cameraX = null
	if(passenger.GetCurrentView() == 2){
		camera = Ent("camera" + passenger.GetCameraIndex() + "_third")
		cameraOffset = 200
		cameraX = 15
	} else if(passenger.GetCurrentView() == 3) {
		camera = Ent("camera" + passenger.GetCameraIndex() + "_far")
		cameraX = 25
		cameraOffset = 400
	}
	local cameraAngle = QAngle(cameraX - Ent("vehicle_base").GetAngles().x, passenger.GetEntity().EyeAngles().y - Ent("vehicle_base").GetAngles().y, Ent("vehicle_base").GetAngles().z)//Ent("infected_target").GetAngles().z)
	if(fabs(passenger.GetEntity().EyeAngles().x) > 75){
		DoEntFire("!self", "ClearParent", "", 0, null, passenger.GetEntity())
		SetPlayerAngles(passenger.GetEntity(), QAngle(cameraAngle.x, cameraAngle.y - 90, cameraAngle.z))
		//SetPlayerAngles(passenger.GetEntity(), camera.GetAngles() + QAngle(0, 180, 0))
		DoEntFire("!self", "SetParent", passenger.GetCarSeat().GetPositionParent().GetName(), 0, null, passenger.GetEntity())
	}
	camera.SetAngles(cameraAngle + QAngle(0, Ent("vehicle_base").GetAngles().y, -Ent("vehicle_base").GetAngles().z))//Ent("infected_target").GetAngles().z))
	camera.SetOrigin(cameraAngle.Forward()*-cameraOffset + Vector(0,0,48))
}

function HandleBotEntering(ent){
	local bot = null
	while(bot = Entities.FindByClassname(bot, "player")){
		if(bot.IsSurvivor() && IsPlayerABot(bot)){
			bot.ValidateScriptScope()
			if("going_to_seat" in bot.GetScriptScope() && bot.GetScriptScope()["going_to_seat"]){
				if((bot.GetOrigin() - Ent("vehicle_base").GetOrigin()).Length() > 500 || bot.GetScriptScope()["target_ent"] == null){
					CommandABot({cmd = g_ModeScript.BOT_CMD_RESET, bot = bot})
					bot.GetScriptScope()["going_to_seat"] <- false
					continue
				}
				//printl(bot.GetScriptScope()["target_ent"])
				if((bot.GetScriptScope()["target_ent"].GetOrigin() - bot.GetOrigin()).Length() < 16){
					local id = bot.GetScriptScope()["target_seat"].GetId()
					CommandABot({cmd = g_ModeScript.BOT_CMD_RESET, bot = bot})
					bot.GetScriptScope()["going_to_seat"] <- false
					if(!FindSeat("driver").IsOccupied){
						return
					}
					EnterPassengerSeat(bot, id.slice(id.find("_") + 1).tointeger())
				} else {
					if(Time() - bot.GetScriptScope()["last_retarget"] > 0.25){
						bot.GetScriptScope()["last_retarget"] <- Time()
						CommandABot({cmd = g_ModeScript.BOT_CMD_MOVE, pos = bot.GetScriptScope()["target_ent"].GetOrigin(), bot = bot})
					}
				}
			}
		}
	}
}

function DisableCameras(index){
	DoEntFire("!self", "Disable", "", 0, null, Ent("camera" + index + "_third"))
	DoEntFire("!self", "Disable", "", 0, null, Ent("camera" + index + "_far"))
}

function LeaveSeat(ent, seat){
	local passenger = FindCarPassenger(ent)
	
	passenger.SetLastTimeExited(Time())
	
	DisableCameras(passenger.GetCameraIndex())
	
	EntFire(seat.GetId() + "_button", "Unlock")
	
	NetProps.SetPropInt(ent, "m_fFlags", NetProps.GetPropInt(ent, "m_fFlags") & ~64)
	NetProps.SetPropInt(ent, "movetype", 2)
	DoEntFire("!self", "ClearParent", "", 0, null, ent)
	SetPlayerAngles(ent, QAngle(Ent(seat.GetId() + "_leave").GetAngles().x, Ent(seat.GetId() + "_leave").GetAngles().y, 0))
	HookController.ScheduleTask(function(){ent.SetOrigin(Ent(seat.GetId() + "_leave").GetOrigin())}, {seat = seat, ent = ent}, 0.033)
	NetProps.SetPropInt(ent, "m_fFlags", NetProps.GetPropInt(ent, "m_fFlags") | 1 | (1 << 14))
	
	HookController.ScheduleTask(function(){NetProps.SetPropInt(ent, "m_fFlags", NetProps.GetPropInt(ent, "m_fFlags") & ~(1 << 14))}, {ent = ent}, 0.033)
	
	passenger.SetCarSeat(null)
	passenger.SetCameraIndex(0)
	passenger.SetCurrentView(1)
	seat.SetOccupied(false)
	seat.SetPassenger(null)
}


function OnTick(){
	local ent = null
	while(ent = Entities.FindByClassname(ent, "player")){ // Adds new players
		if(!ent.IsSurvivor()){
			continue
		}
		local passenger = FindCarPassenger(ent)
		if(passenger == null){
			passengers.append(CarPassenger(ent))
		} else { // Handles current players
			HandleCameraRotation(passenger)
			HandleBotEntering(ent)
			//NetProps.SetPropInt(ent, "m_nSequence", 46)
		}
	}
	for(local i=0; i < passengers.len(); i++){ // Removes invalid players
		if(passengers[i] == null || passengers[i].GetEntity() == null || !passengers[i].GetEntity().IsValid()){
			passengers.remove(i)
			i--
		}
	}
	
	// move players opposite direction of tilt
	//DebugDrawLine(Ent("driver_pos").GetOrigin(), Ent("driver_pos").GetOrigin() + Ent("vehicle_base").GetAngles().Up()*200, 255, 0, 0, true, 0.067)
	//DebugDrawBox((Ent("driver_pos").GetOrigin() + Ent("driver_pos").GetAngles().Up() * 66) - Vector(0, 0, 62), Vector(-4, -4, -4), Vector(4, 4, 4), 0, 0, 255, 255, 0.067)
	foreach(passenger in passengers){
		if(passenger.GetCarSeat() != null){
			NetProps.SetPropInt(passenger.GetEntity(), "m_fFlags", NetProps.GetPropInt(passenger.GetEntity(), "m_fFlags") & ~1)
			//SetPlayerAngles(passenger.GetEntity(), QAngle(passenger.GetEntity().EyeAngles().x, passenger.GetEntity().EyeAngles().y, Ent("vehicle_base").GetAngles().z))
			//passenger.GetEntity().SetOrigin(Vector(0,0,0))
			passenger.GetEntity().SetVelocity(Vector(0,0,1))
			passenger.GetEntity().SetOrigin((((passenger.GetCarSeat().GetPositionParent().GetAngles() + QAngle(0, 0, 0)).Up()) * 62) - Vector(0, 0, GetPlayerHeight(passenger.GetEntity())))
			//printl(FindAngleBetweenPoints(passenger.GetEntity().GetOrigin(), ((passenger.GetCarSeat().GetPositionParent().GetAngles().Up() * 66) - Vector(0, 0, 62) + passenger.GetCarSeat().GetPositionParent().GetOrigin())))
			if(RACECAR_DEBUG){
				DebugDrawLine(passenger.GetCarSeat().GetPositionParent().GetOrigin(), passenger.GetCarSeat().GetPositionParent().GetOrigin() + passenger.GetCarSeat().GetPositionParent().GetAngles().Up()*100, 255, 0, 0, true, 0.067)
				DebugDrawLine(passenger.GetCarSeat().GetPositionParent().GetOrigin() + (((passenger.GetCarSeat().GetPositionParent().GetAngles() + QAngle(0, 0, 0)).Up()) * 62), passenger.GetCarSeat().GetPositionParent().GetOrigin() + (((passenger.GetCarSeat().GetPositionParent().GetAngles() + QAngle(0, 0, 0)).Up()) * 62) - Vector(0, 0, GetPlayerHeight(passenger.GetEntity())), 0, 255, 0, true, 0.067)
				DebugDrawLine(passenger.GetCarSeat().GetPositionParent().GetOrigin() + (((passenger.GetCarSeat().GetPositionParent().GetAngles() + QAngle(0, 0, 0)).Up()) * 62), passenger.GetEntity().GetOrigin(), 0, 0, 255, true, 0.067)
				DebugDrawBox((passenger.GetCarSeat().GetPositionParent().GetOrigin() + passenger.GetCarSeat().GetPositionParent().GetAngles().Up() * GetPlayerHeight(passenger.GetEntity())) - Vector(0, 0, GetPlayerHeight(passenger.GetEntity())), Vector(-4, -4, -4), Vector(4, 4, 4), 0, 0, 255, 255, 0.067)
				DebugDrawBox((passenger.GetCarSeat().GetPositionParent().GetOrigin() + passenger.GetCarSeat().GetPositionParent().GetAngles().Up() * GetPlayerHeight(passenger.GetEntity())), Vector(-4, -4, -4), Vector(4, 4, 4), 0, 255, 0, 255, 0.067)
				DebugDrawBox(passenger.GetEntity().GetOrigin(), Vector(-4, -4, -4), Vector(4, 4, 4), 0, 255, 255, 255, 0.067)
			}
			//printl((passenger.GetCarSeat().GetPositionParent().GetAngles().Up() * 66) - Vector(0, 0, 62) + (passenger.GetEntity().GetOrigin() - passenger.GetCarSeat().GetPositionParent().GetOrigin()))
			//printl((passenger.GetCarSeat().GetPositionParent().GetOrigin() + passenger.GetCarSeat().GetPositionParent().GetAngles().Up() * 62) - Vector(0, 0, 62))
		}
	}
}

function OnKeyPressStart_Jump(player, weapon){
	local passenger = FindCarPassenger(player)
	if(passenger.GetCarSeat() == null){
		return
	}
	
	if(passenger.GetCurrentView() == 3){
		passenger.SetCurrentView(1)
	} else {
		passenger.SetCurrentView(passenger.GetCurrentView() + 1)
	}
	
	if(passenger.GetCurrentView() == 1){
		DoEntFire("!self", "Disable", "", 0, player, Ent("camera" + passenger.GetCameraIndex() + "_third"))
		DoEntFire("!self", "Disable", "", 0, player, Ent("camera" + passenger.GetCameraIndex() + "_far"))
	} else if(passenger.GetCurrentView() == 2){
		DoEntFire("!self", "Enable", "", 0, player, Ent("camera" + passenger.GetCameraIndex() + "_third"))
	} else if(passenger.GetCurrentView() == 3){
		DoEntFire("!self", "Enable", "", 0, player, Ent("camera" + passenger.GetCameraIndex() + "_far"))
	}
}

function OnKeyPressStart_Use(player, weapon){
	local passenger = FindCarPassenger(player)
	local seat = passenger.GetCarSeat()
	if(seat == null){
		return
	}
	
	if(seat.GetId() == "driver"){
		ExitDriverSeat(player)
	} else {
		ExitPassengerSeat(player, seat)
	}
}

g_ModeScript.AllowTakeDamage <- function(table){
	printl(table.Attacker)
	printl(table.DamageType)
	return true
}


function EnterDriverSeat(ent){
	local passenger = FindCarPassenger(ent)
	local seat = FindSeat("driver")
	if(seat.IsOccupied() || passenger.GetCarSeat() != null || (Time() - passenger.GetLastTimeExited()) < 0.067){
		return
	}

	EntFire(seat.GetId() + "_button", "Lock")
	
	EntFire("back_wheels_hinge", "SetAngularVelocity", "0")
	EntFire("trigger_hurt", "Enable")
	EntFire("racecar_sound_start", "PlaySound")
	EntFire("vehicle_gameui", "Activate", null, 0, ent)
	EntFire("vehicle_base", "Wake")
	EntFire("vehicle_base", "SetMass", "10")
	EntFire("infected_target", "Enable")
	
	passenger.SetCarSeat(seat)
	passenger.SetCameraIndex(1)
	passenger.SetCurrentView(1)
	seat.SetOccupied(true)
	seat.SetPassenger(passenger)
	
	local availableSeats = []
	foreach(botSeat in seats){
		if(!botSeat.IsOccupied()){
			availableSeats.append(botSeat)
		}
	}
	
	local bot = null
	while(bot = Entities.FindByClassname(bot, "player")){
		if(bot.IsSurvivor() && IsPlayerABot(bot)){
			for(local i=0; i < availableSeats.len(); i++){
				bot.ValidateScriptScope()
				bot.GetScriptScope()["going_to_seat"] <- true
				bot.GetScriptScope()["target_seat"] <- availableSeats[i]
				bot.GetScriptScope()["target_ent"] <- Ent(availableSeats[i].GetId() + "_enter_pos")
				bot.GetScriptScope()["last_retarget"] <- Time()
				CommandABot({cmd = g_ModeScript.BOT_CMD_MOVE, pos = bot.GetScriptScope()["target_ent"].GetOrigin(), bot = bot})
				availableSeats.remove(i)
				i--
				break
			}
		}
	}
	
	NetProps.SetPropInt(ent, "m_fFlags", NetProps.GetPropInt(ent, "m_fFlags") | 64 | (1 << 14))
	NetProps.SetPropInt(ent, "movetype", 8)
	NetProps.SetPropFloat(ent, "m_Local.m_flFallVelocity", 0)
	ent.SetOrigin(seat.GetPositionParent().GetOrigin() + Vector(0, 0, 62 - GetPlayerHeight(ent)))
	NetProps.SetPropInt(ent, "m_fFlags", NetProps.GetPropInt(ent, "m_fFlags") & ~1)
	DoEntFire("!self", "SetParent", seat.GetPositionParent().GetName(), 0, null, ent)
}

function ExitDriverSeat(ent){
	local passenger = FindCarPassenger(ent)
	local seat = FindSeat("driver")
	if(!seat.IsOccupied()){
		return
	}
	
	EntFire("thruster_left", "Deactivate")
	EntFire("thruster_right", "Deactivate")
	EntFire("thruster_forward", "Deactivate")
	EntFire("thruster_backward", "Deactivate")
	EntFire("vehicle_gameui", "Deactivate")
	EntFire("racecar_sound_*", "Volume", "0")
	EntFire("infected_target", "Disable")
	
	foreach(botSeat in seats){
		if(botSeat.IsOccupied() && IsPlayerABot(botSeat.GetPassenger().GetEntity())){
			ExitPassengerSeat(botSeat.GetPassenger().GetEntity(), botSeat)
		}
	}
	
	LeaveSeat(ent, seat)
}

function EnterPassengerSeat(ent, num){
	local passenger = FindCarPassenger(ent)
	local seat = FindSeat("passenger_" + num)
	if(seat.IsOccupied() || passenger.GetCarSeat() != null || (Time() - passenger.GetLastTimeExited()) < 0.067){
		return
	}

	EntFire(seat.GetId() + "_button", "Lock")
	
	passenger.SetCarSeat(seat)
	passenger.SetCameraIndex(num)
	passenger.SetCurrentView(1)
	seat.SetOccupied(true)
	seat.SetPassenger(passenger)
	
	NetProps.SetPropInt(ent, "m_fFlags", NetProps.GetPropInt(ent, "m_fFlags") | 64 | (1 << 14))
	NetProps.SetPropInt(ent, "movetype", 8)
	NetProps.SetPropFloat(ent, "m_Local.m_flFallVelocity", 0)
	ent.SetOrigin(seat.GetPositionParent().GetOrigin() + Vector(0, 0, 62 - GetPlayerHeight(ent)))
	NetProps.SetPropInt(ent, "m_fFlags", NetProps.GetPropInt(ent, "m_fFlags") & ~1)
	DoEntFire("!self", "SetParent", seat.GetPositionParent().GetName(), 0, null, ent)
}

function ExitPassengerSeat(ent, seat){
	local passenger = FindCarPassenger(ent)
	if(!seat.IsOccupied()){
		return
	}

	LeaveSeat(ent, seat)
}