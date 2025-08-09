local BID_FACTOR = 1.05

function BuyBid(msg)
    if not AuctionFrame or not AuctionFrame:IsShown() then
        return
    end

    local overbidProtection = tonumber(msg) or BID_FACTOR
    
    for i = 1, GetNumAuctionItems("list") do
        local name, _, count, _, _, _, minBid, minIncrement, buyoutPrice, bidAmount, highestBidder, _, _ = GetAuctionItemInfo("list", i)
        local itemLink = GetAuctionItemLink("list", i)
        local itemId = itemLink and itemLink:match("item:(%d+):") or nil
        
        if itemId then
            itemId = tonumber(itemId)
        end
        
        if MATS[itemId] ~= nil or BOES[itemId] ~= nil then
            local cost = GetCost(id)
            local buyoutCost = buyoutPrice / count
            local nextBid = math.max(minBid, bidAmount) + minIncrement
            local bidCost = nextBid / count
            local maxPrice = cost * count
            local smartBid = maxPrice / overbidProtection
            local minPrice = smartBid
            
            if buyoutPrice > 0 then
                minPrice = math.min(minPrice, buyoutPrice / BID_FACTOR)
            end
            
            if buyoutCost <= cost and buyoutPrice > 0 then
                PlaceAuctionBid("list", i, math.min(buyoutPrice, maxPrice))
                print(string.format("BUYING %s: [%d] x [%s] TOTAL [%s]",itemLink, count, GetMoneyString(buyoutPrice / count), GetMoneyString(buyoutPrice)))
            else
                if (bidCost <= cost) and (not highestBidder) then
                    local amountToBid = math.max(minPrice, nextBid)
                    PlaceAuctionBid("list", i, math.min(amountToBid, maxPrice))
                    print(string.format("BIDDING %s: [%d] x [%s] TOTAL [%s]", itemLink, count, GetMoneyString(amountToBid/count), GetMoneyString(amountToBid)))
                end
            end
        end
    end
end
