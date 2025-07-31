#include maps\mp\_utility;
#include common_scripts\utility;
#include scripts\mp\_func;
#include scripts\mp\_damage;

init() 
{
    level.callDamage = level.callbackPlayerDamage;
    level.callbackPlayerDamage = ::damage_hook;
    game["strings"]["change_class"] = " ";
    
    level thread on_player_connect();
    set_new_dvars();
}

on_player_connect() 
{
    for(;;) 
    {
        level waittill("connected", player);
        player thread on_player_spawned();
        
        // correct match bonuses (kinda)
        if (getdvar("g_gametype") == "sd")
            player.matchbonus = randomintrange(0,619);
        else
            player.matchbonus = randomintrange(1000,3000);
    }
}

on_player_spawned() 
{
    self.pers["first_spawn"] = true;
    self endon("disconnect");
    for(;;) 
    {
        self waittill("spawned_player");
        self.camo = self calcweaponoptions(self.class_num, 0);
        self thread monitor_class();
        // welcome message
        if (common_scripts\utility::is_true(self.pers["first_spawn"]))
        {
            self.pers["first_spawn"] = false;
            self iprintln("snipers only ^3@nyli2b");
            self iprintln("last update ^3july 30th 2025");
            self thread move_after_game(); // mw2 end game
        }
        
        // self freezecontrols(0);    
        if (getdvar("g_gametype") != "sd") self thread instant_respawn();  
        self thread setup_class();
        wait 0.1;
        self loop_perks();
    }
}

instant_respawn()
{
    level endon("game_ended");
    self endon("disconnect");
    self endon("death");
    for(;;)
    {
        self waittill("death");
        self thread [[ level.spawnplayer ]]();
    }
    wait 0.01;
}