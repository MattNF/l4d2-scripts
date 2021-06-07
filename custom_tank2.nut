local spots = ["will spawn at the beginning of the map. (10% Map Distance)","will spawn at the beginning of the fairgrounds. (21% Map Distance)","will spawn at the first warehouse entrance. (34% Map Distance)","will spawn shortly after leaving the first warehouse. (44% Map Distance)","will spawn at the end of the alley leading to the rooftops. (60% Map Distance)","will spawn in the Fairgrounds before entering the warehouse. (28% Map Distance)","will spawn at the end of the slide. (84% Map Distance)","will spawn at the event button. (89% Map Distance)","will spawn on the rooftops. (73% Map Distance)","will spawn at the large tent at the entrance to Kiddyland. (49% Map Distance)"]

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