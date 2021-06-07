function SpawnSpotlightTarget(){
	SpawnEntityFromTable("info_target", {targetname = "targetfollow", origin = "880 2385 -277"})
}

function SpawnGasCan(){
	local spawn = SpawnEntityFromTable("weapon_scavenge_item_spawn", {targetname = "gascans_2", origin = "-56 4128 6", angles = "0 90 0"})
	DoEntFire("!self", "SpawnItem", "", 0, null, spawn)
}

function RemoveGasCan(){
	local ent = null
	while(ent = Entities.FindByClassname(ent, "weapon_gascan")){
		if(NetProps.GetPropInt(ent, "m_bVulnerableToSpit") == 1){
			ent.Kill()
		}
	}
}

function LockPVS(num){
	Convars.SetValue("r_lockpvs", num)
}