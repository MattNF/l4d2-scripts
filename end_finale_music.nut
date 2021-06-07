function OnGameEvent_finale_vehicle_leaving(params){
    StopSoundOn("Event.ScenarioWin", Entities.FindByClassname(null, "worldspawn"))
	StopSoundOn("Event.FinalBattle", Entities.FindByClassname(null, "worldspawn"))
}

__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)