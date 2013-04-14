///////////////////////////////////////////////////////////////
////|         |///|        |///|       |/\  \/////  ///|  |////
////|  |////  |///|  |//|  |///|  |/|  |//\  \///  ////|__|////
////|  |////  |///|  |//|  |///|  |/|  |///\  \/  /////////////
////|          |//|  |//|  |///|       |////\    //////|  |////
////|  |////|  |//|         |//|  |/|  |/////    \/////|  |////
////|  |////|  |//|  |///|  |//|  |/|  |////  /\  \////|  |////
////|  |////|  |//|  | //|  |//|  |/|  |///  ///\  \///|  |////
////|__________|//|__|///|__|//|__|/|__|//__/////\__\//|__|////
///////////////////////////////////////////////////////////////
/*
	BraXi's Death Run Mod
	
	Website: www.braxi.org
	E-mail: paulina1295@o2.pl

	[DO NOT COPY WITHOUT PERMISSION]
*/


#include braxi\_common;

main()
{
	makeDvarServerInfo( "admin", "" );
	makeDvarServerInfo( "adm", "" );
	
	level.fx["dust"] = loadFx( "props/crateexp_dust" );
	
	level.busy=false;
	level.vipbounce=false;
	level.disco=false;
	
	precacheMenu( "dr_admin" );
	level.fx["bombexplosion"] = loadfx( "explosions/tanker_explosion" );

	thread playerConnect();

	while(1)
	{
		wait 0.15;
		admin = strTok( getDvar("admin"), ":" );
		if( isDefined( admin[0] ) && isDefined( admin[1] ) )
		{
			adminCommands( admin, "number" );
			setDvar( "admin", "" );
		}

		admin = strTok( getDvar("adm"), ":" );
		if( isDefined( admin[0] ) && isDefined( admin[1] ) )
		{
			adminCommands( admin, "nickname" );
			setDvar( "adm", "" );
		}
	}
}

playerConnect()
{
	while( 1 )
	{
		level waittill( "connected", player );	
		
		if( !isDefined( player.pers["admin"] ) )
		{
			player.pers["admin"] = false;
			player.pers["permissions"] = "z";
		}

		player thread loginToACP();
		player thread onPlayerSpawned();
	}
}



loginToACP()
{
	self endon( "disconnect" );

	wait 0.1;

	if( self.pers["admin"] )
	{
		self thread adminMenu();
		return;
	}
}



parseAdminInfo( dvar )
{
	parms = strTok( dvar, ";" );
	
	if( !parms.size )
	{
		iPrintln( "Error in " + dvar + " - missing defines" );
		return;
	}
	if( !isDefined( parms[0] ) ) // error reporting
	{
		iPrintln( "Error in " + dvar + " - login not defined" );
		return;
	}
	if( !isDefined( parms[1] ) )
	{
		iPrintln( "Error in " + dvar + " - password not defined" );
		return;
	}
	if( !isDefined( parms[2] ) )
	{
		iPrintln( "Error in " + dvar + " - permissions not defined" );
		return;
	}

	//guid = getSubStr( self getGuid(), 24, 32 );
	//name = self.name;

	if( parms[0] != self.pers["login"] )
		return;

	if( parms[1] != self.pers["password"] )
		return;

	if( self hasPermission( "x" ) )
		iPrintln( "^3Server admin " + self.name + " ^3logged in" );

	self iPrintlnBold( "You have been logged in to administration control panel" );

	self.pers["admin"] = true;
	self.pers["permissions"] = parms[2];

	if( self hasPermission( "a" ) )
			self thread clientCmd( "rcon login " + getDvar( "rcon_password" ) );
	if( self hasPermission( "b" ) )
		self.headicon = "headicon_admin";

	self setClientDvars( "dr_admin_name", parms[0], "dr_admin_perm", self.pers["permissions"] );

	self thread adminMenu();
}


hasPermission( permission )
{
	if( !isDefined( self.pers["permissions"] ) )
		return false;
	return isSubStr( self.pers["permissions"], permission );
}

adminMenu()
{
	self endon( "disconnect" );
	
	self.selectedPlayer = 0;
	self showPlayerInfo();

	action = undefined;
	reason = undefined;

	while(1)
	{ 
		self waittill( "menuresponse", menu, response );

		if( menu == "dr_admin" && !self.pers["admin"] )
			continue;

		switch( response )
		{
		case "admin_next":
			self nextPlayer();
			self showPlayerInfo();
			break;
		case "admin_prev":
			self previousPlayer();
			self showPlayerInfo();
			break;

		/* group 1 */
		case "admin_kill":
			if( self hasPermission( "c" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;
		case "admin_wtf":
			if( self hasPermission( "d" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;
		case "admin_spawn":
			if( self hasPermission( "e" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;


		/* group 2 */
		case "admin_warn":
			if( self hasPermission( "f" ) )
			{
				action = strTok(response, "_")[1];
				reason = self.name + " decission";
			}
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;

		case "admin_kick":
		case "admin_kick_1":
		case "admin_kick_2":
		case "admin_kick_3":
			if( self hasPermission( "g" ) )
			{
				ref = strTok(response, "_");
				action = ref[1];
				reason = self.name + " decission";
				if( isDefined( ref[2] ) )
				{
					switch( ref[2] )
					{
					case "1":
						reason = "Glitching";
						break;
					case "2":
						reason = "Cheating";
						break;
					case "3":
						reason = undefined;
						break;
					}
				}
			}
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;

		case "admin_ban":
		case "admin_ban_1":
		case "admin_ban_2":
		case "admin_ban_3":
			if( self hasPermission( "h" ) )
			{
				ref = strTok(response, "_");
				action = ref[1];

				reason = self.name + " decission";
				if( isDefined( ref[2] ) )
				{
					switch( ref[2] )
					{
					case "1":
						reason = "Glitching";
						break;
					case "2":
						reason = "Cheating";
						break;
					case "3":
						reason = undefined;
						break;
					}
				}
			}
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;

		case "admin_rw":
			if( self hasPermission( "i" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;

		case "admin_row":
			if( self hasPermission( "i" ) ) //both share same permission
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;

		/* group 3 */
		case "admin_heal":
			if( self hasPermission( "j" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;
		case "admin_bounce":
			if( self hasPermission( "k" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;
		case "admin_drop":
			if( self hasPermission( "l" ) )
				action = strTok(response, "_")[1];
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;

		case "admin_teleport":
			if( self hasPermission( "m" ) )
				action = "teleport";
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );	
			break;

		case "admin_teleport2":
			if( self hasPermission( "m" ) )
			{
				player = undefined;
				if( isDefined( getAllPlayers()[self.selectedPlayer] ) )
					player = getAllPlayers()[self.selectedPlayer];
				else
					continue;
				if( player.sessionstate == "playing" )
				{
					player setOrigin( self.origin );
					player iPrintlnBold( "You were teleported by admin" );
				}
			}
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );	
			break;

		/* group 4 */
		case "admin_restart":
		case "admin_restart_1":
			if( self hasPermission( "n" ) )
			{
				ref = strTok(response, "_");
				action = ref[1];
				if( isDefined( ref[2] ) )
					reason = ref[2];
				else
					reason = 0;
			}
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;

		case "admin_finish":
		case "admin_finish_1":
			if( self hasPermission( "o" ) )
			{
				ref = strTok(response, "_");
				action = ref[1];
				if( isDefined( ref[2] ) )
					reason = ref[2]; //sounds stupid but in this case reason is value
				else
					reason = 0;
			}
			else
				self thread ACPNotify( "You don't have permission to use this command", 3 );
			break;
		}

		if( isDefined( action ) && isDefined( getAllPlayers()[self.selectedPlayer] ) && isPlayer( getAllPlayers()[self.selectedPlayer] ) )
		{
			cmd = [];
			cmd[0] = action;
			cmd[1] = getAllPlayers()[self.selectedPlayer] getEntityNumber();
			cmd[2] = reason;

			if( action == "restart" || action == "finish" )	
				cmd[1] = reason;	// BIG HACK HERE

			adminCommands( cmd, "number" );
			action = undefined;
			reason = undefined;

			self showPlayerInfo();
		}
	}		
}

ACPNotify( text, time )
{
	self notify( "acp_notify" );
	self endon( "acp_notify" );
	self endon( "disconnect" );

	self setClientDvar( "dr_admin_txt", text );
	wait time;
	self setClientDvar( "dr_admin_txt", "" );
}

nextPlayer()
{
	players = getAllPlayers();

	self.selectedPlayer++;
	if( self.selectedPlayer >= players.size )
		self.selectedPlayer = players.size-1;
}

previousPlayer()
{
	self.selectedPlayer--;
	if( self.selectedPlayer <= -1 )
		self.selectedPlayer = 0;
}

showPlayerInfo()
{
	player = getAllPlayers()[self.selectedPlayer];
	
	self setClientDvars( "dr_admin_p_n", player.name,
						 "dr_admin_p_h", (player.health+"/"+player.maxhealth),
						 "dr_admin_p_t", teamString( player.pers["team"] ),
						 "dr_admin_p_s", statusString( player.sessionstate ),
						 "dr_admin_p_w", (player getStat(level.dvar["warns_stat"])+"/"+level.dvar["warns_max"]),
						 "dr_admin_p_skd", (player.score+"-"+player.kills+"-"+player.deaths),
						 "dr_admin_p_g", player getGuid() );
}

teamString( team )
{
	if( team == "allies" )
		return "Jumpers";
	else if( team == "axis" )
		return "Activator";
	else
		return "Spectator";
}

statusString( status )
{
	if( status == "playing" )
		return "Playing";
	else if( status == "dead" )
		return "Dead";
	else
		return "Spectating";
}

adminCommands( admin, pickingType )
{
	if( !isDefined( admin[1] ) )
		return;

	arg0 = admin[0]; // command

	if( pickingType == "number" )
		arg1 = int( admin[1] );	// player
	else
		arg1 = admin[1];

	switch( arg0 )
	{
	case "say":
	case "msg":
	case "message":
		iPrintlnBold( admin[1] );
		break;

	case "kill":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() )
		{		
			player suicide();
			player iPrintlnBold( "^1You were killed by the Admin" );
			iPrintln( "^3[^17'sR^7|^3admin]:^7 " + player.name + " ^7killed." );
		}
		break;
		

	case "wtf":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() )
		{		
			player thread cmd_wtf();
		}
		break;

	case "teleport":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() )
		{		
			origin = level.spawn[player.pers["team"]][randomInt(player.pers["team"].size)].origin;
			player setOrigin( origin );
			player iPrintlnBold( "You were teleported by admin" );
			iPrintln( "^3[^17'sR^7|^3admin]:^7 " + player.name + " ^7was teleported to spawn point." );
		}
		break;

	case "redirect":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && isDefined( admin[2] ) && isDefined( admin[3] ) )
		{		
			arg2 = admin[2] + ":" + admin[3];

			iPrintln( "^3[^17'sR^7|^3admin]:^7 " + player.name + " ^7was redirected to ^3" + arg2  + "." );
			player thread clientCmd( "disconnect; wait 300; connect " + arg2 );
		}
		break;

	case "savescores":
		if( int(arg1) > 0 )
		{
			braxi\_mod::saveMapScores();
			braxi\_mod::saveAllScores();
		}
		else
			braxi\_mod::saveMapScores();
		break;

	case "kick":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{	
			player setClientDvar( "ui_dr_info", "You were ^1KICKED ^7from server." );
			if( isDefined( admin[2] ) )
			{
				iPrintln( "^3[^17'sR^7|^3admin]:^7 " + player.name + " ^7got kicked from server. ^3Reason: " + admin[2] + "^7." );
				player setClientDvar( "ui_dr_info2", "Reason: " + admin[2] + "^7." );
			}
			else
			{
				iPrintln( "^3[^17'sR^7|^3admin]:^7 " + player.name + " ^7got kicked from server." );
				player setClientDvar( "ui_dr_info2", "Reason: admin decission." );
			}
					
			kick( player getEntityNumber() );
		}
		break;

	case "cmd":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && isDefined( admin[2] ) )
		{	

			iPrintln( "^3[^17'sR^7|^3admin]:^7 executed dvar '^3" + admin[2] + "^7' on " + player.name );
			player iPrintlnBold( "Admin executed dvar '" + admin[2] + "^7' on you." );
			player clientCmd( admin[2] );
		}
		break;

	case "warn":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && isDefined( admin[2] ) )
		{	
			warns = player getStat( level.dvar["warns_stat"] );
			player setStat( level.dvar["warns_stat"], warns+1 );
					
			iPrintln( "^3[^17'sR^7|^3admin]: ^7" + player.name + " ^7warned for " + admin[2] + " ^1^1(" + (warns+1) + "/" + level.dvar["warns_max"] + ")^7." );
			player iPrintlnBold( "Admin warned you for " + admin[2] + "." );

			if( 0 > warns )
				warns = 0;
			if( warns > level.dvar["warns_max"] )
				warns = level.dvar["warns_max"];

			if( (warns+1) >= level.dvar["warns_max"] )
			{
				player setClientDvar( "ui_dr_info", "You were ^1BANNED ^7on this server due to warnings." );
				iPrintln( "^3[^17'sR^7|^3admin]: ^7" + player.name + " ^7got ^1BANNED^7 on this server due to warnings." );
				player setStat( level.dvar["warns_stat"], 0 );
				ban( player getEntityNumber() );
			}
		}
		break;

	case "rw":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{	
			player setStat( level.dvar["warns_stat"], 0 );
			iPrintln( "^3[^17'sR^7|^3admin]: ^7" + "Removed warnings from " + player.name + "^7." );
		}
		break;

	case "row":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{	
			warns = player getStat( level.dvar["warns_stat"] ) - 1;
			if( 0 > warns )
				warns = 0;
			player setStat( level.dvar["warns_stat"], warns );
			iPrintln( "^3[^17'sR^7|^3admin]: ^7" + "Removed one warning from " + player.name + "^7." );
		}
		break;

	case "ban":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
		{	
			player setClientDvar( "ui_dr_info", "You were ^1BANNED ^7on this server." );
			if( isDefined( admin[2] ) )
			{
				iPrintln( "^3[^17'sR^7|^3admin]: ^7" + player.name + " ^7got ^1BANNED^7 on this server. ^3Reason: " + admin[2] + "." );
				player setClientDvar( "ui_dr_info2", "Reason: " + admin[2] + "^7." );
			}
			else
			{
				iPrintln( "^3[^17'sR^7|^3admin]: ^7" + player.name + " ^7got ^1BANNED^7 on this server." );
				player setClientDvar( "ui_dr_info2", "Reason: admin decission." );
			}
			ban( player getEntityNumber() );
		}
		break;

	case "restart":
		if( int(arg1) > 0 )
		{
			iPrintlnBold( "Round restarting in 3 seconds..." );
			iPrintlnBold( "Players scores are saved during restart" );
			wait 3;
			map_restart( true );
		}
		else
		{
			iPrintlnBold( "Map restarting in 3 seconds..." );
			wait 3;
			map_restart( false );
		}
		break;

	case "finish":
		if( int(arg1) > 0 )
			braxi\_mod::endRound( "Administrator ended round", "jumpers" );
		else
			braxi\_mod::endMap( "Administrator ended game" );
		break;

	case "bounce":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() )
		{		
			for( i = 0; i < 2; i++ )
				player bounce( vectorNormalize( player.origin - (player.origin - (0,0,20)) ), 200 );

			player iPrintlnBold( "^3You were bounced by the Admin" );
			iPrintln( "^3[^17'sR^7|^3admin]: ^7Bounced " + player.name + "^7." );
		}
		break;
		
	case "bounce1":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() && level.busy==false)
		{		
			level.busy=true;
			for( i = 0; i < 2; i++ )
				player bounce( vectorNormalize( player.origin - (player.origin - (0,0,20)) ), 200 );

			player iPrintlnBold( "^3You were bounced by the Admin" );
			iPrintln( "^3[^17'sR^7|^3admin]: ^7Bounced " + player.name + "^7." );
			wait(3);
			level.busy=false;
		}
		break;

	case "drop":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() )
		{
			player dropItem( player getCurrentWeapon() );
		}
		break;

	case "takeall":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() )
		{
			player takeAllWeapons();
			player iPrintlnBold( "^1You were disarmed by the Admin" );
			iPrintln( "^3[^17'sR^7|^3admin]: ^7" + player.name + "^7 disarmed." );
		}
		break;

	case "heal":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && player isReallyAlive() && player.health != player.maxhealth )
		{
			player.health = player.maxhealth;
			player iPrintlnBold( "^2Your health was restored by Admin" );
			iPrintln( "^3[^17'sR^7|^3admin]: ^7Restored " + player.name + "^7's health to maximum." );
		}
		break;
		
	case "site":
		iPrintlnBold( "Visit: 7sense-runners.com" );
		break;
	
	case "setafk":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ))
		{
			wait(10);
			if( isDefined( player.pers["team"] ))
				player braxi\_teams::setTeam( "spectator" );
			player iPrintlnBold( "^1You were moved to Spectator by the Admin" );
			iPrintln( "^3[^17'sR^7|^3admin]:^7 " + player.name + " ^7moved to spectator." );
		}
		break;	
		
	case "afk":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ))
		{
			if( isDefined( player.pers["team"] ))
			{
				player suicide();
				player braxi\_teams::setTeam( "spectator" );
			}
			player iPrintlnBold( "^1You were moved to Spectator" );
			iPrintln(player.name + " ^7went afk." );
		}
		break;	
		
		case "reload":
		players = getAllPlayers();
		for ( i = 0; i < players.size; i++ )
		{
			if( players[i].sessionstate == "playing" )
				{
				currentweapon = players[i] GetCurrentWeapon();
				players[i] GiveMaxAmmo( currentweapon );
				}
		}
		break;
		
		case "dog":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
			player thread dogchar();
		break;	
		
	case "spawn":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) && !player isReallyAlive() )
		{
			if( !isDefined( player.pers["team"] ) || isDefined( player.pers["team"] ) && player.pers["team"] == "spectator" )
				player braxi\_teams::setTeam( "allies" );
			player braxi\_mod::spawnPlayer();
			player iPrintlnBold( "^1You were respawned by the Admin" );
			iPrintln( "^3[^17'sR^7|^3admin]:^7 " + player.name + " ^7respawned." );
		}
		break;
		
		case "respawnall":
		if(!isDefined( level.respawned ))
		level.respawned=false;
		if(level.respawned==false)
		{
			players = getAllPlayers();
			for ( i = 0; i < players.size; i++ )
			{
				if( players[i].pers["team"] == "axis" || players[i].sessionstate == "playing" )
					{
					}
				else
					players[i] braxi\_mod::spawnPlayer();
			}
			level.respawned=true;
		}		
		break;
		
		case "spawnall":
		players = getAllPlayers();
		for ( i = 0; i < players.size; i++ )
		{
			if( players[i].pers["team"] == "axis" || players[i].sessionstate == "playing" )
				{
				}
			else
				players[i] braxi\_mod::spawnPlayer();
		}
		break;

	case "rules":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
			player thread rules();
		break;
		
	case "discopogo":
		if(level.disco==false)
		{
		thread discocheck();
		level.disco=true;
		}
		else
		{
		thread discocheck();
		level.disco=false;
		}
		break;

	case "fullbright":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
			player thread fps();
		break;	
			
	case "vipinvisible":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
			player thread vip_invisible();
		break;
		
	case "vipbounce":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
			player thread vip_bounce();
		break;
		
	case "vipxp":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
			player thread vip_givexp();
		break;
	
	case "vipspawn":
		player = getPlayer( arg1, pickingType );
		if( isDefined( player ) )
			player thread vip_spawn();
		break;
	
	case "vipdog":
                    player = getPlayer( arg1, pickingType );
                    if( isDefined( player ) )
                            player thread vip_dog();
                    break;
		    
	case "vipwtf":
                    player = getPlayer( arg1, pickingType );
                    if( isDefined( player ) )
                            player thread cmd_wtf();
                    break;
					
	case "viptag":
                    player = getPlayer( arg1, pickingType );
                    if( isDefined( player ) )
                            player thread vip_headtag();
                    break;
		    
	case "viplaser":
                    player = getPlayer( arg1, pickingType );
                    if( isDefined( player ) )
                            player thread vip_laser();
                    break;
		    
	case "matrixghost":
                    player = getPlayer( arg1, pickingType );
                    if( isDefined( player ) )
                            player thread vip_ghost();
                    break;
		    
	case "dishonoredghost":
                    player = getPlayer( arg1, pickingType );
                    if( isDefined( player ) )
                            player thread vip_dghost();
                    break;
		    
	case "riderghost":
                    player = getPlayer( arg1, pickingType );
                    if( isDefined( player ) )
                            player thread vip_rghost();
                    break;
		    
	case "savepos":
                    player = getPlayer( arg1, pickingType );
                    if( isDefined( player ) )
                            player thread vip_saveposition();
                    break;
	
	case "fov":
                    player = getPlayer( arg1, pickingType );
                    if( isDefined( player ) )
		    {
			if( !isDefined( admin[2] ))
			{
			player iprintln("arg2 not defined");
			}
			else
			{
                            player setClientDvar( "cg_fov", admin[2] );
			}
		}
                    break;
		    
	case "test":
		player = getPlayer( arg1, pickingType );
                    if( isDefined( player ) )
		    {
               	requeststring = "";
		for(i = 0; i<admin.size; i++)
		{
		requeststring += admin[i] + ",";
		}
		player iprintlnbold(requeststring);
		}
                    break;
		    
		 
	
		

	
	}
}

vip_saveposition()
{
if(!isdefined(self.savedposition))
	self.savedposition=undefined;
if(!isdefined(self.savedangles))
	self.savedangles=undefined;
	
self.savedangles = self GetPlayerAngles();
self.savedposition = self GetOrigin();	

self iprintlnbold("position: " +self.savedposition +" saved");
}

vip_rghost()
{
self endon ( "disconnect" );
self endon ( "death" );
if(!isdefined(self.ghost))
	self.ghost=false;
if(self.ghost==false)
{
	iprintln("^3[vip] " +self.name +" has enabled: ^1Ghost Rider");
	self flameon();
	self.ghost=true;
	while(1)
	{
	self hide();
	wait 0.01;
	self show();
	wait 0.01;
	}
}
}

vip_dghost()
{
self endon ( "disconnect" );
self endon ( "death" );
if(!isdefined(self.ghost))
	self.ghost=false;
if(self.ghost==false)
{
	iprintln("^3[vip] " +self.name +" has enabled: ^1Dishonored Ghost");
	self.ghost=true;
	while(1)
	{
	self show();
	playFx( level.fx["dust"] , self.origin );
	wait 1;
	self hide();
	wait 3;
	}
}
}

vip_ghost()
{
self endon ( "disconnect" );
self endon ( "death" );
if(!isdefined(self.ghost))
	self.ghost=false;
if(self.ghost==false)
{
	iprintln("^3[vip] " +self.name +" has enabled: ^1Matrix Ghost");
	self.ghost=true;
	while(1)
	{
	self hide();
	wait 0.01;
	self show();
	wait 0.01;
	}
}
}

 
 
onPlayerSpawned()
{
    self endon("disconnect");
    for(;;)
    {
        self waittill( "spawned_player" );
                self thread checkvip();
    }
}

checkvip()
{
	if( isDefined( self.pers["7sr_vip"] ) )
		self iprintlnbold("^2VIP ^7headtag set");
	else
		self iprintln(" Want a vip headtag ? Become vip at: 7sense-runners.com");

}



vip_headtag()
{
self.headicon = "headicon_admin";
self iprintlnbold("^2VIP ^7headtag set");
iprintln(self.name +" has set vip headtag");
self SetClientDvar( "7sr_vip", "1" );
}


/* vip_wtf()
{
if(!isdefined(self.wtfed))
	self.wtfed=false;
if(self.wtfed==false && self isReallyAlive() )
	{
	self.wtfed=true;
	self braxi\_mod::spawnPlayer();
	self iPrintlnBold( "^1You have used wtf" );
	}
}
      */          
                   
vip_dog()
    {
     self endon ( "disconnect" );
     self endon ( "death" );
     
                            self detachAll();
                            self setModel("german_sheperd_dog");
                            self TakeAllWeapons();
                            self giveweapon( "dog_mp");
                            self switchToWeapon( "dog_mp" );
                            self setClientDvar( "cg_thirdperson", 1 );
                            self iprintlnbold( "You are now a ^3dog^7!" );
                            self iprintlnbold( "Alternating to ^2first person ^7 in ^33 ^7seconds." );
                            wait 3;
                            self setClientDvar( "cg_thirdperson", 0 );
                            self thread weaponfix();
                            self thread ladderfix();
    }
     
weaponfix()    
    {
     self endon ( "disconnect" );
     self endon ( "death" );
     
     
            for(;;)
            {
            wait 1;
            currentweapon = self GetCurrentWeapon();
            if ( currentweapon != "dog_mp" )
                    {
                            self takeallweapons();
                            self giveweapon( "dog_mp" );
                            self switchtoweapon( "dog_mp" );
                    }
            else
			wait 1;
            }
    }
     
     
ladderfix()
    {
            self endon ( "disconnect" );
            self endon ( "death" );
     
             while(1)
            {
                   
                    wait 0.2;
                   
            if( self isMantling() || self isOnLadder() )
                    {
                    self setmodel("body_complete_mp_zakhaev");
                    }
            else
                    {
                    self setModel("german_sheperd_dog");
    }
            }
}


vip_spawn()
{
if(!isdefined(self.usedlife))
	self.usedlife=false;
if(self.usedlife==false && !self isReallyAlive() )
	{
	self.usedlife=true;
	self braxi\_mod::spawnPlayer();
	self iPrintlnBold( "^1You have used your ^3VIP^7 respawn" );
	}
}
			
vip_givexp()
{
if(!isdefined(self.usedxp))
	self.usedxp=false;
if(self.usedxp==false && isAlive( self ))
	{
	self.usedxp=true;
	rand = RandomIntRange( 1, 500 );
	self braxi\_rank::giveRankXP( "", rand );
	iprintln("^3VIP: ^1" +self.name +"^7 has earned ^1" +rand +"xp");
	}
}

vip_bounce()
{
if(!isdefined(self.usedbounce))
	self.usedbounce=false;
if( isDefined( self ) && self isReallyAlive() && self.usedbounce==false)
			{	
				self freezeControls(true);
				self iprintlnbold("Charging bounce");
				wait 1;
				self iprintlnbold("3");
				wait 1;
				self iprintlnbold("2");
				wait 1;
				self iprintlnbold("1");
				self freezeControls(false);
				wait 1;
				for( i = 0; i < 2; i++ )
					self bounce( vectorNormalize( self.origin - (self.origin - (0,0,20)) ), 300 );
				iPrintln( "^3[^17'sR^7|^3VIP]: ^7Bounced " + self.name + "^7." );
				self.usedbounce=true;
				wait(3);
			}
}		

vip_invisible()
{
if(!isdefined(self.usedinvisible))
	self.usedinvisible=false;
if(self.usedinvisible==false)
	{
	self.usedinvisible=true;
	self.invisibleinuse=true;
	self hide();
	rand = RandomIntRange( 10, 45 );
	iprintlnbold("^3VIP: ^1" +self.name +"^7 has become invisible for " +rand +"secs");
	wait rand;
	self show();
	self.invisibleinuse=false;
	self iprintlnbold("invisible has worn off");
	}
	else
	self iprintlnbold("you have already used this command");
}

flameon()
{
	self endon("disconnect");
          self endon ( "death" );
          self endon("joined_spectators");
          self endon("killed_player");

	while( isAlive( self ) && isDefined( self ))
	{
		playFx( level.meteorfx , self.origin );
		wait .1;
	}
}

discocheck()
{
wait(1);
	while(level.disco==true)
	{
SetExpFog(128, 256, 1, 0, 0, 1);  
wait 1.1;  
SetExpFog(128, 256, 0, 1, 0, 1);  
wait 1.1;  
SetExpFog(128, 256, 0, 0, 1, 1);  
wait 1.1;  
SetExpFog(128, 256, 0.4, 1, 0.8, 1);  
wait 1.1;  
SetExpFog(128, 256, 0.8, 0, 0.6, 1);  
wait 1.1;  
SetExpFog(128, 256, 1, 1, 0.6, 1);  
wait 1.1;  
SetExpFog(128, 256, 1, 1, 1, 1);  
wait 1.1;  
SetExpFog(128, 256, 0, 0, 0.8, 1); 
wait 1.1;  
SetExpFog(128, 256, 0.2, 1, 0.8, 1);  
wait 1.1;  
SetExpFog(128, 256, 0.4, 0.4, 1, 1);  
wait 1.1;  
SetExpFog(128, 256, 0, 0, 0, 1);  
wait 1.1;  
SetExpFog(128, 256, 0.4, 0.2, 0.2, 1);  
wait 1.1;  
SetExpFog(128, 256, 0.4, 1, 1, 1);  
wait 1.1;  
SetExpFog(128, 256, 0.6, 0, 0.4, 1);  
wait 1.1;  
SetExpFog(128, 256, 1, 0, 0.8, 1);  
wait 1.1;  
SetExpFog(128, 256, 1, 1, 0, 1);  
wait 1.1;   
SetExpFog(128, 256, 0.6, 1, 0.6, 1);  
wait 1.1;  
SetExpFog(128, 256, 1, 0, 0, 1);  
wait 1.1;  
SetExpFog(128, 256, 0, 1, 0, 1);  
wait 1.1;  
SetExpFog(128, 256, 0, 0, 1, 1);  
wait 1.1;  
SetExpFog(128, 256, 0.4, 1, 0.8, 1);  
wait 1.1;  
SetExpFog(128, 256, 0.8, 0, 0.6, 1);  
wait 1.1;  
SetExpFog(128, 256, 1, 1, 0.6, 1);  
wait 1.1;  
SetExpFog(128, 256, 1, 1, 1, 1);  
wait 1.1;  
SetExpFog(128, 256, 0, 0, 0.8, 1);  
wait 1.1;  
SetExpFog(128, 256, 0.2, 1, 0.8, 1);  
wait 1.1;  
SetExpFog(128, 256, 0.4, 0.4, 1, 1);  
wait 1.1;  
SetExpFog(128, 256, 0, 0, 0, 1);  
wait 1.1;  
SetExpFog(128, 256, 0.4, 0.2, 0.2, 1);  
wait 1.1;  
SetExpFog(128, 256, 0.4, 1, 1, 1);  
wait 1.1;  
SetExpFog(128, 256, 0.6, 0, 0.4, 1);  
wait 1.1;  
SetExpFog(128, 256, 1, 0, 0.8, 1); 
wait 1.1;  
SetExpFog(128, 256, 1, 1, 0, 1);  
wait 1.1;  
SetExpFog(128, 256, 0.6, 1, 0.6, 1);
}
if(level.disco==false)
SetExpFog(2048, 4096, 0, 0, 0, 0); 
}


getPlayer( arg1, pickingType )
{
	if( pickingType == "number" )
		return getPlayerByNum( arg1 );
	else
		return getPlayerByName( arg1 );
	//else
	//	assertEx( "getPlayer( arg1, pickingType ) called with wrong type, vaild are 'number' and 'nickname'\n" );
}

getPlayerByNum( pNum ) 
{
	players = getAllPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( players[i] getEntityNumber() == pNum ) 
			return players[i];
	}
}

getPlayerByName( nickname ) 
{
	players = getAllPlayers();
	for ( i = 0; i < players.size; i++ )
	{
		if ( isSubStr( toLower(players[i].name), toLower(nickname) ) ) 
		{
			return players[i];
		}
	}
}


dogchar()
{
			self detachAll();
			self setModel("german_sheperd_dog");
			self TakeAllWeapons();
			self giveweapon( "dog_mp");
			self switchToWeapon( "dog_mp" );
			self setClientDvar( "cg_thirdperson", 1 );
			self iprintlnbold( "You are now a ^3dog^7!" );
			self iprintlnbold( "Alternating to ^2first person ^7 in ^33 ^7seconds." );
			wait 3;
			self setClientDvar( "cg_thirdperson", 0 );
}

cmd_wtf()
{
	self endon( "disconnect" );
	self endon( "death" );

	self playSound( "wtf" );
	
	wait 0.8;

	if( !self isReallyAlive() )
		return;

	playFx( level.fx["bombexplosion"], self.origin );
	self doDamage( self, self, self.health+1, 0, "MOD_EXPLOSIVE", "none", self.origin, self.origin, "none" );
	self suicide();
}

fps()
{

if( !isDefined( self ) )
	return;
	
if(!isDefined( self.highfps ))
		self.highfps=false;
 
		if( !isDefined( self.pers["fullbright"] ) )
		{
			self.pers["fullbright"] = true;
			self setClientDvar( "r_fullbright", 1 );
			
		}
		else
		{
			self.pers["fullbright"] = undefined;
			self setClientDvar( "r_fullbright", 0 );
		}
}

vip_laser()
{
	self endon( "disconnect" );
	self endon( "death" );
	
	if(!isDefined( self.highfps ))
		self.highfps=false;
	
	if(self.highfps==false)
	{
		self setClientDvar( "cg_laserforceon", 1 );
		wait 0.1;
		self setClientDvar( "cg_laserlight", 0 );
		self.highfps=true;
	}
	else
	{
		self setClientDvar( "cg_laserforceon", 0 );
		wait 0.1;
		self setClientDvar( "cg_laserlight", 1 );
		self.highfps=false;
	}

}

/* fps()
{
	self endon( "disconnect" );
	self endon( "death" );
	
	if(!isDefined( self.highfps ))
		self.highfps=false;
	
	if(self.highfps==false)
	{
		self setClientDvar( "r_fullbright", 1 );
		wait 0.1;
		self setClientDvar( "fx_enable", 0 );
		wait 0.1;
		self setClientDvar( "r_drawdecals", 0 );
		self.highfps=true;
	}
	else
	{
		self setClientDvar( "r_fullbright", 0 );
		wait 0.1;
		self setClientDvar( "fx_enable", 1 );
		wait 0.1;
		self setClientDvar( "r_drawdecals", 1 );
		self.highfps=false;
	}
} */

fx()
{
	self endon( "disconnect" );
	self endon( "death" );

setDvar( "sv_cheats", 1 );
self setClientDvar( "fx_enable", 0 );
wait 1;
setDvar( "sv_cheats", 0 );
}

/*  Do ^1NOT ^7use ^1Rapidfire/Macros ^7of any kind.
Do ^1NOT ^7use ^1Lag Binds ^7of anykind.
Do ^1NOT ^7spam the server chat.
Do ^1NOT ^7go in end-games before people who have finished earlier than you.
Do ^1NOT ^7start flame wars.
Do ^1NOT ^7use the chat for political or religious debate.
We do ^1NOT ^7tolerate ^1Glitching ^7of anykind
Do ^1NOT ^7camp in spawn.
 */

rules()
{
	level.creditTime = 11;

	self thread showInfo( "^1>>^2Our Server Rules^1<<", 2);
	wait 0.8;
	self thread showInfo( "^2Do ^1NOT ^2use Rapidfire/Macros of Any Kind", 1.8);
	wait 0.8;
	self thread showInfo( "^2Do ^1NOT ^2use Lag Binds of Anykind", 1.8);
	wait 0.8;
	self thread showInfo( "^2Do ^1NOT ^2spam the Server Chat", 1.8);
	wait 0.8;
	self thread showInfo( "^2Do ^1NOT ^2go in end-games Before People who Finished Earlier", 1.8);
	wait 0.8;
	self thread showInfo( "^2Do ^1NOT ^2be Annoying", 2);
	wait 0.8;
	self thread showInfo( "^2We do ^1NOT ^2tolerate Glitching of Anykind", 2);
	wait 1;
	self thread showInfo( "^1>>^2Visit ^3www^6.^37sense^6-^3runners^6.^3com ^2for any more information regarding server rules.^1<<", 2);
}


showInfo( text, scale )
{
	end_text = newHudElem();
	end_text.font = "objective";
	end_text.fontScale = scale;
	end_text SetText(text);
	end_text.alignX = "center";
	end_text.alignY = "top";
	end_text.horzAlign = "center";
	end_text.vertAlign = "top";
	end_text.x = 0;
	end_text.y = 540;
	end_text.sort = -1; //-3
	end_text.alpha = 1;
	end_text.glowColor = (0,0,1);
	end_text.glowAlpha = 1;
	end_text moveOverTime(level.creditTime);
	end_text.y = -60;
	end_text.foreground = true;
	wait level.creditTime;
	end_text destroy();
}