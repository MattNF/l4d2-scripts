function Think(){
	if(Director.HasAnySurvivorLeftSafeArea())
		DoEntFire( "saferoomboundary", "kill", "", 0, null, "" );
}