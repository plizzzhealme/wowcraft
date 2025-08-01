local addonName, addon = {}
local overbidProtection = 1.05
local sessionBuylist = {}

for _, item in ipairs(buylist) do
    sessionBuylist[item.name] = {
        id = item.id,
        name = item.name,
        price = item.price
    }
end

SLASH_FUCK1 = "/fuck"
SlashCmdList["FUCK"] = function(msg)
    if not AuctionFrame or not AuctionFrame:IsShown() then
        return
    end

    if msg and msg ~= "" then
      overbidProtection = tonumber(msg) or 1.05
    end
    
    for i = 1, GetNumAuctionItems("list") do
        local name, texture, count, quality, canUse, level, minBid, minIncrement, buyoutPrice, bidAmount, highestBidder, owner, sold = GetAuctionItemInfo("list", i)
            
        if sessionBuylist[name] ~= nil then
            local item = sessionBuylist[name]
            
            local buyoutCost = buyoutPrice / count
            local nextBid = math.max(minBid, bidAmount) + minIncrement
            local bidCost = nextBid / count
            local maxPrice = item.price * count
            local smartBid = maxPrice / overbidProtection
            local minPrice = smartBid
            
            if buyoutPrice > 0 then
                minPrice = math.min(minPrice, buyoutPrice / 1.05)
            end
            
            if buyoutCost <= item.price and buyoutPrice > 0 then
                print(string.format("%s: buyout %s",name, GetColoredMoney(buyoutPrice / count)))
                PlaceAuctionBid("list", i, math.min(buyoutPrice, maxPrice))
            else
                if (bidCost <= item.price) and (not highestBidder) then
                    local amountToBid = math.max(minPrice, nextBid)
                    print(string.format("%s: buy/1.05 %s, min %s , smart %s, bid %s", name, GetColoredMoney(buyoutPrice/count/1.05), GetColoredMoney(nextBid/count), GetColoredMoney(smartBid/count), GetColoredMoney(amountToBid/count)))
                    PlaceAuctionBid("list", i, math.min(amountToBid, maxPrice))
                end
            end
        end
    end
end
function GetColoredMoney(copper)
    local gold = math.floor(copper / 10000)
    local silver = math.floor((copper % 10000) / 100)
    local copper = copper % 100
    
    -- Classic WoW color codes
    local goldColor = "|cFFFFD700"   -- Gold (yellow)
    local silverColor = "|cFFC0C0C0" -- Silver (light gray)
    local copperColor = "|cFFB87333" -- Copper (orange-brown)
    
    return string.format(
        "%s%02d%s%02d%s%02d|r",
        goldColor, gold,
        silverColor, silver,
        copperColor, copper
    )
end


SLASH_BUY1 = "/buy"
SlashCmdList["BUY"] = function() 
    if not AuctionFrame or not AuctionFrame:IsShown() then
        return
    end
    
    for i = 1, GetNumAuctionItems("list") do
        local name, texture, count, quality, canUse, level, minBid, minIncrement, buyoutPrice, bidAmount, highestBidder, owner, sold = GetAuctionItemInfo("list", i)
        
        if sessionBuylist[name] ~= nil then
            local item = sessionBuylist[name]
            
            if (buyoutPrice > 0) and (buyoutPrice/count <= item.price) then 
                PlaceAuctionBid("list", i, buyoutPrice)
            end
        end
    end
end

SLASH_BUYLIST1 = "/buylist"
SLASH_BUYLIST2 = "/bl"
SlashCmdList["BUYLIST"] = function()
    for _, item in ipairs(buylist) do
        local itemLink = select(2, GetItemInfo(item.id)) or ("|cff00ff00[Item " .. item.id .. "]|r")
        
        print(string.format("%s %s", itemLink, GetCoinTextureString(item.price)))
    end
end
