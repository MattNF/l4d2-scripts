function KillMusic(){
    local worldspawn = Entities.FindByClassname(null, "worldspawn")
    StopSoundOn("Event.Tank", worldspawn)
    StopSoundOn("Event.TankMidpoint", worldspawn)
    StopSoundOn("Event.TankBrothers", worldspawn)
}