local revolvers = {"weapon_revolver", "weapon_revolver_mk2", "weapon_doubleaction"}

RegisterCommand("rr", function(playerServerID, args, rawString)
    TriggerEvent("russianRoulette", PlayerPedId())
end, false)

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
                if GetCurrentPedWeapon(player, revolvers[i], 0) then -- if the ped has a revolver equipped then further checking is unnecessary
                    weapon = revolvers[i]
                    break
                end
                table.insert(revolversAtHand, revolvers[i]) -- make a list of revolvers the player has in his inventory to pick one at random if one isn't equipped
            end
        end

        if weapon then -- if the player has a revolver equipped, check if it has ammo, if not, give a bullet
            if GetAmmoInPedWeapon(player, weapon) == 0 then
                AddAmmoToPed(player, weapon, 1)
            end
        else  -- if the player doesn't have a revolver, we check if there's one in his inventory, if he does, use it, if not, give a random revolver
            if revolversAtHand[1] then
                weapon = revolversAtHand[math.random(1, #revolversAtHand)]
            else
                weapon = revolvers[math.random(1, #revolvers)]
                GiveWeaponToPed(player, weapon, 1, false, false)
            end
        end

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
            while not (GetEntityAnimCurrentTime(player, "mp_suicide", "pistol") > 0.21) do
                Wait(0)
            end
            -- PlaySoundFromEntity(-1, "REVOLVER_DRY_FIRE_02B", player, "weapons", false, 0)
            StopAnimTask(player, "mp_suicide", "pistol", 4.0)
            print("NO SHOT")
        end

        RemoveAnimDict("mp_suicide")

    end)
end)