#include braxi\_dvar;

init( modVers )
{
	addDvar( "pi_hn", "plugin_hostname_enable", 1, 0, 1, "int" );
	if( !level.dvar["pi_hn"] )
		return;
		
	addDvar( "pi_hn_time", "plugin_hostname_updatetime", 10, 2, 60, "int" );
	if( getDvar( "sv_newhostname" ) == "" )
		setDvar( "sv_newhostname", "^1DeathRun ^2V1.2 ^7- Round: PIHN_ROUND/PIHN_MAXROUNDS - Players: PIHN_PLAYERS/PIHN_MAXPLAYERS - Activator: PIHN_ACTIVATOR" );
	
	wait 1;
	
	level.pihostname = getDvar( "sv_newhostname" );
	
	thread WatchHostname();
}

/*
Useable paramaters:

PIHN_PLAYERS	-	Amount of players
PIHN_MAXPLAYERS	-	Slots
PIHN_ROUND	-	Round Number
PIHN_MAXROUNDS	-	max amount of rounds
PIHN_ACTIVATOR	-	Name of activator
PIHN_BESTPLAYER	-	Best Player name
PIHN_BESTPLAYERSCORE	-	Score of the best player
PIHN_JUMPERS	-	Alive Jumpers
*/

WatchHostname()
{
	newhostname = undefined;

	while(1)
	{
		newhostname = GetNewHostname();
		if( isDefined( newhostname ) )
			setDvar( "sv_hostname", newhostname );
		wait level.dvar["pi_hn_time"];
	}
}

GetNewHostname()
{
	string = level.pihostname;
	//iPrintln( "Getting new hostname: " + string );
	string = CheckString( "PIHN_PLAYERS", string );
	string = CheckString( "PIHN_MAXPLAYERS", string );
	string = CheckString( "PIHN_ROUND", string );
	string = CheckString( "PIHN_MAXROUNDS", string );
	string = CheckString( "PIHN_ACTIVATOR", string );
	string = CheckString( "PIHN_BESTPLAYER", string );
	string = CheckString( "PIHN_BESTPLAYERSCORE", string );
	string = CheckString( "PIHN_JUMPERS", string );
	
	return string;
}

CheckString( search, string )
{
	if( !isDefined( search ) || !isDefined( string ) )
		return;
	
	if( !isSubStr( string, search ) )
		return string;
	
	cont = false;
	mark = [];
	
	for(i=0;i<string.size;i++)
	{
		if( string[i] != search[0] )
			continue;
		
		mark[0] = i;
		for(ii=0;ii<search.size;ii++)
		{
			if( search[ii] != string[i+ii] )
			{
				cont = true;
				break;
			}
			mark[1] = int(i+ii)+1;
		}
		if( cont )		//we are not done yet
		{
			cont = false;
			continue;
		}
		break;
	}
	//iPrintln( GetSubStr( string, 0, mark[0] ) + "TO_BE_REPLACED" + GetSubStr( string, mark[1], string.size ) );
	return /*newstring =*/ GetSubStr( string, 0, mark[0] ) + ReplaceString( search ) + GetSubStr( string, mark[1], string.size );
}

ReplaceString( replace )
{
	if( !isDefined( replace ) )
		return;
	
	switch( replace )
	{
		case "PIHN_PLAYERS":
			players = getEntArray( "player", "classname" );
			return players.size;
		case "PIHN_MAXPLAYERS":
			return getDvarInt( "sv_maxClients" );
		case "PIHN_ROUND":
			return game["roundsplayed"];
		case "PIHN_MAXROUNDS":
			return level.dvar["round_limit"];
		case "PIHN_ACTIVATOR":
			if( isDefined( level.activ ) )
				return level.activ.name;
			else
				return "None choosen yet";
		case "PIHN_BESTPLAYER":
			guy = braxi\_common::getBestPlayerFromScore( "score" );
			if( !isDefined( guy ) )
				guy = "None";
			else
				guy = guy.name;
			return guy;
		case "PIHN_BESTPLAYERSCORE":
			guy = braxi\_common::getBestPlayerFromScore( "score" );
			if( !isDefined( guy ) )
				guy = 0;
			else
				guy = guy.pers["score"];
			return guy;
		case "PIHN_JUMPERS":
			return GetTeamPlayersAlive( "allies" );
		case "default":
			return replace;
	}
}