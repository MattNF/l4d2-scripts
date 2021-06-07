Msg("Initiating Merry-Go-Round Event!\n");
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
	PreferredMobDirection = SPAWN_ANYWHERE
	MobSpawnMinTime = 1
	MobSpawnMaxTime = 1
	MobMaxPending = 30
	MobMinSize = 30
	MobMaxSize = 30
	SustainPeakMinTime = 2
	SustainPeakMaxTime = 2
	IntensityRelaxThreshold = 0.99
	RelaxMinInterval = 1
    RelaxMaxInterval = 1
    RelaxMaxFlowTravel = 1

}

Director.ResetMobTimer()
Director.PlayMegaMobWarningSounds()

