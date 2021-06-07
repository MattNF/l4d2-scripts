// The below script is if you wanted to change the finale to a standard "camping" finale. 

if ( Director.GetGameMode() == "versus" )
 {
	Msg("Beginning versus finale script.\n");
	DirectorOptions <-
	{
		ZombieSpawnRange = 1500
		A_CustomFinale_StageCount = 8
		
		A_CustomFinale1 = PANIC
		A_CustomFinaleValue1 = 3

		A_CustomFinale2 = DELAY
		A_CustomFinaleValue2 = 5

		A_CustomFinale3 = TANK
		A_CustomFinaleValue3 = 1
		A_CustomFinaleMusic3 = "C2M5.BadManTank2"

		A_CustomFinale4 = DELAY
		A_CustomFinaleValue4 = 5

		A_CustomFinale5 = PANIC
		A_CustomFinaleValue5 = 2

		A_CustomFinale6 = DELAY
		A_CustomFinaleValue6 = 10
		
		A_CustomFinale7 = ONSLAUGHT
		A_CustomFinaleValue7 = "dkr_m5_stadium_finale_vsextra"
		
		A_CustomFinale8 = DELAY
		A_CustomFinaleValue8 = 1
	}
}