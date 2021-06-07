Msg("Initiating Versus Mode Ferris Wheel Event!\n");

DirectorOptions <-
{
	CommonLimit = 18
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

