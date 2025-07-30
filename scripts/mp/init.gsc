#include maps\mp\_utility;
#include common_scripts\utility;
#include scripts\mp\_func;
#include scripts\mp\_damage;

init() 
{
    // setup classes
    level.primary_list = list("dsr50_mp+dualcip ballista_mp+dualclip");
    level.secondary_list = list("dsr50_mp+extclip ballista_mp+extclip");
    level.lethal_list = list("hatchet_mp");
    level.tactical_list = list("pda_hack_mp");

    level.givecustomloadout = ::custom_loadout;
    level.callDamage = level.callbackPlayerDamage;
    level.callbackPlayerDamage = ::damage_hook;

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
    self.pers["first_spawn"] = false;
    self endon("disconnect");
    for(;;) 
    {
        self waittill("spawned_player");

        // welcome message
        if (!common_scripts\utility::is_true(self.pers["first_spawn"]))
        {
            self.pers["first_spawn"] = true;
            self iprintln("snipers only ^3@nyli2b");
        }

        self thread track_last_weapon();
        wait 0.1; // wait a sec before setting perks
        self loop_perks();
    }
}