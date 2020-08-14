local function MarkParty(skipInstanceCheck)    
    local function MaybeMarkUnit(unitType, iconIndex) 
        local name = GetUnitName(unitType)
        -- First check if the unit is already marked
        local unitRaidTargetIcon = GetRaidTargetIndex(unitType)

        if unitRaidTargetIcon == nil then 
            SetRaidTarget(unitType, iconIndex) 
            print("ArenaMarker: Marked " ..name.. " with raid icon " .. tostring(iconIndex) .. ".")
        else 
            print("ArenaMarker: " .. name .. " is already marked. Skipping.")
        end
    end
    
    -- Check which kind of instance the user is in. instanceType will be "arena" for arenas. 
    -- https://wow.gamepedia.com/API_GetInstanceInfo
    local instanceName, instanceType = GetInstanceInfo()

    -- Only mark players if the player is in arena 
    -- TODO: will this work when the player is the first to load in? Party may appear empty?
    if instanceType == "arena" or skipInstanceCheck == true then 
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
eventFrame:SetScript("OnEvent", function (self, event, isInitialLogin, isReloadingUi)
    MarkParty(false)
end)

SLASH_ARENAMARKER1, SLASH_ARENAMARKER2 = "/am", "arenamarker"
function SlashCmdList.ARENAMARKER(msg, editBox)
    if msg == nil or msg == "" then 
        MarkParty(true)
    else 
        print("Usage: /am or /arenamarker to mark friendly players.")
    end
end
