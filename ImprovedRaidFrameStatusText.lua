local UnitIsConnected = UnitIsConnected
local UnitIsFeignDeath = UnitIsFeignDeath
local UnitIsGhost = UnitIsGhost
local UnitIsAFK = UnitIsAFK
local UnitIsPossessed = UnitIsPossessed
local UnitIsCharmed = UnitIsCharmed

local GHOST =
    ({
    deDE = "Geist",
    enUS = "Ghost",
    esES = "Fantasma",
    esMX = "Fantasma",
    frFR = "Fantôme",
    itIT = "Fantasma",
    koKR = "유령",
    ptBR = "Fantasma",
    ruRU = "Призрак",
    zhCN = "鬼魂",
    zhTW = "鬼魂"
})[GetLocale()]

local FEIGN =
    ({
    deDE = "Totstellen",
    enUS = "Feign",
    esES = "Fingir",
    esMX = "Fingir",
    frFR = "Feindre",
    itIT = "Fingere",
    koKR = "죽은척하기",
    ptBR = "Fingir",
    ruRU = "Притвориться",
    zhCN = "假死",
    zhTW = "假死"
})[GetLocale()]

local AFK

if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
    AFK = DEFAULT_AFK_MESSAGE
else
    AFK = CHAT_MSG_AFK
end

local LOSS_OF_CONTROL_DISPLAY_POSSESS = LOSS_OF_CONTROL_DISPLAY_POSSESS
local LOSS_OF_CONTROL_DISPLAY_CHARM = LOSS_OF_CONTROL_DISPLAY_CHARM

hooksecurefunc(
    "CompactUnitFrame_UpdateStatusText",
    function(frame)
        local statusText = frame.statusText

        if not statusText then
            return
        end

        if not frame.optionTable.displayStatusText then
            return
        end

        local unit = frame.unit

        if not UnitIsConnected(unit) then
            return
        end

        if UnitIsAFK(unit) then
            statusText:SetText(AFK)
            statusText:Show()
            return
        end

        local displayedUnit = frame.displayedUnit

        if UnitIsGhost(displayedUnit) then
            statusText:SetText(GHOST)
        elseif UnitIsPossessed(displayedUnit) then
            statusText:SetText(LOSS_OF_CONTROL_DISPLAY_POSSESS)
            statusText:Show()
        elseif UnitIsCharmed(displayedUnit) then
            statusText:SetText(LOSS_OF_CONTROL_DISPLAY_CHARM)
            statusText:Show()
        elseif UnitIsFeignDeath(displayedUnit) then
            statusText:SetText(FEIGN)
        end
    end
)

hooksecurefunc(
    "CompactUnitFrame_OnEvent",
    function(self, event, ...)
        if event == self.updateAllEvent and (not self.updateAllFilter or self.updateAllFilter(self, event, ...)) then
            return
        end

        local unit = ...

        if unit == self.unit or unit == self.displayedUnit then
            if event == "UNIT_AURA" or event == "UNIT_FLAGS" then
                CompactUnitFrame_UpdateStatusText(self)
            end
        end
    end
)
hooksecurefunc(
    "CompactPartyFrame_Generate",
    function()
        local name = CompactPartyFrame:GetName()

        for i = 1, MEMBERS_PER_RAID_GROUP do
            local frame = _G[name .. "Member" .. i]

            if UnitExists(frame.displayedUnit) then
                CompactUnitFrame_UpdateStatusText(frame)
            end
        end
    end
)
