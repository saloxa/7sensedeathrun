init( modVersion )
{
    thread onIntermission();

    level waittill( "round_ended" );
    ambientStop( 2 );
	musicstop( 2 );
}

onIntermission()
{
    level waittill( "intermission" );
    ambientStop( 2 );
	musicstop( 2 );
} 