Msg("Initiating Ferris Wheel Event!\n");
Msg("Turning off director bosses!\n");

DirectorOptions <-
{
    ProhibitBosses = true
    DisallowThreatType = ZOMBIE_WITCH
    DisallowThreatType = ZOMBIE_TANK //The above three only work in coop mode I believe, but let's set them anyway just in case.
    IgnoreNavThreatAreas = 1
    TankLimit = 0
    WitchLimit = 0
    cm_TankLimit = 0
    cm_WitchLimit = 0
	CommonLimit = 20
	MobSpawnMinTime = 4
	MobSpawnMaxTime = 4
	MobMinSize = 10
	MobMaxSize = 10
	MobMaxPending = 10
	SustainPeakMinTime = 4
	SustainPeakMaxTime = 4
    IntensityRelaxThreshold = 0.99
    RelaxMinInterval = 1
    RelaxMaxInterval = 1
    RelaxMaxFlowTravel = 1
	SpecialRespawnInterval = 5.0
	ZombieSpawnRange = 1000
	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
}

Director.ResetMobTimer()

