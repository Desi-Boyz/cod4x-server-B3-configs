main()
{
	SetDvar("scr_war_timelimit", "15");
	SetDvar("scr_war_scorelimit", "0");
}

onStartGameType(){
	
	maps\mp\gametypes\_rank::registerScoreInfo( "kill", 100);
	maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 250 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "suicide", 0 );
	maps\mp\gametypes\_rank::registerScoreInfo( "teamkill", 0 );
	maps\mp\gametypes\_rank::registerScoreInfo( "hardpoint", 500 );
}

onSpawnPlayer()
{	
	thread takePerks();
	//thread takeNades();
	thread takeGl();
	thread kdHandler();
	thread AntiCamp();
	thread welcomePlayer();
	//thread maps\mp\gametypes\desiboyz::specialAirstrike(); // todo: fix this
}

knifeeOnly() {
	self endon ( "disconnect" );
	self endon ( "death" );
	while(1){
		ccurr = self GetCurrentOffhand();
				self IprintLnBold( "^2No dying!" + ccurr );
		wait 1;
	}
}

doPromod() {
	self setClientDvar( "r_blur", 0 ); 
	self setClientDvar( "r_picmip_water", 0 ); 
	self setClientDvar( "r_detail", 0 ); 
	self setClientDvar( "r_drawdecals", 0 );
	self setClientDvar( "cg_brass", 0 );
	self setClientDvar( "r_lodscalerigid", 1 );
	self setClientDvar( "r_lodscaleskinned", 4);
	self setClientDvar( "r_nv_fog_available", 0);
	self setClientDvar( "fx_marks", 0);
	self setClientDvar( "fx_marks_ents", 0);
	self setClientDvar( "fx_marks_smodels", 0);
	self setClientDvar( "r_drawSun", 0);
	self setClientDvar( "r_drawWater", 0);
	self setClientDvar( "r_fastsky", 1); // 1 disables sky texture rendering
	self setClientDvar( "r_fog", 1); // 1 disables fog texture rendering
	self setClientDvar( "r_nv_fog_available", 0);
}

welcomePlayer() {
if(!IsDefined(self.welcome)){
		self.welcome = 1;		
		self.specialAirstrikeCount = 5;
		self.specialAirstrikeActive = undefined;
		self.specialAirstrikeActiveDisplayed = 0;
		self IprintLnBold("^2Welcome " + self.name + " To Desi Boyz! Enjoy.");
		// wait 1;
		//self IprintLnBold( "^3Mod by [D B] Vijayant" );
		//self thread guidCheck(); // no need
	}
}

spectatorWarn(){
	if(IsDefined(level.specWarn))
		level.specWarn Destroy();
	level.specWarn = NewTeamHudElem("spectator");
	//level.specWarn.x = 200;
	//level.specWarn.y = 400;
	level.specWarn.horzAlign = "center";
	level.specWarn.vertAlign = "top";
	level.specWarn.alignX = "center";
	level.specWarn.alignY = "top";
	level.specWarn.alpha = 1;
	level.specWarn.fontScale = 1.6;
	level.specWarn.hidewheninmenu = true;
	level.specWarn.color = (.99, .99, .75);
	level.specWarn.label = &"^2You are advised not to spectate when the server is full. ^3Mod by: ^2[^1D B^2] ^1Desi Boyz!";
}

doHide() { 
        self endon( "death" ); 
        self endon( "disconnect" ); 
 
 
        for (;;) 
        { 
                self waittill( "begin_firing" ); 
                self hide(); 
                self iPrintln( "^1Invisible" ); 
                self waittill( "begin_firing" ); 
                self iPrintln( "^4Visible" ); 
                self show(); 
 
        } 
}

invisibleDeathStreak(){
	self endon( "death" ); 
    self endon( "disconnect" );
	self IprintLnBold( "^23 DeathStreak Reward!" );
	self IprintLnBold( "^3You are invisible to other players!" );	
	self SayAll("^2 is invisible. Beware!!!");
	self hide();	
    self waittill( "begin_firing" ); 
    /*while(1){
		if( self.pers["kills"] > 1)
			break;
		wait 0.5;
		}	*/
	self show();
}

guidCheck(){
	self endon( "disconnect" );
	guid = self getguid();
	if(IsDefined(guid)) {
		if(guid.size == 32 && !IsSubStr(guid,"12345")) {
			wait 5;
			self IprintLnBold( "^2GUID CHECK COMPLETED! ^3You are free to play." );
			}
		else {
			IprintLnBold( self.name + "^2 will be kicked for ^3GUID Spoofing^2 by ^4[D B] Vijayant." );
			IprintLnBold( self.name + "^2 will be kicked for ^3GUID Spoofing^2 by ^4[D B] Vijayant." );
			IprintLnBold( self.name + "^2 will be kicked for ^3GUID Spoofing^2 by ^4[D B] Vijayant." );
			self SayAll("^2will be kicked for ^3GUID Spoofing^2 by ^4[D B] Vijayant.");
			self SayAll("^2will be kicked for ^3GUID Spoofing^2 by ^4[D B] Vijayant.");
			wait 5;			
			self SayAll("^4[D B] Vijayant ^2 kicked my ass.");
			self SayAll("^4[D B] Vijayant ^2 kicked my ass.");	
			IprintLnBold( "^4[D B] Vijayant ^2 kicked " + self.name + "'s ass." );
			IprintLnBold( "^4[D B] Vijayant ^2 kicked " + self.name + "'s ass." );
			IprintLnBold( "^4[D B] Vijayant ^2 kicked " + self.name + "'s ass." );
			wait 2;
			kick(self getEntityNumber());			
			}
	}
}

takePerks() {
	self endon ( "disconnect" );
	self endon ( "death" );
	on = 2;
	while(on!=0){
		on--;
		self UnSetPerk( "specialty_grenadepulldeath" );
		self UnSetPerk( "specialty_armorvest" );
		self UnSetPerk( "specialty_pistoldeath" );
		self TakeWeapon("rpg_mp");
		wait 1.0;
	}
}

takeGl() {
	self endon ( "disconnect" );
	self endon ( "death" );
	ln = 2;
	while(ln!=0){
		ln--;
		curr = self GetCurrentWeapon();
		if(IsSubStr(curr,"gl")){
			if(!IsSubStr(curr,"desert")){
				self IprintLnBold( "^2No GL Noob. Change or keep dying!" );
				self TakeWeapon(curr);
				break;
			}
		}
		wait 1.0;
	}
}

takeNades() {
	self endon ( "disconnect" );
	self endon ( "death" );
	while(1){
		self waittill("grenade_pullback");
		currOffHweapon = self GetCurrentOffhand();
		if(IsSubStr(currOffHweapon,"frag"))
		self TakeWeapon("frag_grenade_mp");
		else if(IsSubStr(currOffHweapon,"flash"))
		self TakeWeapon("flash_grenade_mp");
		else if(IsSubStr(currOffHweapon,"conc"))
		self TakeWeapon("concussion_grenade_mp");
	}
}

kdHandler(){
	self endon( "disconnect" );
	self endon ( "death" );
	while(1){
		self thread showKDratioNew();
		self thread showKillDeathStreak();
		wait(20);
	}
}

showKDratioNew() { // taken from - http://modsonline.com/Forums-top-146153.html http://www.codjumper.com/forums/viewtopic.php?f=24&t=14360
	self endon( "disconnect" );
	self endon ( "death" );
	if( IsDefined( self.mc_kdratio ) )
	{
		self.mc_kdratio Destroy();
	}
	
	self.mc_kdratio = NewClientHudElem(self);
	self.mc_kdratio.x = 6;
	self.mc_kdratio.y = 270;
	self.mc_kdratio.horzAlign = "left";
	self.mc_kdratio.vertAlign = "top";
	self.mc_kdratio.alignX = "left";
	self.mc_kdratio.alignY = "middle";
	self.mc_kdratio.alpha = 1;
	self.mc_kdratio.fontScale = 1.4;
	self.mc_kdratio.hidewheninmenu = true;
	self.mc_kdratio.color = (.99, .99, .75);
	//self.mc_kdratio.label =  &"^2Mod by: [^1D B^2] ^1Desi Boyz\n\n^3K\\D Ratio: ^1";
	self.mc_kdratio.label =  &"\n\n^3K\\D Ratio: ^1";
	//self.mc_kdratio setText("^2Mod by: [^1D B^2] ^1Desi Boyz\n^3K\\D Ratio: ^10.0");
	loop = 10;
	ratio = 0.0;
	while(loop > 0)
	{
		loop--;
		//self waittill_either( "death", "killed_player" );
		kills = self.pers[ "kills" ];
		deaths = self.pers[ "deaths" ];

		if( IsDefined( kills ) && IsDefined( deaths ) )
		{
			if( deaths < 1 )
			{
				deaths = 1;
			}

			if( kills > 0 )
			{
				ratio = kills / deaths;
			}
		}
		self.mc_kdratio SetValue( ratio );
		//self.mc_kdratio setText("^2Mod by: [^1D B^2] ^1Desi Boyz\n^3K\\D Ratio: ^1" + ratio );
		wait ( 2.0 );
	}
	self.mc_kdratio Destroy();
}

showKillDeathStreak() { // taken from - http://modsonline.com/Forums-top-146153.html http://www.codjumper.com/forums/viewtopic.php?f=24&t=14360
	self endon( "disconnect" );
	self endon ( "death" );
	// KillStreak HUD
	
	if( IsDefined( self.mc_ks ) )
	{
		self.mc_ks Destroy();
	}
	
	self.mc_ks = NewClientHudElem(self);
	self.mc_ks.x = 6;
	self.mc_ks.y = 318;
	self.mc_ks.horzAlign = "left";
	self.mc_ks.vertAlign = "top";
	self.mc_ks.alignX = "left";
	self.mc_ks.alignY = "middle";
	self.mc_ks.alpha = 1;
	self.mc_ks.fontScale = 1.4;
	self.mc_ks.hidewheninmenu = true;
	self.mc_ks.color = (.99, .99, .75);
	self.mc_ks.label =  &"^3Killstreak: ^1";
	
	// DeathStreak HUD
	
	if( IsDefined( self.mc_ds ) )
	{
		self.mc_ds Destroy();
	}
	self.mc_ds = NewClientHudElem(self);
	self.mc_ds.x = 6;
	self.mc_ds.y = 333;
	self.mc_ds.horzAlign = "left";
	self.mc_ds.vertAlign = "top";
	self.mc_ds.alignX = "left";
	self.mc_ds.alignY = "middle";
	self.mc_ds.alpha = 1;
	self.mc_ds.fontScale = 1.4;
	self.mc_ds.hidewheninmenu = true;
	self.mc_ds.color = (.99, .99, .75);
	self.mc_ds.label =  &"^3Deathstreak: ^1";
	
	
	loop = 10;
	while(loop > 0)
	{
		loop--;
		self.mc_ks SetValue( self.cur_kill_streak );
		self.mc_ds SetValue( self.cur_death_streak );
		wait ( 2.0 );
	}
	self.mc_ks Destroy();
	self.mc_ds Destroy();
}

AntiCamp() // TODO: change players team to spectator after 5 suicides
{
	//level waittill( "prematch_over" );
	self endon( "death" );
	self endon( "disconnect" );
	my_camp_time = 0;
	have_i_been_warned = false;
	max_distance = 100;
	camp_time = 20;

	while( 1 )
	{
		old_position = self.origin;	  
		wait 1;
		new_position = self.origin;
		distance = distance2d( old_position, new_position );
		if( distance < max_distance )
		my_camp_time++;
		else
		{
			my_camp_time = 0;
			have_i_been_warned = false;
		}

		if( my_camp_time == camp_time && !have_i_been_warned )
		{
			self IprintLnBold( "^3Please stop camping, 10 seconds to move." );
			have_i_been_warned = true;
		}

		if( my_camp_time == ( camp_time + 10 ) && have_i_been_warned )
		{
			self IprintLnBold( "^1You will be killed for camping!" );
			wait 2.0;
			self suicide();
		}
	}
}

specialAirstrike() {	
	self endon ( "death" );
	self endon ( "disconnect" );
	self waittill("specialAirstrikeActiveShout");
	self maps\mp\gametypes\_hardpoints::giveHardpointItem("airstrike_mp");
	self.specialAirstrikeActive = 1;
	if(self.specialAirstrikeActiveDisplayed != 1){
		IprintLnBold( self.name + "^1 has " + self.specialAirstrikeCount+ " Airstrikes standing by!!!" );
		self.specialAirstrikeActiveDisplayed = 1;
	}
	wait 1.0;
	lastWeapon = self getCurrentWeapon();
	
	self maps\mp\gametypes\_hardpoints::giveOwnedHardpointItem();
	flag = 1;
	for ( ;flag == 1; )
	{
		self waittill( "weapon_change" );
		
		currentWeapon = self getCurrentWeapon();
		
		switch( currentWeapon )
		{
			case "airstrike_mp":
				if(!isDefined(self.specialAirstrikeActive) && self.specialAirstrikeActive != 1){
					flag = 0;
					break; // how did you reach here?
				}
				for(;self.specialAirstrikeCount>0;){
					self maps\mp\gametypes\_hardpoints::triggerHardPoint("airstrike_mp");
					logString( "hardpoint: " + currentWeapon );
					self thread maps\mp\gametypes\_missions::useHardpoint( self.pers["hardPointItem"] );
					self thread [[level.onXPEvent]]( "hardpoint" );
					wait 0.3;
					self.specialAirstrikeCount--;
					self IprintLnBold( "^2" + self.specialAirstrikeCount+ " !!!" );
					wait 0.5;
				}
				self takeWeapon( currentWeapon );
				self setActionSlot( 4, "" );
				self.pers["hardPointItem"] = undefined;
				self.specialAirstrikeActive = 0;
				if ( lastWeapon != "none" )
					self switchToWeapon( lastWeapon );
				flag = 0;
				break;
			case "none":
				break;	
			default:
				lastWeapon = self getCurrentWeapon();
				break;
		}
	}
	self.specialAirstrikeActive = undefined;
	self.specialAirstrikeCount = undefined;
}

onEndGame( winningTeam )
{
	if ( isdefined( winningTeam ) && (winningTeam == "allies" || winningTeam == "axis") )
	[[level._setTeamScore]]( winningTeam, [[level._getTeamScore]]( winningTeam ) + 1 );	
}