local addonName, addon = {}

SLASH_FUCK1 = "/fuck"
SlashCmdList["FUCK"] = function(msg)
    local fuckCoef = 1.05
    
    if msg and msg ~= "" then
      fuckCoef = tonumber(msg) or 1.05
    end

    if not AuctionFrame or not AuctionFrame:IsShown() then
        print("Open Auction House first")
        return
    end
    
    for _, item in ipairs(buylist) do
        for i = 1, GetNumAuctionItems("list") do
            local name,
            texture,
            count,
            quality,
            canUse, level,
            minBid, minIncrement,
            buyoutPrice,
            bidAmount,
            highestBidder,
            owner,
            sold = GetAuctionItemInfo("list", i)
            
            if name == item.name then
                local smartBid = item.price / fuckCoef
                
                if (buyoutPrice > 0) and (buyoutPrice/count <= item.price) then
                    PlaceAuctionBid("list", i, buyoutPrice)
                elseif (not highestBidder)
                    and ((minBid + minIncrement) / count <= item.price)
                    and ((bidAmount + minIncrement) / count <= item.price) then
                    PlaceAuctionBid("list", i, math.max(minBid + minIncrement, smartBid * count, bidAmount + minIncrement))
                end
            end
        end
    end
end

SLASH_BUY1 = "/buy"
SlashCmdList["BUY"] = function()
    if not AuctionFrame or not AuctionFrame:IsShown() then
        print("Open Auction House first")
        return
    end
    
    for i = 1, GetNumAuctionItems("list") do
            local name,
            texture,
            count,
            quality,
            canUse, level,
            minBid, minIncrement,
            buyoutPrice,
            bidAmount,
            highestBidder,
            owner,
            sold = GetAuctionItemInfo("list", i)
            
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
    for _, item in ipairs(buylist) do
        local itemLink = select(2, GetItemInfo(item.id)) or ("|cff00ff00[Item " .. item.id .. "]|r")
        print(string.format("%s - %.4f", itemLink, item.price/10000))
    end
end
