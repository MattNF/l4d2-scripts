local spots = ["will spawn at the beginning of the map. (18% Map Distance)","will spawn at the end of the highway section. (43% Map Distance)","will spawn by the pool. (60% Map Distance)","will spawn by the motel office. (73% Map Distance)","will spawn at the valley campsite. (83% Map Distance)","will spawn at the end of the valley. (94% Map Distance)","will spawn at the middle of the highway section. (28% Map Distance)","will spawn by the beginning of the motel. (48% Map Distance)","will spawn under the overpass. (37% Map Distance)","will spawn at the end of the motel. (78% Map Distance)"]

local chosen_spot = -1
local chat_prefix = "The Tank "

SayTankSpot <- function(spot_num){
	Say(null,chat_prefix + spots[spot_num-1],false)
	chosen_spot = spot_num-1
}

local function IsCommand(msg,ent,command){
	local message = ""
	local found_start = false
	local found_end = false
	local last_char = 0
	foreach(char in msg){
		if(char != 32 && char != 10){
			if(!found_start){
				found_start = true
			}
			message += char.tochar()
		} else if(char == 32){
			if(last_char != 32){
				found_end = true
			}
			if(found_start && !found_end){
				message += char.tochar()
			}
		}
	}
	return message == command
}

function OnGameEvent_player_say(params)
{
	local userid = params.userid
	local text = params.text

	if(IsCommand(text,GetPlayerFromUserID(userid),"!tank")){
		SayTankSpot(chosen_spot+1)
	}
	
	if(IsCommand(text,GetPlayerFromUserID(userid),"!sm_tank")){
		SayTankSpot(chosen_spot+1)
	}
	
	if(IsCommand(text,GetPlayerFromUserID(userid),"!boss")){
		SayTankSpot(chosen_spot+1)
	}
	
	if(IsCommand(text,GetPlayerFromUserID(userid),"!b")){
		SayTankSpot(chosen_spot+1)
	}
	
	if(IsCommand(text,GetPlayerFromUserID(userid),"!t")){
		SayTankSpot(chosen_spot+1)
	}
}

__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)