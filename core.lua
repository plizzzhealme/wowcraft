local addonName, addon = {}
local BID_FACTOR = 1.05

SLASH_FUCK1 = "/fuck"
SlashCmdList["FUCK"] = function(msg)
    if not AuctionFrame or not AuctionFrame:IsShown() then
        return
    end

    if msg and msg ~= "" then
      overbidProtection = tonumber(msg) or BID_FACTOR
    end
    
    for i = 1, GetNumAuctionItems("list") do
        local name, texture, count, quality, canUse, level, minBid, minIncrement, buyoutPrice, bidAmount, highestBidder, owner, sold = GetAuctionItemInfo("list", i)
        local itemLink = GetAuctionItemLink("list", i)
        local itemId = itemLink and itemLink:match("item:(%d+):") or nil
        
        if itemId then
            itemId = tonumber(itemId)
        end
        
        if buylist[itemId] ~= nil or boelist[itemId] ~= nil then
            local item = buylist[itemId] or boelist[itemId]
            local buyoutCost = buyoutPrice / count
            local nextBid = math.max(minBid, bidAmount) + minIncrement
            local bidCost = nextBid / count
            local maxPrice = item.cost * count
            local smartBid = maxPrice / overbidProtection
            local minPrice = smartBid
            
            if buyoutPrice > 0 then
                minPrice = math.min(minPrice, buyoutPrice / BID_FACTOR)
            end
            
            if buyoutCost <= item.cost and buyoutPrice > 0 then
                print(string.format("%s: buying [x%d] %s each %s total",itemLink, count, GetMoneyString(buyoutPrice / count), GetMoneyString(buyoutPrice)))
                PlaceAuctionBid("list", i, math.min(buyoutPrice, maxPrice))
            else
                if (bidCost <= item.cost) and (not highestBidder) then
                    local amountToBid = math.max(minPrice, nextBid)
                    print(string.format("%s: bidding [x%d] %s each %s total", itemLink, count, GetMoneyString(amountToBid/count), GetMoneyString(amountToBid)))
                    PlaceAuctionBid("list", i, math.min(amountToBid, maxPrice))
                end
            end
        end
    end
end

SLASH_BUY1 = "/buy"
SlashCmdList["BUY"] = function() 
    if not AuctionFrame or not AuctionFrame:IsShown() then
        return
    end
    
    for i = 1, GetNumAuctionItems("list") do
        local name, texture, count, quality, canUse, level, minBid, minIncrement, buyoutPrice, bidAmount, highestBidder, owner, sold = GetAuctionItemInfo("list", i)
        local itemLink = GetAuctionItemLink("list", i)
        local itemId = itemLink and itemLink:match("item:(%d+):") or nil
        
        if itemId then
            itemId = tonumber(itemId)
        end
        
        if buylist[itemId] ~= nil then
            local item = buylist[itemId]
            
            if (buyoutPrice > 0) and (buyoutPrice/count <= item.cost) then 
                PlaceAuctionBid("list", i, buyoutPrice)
            end
        end
    end
end

SLASH_BUYLIST1 = "/buylist"
SLASH_BUYLIST2 = "/bl"
SlashCmdList["BUYLIST"] = function()
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
        local itemData = buylist[itemId]
        local itemLink = select(2, GetItemInfo(itemId)) or ("|cff00ff00[Item " .. itemId .. "]|r")
        
        print(string.format("%s %s", itemLink, GetMoneyString(itemData.price)))
    end
end

SLASH_BOELIST1 = "/boelist"
SLASH_BOELIST2 = "/boe"
SlashCmdList["BOELIST"] = function()
    -- BOE item IDs with Horde (odd) and Alliance (even) pairs
    local boelistOrder = {
        47573, 47572,  -- [1] Horde, [2] Alliance
        47590, 47589,  -- [3] Horde, [4] Alliance
        47571, 47570,   -- [5] Horde, [6] Alliance
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
    
    local playerFaction = UnitFactionGroup("player")
    local anyItemsShown = false
    
    for i = 1, #boelistOrder, 2 do  -- Step by 2 to check pairs
        local hordeItemId = boelistOrder[i]
        local allianceItemId = boelistOrder[i+1]
        local itemId = (playerFaction == "Horde") and hordeItemId or allianceItemId
        
        local itemData = boelist[itemId]
        if itemData then
            local itemLink = select(2, GetItemInfo(itemId)) or ("|cff00ff00[Item " .. itemId .. "]|r")
            
            print(string.format("%s |cffffd700Cost:|r %s  |cff00ff00Non-profit:|r %s", 
                itemLink, 
                GetMoneyString(itemData.cost),
                GetMoneyString(itemData.nonprofit)
            ))
            anyItemsShown = true
        end
    end
    
    if not anyItemsShown then
        print("|cffff0000No BOE items found for your faction|r")
    end
end
