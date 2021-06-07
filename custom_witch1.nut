local spots = ["will spawn by the white bus on the highway. (25% Map Distance)","will spawn at near the hill at the end of the highway. (34% Map Distance)","will spawn by the motel pool. (47% Map Distance)","will spawn on the second floor of the motel. (63% Map Distance)","will spawn near the back of the motel office. (75% Map Distance)","will spawn at the valley campsite. (80% Map Distance)","will spawn near the alarm car at the end. (99% Map Distance)","will spawn near the end saferoom. (100% Map Distance)","will spawn at the bottom of the valley. (86% Map Distance)","will spawn underneath the overpass. (37% Map Distance)"]
 
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