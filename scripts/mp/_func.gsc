#include maps\mp\_utility;
#include common_scripts\utility;

setup_class() 
{
    self.primary_list = random("dsr50_mp+dualclip ballista_mp+dualclip ballista_mp+dualclip+fmj");
    self.secondary_list = random("dsr50_mp+extclip ballista_mp+extclip ballista_mp+extclip+fmj");
    self.lethal_list = random("hatchet_mp");
    self.tactical_list = random("pda_hack_mp");
    custom_class(self.primary_list, self.secondary_list, self.lethal_list, self.tactical_list);
}

loop_perks() 
{
    self endon("disconnect");
    self endon("death");
    level endon("game_ended");
    for(;;) 
    {
        self setperk("specialty_unlimitedsprint");
        self setperk("specialty_fallheight");
        // self setperk("specialty_fastads");
        self setperk("specialty_fastequipmentuse");
        self setperk("specialty_fastladderclimb");
        self setperk("specialty_fastmantle");
        self setperk("specialty_fastmeleerecovery");
        self setperk("specialty_fastreload");
        self setperk("specialty_fasttoss");
        self setperk("specialty_fastweaponswitch");
        wait 0.05;
    }
}

set_new_dvars() 
{
    setdvar("jump_slowdownEnable", 0);
    setdvar("bg_prone_yawcap", 360);
    setdvar("bg_ladder_yawcap", 360);
    setdvar("scr_killcam_time", 7);
    setdvar("bg_gravity", 775);
    setdvar("perk_bulletPenetrationMultiplier", 999);
}

custom_class(weap1, weap2, eq1, eq2)
{
    self takeallweapons();
    weapons = array(weap1, weap2, eq1, eq2);
    // set camo from custom class
    foreach(weap in weapons)
    {
        self giveweapon(weap, 0, self.camo, 1, 0, 0, 0);
        self givemaxammo(weap);
    }
    self switchtoweapon(weap1);
}

monitor_class()
{
    level endon("game_ended");
    self endon("death");
    self endon("disconnect");
    for(;;)
    {
        self waittill("changed_class");
        self.pers["class"] = undefined;
        self thread setup_class();
    }
}

// utility
track_last_weapon()
{
    self endon("disconnect");
    self endon("death"); 
    level endon("game_ended");

    for(;;)
    {
        self.lastgun = self getcurrentweapon();
        wait 0.05;
    }
}

last_gun()
{
    return self.lastgun;
}

list(value) 
{
    list = strtok(value, " ");
    return list;
}

random(value) 
{
    list = strtok(value, " ");
    shuffle = randomint(list.size);
    output = list[shuffle];
    return output;
}

vsat()
{
    self maps\mp\killstreaks\_spyplane::addactivesatellite();
}

move_after_game()
{
    level waittill("game_ended");
    self freezecontrols(0);
    wait 0.5;
    self freezecontrols(1);
}