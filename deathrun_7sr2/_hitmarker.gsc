//v1.1
//FIXED: hitmarker was also shown on teammates

#include braxi\_dvar;

init()
{
	level thread PlayerDamage();
}

PlayerDamage()
{
	for(;;)
	{
		level waittill( "player_damage", owned, attacker );
		if( isDefined(attacker) && isPlayer(attacker) && owned != attacker && isDefined(level.activ) && ( level.activ == owned || level.activ == attacker) )
			attacker Marker();
	}
}

Marker()
{
	self playlocalsound("MP_hit_alert");
	self.hud_damagefeedback.alpha = 1;
	self.hud_damagefeedback fadeOverTime(1);
	self.hud_damagefeedback.alpha = 0;
}