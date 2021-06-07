Msg("Initiating Versus Mode Merry-Go-Round Event!\n");

DirectorOptions <-
{
	PreferredMobDirection = SPAWN_ANYWHERE
	MobSpawnMinTime = 3
	MobSpawnMaxTime = 3
	MobMaxPending = 12
	MobMinSize = 12
	MobMaxSize = 12
	SustainPeakMinTime = 2
	SustainPeakMaxTime = 2
	IntensityRelaxThreshold = 0.99
	RelaxMinInterval = 1
    RelaxMaxInterval = 1
    RelaxMaxFlowTravel = 1
}

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()

