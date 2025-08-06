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
        49907, 49906, 49903, 49904, 49905, 49902,
        49899, 49984, 49901, 49896, 49895, 49898,
        49900, 49897, 49890, 49891, 49892, 49893
    }
    
    -- Get player faction (returns "Alliance" or "Horde" in 3.3.5)
    local faction = UnitFactionGroup("player")

    -- Determine the starting index and step based on faction
    local startIndex, step
    
    if faction == "Horde" then
        startIndex = 1
        step = 2
    else -- Alliance
        startIndex = 2
        step = 2
    end

    -- Iterate through the array for the player's faction
    for i = startIndex, #order245, step do
        local itemId = order245[i]
        local itemData = BOES[itemId]
        local itemLink = select(2, GetItemInfo(itemId)) or ("|cff00ff00[Item " .. itemId .. "]|r")
        print(string.format("%s [%s]", itemLink, GetMoneyString(itemData.cost)))
    end
    
    for _, itemId in ipairs(order264) do
        local itemData = BOES[itemId]
        local itemLink = select(2, GetItemInfo(itemId)) or ("|cff00ff00[Item " .. itemId .. "]|r")
        
        print(string.format("%s [%s]", itemLink, GetMoneyString(itemData.cost)))
    end
end

local function AddNonProfitPriceToTooltip(tooltip, itemID)
    local itemInfo = BOES[itemID]
    if itemInfo and itemInfo.cost then
        -- Format the price with commas for readability
        local formattedPrice = GetCoinTextureString(itemInfo.cost / .95)
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
