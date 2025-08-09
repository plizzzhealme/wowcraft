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
        local itemLink = select(2, GetItemInfo(itemId)) or ("|cff00ff00[Item " .. itemId .. "]|r")
        
        print(string.format("%s [%s]", itemLink, GetMoneyString(MATS[itemId])))
    end
end

function ShowBoelist()
    local order245 = {
        47573, 47572,   -- Titanium Spikeguards
        47590, 47589,   -- Titanium Razorplate
        47571, 47570,   -- Saronite Swordbreakers
        47592, 47591,   -- Breastplate of the White Knight
        47575, 47574,   -- Sunforged Bracers
        47594, 47593,   -- Sunforged Breastplate
        47586, 47585,   -- Bejeweled Wizard's Bracers
        47604, 47603,   -- Merlin's Robe
        47588, 47587,   -- Royal Moonshroud Bracers
        47606, 47605,   -- Royal Moonshroud Robe
        47582, 47581,   -- Bracers of Swift Death
        47600, 47599,   -- Knightbane Carapace
        47584, 47583,   -- Moonshadow Armguards
        47601, 47602,   -- Lunar Eclipse Robes
        47577, 47576,   -- Crusader's Dragonscale Bracers
        47596, 47595,   -- Crusader's Dragonscale Breastplate
        47580, 47579,   -- Black Chitin Bracers
        47598, 47597    -- Ensorcelled Nerubian Breastplate
    }
    
    local order264 = {
        49907, -- Boots of Kingly Upheaval
        49906, -- Hellfrozen Bonegrinders
        49903, -- Legplates of Painful Death
        49904, -- Pillars of Might
        49905, -- Protectors of Life
        49902, -- Puresteel Legplates
        49899, -- Bladeborn Leggings
        49894, -- Blessed Cenarion Boots
        49901, -- Draconic Bonesplinter Legguards
        49896, -- Earthsoul Boots
        49895, -- Footpads of Impending Death
        49898, -- Legwraps of Unleashed Nature
        49900, -- Lightning-Infused Leggings
        49897, -- Rock-Steady Treads
        49890, -- Deathfrost Boots
        49891, -- Leggings of Woven Death
        49892, -- Lightweave Leggings
        49893, -- Sandals of Consecration
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
        print(string.format("%s [%s]", itemLink, GetMoneyString(GetCost(itemId))))
    end
    
    for _, itemId in ipairs(order264) do
        local itemData = BOES[itemId]
        local itemLink = select(2, GetItemInfo(itemId)) or ("|cff00ff00[Item " .. itemId .. "]|r")
        
        print(string.format("%s [%s]", itemLink, GetMoneyString(GetCost(itemId))))
    end
end

function GetCost(id)
    if MATS[id] ~= nil then
        return MATS[id]
    end
        
    if BOES[id] ~= nil then
        local cost = 0
        local boe = BOES[id]
        
        for matId, quantity in pairs(boe) do
            cost = cost + MATS[matId] * quantity
        end
        return cost
    end
    
    return 0
end

local function AddNonProfitPriceToTooltip(tooltip, itemId)
    if BOES[itemId] or MATS[itemId] then
        -- Format the price with commas for readability
        local formattedPrice = GetCoinTextureString(math.ceil(GetCost(itemId) / .95))
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
