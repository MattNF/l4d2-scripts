local wipeData = {wipeCount = 0, wipeMap = null}

RestoreTable("wipeData", wipeData)
SaveTable("wipeData", wipeData)

function OnMapStart(){
    if(wipeData["wipeMap"] == NetProps.GetPropString(Entities.FindByClassname(null, "info_changelevel"), "m_mapName")){ // If we actually wiped on the same map
        wipeData["wipeCount"]++
    } else { // If we only transitioned, not wiped
        wipeData["wipeCount"] = 0
        wipeData["wipeMap"] = NetProps.GetPropString(Entities.FindByClassname(null, "info_changelevel"), "m_mapName")
    }
    SaveTable("wipeData", wipeData)

    if(wipeData.wipeCount >= 1){
        EntFire("ConvoBegin", "Kill")
    }
}