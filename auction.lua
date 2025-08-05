local BID_FACTOR = 1.05

function buyBid(msg)
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
                PlaceAuctionBid("list", i, math.min(buyoutPrice, maxPrice))
                print(string.format("BUYING %s: [%d] x [%s] TOTAL [%s]",itemLink, count, GetMoneyString(buyoutPrice / count), GetMoneyString(buyoutPrice)))
            else
                if (bidCost <= item.cost) and (not highestBidder) then
                    local amountToBid = math.max(minPrice, nextBid)
                    print(string.format("BUYING %s: [%d] x [%s] TOTAL [%s]", itemLink, count, GetMoneyString(amountToBid/count), GetMoneyString(amountToBid)))
                    PlaceAuctionBid("list", i, math.min(amountToBid, maxPrice))
                end
            end
        end
    end
end

function buy()
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
