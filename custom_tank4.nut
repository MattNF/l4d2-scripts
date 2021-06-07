local spots = ["will spawn at the beginning. (10% Map Distance)","will spawn in the large barn near the start. (24% Map Distance)","will spawn at the park entrance. (35% Map Distance)","will spawn on the barn rooftops. (58% Map Distance)","will spawn in the generator room. (62% Map Distance)","will spawn at the food court. The event will end instantly after the Tank is spawned. (70% Map Distance)","will spawn at the event turn-off switch. (88% Map Distance)","will spawn at raised veranda area. The event will end instantly after the Tank is spawned. (80% Map Distance)","will spawn at the large barn at the end of the park. (50% Map Distance)","will spawn in the pool table room. (31% Map Distance)"]

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