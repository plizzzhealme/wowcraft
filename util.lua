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

function GetMoneyString(money)
	local gold = floor(money / 10000)
	local silver = floor((money - gold * 10000) / 100)
	local copper = mod(money, 100)
	if gold > 0 then
		return format(GOLD_AMOUNT_TEXTURE.." "..SILVER_AMOUNT_TEXTURE.." "..COPPER_AMOUNT_TEXTURE, gold, 0, 0, silver, 0, 0, copper, 0, 0)
	elseif silver > 0 then
		return format(SILVER_AMOUNT_TEXTURE.." "..COPPER_AMOUNT_TEXTURE, silver, 0, 0, copper, 0, 0)
	else
		return format(COPPER_AMOUNT_TEXTURE, copper, 0, 0)
	end
end

