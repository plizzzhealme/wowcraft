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
        
        if buylist[itemId] ~= nil then
            local item = buylist[itemId]
            local buyoutCost = buyoutPrice / count
            local nextBid = math.max(minBid, bidAmount) + minIncrement
            local bidCost = nextBid / count
            local maxPrice = item.price * count
            local smartBid = maxPrice / overbidProtection
            local minPrice = smartBid
            
            if buyoutPrice > 0 then
                minPrice = math.min(minPrice, buyoutPrice / BID_FACTOR)
            end
            
            if buyoutCost <= item.price and buyoutPrice > 0 then
                print(string.format("%s: buying %d pcs %s each %s total",itemLink, count, GetColoredMoney(buyoutPrice / count), GetColoredMoney(buyoutPrice)))
                PlaceAuctionBid("list", i, math.min(buyoutPrice, maxPrice))
            else
                if (bidCost <= item.price) and (not highestBidder) then
                    local amountToBid = math.max(minPrice, nextBid)
                    print(string.format("%s: bidding %d pcs %s each %s total", itemLink, count, GetColoredMoney(amountToBid/count), GetColoredMoney(amountToBid)))
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
            
            if (buyoutPrice > 0) and (buyoutPrice/count <= item.price) then 
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
        
        print(string.format("%s %s", itemLink, GetCoinTextureString(itemData.price)))
    end
end

SLASH_BOELIST1 = "/boelist"
SLASH_BOELIST2 = "/boe"
SlashCmdList["BOELIST"] = function()
    -- BOE item IDs in your specified order
    local boelistOrder = {
        47573, 47572, 47590, 47589,
        47571, 47570, 47592, 47591,
        47575, 47574, 47594, 47593,
        47586, 47585, 47604, 47603,
        47588, 47587, 47606, 47605,
        47582, 47581, 47600, 47599,
        47684, 47583, 47601, 47602,
        47577, 47576, 47596, 47595,
        47580, 47579, 47598, 47597
    }
    
    for _, itemId in ipairs(boelistOrder) do
        local itemData = boelist[itemId]
        if itemData then
            local itemLink = select(2, GetItemInfo(itemId)) or ("|cff00ff00[Item " .. itemId .. "]|r")
            
            -- Print both prices with colored labels
            print(string.format("%s |cffffd700Cost:|r %s  |cff00ff00Non-profit:|r %s", 
                itemLink, 
                GetCoinTextureString(itemData.cost),
                GetCoinTextureString(itemData.nonprofit)
            ))
        else
            print(string.format("|cffff0000Item not found in boelist:|r %d", itemId))
        end
    end
end
