if ( Director.GetGameMode() == "coop" )
{
	Msg("Initiating Co-op Onslaught Script!\n");
	DirectorOptions <-
	{
		MobSpawnMinTime = 6
		MobSpawnMaxTime = 6
		MobSpawnSize = 16
		SpecialRespawnInterval = 25
		//LockTempo = true
		CommonLimit = 25
		MobMaxPending = 20
		ZombieSpawnRange = 5000
		PreferredMobDirection = SPAWN_LARGE_VOLUME
		PreferredSpecialDirection = SPAWN_LARGE_VOLUME
		// ShouldConstrainLargeVolumeSpawn = false
		MusicDynamicMobSpawnSize = 999
		MusicDynamicMobScanStopSize = 999
		MaxSpecials = 1
		HunterLimit = 1
		SmokerLimit = 1
		BoomerLimit = 1
		ChargerLimit = 1
		SpitterLimit = 1
		WitchLimit = 0
	}
}

if ( Director.GetGameMode() == "versus" )
{
	Msg("Initiating Versus Onslaught Script!\n");
	DirectorOptions <-
	{
		MobSpawnMinTime = 6
		MobSpawnMaxTime = 6
		MobSpawnSize = 9
		SpecialRespawnInterval = 25
		//LockTempo = true
		CommonLimit = 18
		MobMaxPending = 18
		ZombieSpawnRange = 500
		PreferredMobDirection = SPAWN_LARGE_VOLUME
		PreferredSpecialDirection = SPAWN_LARGE_VOLUME
		// ShouldConstrainLargeVolumeSpawn = false
		MusicDynamicMobSpawnSize = 999
		MusicDynamicMobScanStopSize = 999
		MaxSpecials = 1
		HunterLimit = 1
		SmokerLimit = 1
		BoomerLimit = 1
		ChargerLimit = 1
		SpitterLimit = 1
		WitchLimit = 0
	}
}
Director.ResetMobTimer()
