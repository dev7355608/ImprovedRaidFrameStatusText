local UnitIsConnected = UnitIsConnected
local UnitIsDead = UnitIsDead
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

hooksecurefunc(
    "CompactUnitFrame_UpdateStatusText",
    function(frame)
        if frame:IsForbidden() then
            return
        end

        if not frame.statusText then
            return
        end

        if not frame.optionTable.displayStatusText then
            frame.statusText:Hide()
            return
        end

        local unit = frame.unit
        local displayedUnit = frame.displayedUnit

        if not UnitIsConnected(unit) then
            frame.statusText:SetText(PLAYER_OFFLINE)
            frame.statusText:Show()
        elseif UnitIsAFK(unit) then
            frame.statusText:SetText(DEFAULT_AFK_MESSAGE)
            frame.statusText:Show()
        elseif UnitIsGhost(displayedUnit) then
            frame.statusText:SetText(GHOST)
            frame.statusText:Show()
        elseif UnitIsPossessed(displayedUnit) then
            frame.statusText:SetText(LOSS_OF_CONTROL_DISPLAY_POSSESS)
            frame.statusText:Show()
        elseif UnitIsCharmed(displayedUnit) then
            frame.statusText:SetText(LOSS_OF_CONTROL_DISPLAY_CHARM)
            frame.statusText:Show()
        elseif UnitIsFeignDeath(displayedUnit) then
            frame.statusText:SetText(FEIGN)
            frame.statusText:Show()
        elseif UnitIsDead(displayedUnit) then
            frame.statusText:SetText(DEAD)
            frame.statusText:Show()
        end
    end
)

hooksecurefunc(
    "CompactUnitFrame_OnEvent",
    function(self, event, ...)
        if self:IsForbidden() then
            return
        end

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
