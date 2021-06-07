local spots = ["will spawn at the beginning of the map. (12% Map Distance)","will spawn at the storage room near the beginning. (24% Map Distance)","will spawn at the entrance to the swan maintenance room. (29% Map Distance)","will spawn at the one way drop. (38% Map Distance)","will spawn near the end of the Tunnel of Love. (45% Map Distance)","will spawn at the warehouse after leaving the Tunnel of Love. (52% Map Distance)","will spawn by the roller coaster ticket booth. (61% Map Distance)","will spawn at the coaster event button. (71% Map Distance)","will spawn at the end of the swan maintenance room. (35% Map Distance)","will spawn at the first bend in the Tunnel of Love. (17% Map Distance)"]

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