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

function GetMoneyStringPlain(money)
    local gold = floor(money / 10000)
    local silver = floor((money - gold * 10000) / 100)
    local copper = mod(money, 100)
    if gold > 0 then
        return gold..GOLD_AMOUNT_SYMBOL.." "..silver..SILVER_AMOUNT_SYMBOL.." "..copper..COPPER_AMOUNT_SYMBOL
    elseif silver > 0 then
        return silver..SILVER_AMOUNT_SYMBOL.." "..copper..COPPER_AMOUNT_SYMBOL
    else
        return copper..COPPER_AMOUNT_SYMBOL
    end
end

function ShowBuylist()
    local buylistOrder = {
    36860, 35627, 35625, 35624, 35623, 35622, 
    37701, 37705, 37702, 37703, 37704, 37700,
    41163, 36910, 36913, 36912, 37663, 33470,
    41510, 41511, 41595, 41593, 41594, 42253,
    34052, 34053, 34054, 34057, 34055, 36908,
    33567, 33568, 38425, 44128, 38557, 38558,
    36919, 36934, 36925, 36922, 36924, 36784,
    41355, 41245, 38426, 40533, 47556, 43102,
    45087, 49908
    }
    
    for _, itemId in ipairs(buylistOrder) do
        local itemData = MATS[itemId]
        local itemLink = select(2, GetItemInfo(itemId)) or ("|cff00ff00[Item " .. itemId .. "]|r")
        
        print(string.format("%s [%s]", itemLink, GetMoneyString(itemData.cost)))
    end
end

function ShowBoelist()
    local order245 = {
        47573, 47572,  -- [1] Horde, [2] Alliance
        47590, 47589,  -- [3] Horde, [4] Alliance
        47571, 47570,  -- [5] Horde, [6] Alliance
        47592, 47591,  -- [7] Horde, [8] Alliance
        47575, 47574,  -- [9] Horde, [10] Alliance
        47594, 47593,  -- [11] Horde, [12] Alliance
        47586, 47585,  -- [13] Horde, [14] Alliance
        47604, 47603,  -- [15] Horde, [16] Alliance
        47588, 47587,  -- [17] Horde, [18] Alliance
        47606, 47605,  -- [19] Horde, [20] Alliance
        47582, 47581,  -- [21] Horde, [22] Alliance
        47600, 47599,  -- [23] Horde, [24] Alliance
        47684, 47583,  -- [25] Horde, [26] Alliance
        47601, 47602,  -- [27] Horde, [28] Alliance
        47577, 47576,  -- [29] Horde, [30] Alliance
        47596, 47595,  -- [31] Horde, [32] Alliance
        47580, 47579,  -- [33] Horde, [34] Alliance
        47598, 47597   -- [35] Horde, [36] Alliance
    }
    
    local order264 = {
        70568, 70566, 70565, 70567, 70563, 70562,
        70556, 70555, 70560, 70559, 70557, 70554,
        70558, 70561, 70551, 70550, 70552, 70553
    }
    
    local playerFaction = UnitFactionGroup("player")
    
    for i = 1, #order245, 2 do
        local hordeItemId = order245[i]
        local allianceItemId = order245[i+1]
        local itemId = (playerFaction == "Horde") and hordeItemId or allianceItemId
        local itemData = BOES[itemId]
        
        if itemData then
            local itemLink = select(2, GetItemInfo(itemId)) or ("|cff00ff00[Item " .. itemId .. "]|r")
            
            print(string.format("%s COST [%s] NON-PROFIT [%s]", itemLink, GetMoneyString(itemData.cost), GetMoneyString(itemData.nonprofit)))
            anyItemsShown = true
        end
    end
    
    for _, itemId in ipairs(order264) do
        local itemData = BOES[itemId]
        local itemLink = select(2, GetItemInfo(itemId)) or ("|cff00ff00[Item " .. itemId .. "]|r")
        
        print(string.format("%s [%s]", itemLink, GetMoneyString(itemData.cost)))
    end
end

local function AddNonProfitPriceToTooltip(tooltip, itemID)
    local itemInfo = BOES[itemID]
    if itemInfo and itemInfo.nonprofit then
        -- Format the price with commas for readability
        local formattedPrice = GetCoinTextureString(itemInfo.nonprofit)
        tooltip:AddLine("Nonprofit Price: "..formattedPrice, 1, 1, 1)
        tooltip:Show()
    end
end

-- Hook the tooltip
GameTooltip:HookScript("OnTooltipSetItem", function(tooltip)
    local _, itemLink = tooltip:GetItem()
    if itemLink then
        -- This works in Wrath Classic
        local itemID = tonumber(string.match(itemLink, "item:(%d+)"))
        if itemID then
            AddNonProfitPriceToTooltip(tooltip, itemID)
        end
    end
end)
