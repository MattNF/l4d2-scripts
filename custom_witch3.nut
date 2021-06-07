local spots = ["will spawn at the beginning of the tunnel of love. (15% Map Distance)","will spawn at the first storage room in the tunnel of love. (19% Map Distance)","will spawn near the entrance to the swan maintenance room. (27% Map Distance)","will spawn in the room before the one way drop. (36% Map Distance)","will spawn after the one way drop hole. (38% Map Distance)","will spawn near the end of the tunnel of love. (44% Map Distance)","will spawn outside the warehouse building after leaving the tunnel of love. (53% Map Distance)","will spawn by the end saferoom. (100% Map Distance)","will spawn by the Screaming Oak ticket booth. (60% Map Distance)","will spawn shortly after leaving the tunnel of love. (49% Map Distance)"]
 
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