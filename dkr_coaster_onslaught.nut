Msg("Initiating Roller Coaster Event!\n");
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
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 1
	MobMinSize = 6
	MobMaxSize = 6
	MobMaxPending = 25
	SustainPeakMinTime = 7
	SustainPeakMaxTime = 7
    IntensityRelaxThreshold = 0.99
	RelaxMinInterval = 1
    RelaxMaxInterval = 1
    RelaxMaxFlowTravel = 1
	SpecialRespawnInterval = 10.0
	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	ZombieSpawnRange = 750
	MaxSpecials = 2
	HunterLimit = 1
	SmokerLimit = 1
	BoomerLimit = 0
	ChargerLimit = 1
	SpitterLimit = 1
}

Director.PlayMegaMobWarningSounds()
Director.ResetMobTimer()