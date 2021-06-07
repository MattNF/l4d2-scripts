//-----------------------------------------------------------------------------

PANIC <- 0
TANK <- 1
DELAY <- 2
ONSLAUGHT <- 3

//-----------------------------------------------------------------------------


	Msg("Beginning finale script.\n");
	DirectorOptions <-
	{
		A_CustomFinale_StageCount = 10
		
		A_CustomFinale1 = ONSLAUGHT
		A_CustomFinaleValue1 = "dkr_stadium_onslaught"
		A_CustomFinaleMusic1 = ""

		A_CustomFinale2 = ONSLAUGHT 
		A_CustomFinaleValue2 = "dkr_stadium_onslaught"
		
		A_CustomFinale3 = ONSLAUGHT
		A_CustomFinaleValue3 = "dkr_stadium_onslaught"

		A_CustomFinale4 = DELAY 
		A_CustomFinaleValue4 = 999999999
		//A_CustomFinaleMusic4 = "C2M5.BadManTank2"
		A_CustomFinaleMusic4 = ""
		
		A_CustomFinale5 = ONSLAUGHT 
		A_CustomFinaleValue5 = "dkr_stadium_onslaught"
			
		A_CustomFinale6 = ONSLAUGHT 
		A_CustomFinaleValue6 = "dkr_stadium_onslaught"
		
		A_CustomFinale7 = ONSLAUGHT 
		A_CustomFinaleValue7 = "dkr_stadium_onslaught" 
		
		A_CustomFinale8 = ONSLAUGHT 
		A_CustomFinaleValue8 = "dkr_stadium_onslaught" 
			
		A_CustomFinale9 = DELAY 
		A_CustomFinaleValue9 = 99999999
		A_CustomFinaleMusic9 = ""
		
		A_CustomFinale10 = ONSLAUGHT 
		A_CustomFinaleValue10 = "dkr_stadium_onslaught"
	} 