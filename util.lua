function GetColoredMoney(copper)
    local gold = math.floor(copper / 10000)
    local silver = math.floor((copper % 10000) / 100)
    local copper = copper % 100
    
    -- Classic WoW color codes
    local goldColor = "|cFFFFD700"   -- Gold (yellow)
    local silverColor = "|cFFC0C0C0" -- Silver (light gray)
    local copperColor = "|cFFB87333" -- Copper (orange-brown)
    
    return string.format(
        "%s%02d%s%02d%s%02d|r",
        goldColor, gold,
        silverColor, silver,
        copperColor, copper
    )
end

