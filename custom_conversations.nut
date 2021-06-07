local nick_ents = 2
local coach_ents = 2
local rochelle_ents = 2
local ellis_ents = 2

local nick_ents_prefix = "nick_sound_ent"
local coach_ents_prefix = "coach_sound_ent"
local rochelle_ents_prefix = "ro_sound_ent"
local ellis_ents_prefix = "ellis_sound_ent"

local conversation_relays = ["coach_sounds","ro_sounds","ellis_sounds","nick_sounds"]

local function FindCharacter(name){
	local ent = null
	while(ent = Entities.FindByClassname(ent,"player")){
		if(ent.IsValid() && ent.IsSurvivor() && GetCharacterDisplayName(ent) == name){
			return ent
		}
	}
}

local function AlivePlayerCount(){
	local ent = null
	local count = 0
	while(ent = Entities.FindByClassname(ent,"player")){
		if(ent.IsValid() && ent.IsSurvivor() && !ent.IsDead()){
			count += 1
		}
	}
	
	return count
}

local function DisableRelays(){
	foreach(ent in conversation_relays){
		EntFire(ent,"Disable")
	}
}

local function EnableRelays(){
	foreach(ent in conversation_relays){
		EntFire(ent,"Enable")
	}
}

ParentToNick <- function(){
	local player = FindCharacter("Nick")
	if(player != null){
		for(local i=1; i<=nick_ents;i++){
			local ent = Entities.FindByName(null,nick_ents_prefix + i)
			if(ent != null){
				ent.SetOrigin(player.EyePosition())
				local name = UniqueString()
				DoEntFire("!self","AddOutput","targetname " + name,0,null,player)
				EntFire(nick_ents_prefix + i,"SetParent",name)
			}
		}
	} else {
		DisableRelays()
	}
}

ParentToCoach <- function(){
	local player = FindCharacter("Coach")
	if(player != null){
		for(local i=1; i<=coach_ents;i++){
			local ent = Entities.FindByName(null,coach_ents_prefix + i)
			if(ent != null){
				ent.SetOrigin(player.EyePosition())
				local name = UniqueString()
				DoEntFire("!self","AddOutput","targetname " + name,0,null,player)
				EntFire(coach_ents_prefix + i,"SetParent",name)
			}
		}
	} else {
		DisableRelays()
	}
}

ParentToRochelle <- function(){
	local player = FindCharacter("Rochelle")
	if(player != null){
		for(local i=1; i<=rochelle_ents;i++){
			local ent = Entities.FindByName(null,rochelle_ents_prefix + i)
			if(ent != null){
				ent.SetOrigin(player.EyePosition())
				local name = UniqueString()
				DoEntFire("!self","AddOutput","targetname " + name,0,null,player)
				EntFire(rochelle_ents_prefix + i,"SetParent",name)
			}
		}
	} else {
		DisableRelays()
	}
}

ParentToEllis <- function(){
	local player = FindCharacter("Ellis")
	if(player != null){
		for(local i=1; i<=ellis_ents;i++){
			local ent = Entities.FindByName(null,ellis_ents_prefix + i)
			if(ent != null){
				ent.SetOrigin(player.EyePosition())
				local name = UniqueString()
				DoEntFire("!self","AddOutput","targetname " + name,0,null,player)
				EntFire(ellis_ents_prefix + i,"SetParent",name)
			}
		}
	} else {
		DisableRelays()
	}
}

function Update(){
	ParentToCoach()
	ParentToEllis()
	ParentToNick()
	ParentToRochelle()
	
	if(AlivePlayerCount() >= 4){
		EnableRelays()
	} else {
		DisableRelays()
	}
}

function OnGameEvent_player_death(params)
{
	if("userid" in params){
		local player = GetPlayerFromUserID(params.userid)
		if(player != null && player.IsValid() && player.IsSurvivor()){
			DisableRelays()
		}
	}
}

function OnGameEvent_defibrillator_used(params)    
{
	local subject = params.subject
	local player = GetPlayerFromUserID(params.subject)
	if(player != null && player.IsValid() && player.IsSurvivor()){
		if(AlivePlayerCount() >= 4){
			EnableRelays()
		} else {
			DisableRelays()
		}
	}
}

__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)