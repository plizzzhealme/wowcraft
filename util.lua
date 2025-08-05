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
