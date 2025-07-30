#include common_scripts\utility;
#include maps\mp\_utility;
#include scripts\mp\_func;

damage_hook( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex ) 
{
    death = random("mpl_flag_pickup_plr mus_lau_rank_up aml_dog_bark cac_enter_cac wpn_grenade_bounce_metal mpl_wager_humiliate wpn_claymore_alert wpn_grenade_explode_glass wpn_taser_mine_zap wpn_hunter_ignite"); // Bot Weapons. Add above

    if (is_valid_weapon(sweapon))
    {
        idamage = 9999;
        eAttacker playsound(death);
    }

    [[level.callDamage]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, timeOffset, boneIndex );
}

is_valid_weapon( weapon ) 
{
    if (!isdefined(weapon))
        return false;
    
    weapon_class = getweaponclass(weapon);
    if (weapon_class == "weapon_sniper")
        return true;
        
    switch(weapon)
    {
        case "hatchet_mp":
            return true;
        default:
            return false;        
    }
}