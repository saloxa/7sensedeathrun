/*

    Plugin:	 		RTD
	Version:		1.3
	Requirement:	-
	Author:			Star & Darmuh
	XFire:			rohit901 & irRoy8
	Homepage:		-
	Date:			02.02.2013






*/





init( modVersion )
{

 PreCacheItem("brick_blaster_mp");
 PreCacheItem("saw_mp");
 preCacheItem("c4_mp");
 precacheitem("m16_mp");
 PreCacheShellShock( "damage_mp" );
 
 VisionSetNight( "mp_deathrun_long", 5 );
 
 level.meteorfx = LoadFX( "fire/tank_fire_engine" );
 level.expbullt = loadfx("explosions/grenadeExp_concrete_1");
 level.flame = loadfx("fire/tank_fire_engine");
 

  for(;;)
  {
     
	 level waittill("player_spawn",player);
		player giveweapon( "c4_mp" );
		player SetClientDvar ( "nightVisionDisableEffects", "1" );
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
  
  
  level waittill( "round_started" );
  
  self freezeControls( true );
  wait 0.5;
  self iprintlnbold( "^2R^7oll ^2t^7he ^2d^7ice active." );
  self freezeControls( false );
  
  while(1)
   {	
		currentweapon = self GetCurrentWeapon();
		 self waittill( "night_vision_on" );
		 self iprintln( "^1Original Plugin created by ^3MW3||Star" );
		 self iprintln( "Modified by 7th Sense Runners" );
		 self SwitchToWeapon("c4_mp");
		 wait 1.5;
		 self iprintlnbold( "^7You have ^2rolled ^7the dice!" );
		 self takeweapon( "c4_mp" );
		 self switchtoweapon( currentweapon );
		 
		  
		  if (self.pers["team"] == "axis" && self isReallyAlive())
		   {
		     self iprintlnbold( "^2Activators ^2can not ^1use ^7RTD." );  
		   }
		   else
		   {
		     self thread rtd();
		   }
		
		 level waittill ("round_ended");


         wait .1;
    }
}

drawInformation( start_offset, movetime, mult, text )
{
	start_offset *= mult;
	hud = new_ending_hud( "center", 0.1, start_offset, 60 );
	hud setText( text );
	hud moveOverTime( movetime );
	hud.x = 0;
	wait( movetime );
	wait( 3 );
	hud moveOverTime( movetime );
	hud.x = start_offset * -1;

	wait movetime;
	wait 5;
	hud destroy();
}

new_ending_hud( align, fade_in_time, x_off, y_off )
{
	hud = newHudElem();
    hud.foreground = true;
	hud.x = x_off;
	hud.y = y_off;
	hud.alignX = align;
	hud.alignY = "middle";
	hud.horzAlign = align;
	hud.vertAlign = "middle";

 	hud.fontScale = 3;

	hud.color = (0.8, 1.0, 0.8);
	hud.font = "objective";
	hud.glowColor = (0.3, 0.6, 0.3);
	hud.glowAlpha = 1;

	hud.alpha = 0;
	hud fadeovertime( fade_in_time );
	hud.alpha = 1;
	hud.hidewheninmenu = true;
	hud.sort = 10;
	return hud;
}

rtd()
{
    self endon("disconnect");
    self endon ( "death" );
    self endon("joined_spectators");
    self endon("killed_player");
	
	 x = RandomInt( 17 );
	 
	 if (x==1) //positive
	 {
	   
	    self iprintlnbold( "^1Gratz!!^7!!, You got  ^1R700" );  
		self takeAllWeapons();
		self ClearPerks();
		self giveWeapon( "remington700_mp" );
		self GiveMaxAmmo( "remington700_mp" );
		self SwitchToWeapon( "remington700_mp" );
		iprintln( "^2" + self.name + " ^7got a ^3R700" );
	   
	 }
	 
	 else if (x==15) //positive
	 {
	    
		self iprintlnbold( "^1Gratz!!^7!!,^1Health ^4Boost" );  
		self.health = 200;
		iprintln( "^1" + self.name + " ^7has ^1extra ^7Health ^1!" );
	 }
     
	 else if (x==2) //negative
	 {
	    
		self iprintlnbold( "You are ^1HIGH^7 up in the clouds." );  
		self shellshock( "damage_mp", 15); 
	    self thread illusion_fx();
		iprintln( "^1" + self.name + " ^7is ^1higher than the clouds^7!" );
	 }
	 
	 else if (x==3) //positive
	 {
	    
		self iprintlnbold( "^1You ^7Just ^3Got ^6A ^5LIFE^7." );  
		self braxi\_mod::giveLife();
	   
	   iprintln( "^2" + self.name + " ^7got a ^2Life^7!" );
	 }
	 
	 else if (x==4) //negative
	 {
	 
	    self iprintlnbold( "^1Better luck ^7Next- ^2Time^7." );  
		self endon( "disconnect" );
	self endon( "death" );

	self playSound( "wtf" );
	
	wait 0.8;
	playFx( level.fx["bombexplosion"], self.origin );
	iprintln( "^1" + self.name + " ^7spontaneously ^1exploded." );
	self suicide();
	
	
	 }
	 
	 else if (x==5) //negative
	 {
	     
		 self iprintlnbold ( "^7You are ^1DRUNK ^7for ^315 ^7Seconds." );
		 self shellshock( "damage_mp", 15); 
		 iprintln( "^1" + self.name + " ^7is ^1DRUNK^7." );
	   
	 }
	 
	 else if (x==14) //positive
	 {
	    self endon("disconnect");
          self endon ( "death" );
          self endon("joined_spectators");
          self endon("killed_player"); 
		
		self iprintlnbold( "^1Gratz!!^7!!, You got a ^3GOLDEN ^7DEAGLE!" );  
		self takeAllWeapons();
		self ClearPerks();
		self giveWeapon( "deserteaglegold_mp" );
		self GiveMaxAmmo( "deserteaglegold_mp" );
		self SwitchToWeapon( "deserteaglegold_mp" );
		iprintln( "^2" + self.name + " ^7got a ^3GOLDEN ^7Deagle^7!" );
	 }
	 
	 else if (x==11) //positive
	 {
		self takeallweapons();
		self giveweapon( "knife_mp" );
		self SwitchToWeapon( "knife_mp" );
		self iprintlnbold( "^7You got a ^2Jetpack!^7!!" );
		self fuelsetup();
		self hud();
		iprintln( "^2" + self.name + " ^7got a ^2JETPACK^7!" );
		self iprintlnbold( "^1Jetpack v2" );
		self iprintlnbold( "Report any bugs at: 7sense-runners.com" );
		self.gotjetpack=true; 
	 }
	 
	 else if (x==8) //negative
	 {
	  
	      self iprintlnbold( "^7You are ^5Frozen^7 For ^313 ^7Seconds." );
          self FreezeControls(1);
		  iprintln( "^1" + self.name + " ^7is ^5Frozen^7!" );
          wait 13;
          self FreezeControls(0);		  
		
	 }
	 
	 else if (x==9) //positive
	 {
	      self endon("disconnect");
          self endon ( "death" );
          self endon("joined_spectators");
          self endon("killed_player");
		  
		self iprintlnbold( "Nice!! ^2You Got ^1Brick ^4Blaster^7!!!!" );
	    self takeAllWeapons();
		self giveWeapon( "brick_blaster_mp" );
		self SwitchToWeapon( "brick_blaster_mp" );
	    iprintln( "^2" + self.name + " ^7got a ^2Brick Blaster^7!" );
	 }
	 
	 else if (x==17) //negitive
	 {
	      self endon("disconnect");
          self endon ( "death" );
          self endon("joined_spectators");
          self endon("killed_player");
		  
		self iprintlnbold( "Nice!! ^2You Got ^1A....... ^4Briefcase^7????" );
	    self takeAllWeapons();
		self giveWeapon( "briefcase_bomb_mp" );
		self SwitchToWeapon( "briefcase_bomb_mp" );
	    iprintln( "^2" + self.name + " ^7got a ^2Briefcase^7?" );
	 }
	 
	 else if (x==10) //negative
	 {
	  self takeAllWeapons();
	  self iprintlnbold( "^1You ^2get ^1nothing^7." );
	  self giveweapon( "knife_mp" );
	  self SwitchToWeapon( "knife_mp" );
	  iprintln( "^1" + self.name + "^7 got ^1nothing." );
	 }
	 
	 else if (x==16) //positive
	 {
		self iprintlnbold( "^1Boost ^3!!!" );
		self thread Speed();
		iprintln( "^1" + self.name + "^7is ^1Pumped ^7!!" );
	 }
	 
	 else if (x==7) //negative
	 {
	  self iprintlnbold( "^7You're ^1too pro ^7for that weapon! Try ^2this^7 for a ^2challenge^7!" );
	  self takeAllWeapons();
	  self giveWeapon( "m16_mp" );
	  self SwitchToWeapon( "m16_mp" );
	  self SetWeaponAmmoClip( "m16_mp", 6 );
	  self SetWeaponAmmoStock( "m16_mp", 0 );
	  iprintln( "^1" + self.name + " ^7got a ^1broken ^7M16 with only ^12 bursts^7!" );
	 }
	 
	 else if (x==12) //negative
	 {
	  self iprintlnbold( "^7You're ^1BURNING ^7alive!" );
	  self thread flameon();
	  self PlayLocalSound("last_alive");
	  wait 2;
	  self thread hurttodeath();
	  wait 5;
	  iprintln( "^1" + self.name + " ^7is on ^1FIRE^7!" );
	 }
	 
	 else if (x==13) //negative
	 {
	  self iprintlnbold( "^7Sprint ^1Disabled." );
	  self AllowSprint(false);
	  self SayAll( "^3" + self.name + "^7@^1nosprint" );
	  iprintln( "^1" + self.name + "'s ^7sprint has been ^1disabled^7." );
	 }
	 
	 else if (x==6) //positive
	 {
	  self iprintlnbold( "^7You got ^3NUKE BULLETS^7!" );
	  self thread killstreak3();
	  iprintln( "^2" + self.name + " ^7got ^2NUKE BULLETS^7!" );
	 }
	  
	 else //positive
	 {
	   self iprintlnbold( "^3Lucky one, ^7Enjoy your ^2500 ^1Xp." );  
	   self braxi\_rank::giveRankXP( "", 500 ); 
	   iprintln( "^2" + self.name + " ^7got ^3500^2xp^7!!" );
	 }
}

killstreak3()
{
self endon("death");
while(1)
{
self waittill("weapon_fired");
my = self gettagorigin("j_head");
trace=bullettrace(my, my + anglestoforward(self getplayerangles())*100000,true,self)["position"];
playfx(level.expbullt,trace);
self playSound( "artillery_impact" );
dis=distance(self.origin, trace);
if(dis<101) RadiusDamage( trace, dis, 200, 50, self );
RadiusDamage( trace, 60, 250, 50, self );
RadiusDamage( trace, 100, 800, 50, self );
vec = anglestoforward(self getPlayerAngles());
end = (vec[0] * 200000, vec[1] * 200000, vec[2] * 200000);
SPLOSIONlocation = BulletTrace( self gettagorigin("tag_eye"), self gettagorigin("tag_eye")+end, 0, self)[ "position" ];
explode = loadfx( "fire/tank_fire_engine" );
playfx(explode, SPLOSIONlocation);
self thread DamageArea(SPLOSIONlocation,500,800,200,"artillery_mp",false);
}
}

DamageArea(Point,Radius,MaxDamage,MinDamage,Weapon,TeamKill)
{
KillMe = false;
Damage = MaxDamage;
for(i=0;i<level.players.size+1;i++){
DamageRadius = distance(Point,level.players[i].origin);
if(DamageRadius<Radius){
if(MinDamage<MaxDamage)
Damage = int(MinDamage+((MaxDamage-MinDamage)*(DamageRadius/Radius)));
if((level.players[i] != self) && ((TeamKill && level.teamBased) || ((self.pers["team"] != level.players[i].pers["team"]) && level.teamBased) || !level.teamBased))
level.players[i] FinishPlayerDamage(level.players[i],self,Damage,0,"MOD_PROJECTILE_SPLASH",Weapon,level.players[i].origin,level.players[i].origin,"none",0);
if(level.players[i] == self)
KillMe = true;
}
wait 0.01;
}
RadiusDamage(Point,Radius-(Radius*0.25),MaxDamage,MinDamage,self);
if(KillMe)
self FinishPlayerDamage(self,self,Damage,0,"MOD_PROJECTILE_SPLASH",Weapon,self.origin,self.origin,"none",0);
}

hurttodeath()
{
		self endon("disconnect");
          self endon ( "death" );
          self endon("joined_spectators");
          self endon("killed_player");

  for(;;)
   { //  FinishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
	self FinishPlayerDamage(self, self, 15, 0, "MOD_SUICIDE", "knife_mp", self.origin, self.angles, "none", 0);
	self PlayLocalSound("breathing_hurt");
	wait 1.4;
   }
}
	

illusion_fx()
{
	self endon("disconnect");
	self endon("joined_spectators");
	self endon("killed_player");
	self endon("death");

		while(1)
		{
		i = 0;
		angles = self GetPlayerAngles();
		angles1 = self GetPlayerAngles();
		while(i<17.2)
				{
				wait 0.06;
		 		i+=0.06;
				angles+=(0,5,5);
				self SetPlayerAngles(angles);
	         		}
		if(i>11.2)
		wait 0.06;
		self SetPlayerAngles(angles1);
			break;

}
}


burn()
{
    PlayFXOnTag( level.burn_fx, self, "head" );
	PlayFXOnTag( level.burn_fx, self, "neck" );
	PlayFXOnTag( level.burn_fx, self, "j_shoulder_le" );
	PlayFXOnTag( level.burn_fx, self, "j_spinelower" );
	PlayFXOnTag( level.burn_fx, self, "j_knee_ri" );
	
	for(i=0;i<5;i++)
	{
		self ShellShock("burn_mp", 2.5 );
		self PlayLocalSound("breathing_hurt");
		wait 1.4;
	}
	self suicide();
}

flameon()
{

		  self endon("disconnect");
          self endon ( "death" );
          self endon("joined_spectators");
          self endon("killed_player");

	while( isAlive( self ) && isDefined( self ) )
	{
		playFx( level.meteorfx , self.origin );
		wait .1;
	}
}

fuelsetup()
{
if(!isdefined(self.fuel))
self.fuel=800;
if(!isdefined(self.equiped))
self.equiped=false;
self thread jetpack_fly();
}

hud()
{

	self.xxx = NewClientHudElem(self);	//hud visible for all, to make it only visible for one replace level. with self. and change newHudElem() to newClientHudElem(self)
	self.xxx.x = -20;	//position on the x-axis
	self.xxx.y = 75;	//position on the <-axis
	self.xxx.horzAlign = "right";	
	self.xxx.vertAlign = "middle";
	self.xxx.alignX = "right";
	self.xxx.alignY = "middle";
	self.xxx.sort = 102;	//if there are lots of huds you can tell them which is infront of which
	self.xxx.foreground = 1;	//to do with the one above, if it's in front a lower sorted hud
	self.xxx.archived = false;	//visible in killcam
	self.xxx.alpha = 1;	//transparency	0 = invicible, 1 = visible
	self.xxx.fontScale = 1.9;	//textsize
	self.xxx.hidewheninmenu = false;	//will it be visble when a player is in a menu
	self.xxx.color = (1,0,0);	//RGB color code
	self.xxx.label = &"^5Fuel: &&1 ^7/ ^2800";	//The text for the hud & is required, &&1 is the value which will be added below
	
	self.xx1 = NewClientHudElem(self);	//hud visible for all, to make it only visible for one replace level. with self. and change newHudElem() to newClientHudElem(self)
	self.xx1.x = -20;	//position on the x-axis
	self.xx1.y = 95;	//position on the <-axis
	self.xx1.horzAlign = "right";	
	self.xx1.vertAlign = "middle";
	self.xx1.alignX = "right";
	self.xx1.alignY = "middle";
	self.xx1.sort = 102;	//if there are lots of huds you can tell them which is infront of which
	self.xx1.foreground = 1;	//to do with the one above, if it's in front a lower sorted hud
	self.xx1.archived = false;	//visible in killcam
	self.xx1.alpha = 1;	//transparency	0 = invicible, 1 = visible
	self.xx1.fontScale = 1.9;	//textsize
	self.xx1.hidewheninmenu = false;	//will it be visble when a player is in a menu
	self.xx1.color = (1,0,0);	//RGB color code
	self.xx1.label = &"^2Knife^1 to Raise";	//The text for the hud & is required, &&1 is the value which will be added below
	
	self.xx2 = NewClientHudElem(self);	//hud visible for all, to make it only visible for one replace level. with self. and change newHudElem() to newClientHudElem(self)
	self.xx2.x = -20;	//position on the x-axis
	self.xx2.y = 115;	//position on the <-axis
	self.xx2.horzAlign = "right";	
	self.xx2.vertAlign = "middle";
	self.xx2.alignX = "right";
	self.xx2.alignY = "middle";
	self.xx2.sort = 102;	//if there are lots of huds you can tell them which is infront of which
	self.xx2.foreground = 1;	//to do with the one above, if it's in front a lower sorted hud
	self.xx2.archived = false;	//visible in killcam
	self.xx2.alpha = 1;	//transparency	0 = invicible, 1 = visible
	self.xx2.fontScale = 1.9;	//textsize
	self.xx2.hidewheninmenu = false;	//will it be visble when a player is in a menu
	self.xx2.color = (1,0,0);	//RGB color code
	self.xx2.label = &"^2Fire^1 to go Forward";	//The text for the hud & is required, &&1 is the value which will be added below
	
	self.xx3 = NewClientHudElem(self);	//hud visible for all, to make it only visible for one replace level. with self. and change newHudElem() to newClientHudElem(self)
	self.xx3.x = -20;	//position on the x-axis
	self.xx3.y = 135;	//position on the <-axis
	self.xx3.horzAlign = "right";	
	self.xx3.vertAlign = "middle";
	self.xx3.alignX = "right";
	self.xx3.alignY = "middle";
	self.xx3.sort = 102;	//if there are lots of huds you can tell them which is infront of which
	self.xx3.foreground = 1;	//to do with the one above, if it's in front a lower sorted hud
	self.xx3.archived = false;	//visible in killcam
	self.xx3.alpha = 1;	//transparency	0 = invicible, 1 = visible
	self.xx3.fontScale = 1.9;	//textsize
	self.xx3.hidewheninmenu = false;	//will it be visble when a player is in a menu
	self.xx3.color = (1,0,0);	//RGB color code
	self.xx3.label = &"^2Grenade^1 to detach";	//The text for the hud & is required, &&1 is the value which will be added below

	self thread monitorhud();
	while(1)
	{
	wait 1;
			if(self.fuel>500)
			{
			self.xxx setValue("^2" +self.fuel);	//if level.count is a integer
			self.xxx setText("^2" +self.fuel);	//if level.count is a string
			}
			if(self.fuel>200 && self.fuel<500)
			{
			self.xxx setValue("^3" +self.fuel);	//if level.count is a integer
			self.xxx setText("^3" +self.fuel);	//if level.count is a string
			}
			if(self.fuel<200)
			{
			self.xxx setValue("^1" +self.fuel);	//if level.count is a integer
			self.xxx setText("^1" +self.fuel);	//if level.count is a string
			}
		}
	}
	
monitorhud()
{
self endon("round_end");
self endon("disconnect");
self.monitorhud=true;
while(self.monitorhud==true)
{
	if( self isReallyAlive())
	{
	}
	else
			{	
			self.xxx Destroy();
			self.xx1 Destroy();
			self.xx2 Destroy();
			self.xx3 Destroy();
			self.monitorhud=false;
			}
	wait 0.05;
}
}

jetpack_fly()
{

self endon("death");
self endon("disconnect");

	if(isdefined(self.fuel) && isdefined(self.equiped) && self.equiped==false)
	{
	self.mover = spawn( "script_origin", self.origin );
	self.mover.angles = self.angles;
	self linkto (self.mover);
	self.equiped = true;
	self.mover moveto( self.mover.origin + (0,0,25), 0.5 );
	
	
	self disableweapons();
	
	while( self.equiped == true )
		{
		Earthquake( .1, 1, self.mover.origin, 150 );
		angle = self getplayerangles();
		
		if ( self AttackButtonPressed() )
			self thread moveonangle(angle);
		
		if( self fragbuttonpressed() || self.health < 1 || self.fuel==0 )
			self thread killjetpack();
		
		if( self meleeButtonPressed() )
			self jetpack_vertical( "up" );
		
		if( self buttonpressed() )
			self jetpack_vertical( "down" );
		
		wait .05;
		}
	}
}

jetpack_vertical( dir )
{	

vertical = (0,0,50);
vertical2 = (0,0,100);

if( dir == "up" )
{
	if( bullettracepassed( self.mover.origin, self.mover.origin + vertical2, false, undefined ) )
	{
	self.mover moveto( self.mover.origin + vertical, 0.25 );
	self.fuel--;
	}
	else
	{
	self.mover moveto( self.mover.origin - vertical, 0.25 );
	self iprintlnbold("^2Stay away from objects while flying Jetpack");
	self.fuel--;
	}
}

if( dir == "down" )
{
	if( bullettracepassed( self.mover.origin, self.mover.origin - vertical, false, undefined ) )
	{
		self.mover moveto( self.mover.origin - vertical, 0.25 );
		self.fuel--;
	}
}
else
{
self.mover moveto( self.mover.origin + vertical, 0.25 );
self iprintlnbold("^2Numb Nuts Stay away From Buildings ");
self.fuel--;
}

}


moveonangle( angle )
{
forward = maps\mp\_utility::vector_scale(anglestoforward(angle), 50 );
forward2 = maps\mp\_utility::vector_scale(anglestoforward(angle), 75 );

if( bullettracepassed( self.origin, self.origin + forward2, false, undefined ) )
{
	self.mover moveto( self.mover.origin + forward, 0.25 );
	self.fuel--;
}

else
{
	self.mover moveto( self.mover.origin - forward, 0.25 );
	self iprintlnbold("^2Stay away from objects while flying Jetpack");
	self.fuel--;
}

}


killjetpack()
{
self.mover stoploopSound();
self unlink();
wait .5;
self enableweapons();
self.equiped=false;
self.xxx Destroy();
self.xx1 Destroy();
self.xx2 Destroy();
self.xx3 Destroy();
}

showCredit( text, scale, alap )
{

if ( alap == 1 )
{
	hud = addTextHud( self, 320, 60, 0, "center", "top", scale );
}
else if( alap == 2 )
{
	hud = addTextHud( self, 320, 95, 0, "center", "top", scale );
}
else if( alap == 3 )
{
	hud = addTextHud( self, 320, 130, 0, "center", "top", scale );
}
else if( alap == 4 )
{
	hud = addTextHud( self, 320, 165, 0, "center", "top", scale );
}
else if( alap == 5 )
{
	hud = addTextHud( self, 320, 200, 0, "center", "top", scale );
}
else if( alap == 6 )
{
	hud = addTextHud( self, 320, 235, 0, "center", "top", scale );
}
else if( alap == 7 )
{
	hud = addTextHud( self, 320, 270, 0, "center", "top", scale );
}
else if( alap == 8 )
{
	hud = addTextHud( self, 320, 305, 0, "center", "top", scale );
}
else if( alap == 9 )
{
	hud = addTextHud( self, 320, 340, 0, "center", "top", scale );
}
else if( alap == 10 )
{
	hud = addTextHud( self, 320, 375, 0, "center", "top", scale );
}
else
{
	hud = addTextHud( self, 320, 60, 0, "center", "top", scale );
}


	hud setText( text );

	hud.glowColor = (0.7,0,0);
	hud.glowAlpha = 1;
	hud SetPulseFX( 30, 100000, 700 );

	hud fadeOverTime( 0.5 );
	hud.alpha = 1;

	wait 2.6;

	hud fadeOverTime( 0.4 );
	hud.alpha = 0;
	wait 0.4;

	hud destroy();
}

addTextHud( who, x, y, alpha, alignX, alignY, fontScale )
{
	hud = newClientHudElem(self);

	hud.x = x;
	hud.y = y;
	hud.alpha = alpha;
	hud.alignX = alignX;
	hud.alignY = alignY;
	hud.fontScale = fontScale;
	return hud;
}

Speed()
{
	self endon("disconnect");
	
	self SetMoveSpeedScale(1.4);
	self setClientDvar("g_gravity", 70 );
	
	while(isDefined(self) && self.sessionstate == "playing" && game["state"] != "round ended")
	{
		if(!self isOnGround() && !self.doingBH)
		{
			while(!self isOnGround())
				wait 0.05;
				
			playfx(level.fx[2], self.origin - (0, 0, 10)); 
			earthquake (0.3, 1, self.origin, 100); 
		}
		wait .2;
	}
	
	if(isDefined(self))
	{
		self setClientDvar("g_gravity", 70 );
		self SetMoveSpeedScale(1);
	}
}

