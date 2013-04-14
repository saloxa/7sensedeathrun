/*

    Plugin:	 		Qube Fix
	Version:		1
	Requirement:	Easy fix no biggie
	Author:			Darmuh
	XFire:			irRoy8
	Homepage:		7sense-runners.com
	Date:			02.05.2013






*/
init( modversion )
{

  for(;;)
  {
     
	 level waittill( "round_ended" );
	 thread qube();
  
  }



}



qube()
{
	if( getDvar("mapname") == ("mp_deathrun_qube") )
		{
			setdvar("bunnyhoop", 0);
			iprintln( "bunnyhop disabled." );
		}
	else
		{
			setDvar("bunnyhoop", 1);
			setDvar("g_knockback",1000);
		}
}