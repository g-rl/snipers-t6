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
    }
}

on_player_spawned() 
{
    self.pers["first_spawn"] = true;
    self endon("disconnect");
    for(;;) 
    {
        self waittill("spawned_player");

        // welcome message
        if (common_scripts\utility::is_true(self.pers["first_spawn"]))
        {
            self.pers["first_spawn"] = false;
            self iprintln("snipers only ^3@nyli2b");
        }
        
        self freezecontrols(0);
        self thread setup_class();
        self thread monitor_class();
        self thread track_last_weapon();
        self thread vsat();
        wait 0.1; // wait a sec before setting perks
        self loop_perks();
    }
}