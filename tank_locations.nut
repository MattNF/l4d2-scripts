local enabled = false
local saveTable = {
	tankLocation = -1
	witchLocation = -1
}

function SayInvalidRange(max){
	Say(null, "Please enter a number between 1-" + max, false)
}

function CountTankSpawns(){
	local spot = 1
	while(Entities.FindByName(null, "tankspawn" + spot)){
		spot++
	}
	return spot - 1
}

function CountWitchSpawns(){
	local spot = 1
	while(Entities.FindByName(null, "witchspawn" + spot)){
		spot++
	}
	return spot - 1
}

function ChooseRandomBossLocations(){
	RestoreTable("bossLocations", saveTable)
	ChooseRandomTankLocation()
	ChooseRandomWitchLocation()
}

function ChooseRandomWitchLocation(){
	if(NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_bInSecondHalfOfRound")){
		SetWitchLocation(saveTable["witchLocation"])
	} else {
		SetWitchLocation(RandomInt(1, CountWitchSpawns()))
	}
}

function ChooseRandomTankLocation(){
	if(NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_bInSecondHalfOfRound")){
		SetTankLocation(saveTable["tankLocation"])
	} else {
		SetTankLocation(RandomInt(1, CountTankSpawns()))
	}
}

function DisableOtherTankLocations(spot){
	for(local i=1; i <= CountTankSpawns(); i++){
		if(i != spot){
			DisableTankLocation(i)
		}
	}
}

function EnableWitchLocation(spot){
	EntFire("witch_script", "RunScriptCode", "SayWitchSpot(" + spot + ")")
	local witch = Entities.FindByClassname(null, "witch")
	if(witch){
		witch.Kill()
	}
	ZSpawn({type = 7, pos = Entities.FindByName(null, "witchspawn" + spot).GetOrigin()})
	//EntFire("witchspawn" + spot, "SpawnZombie")
}

function EnableTankLocation(spot){
	EntFire("tankbrush" + spot, "Enable")
	EntFire("tanktrigger" + spot, "Enable")
	EntFire("tank_script", "RunScriptCode", "SayTankSpot(" + spot + ")")
	local location = Entities.FindByName(null, "tankspawn" + spot).GetOrigin()
	local direction = Entities.FindByName(null, "tankspawn" + spot).GetAngles()
	local entTable = {
		disableshadows = 1
		targetname = "tankglow" + spot
		angles = direction.x + " " + direction.y + " " + direction.z
		origin = location.x + " " + location.y + " " + location.z
		solid = 0
		model = "models/darkcarnremix/zombies/hulk.mdl"
		defaultanim = "idle"
	}
	SpawnEntityFromTable("prop_dynamic", entTable)
	DisableOtherTankLocations(spot)
	EntFire("tankglow" + spot, "StartGlowing")
}

function DisableTankLocation(spot){
	EntFire("tankbrush" + spot, "Disable")
	EntFire("tanktrigger" + spot, "Disable")
	EntFire("tankglow" + spot, "Kill")
}

function KillTankGlows(){
	for(local i=1; i <= CountTankSpawns(); i++){
		EntFire("tankglow" + i, "Kill")
	}
}

function SetWitchLocation(spot){
	if(CountWitchSpawns() == 0){
		Say(null, "No Witch spawns on this map.", false)
		return
	}
	try {
		spot.tointeger()
	} catch(e){
		SayInvalidRange(CountWitchSpawns())
		return
	}
	spot = spot.tointeger()
	if(spot < 1 || spot > CountWitchSpawns()){
		SayInvalidRange(CountWitchSpawns())
		return
	}
	EnableWitchLocation(spot)
	saveTable["witchLocation"] = spot
	SaveTable("bossLocations", saveTable)
}

function SetTankLocation(spot){
	if(CountTankSpawns() == 0){
		Say(null, "No Tank spawns on this map.", false)
		return
	}
	try {
		spot.tointeger()
	} catch(e){
		SayInvalidRange(CountTankSpawns())
		return
	}
	spot = spot.tointeger()
	if(spot < 1 || spot > CountTankSpawns()){
		SayInvalidRange(CountTankSpawns())
		return
	}
	EnableTankLocation(spot)
	saveTable["tankLocation"] = spot
	SaveTable("bossLocations", saveTable)
}

function Enable(){
	enabled = true
}

function Disable(){
	enabled = false
}

local function GetInputCommand(msg, command){
	local message = ""
	local found_start = false
	local found_end = false
	local index = 0
	foreach(char in msg){
		if(char != 32 && char != 10){
			found_start = true
			message += char.tochar().tolower()
		} else if(char == 32){
			found_end = true
			if(message != command || index == msg.len() - 1){
				return false
			}
			return msg.slice(index + 1, msg.len())
		}
		index += 1
	}
	return false
}

function OnGameEvent_player_say(params){
	local userid = params.userid
	local text = params.text
	local player = GetPlayerFromUserID(userid)

	local input = GetInputCommand(text, "tankspawn")
	if(input){
		if(enabled){
			SetTankLocation(input)
		} else {
			Say(null, "Tank and Witch spawn selection disabled due to Survivors leaving saferoom.", false)
		}
	}
	input = GetInputCommand(text, "witchspawn")
	if(input){
		if(enabled){
			SetWitchLocation(input)
		} else {
			Say(null, "Tank and Witch spawn selection disabled due to Survivors leaving saferoom.", false)
		}
	}
}

function OnGameEvent_player_left_start_area(params){
	KillTankGlows()
	Disable()
}

__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)