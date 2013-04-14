main()
{
//LoadPlugin( plugins\triggerspawner::init, "Weapon", "BraXi" );
LoadPlugin( plugins\welcome::init, "Welcome", "BraXi" );
LoadPlugin( plugins\_killcam::init, "Killcam", "Rycoon" );
//LoadPlugin( plugins\_hitmarker::init, "Hitmarker", "Rycoon" );
LoadPlugin( plugins\nomusic::init, "No Double Music", "BraXi" );
LoadPlugin( plugins\rtd::init, "RTD", "MW3||Star" );
LoadPlugin( plugins\vip::init, "VIP", "Many" );
	//LoadPlugin( plugins\default_ambient::init, "default ambient", "Darmuh" );
LoadPlugin( plugins\qubefix::init, "qube fix", "Darmuh" );
LoadPlugin( plugins\reg::init, "reg menu", "Many" );
LoadPlugin( plugins\_efr::init, "Unlimit Free Run Rounds", "Rycoon" );
LoadPlugin( plugins\_hostname::init, "hostname", "Dobbin" );
}



// ===== DO NOT EDIT ANYTHING UNDER THIS LINE ===== //
LoadPlugin( pluginScript, name, author )
{
	thread [[ pluginScript ]]( game["DeathRunVersion"] );
	println( "" + name + " ^7plugin created by " + author + "\n" );
}