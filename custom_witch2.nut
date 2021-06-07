local spots = ["will spawn at the beginning. (14% Map Distance)","will spawn at the refreshment building. (25% Map Distance)","will spawn at the warehouse entrance. (34% Map Distance)","will spawn at the end of the warehouse. (40% Map Distance)","will spawn at the entrance to kiddyland. (45% Map Distance)","will spawn in the alleyway leading to the rooftops. (64% Map Distance)","will spawn on the rooftops. (76% Map Distance)","will spawn near the event button. (88% Map Distance)","will spawn near the end saferoom. (100% Map Distance)","will spawn in the water pump room. (78% Map Distance)"]
 
local chosen_spot = -1
local chat_prefix = "The Witch "
 
SayWitchSpot <- function(spot_num){
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
 
    if(IsCommand(text,GetPlayerFromUserID(userid),"!witch")){
        SayWitchSpot(chosen_spot+1)
    }
    if(IsCommand(text,GetPlayerFromUserID(userid),"!boss")){
        SayWitchSpot(chosen_spot+1)
    }
    if(IsCommand(text,GetPlayerFromUserID(userid),"!sm_witch")){
        SayWitchSpot(chosen_spot+1)
    }
	
	if(IsCommand(text,GetPlayerFromUserID(userid),"!b")){
		SayWitchSpot(chosen_spot+1)
	}
	
	if(IsCommand(text,GetPlayerFromUserID(userid),"!w")){
		SayWitchSpot(chosen_spot+1)
	}
}
 
__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)