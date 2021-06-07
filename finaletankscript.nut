local enabled = false

function EnableKillOutput(){
    enabled = true
}

function OnGameEvent_tank_killed(params){
    if(enabled){
            EntFire("stage2_logic_relay", "Trigger", "", 5)
    }
}

__CollectEventCallbacks(this, "OnGameEvent_", "GameEventCallbacks", RegisterScriptGameEventListener)