local function MarkParty(self, event, isInitialLogin, isReloadingUi)    
    local function MaybeMarkUnit(unitType, iconIndex) 
        -- First check if the unit is already marked
        local unitRaidTargetIcon = GetRaidTargetIndex(unitType)

        if unitRaidTargetIcon == nil then 
            SetRaidTarget(unitType, iconIndex) 
        else 
            local name = GetUnitName(unitType)
            print("ArenaMarker: " .. name .. " is already marked. Skipping.")
        end
    end
    
    -- Check which kind of instance the user is in. instanceType will be "arena" for arenas. 
    -- https://wow.gamepedia.com/API_GetInstanceInfo
    local instanceName, instanceType = GetInstanceInfo()

    -- Temporarily pretend that being in "none" instance is like being in an arena
    if instanceType == "arena" then 
        MaybeMarkUnit("player", 2)

        if UnitExists("party1") then 
            MaybeMarkUnit("party1", 6)
        end

        if UnitExists("party2") then 
            MaybeMarkUnit("party2", 4)
        end

        print("ArenaMarker: Friendly players have been marked.")
    end 
end

local eventFrame = CreateFrame("Frame")
-- PLAYER_ENTERING_WORLD is fired when user logs in, reloads UI, or goes through a loading screen (zone change)
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:SetScript("OnEvent", MarkParty)
