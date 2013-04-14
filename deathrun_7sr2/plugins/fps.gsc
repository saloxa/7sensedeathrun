/*

    Shit doesn't matter.






*/





init( modVersion )
{
 

  for(;;)
  {
     
	 level waittill("player_spawn",player);
		player thread credit();
		
  
  }



}

isReallyAlive()
{
	return self.sessionstate == "playing";
}
 
isPlaying()
{
	return isReallyAlive();
}


credit()
{
  level endon ( "endmap" );
  self endon("disconnect");
  self endon ( "death" );
  self endon("joined_spectators");
  
  if( self SecondaryOffhandButtonPressed())
	{	 
		if( !isDefined( self.pers["fullbright"] ) )
			{
				self.pers["fullbright"] = true;
				self setClientDvar( "r_fullbright", 1 );
				self iprintlnbold( "^7You have enabled ^3FPS MODE^7..." );
			}
		else
			{
				self.pers["fullbright"] = undefined;
				self setClientDvar( "r_fullbright", 0 );
				self iprintlnbold( "^7You have disabled ^3FPS MODE^7..." );
			}
	}
         wait .1;
}