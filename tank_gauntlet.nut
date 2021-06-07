/*
	EnableSpawning - enable common and SI spawning
	DisableSpawning - disable common and SI spawning
	TeleportToArena - teleport to previously determined arena
*/

/*
	Save the current scores and the map name at the beginning of each map
	If it's the beginning of the first round, and the map name is the same, reset scores to saved scores
*/

HookController <- {}
IncludeScript("HookController", HookController)
HookController.RegisterOnTick(this)

IncludeScript("response_testbed")

HUD <- {
	Fields = {
		team1 = { slot = g_ModeScript.HUD_MID_TOP, dataval = "",flags = g_ModeScript.HUD_FLAG_ALIGN_CENTER | g_ModeScript.HUD_FLAG_NOBG, name = "team1" }
		team2 = { slot = g_ModeScript.HUD_MID_BOT, dataval = "",flags = g_ModeScript.HUD_FLAG_ALIGN_CENTER | g_ModeScript.HUD_FLAG_NOBG, name = "team2" }
		background = { slot = g_ModeScript.HUD_TICKER, dataval = "",flags = g_ModeScript.HUD_FLAG_ALIGN_CENTER, name = "background" }
	}
}

HUDSetLayout(HUD)

HUDPlace(g_ModeScript.HUD_TICKER, 0.4, 0, 0.2, 0.15)
HUDPlace(g_ModeScript.HUD_MID_BOT, 0.52, 0, 0.1, 0.15)
HUDPlace(g_ModeScript.HUD_MID_TOP, 0.405, 0, 0.1, 0.15)

const ARENAS_TO_PLAY = 3
const HP_REWARD = 15
const FADE_DELAY = 5.5
local ARENA_COUNT = -1

local currentArena = -1
local arenasCompleted = 0

local spawnEnabled = false
local showScores = true

local map = null

local arenaOrder = []
local savedOrder = {}
local score = {
	team1 = 0
	team2 = 0
}
local oldScore = {
	team1 = 0
	team2 = 0
	map = null
}


// PRIVATE FUNCTIONS

function GetQueryData(data){
	//printl("test1")
	if(typeof(data) == "instance"){
		DoEntFire("!self", "SpeakResponseConcept", "GetQueryData", 0, null, data)
		return
	}
	
	local query = {}
	foreach(var,val in data){
		//printl(var + " : " + val)
		query[var.tolower()] <- val
	}
	
	if(query.concept == "GetQueryData"){
		//printl(query.map)
		map = query.map
	}
}

local responseRules = [
{
	name = "QueryData",
	criteria =
	[
		[ "concept", "GetQueryData" ],
		[ GetQueryData ],
	],
	responses =
	[
		{
			scenename = "",
		}
	],
	group_params = RGroupParams({ permitrepeats = true, sequential = false, norepeat = false })
}
]

function HandleOldScore(){
	RestoreTable("OldScore", oldScore)
	SaveTable("OldScore", oldScore)
	//local orator = SpawnEntityFromTable("func_orator", {})
	//GetQueryData(orator)
	//orator.Kill()
	//GetQueryData(Entities.FindByClassname(null, "player"))
	if(!NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_bInSecondHalfOfRound")){
		//printl(oldScore.map)
		//printl(map)
		if(oldScore.map = map){
			score.team1 = oldScore.team1
			score.team2 = oldScore.team2
			SaveTable("Score", score)
			return
		}
		oldScore.team1 = score.team1
		oldScore.team2 = score.team2
		oldScore.map = map
		SaveTable("OldScore", oldScore)
	}
}

function ArrayToTable(value){
	local table = {}
	foreach(key, val in value){
		table[key.tostring()] <- val
	}
	
	return table
}

function TableToArray(table){
	local newArray = array(table.len())
	foreach(key, val in table){
		newArray[key.tointeger()] = val
	}
	
	return newArray
}

function ShuffleArray(value){
	for(local i=0; i < value.len(); i++){
		local index = RandomInt(0, value.len() - 1)
		local temp = value[index]
		value[index] = value[i]
		value[i] = temp
	}
	
	return value
}

function CountArenas(){
	if(ARENA_COUNT == -1){
		local count = 1
		while(Entities.FindByName(null, "arena" + count + "_dest")){
			count++
		}
		ARENA_COUNT = count - 1
		return ARENA_COUNT
	}
	return ARENA_COUNT
}

function PickNextArena(){
	currentArena = arenaOrder.pop()
	DisplayPreview()
}

function DetermineArenaOrder(){
	if(NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_bInSecondHalfOfRound")){
		RestoreTable("ArenaOrder", savedOrder)
		//g_ModeScript.DeepPrintTable(savedOrder)
		arenaOrder = TableToArray(savedOrder)
		printl("restoring order")
	} else {
		printl("determining order")
		if(CountArenas() < ARENAS_TO_PLAY){
			error("TANK GAUNTLET: NOT ENOUGH ARENAS\n")
		}
		
		arenaOrder = []
		for(local i=1; i <= CountArenas(); i++){
			arenaOrder.append(i)
		}
		arenaOrder = ShuffleArray(arenaOrder)
		arenaOrder = arenaOrder.slice(0, 3)
		
		savedOrder = ArrayToTable(arenaOrder)
	}
	SaveTable("ArenaOrder", savedOrder)
}

function KillInfected(){
	foreach(ent in HookController.EntitiesByClassname("infected")){
		ent.Kill()
	}
	foreach(player in HookController.PlayerGenerator()){
		if(NetProps.GetPropInt(player, "m_iTeamNum") == 3 && !player.IsDead()){
			player.TakeDamage(69420, 0, null)
		}
	}
}

function DisplayPreview(){
	for(local i=1; i <= CountArenas(); i++){
		local input = "Disable"
		if(i == currentArena){
			input = "Enable"
		}
		EntFire("arena" + i + "_preview", input)
	}
}

function TeleportToSaferoom(){
	foreach(player in HookController.PlayerGenerator()){
		player.SetOrigin(Entities.FindByName(null, "saferoom_teleport_dest").GetOrigin())
		HookController.SetPlayerAngles(player, Entities.FindByName(null, "saferoom_teleport_dest").GetAngles())
	}
	showScores = true
}

function ArenaCompleted(){
	foreach(player in HookController.PlayerGenerator()){
		if(player.IsSurvivor()){
			if(player.IsIncapacitated()){
				player.ReviveFromIncap()
			}
			player.SetHealth(player.GetHealth() + HP_REWARD > 100 ? 100 : player.GetHealth() + HP_REWARD)
		}
	}
	TeleportToSaferoom()
	Say(null, "Survivors have been granted " + HP_REWARD + " Permanent HP for completion.", false)
}

function IncreaseScore(){
	if(NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_bInSecondHalfOfRound")){
		score.team2++
	} else {
		score.team1++
	}
	SaveTable("Score", score)
}

function ShowScores(){
	HUD.Fields.team1.flags = HUD.Fields.team1.flags & ~g_ModeScript.HUD_FLAG_NOTVISIBLE
	HUD.Fields.team2.flags = HUD.Fields.team2.flags & ~g_ModeScript.HUD_FLAG_NOTVISIBLE
	HUD.Fields.background.flags = HUD.Fields.background.flags & ~g_ModeScript.HUD_FLAG_NOTVISIBLE
	
	if(NetProps.GetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_bInSecondHalfOfRound")){
		HUD.Fields.team1.dataval = "Team 1\nInfected\n\n     " + score.team1
		HUD.Fields.team2.dataval = "Team 2\nSurvivors\n\n     " + score.team2
	} else {
		HUD.Fields.team1.dataval = "Team 1\nSurvivors\n\n     " + score.team1
		HUD.Fields.team2.dataval = "Team 2\nInfected\n\n     " + score.team2
	}
	
	HUDSetLayout(HUD)
}

function HideScores(){
	HUD.Fields.team1.flags = HUD.Fields.team1.flags | g_ModeScript.HUD_FLAG_NOTVISIBLE
	HUD.Fields.team2.flags = HUD.Fields.team2.flags | g_ModeScript.HUD_FLAG_NOTVISIBLE
	HUD.Fields.background.flags = HUD.Fields.background.flags | g_ModeScript.HUD_FLAG_NOTVISIBLE
	
	HUDSetLayout(HUD)
}

function OnTick(){
	if(showScores){
		ShowScores()
	} else {
		HideScores()
	}
	HUDPlace(g_ModeScript.HUD_TICKER, 0.4, 0, 0.2, 0.15)
	HUDPlace(g_ModeScript.HUD_MID_BOT, 0.52, 0, 0.1, 0.15)
	HUDPlace(g_ModeScript.HUD_MID_TOP, 0.405, 0, 0.1, 0.15)
	foreach(player in HookController.PlayerGenerator()){
		if(NetProps.GetPropInt(player, "m_iTeamNum") == 3){ // infected team
			if(spawnEnabled){
				NetProps.SetPropInt(player, "m_afButtonDisabled", NetProps.GetPropInt(player, "m_afButtonDisabled") & ~1) // enable attack1
			} else {
				if(IsPlayerABot(player)){
					player.Kill()
				}
				NetProps.SetPropInt(player, "m_afButtonDisabled", NetProps.GetPropInt(player, "m_afButtonDisabled") | 1) // disable attack1
				NetProps.SetPropInt(player, "m_ghostSpawnState", 1) // set the menu to display spawning is disabled
			}
		} else {
			NetProps.SetPropInt(player, "m_afButtonDisabled", NetProps.GetPropInt(player, "m_afButtonDisabled") & ~1) // enable attack1
		}
	}
	foreach(ent in HookController.EntitiesByClassname("infected")){
		if(!spawnEnabled){
			ent.Kill()
		}
	}
}
	
function OnGameEvent_tank_killed(params){
	DisableSpawning()
	KillInfected()
	arenasCompleted++
	IncreaseScore()
	if(arenasCompleted < ARENAS_TO_PLAY){
		PickNextArena()
	}
	EntFire("arena" + arenasCompleted + "_complete_relay", "Trigger")
	EntFire("fade_to_white", "Fade")
	EntFire("fade_from_white", "Fade", "", FADE_DELAY)
	DoEntFire("!self", "RunScriptCode", "ArenaCompleted()", FADE_DELAY, null, self)
}

function OnGameEvent_round_end(params){
	//printl("round_end")
	showScores = true
}

printl("test1")

DetermineArenaOrder()
PickNextArena()

printl("test2")

RestoreTable("Score", score)
SaveTable("Score", score)

printl("test3")

DoEntFire("!self", "SpeakResponseConcept", "GetQueryData", 0.0, null, Entities.FindByClassname(null, "func_orator"))
DoEntFire("!self", "RunScriptCode", "HandleOldScore()", 0.001, null, self)

printl("test4")

NetProps.SetPropInt(Entities.FindByClassname(null, "terror_gamerules"), "m_bChallengeModeActive", 1)

printl("test5")

rr_ProcessRules(responseRules)
__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)

printl("test6")

// PUBLIC FUNCTIONS

function DisableScoreboard(){
	showScores = false
}

function EnableSpawning(){
	spawnEnabled = true
	Convars.SetValue("director_allow_infected_bots", 1)
	DirectorScript.GetDirectorOptions().CommonLimit <- Convars.GetFloat("z_common_limit")
}

function DisableSpawning(){
	spawnEnabled = false
	Convars.SetValue("director_allow_infected_bots", 0)
	DirectorScript.GetDirectorOptions().CommonLimit <- 0
}

function TeleportToArena(){
	foreach(player in HookController.PlayerGenerator()){
		player.SetOrigin(Entities.FindByName(null, "arena" + currentArena + "_dest").GetOrigin())
		HookController.SetPlayerAngles(player, Entities.FindByName(null, "arena" + currentArena + "_dest").GetAngles())
	}
	showScores = false
}