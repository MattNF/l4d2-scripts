local data = {num_found = 0}
local TOTAL_EASTER_EGGS = 5

RestoreTable("easteregg_data", data)

SaveTable("easteregg_data", data) // If we don't save the table here and if the round restarts before anyone collects the map's coin, we lose the data

SecretFound <- function(coinNum){
    if(coinNum == data.num_found + 1){
        data.num_found++
        printl("Found coin " + data.num_found + " out of 5 (one coin per map)!")
    } else {
		printl(data.num_found)
        printl("Found coin " + coinNum + " but either a coin was missed, or the coin was already collected")
    }
    SaveTable("easteregg_data", data) 
}

DoEasterEgg <- function(){
	printl("num_found: " + data.num_found)
    if(data.num_found >= TOTAL_EASTER_EGGS){
        EntFire("easter_egg_ending", "Trigger")
        printl("Commencing secret ending!")
    }
    if(data.num_found < TOTAL_EASTER_EGGS){
        EntFire("normal_ending", "Trigger")
        printl("Didn't find enough coins for the secret ending! (5 coins needed, 1 coin per map)")
    }
}


function OnMapStart(){
	local nextMapName = NetProps.GetPropString(Entities.FindByClassname(null, "info_changelevel"), "m_mapName")

	if(nextMapName == "dkr_m2_carnival" && data.num_found >= 1){
		data.num_found = 0
	} else if(nextMapName == "dkr_m3_tunneloflove" && data.num_found >= 2){
		data.num_found = 1
	} else if(nextMapName == "dkr_m4_ferris" && data.num_found >= 3){
		data.num_found = 2
	} else if(nextMapName == "dkr_m5_stadium" && data.num_found >= 4){
		data.num_found = 3
	} else if(nextMapName == "" && data.num_found >= 5){ // returns an empty string because of no info_changelevel ent
		data.num_found = 4
	}

	SaveTable("easteregg_data", data)
}