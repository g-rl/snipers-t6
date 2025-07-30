#include maps\mp\_utility;
#include common_scripts\utility;

custom_loadout() 
{
    custom_class(level.primary_list, level.secondary_list, level.lethal_list, level.tactical_list);
    return; // end just in case lol
}

loop_perks() 
{
    self endon("disconnect");
    level endon("game_ended");

    for(;;) 
    {
        self setperk("specialty_unlimitedsprint");
        self setperk("specialty_fallheight");
        wait 0.05;
    }
}

set_new_dvars() 
{
    setdvar("jump_slowdownEnable", 0);
    setdvar("bg_prone_yawcap", 200);
    setdvar("bg_ladder_yawcap", 200);
    setdvar("scr_killcam_time", 7);
}

custom_class(weap1, weap2, eq1, eq2)
{
    weapons = array(weap1, weap2, eq1, eq2);

    // set camo from custom class
    self.camo = self calcweaponoptions( self.class_num, 0 );

    self takeallweapons();

    foreach(weap in weapons)
        self giveweapon(weap, 0, self.camo, 1, 0, 0, 0);

    if (isdefined(last_gun()) && last_gun() != "none")
    {
        if (last_gun() == weap2) // make sure weapon orders are correct
        {
            weapons = array(weap2, weap1, eq1, eq2);
            self takeallweapons();
        }

        foreach(weap in weapons)
            self giveweapon(weap, 0, self.camo, 1, 0, 0, 0);

        if (last_gun() != weap && last_gun() != weap2)
        {
            self switchtoweapon(weap1);
            return;
        }
        self switchtoweapon(last_gun());
        return;
    }
    self switchtoweapon(weap1);
}

monitor_class()
{
    self endon("disconnect");
    level endon("game_ended");
    for(;;)
    {
        self waittill("changed_class");
        self.class = undefined; // allow changing to same class (?)
        self maps\mp\gametypes\_class::giveloadout(self.team, self.class);
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