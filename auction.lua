local BID_FACTOR = 1.05

local function getBidAmount(i, overbidProtection)
    local _, _, count, _, _, _, minBid, minIncrement, buyoutPrice, bidAmount, highestBidder, _, _ = GetAuctionItemInfo("list", i)
    local itemLink = GetAuctionItemLink("list", i)
    local itemId = itemLink and itemLink:match("item:(%d+):") or nil
    local itemCost = GetCost(itemId)
    local nextBid = math.max(minBid, bidAmount) + minIncrement
    local bidCost = nextBid / count
    
    --stop if over buylist price
    if bidCost > itemCost then
        return 0
    end
    
    local buyoutCost = buyoutPrice / count
    
    --instant buyout if possible
    if buyoutCost <= itemCost then
        return buyoutPrice
    end
    
    --skip auctions we have bids on
    if highestBidder then
        return 0
    end
    
    local safeBid = math.max(nextBid, count * itemCost / overbidProtection)
    
    if not buyoutPrice then
        return safeBid
    end
    
    return math.min(safeBid, buyoutPrice / BID_FACTOR)
end

function BuyBid(msg)
    if not AuctionFrame or not AuctionFrame:IsShown() then
        return
    end

    local overbidProtection = tonumber(msg) or BID_FACTOR
    
    for i = 1, GetNumAuctionItems("list") do
        local name, _, count, _, _, _, minBid, minIncrement, buyoutPrice, bidAmount, highestBidder, _, _ = GetAuctionItemInfo("list", i)
        local itemLink = GetAuctionItemLink("list", i)
        local itemId = itemLink and itemLink:match("item:(%d+):") or nil
        
        local testBid = getBidAmount(i, overbidProtection)
        
        if testBid > 0 then
            print(GetMoneyString(testBid))
        end
        
        if itemId then
            itemId = tonumber(itemId)
        end
        
        if MATS[itemId] ~= nil or BOES[itemId] ~= nil then
            local cost = GetCost(itemId)
            local buyoutCost = buyoutPrice / count
            local nextBid = math.max(minBid, bidAmount) + minIncrement
            local bidCost = nextBid / count
            local maxPrice = cost * count
            local safeBid = maxPrice / overbidProtection
            local minPrice = safeBid
            
            if buyoutPrice > 0 then
                minPrice = math.min(minPrice, buyoutPrice / BID_FACTOR)
            end
            
            if buyoutCost <= cost and buyoutPrice > 0 then
                PlaceAuctionBid("list", i, math.min(buyoutPrice, maxPrice))
                print(string.format("BUYING %s: [%d] x [%s] = [%s]",itemLink, count, GetMoneyString(buyoutPrice / count), GetMoneyString(buyoutPrice)))
            else
                if (bidCost <= cost) and (not highestBidder) then
                    local amountToBid = math.max(minPrice, nextBid)
                    PlaceAuctionBid("list", i, math.min(amountToBid, maxPrice))
                    print(string.format("BIDDING %s: [%d] x [%s] = [%s]", itemLink, count, GetMoneyString(amountToBid/count), GetMoneyString(amountToBid)))
                end
            end
        end
    end
end


