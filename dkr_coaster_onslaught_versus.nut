Msg("Initiating Versus Mode Roller Coaster Event!\n");

DirectorOptions <-
{
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 1
	MobMinSize = 3
	MobMaxSize = 3
	MobMaxPending = 15
	SustainPeakMinTime = 7
	SustainPeakMaxTime = 7
    IntensityRelaxThreshold = 0.99
	RelaxMinInterval = 1
    RelaxMaxInterval = 1
    RelaxMaxFlowTravel = 1
	SpecialRespawnInterval = 5.0
	PreferredMobDirection = SPAWN_IN_FRONT_OF_SURVIVORS
	ZombieSpawnRange = 1000

}

Director.PlayMegaMobWarningSounds()
Director.ResetMobTimer()