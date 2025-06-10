local addonName, addon = {}

SLASH_FUCK1 = "/fuck"
SlashCmdList["FUCK"] = function(msg)
    local fuckCoef = 1.05
    local buyDiscount = 0
    local bidDiscount = 0

    
    if msg and msg ~= "" then
      fuckCoef = tonumber(msg) or 1.05
    end

    if not AuctionFrame or not AuctionFrame:IsShown() then
        print("Open Auction House first")
        return
    end
    
    for _, item in ipairs(buylist) do
        for i = 1, GetNumAuctionItems("list") do
            local name, texture, count, quality, canUse, level, minBid, minIncrement, buyoutPrice, bidAmount, highestBidder, owner, sold = GetAuctionItemInfo("list", i)
            
            if name == item.name then
                local smartBid = item.price / fuckCoef
                
                if (buyoutPrice > 0) and (buyoutPrice/count <= item.price) then
                    local lastMoney = GetMoney()
                    PlaceAuctionBid("list", i, buyoutPrice)

                    if (lastMoney > GetMoney()) then
                        buyDiscount = buyDicount + buyoutPrice
                    end
                elseif (not highestBidder)
                    and ((minBid + minIncrement) / count <= item.price)
                    and ((bidAmount + minIncrement) / count <= item.price) then
                    local lastMoney = GetMoney();
                    bidPrice = math.max(minBid + minIncrement, smartBid * count, bidAmount + minIncrement)
                    PlaceAuctionBid("list", i, bidPrice)
                    
                    if (latMoney > GetMoney()) then
                        bidDicount = bidDiscount + bidPrice
                    end
                end
            end
        end
    end
    print(string.format("BUYOUT PROFIT: %.4f", buyDiscount / 10000))
    print(string.format("POSSIBLE BID PROFIT: %.4f", bidDiscount / 10000))
end

SLASH_BUY1 = "/buy"
SlashCmdList["BUY"] = function() 
    if not AuctionFrame or not AuctionFrame:IsShown() then 
        print("Open Auction House first") 
        return
    end

    for _, item in ipairs(buylist) do
        for i = 1, GetNumAuctionItems("list") do  
            local name, texture, count, quality, canUse, level, minBid, minIncrement, buyoutPrice, bidAmount, highestBidder, owner, sold = GetAuctionItemInfo("list", i) 
        
            if name == item.name then 
                if buyoutPrice/count <= item.price then  
                    PlaceAuctionBid("list", i, buyoutPrice) 
                end
            end 
        end 
    end
end

SLASH_BUYLIST1 = "/buylist"
SLASH_BUYLIST2 = "/bl"
SlashCmdList["BUYLIST"] = function()
    print("----------------------------------")
    for _, item in ipairs(buylist) do
        local itemLink = select(2, GetItemInfo(item.id)) or ("|cff00ff00[Item " .. item.id .. "]|r")
        print(string.format("%s - %.4f", itemLink, item.price/10000))
    end
    print("----------------------------------")
end
