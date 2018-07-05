local revolvers = {"weapon_revolver", "weapon_revolver_mk2", "weapon_doubleaction"}

RegisterCommand("rr", function(playerServerID, args, rawString)
    TriggerEvent("russianRoulette", PlayerPedId())
end, false)
-- try firing a shot without ammo
RegisterNetEvent("russianRoulette")

AddEventHandler("russianRoulette", function(player)
    Citizen.CreateThread(function()

        RequestAnimDict("mp_suicide") -- load the animation dictionary
        while not HasAnimDictLoaded("mp_suicide") do
            Wait(0)
        end

        --[[
        RequestAmbientAudioBank("weapons", 0)
        while not RequestAmbientAudioBank("weapons", 0) do
            Wait(0)
        end
        ]]

        local revolversAtHand = {}

        local weapon = false

        for i = 1, #revolvers do -- find which revolver the player has
            if HasPedGotWeapon(player, revolvers[i], 0) then
                table.insert(revolversAtHand, revolvers[i])
                if GetCurrentPedWeapon(player, revolvers[i], 0) then
                    weapon = revolvers[i]
                end
            end
        end

        print("stage 3 and " .. tostring(weapon))

        if not weapon then -- if the player doesn't have a revolver, we give a random one
            weapon = revolvers[math.random(1, #revolvers)]
            GiveWeaponToPed(player, weapon, 1, false, false)
        else
            if GetAmmoInPedWeapon(player, weapon) == 0 then -- if the player has a revolver, check if it has ammo, if not, give a bullet
                AddAmmoToPed(player, weapon, 1)
            end
        end

        print("stage 4")

        local dice = math.random(1, 6)
        
        SetCurrentPedWeapon(player, weapon, true) -- equip weapon

        TaskPlayAnim(player, "mp_suicide", "pistol", 8.0, -8.0, -1, 270540800, 0, false, false, false)

        if dice == 6 then
            while not (GetEntityAnimCurrentTime(player, "mp_suicide", "pistol") > 0.3) do
                Wait(0)
            end
            ClearEntityLastDamageEntity(player)
            SetPedShootsAtCoord(player, 0.0, 0.0, 0.0, false)
            SetEntityHealth(player, 0)
            print("SHOT")
        else
            while not (GetEntityAnimCurrentTime(player, "mp_suicide", "pistol") > 0.25) do
                Wait(0)
            end
            -- PlaySoundFromEntity(-1, "REVOLVER_DRY_FIRE_02B", player, "weapons", false, 0)
            StopAnimTask(player, "mp_suicide", "pistol", 4.0)
            print("NO SHOT")
        end

        if GetEntityAnimCurrentTime(player, "mp_suicide", "pistol") > 0.365 then
        print("taking too much time")
        end

        RemoveAnimDict("mp_suicide")

    end)
end)