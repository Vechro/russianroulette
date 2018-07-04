local revolvers = {"weapon_revolver", "weapon_revolver_mk2", "weapon_doubleaction"}

RegisterCommand("rr", function(playerServerID, args, rawString)
    TriggerEvent("russianRoulette", PlayerPedId())
end, false)

RegisterNetEvent("russianRoulette")

AddEventHandler("russianRoulette", function(player)
    Citizen.CreateThread(function()

        print("stage 1")

        RequestAnimDict("mp_suicide") -- load the animation dictionary
        while not HasAnimDictLoaded("mp_suicide") do
            Wait(0)
        end

        local weapon = false

        print("stage 2")

        for i = 1, #revolvers do -- find which revolver the player has
            if HasPedGotWeapon(player, revolvers[i], 0) then
                weapon = revolvers[i]
            end
        end

        print("stage 3")

        if not weapon then -- if the player doesn't have a revolver, we give a random one
            GiveWeaponToPed(player, revolvers[math.random(1, #revolvers)], 1, false, false)
        else
            if GetAmmoInPedWeapon(player, weapon) == 0 then -- if the player has a revolver, check if it has ammo, if not, give a bullet
                AddAmmoToPed(player, weapon, 1)
            end
        end

        print("stage 4")
        
        SetCurrentPedWeapon(player, weapon, true) -- equip weapon

        TaskPlayAnim(player, "mp_suicide", "pistol", 8.0, -8.0, -1, 270540800, 0, false, false, false)

        if HasAnimEventFired(player, "fire") then
            ClearEntityLastDamageEntity(player)
            SetPedShootsAtCoord(player, 0.0, 0.0, 0.0, false)
        end

        print("stage 5")

        if GetEntityAnimCurrentTime(player, "mp_suicide", "pistol") > 0.365 then
        print("taking too much time")
        end

    end)
end)

--[[
    else if (ENTITY::IS_ENTITY_PLAYING_ANIM(PLAYER::PLAYER_PED_ID(), "MP_SUICIDE", &(Global_2436181.f_1083), 3))
{
    if (!MISC::IS_BIT_SET(Global_2436181.f_1083.f_4, 2))
    {
        if (ENTITY::HAS_ANIM_EVENT_FIRED(PLAYER::PLAYER_PED_ID(), MISC::GET_HASH_KEY("Fire")))
        {
            ENTITY::CLEAR_ENTITY_LAST_DAMAGE_ENTITY(PLAYER::PLAYER_PED_ID());
            iVar0 = func_1798(PLAYER::PLAYER_PED_ID());
            if (iVar0 == joaat("weapon_pistol") || iVar0 == joaat("weapon_pistol_mk2"))
            {
                PED::SET_PED_SHOOTS_AT_COORD(PLAYER::PLAYER_PED_ID(), 0f, 0f, 0f, 0);
            }
            MISC::SET_BIT(&(Global_2436181.f_1083.f_4), 2);
        }
    }



if (ENTITY::GET_ENTITY_ANIM_CURRENT_TIME(PLAYER::PLAYER_PED_ID(), "MP_SUICIDE", &(Global_2436181.f_1083)) > Global_2436181.f_1083.f_5)
{
    PED::SET_PED_TO_RAGDOLL(PLAYER::PLAYER_PED_ID(), 0, 250, 0, 0, 0, 0);
    ENTITY::CLEAR_ENTITY_LAST_DAMAGE_ENTITY(PLAYER::PLAYER_PED_ID());
    func_7548();
    func_7545();
    func_7544();
    func_7543();
    MISC::SET_BIT(&(Global_2436181.f_1083.f_4), 5);
    func_7553();
}
]]