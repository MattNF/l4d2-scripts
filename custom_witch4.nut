local spots = ["will spawn in the barns entrance. (19% Map Distance)","will spawn at the warehouse entrance. (26% Map Distance)","will spawn at the end of the warehouse. (32% Map Distance)","will spawn shortly after entering the park. (36% Map Distance)","will spawn in the park. (42% Map Distance)","will spawn inside the barn at the end of the park. (49% Map Distance)","will spawn by the event button. (63% Map Distance)","will spawn on the walkway leading to the ferris wheel. (90% Map Distance)","will spawn outside the barn at the end of the park. (48% Map Distance)","will spawn by the stache whacker game. (16% Map Distance)"]
 
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