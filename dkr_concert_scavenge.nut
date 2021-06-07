Msg("Initiating Scavenge Event!\n");
Msg("Turning off director bosses!\n");

DirectorOptions <-
{
    ProhibitBosses = true
    DisallowThreatType = ZOMBIE_WITCH
    DisallowThreatType = ZOMBIE_TANK //The above three only work in coop mode I believe, but let's set them anyway just in case.
    IgnoreNavThreatAreas = 1
    TankLimit = 0
    WitchLimit = 0
	MobSpawnMinTime = 10
	MobSpawnMaxTime = 10
	MobSpawnSize = 3
	MobMaxPending = 12
    IntensityRelaxThreshold = 0.99
    RelaxMinInterval = 1
    RelaxMaxInterval = 1
    RelaxMaxFlowTravel = 1
	SpecialRespawnInterval = 30
	LockTempo = true
	
	PreferredMobDirection = SPAWN_ANYWHERE
}

Director.ResetMobTimer()

