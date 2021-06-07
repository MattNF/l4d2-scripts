local spots = ["will spawn in the parking lot. (57% Map Distance)","will spawn by the scavenge generator. (38% Map Distance)","will spawn by the parking lot entrance. (44% Map Distance)","will spawn at the stadium entrance. (64% Map Distance)","will spawn in the stadium. (73% Map Distance)"]

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