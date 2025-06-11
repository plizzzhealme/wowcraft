local addonName, addon = {}
local overbidProtection = 1.05 -- Used to calculate min bid to make next bid more expensive than buylist, 1.05 is default, can be changed with parameters
local sessionBuylist = {} -- Hastable with session buylist and purchase info based on buylist from items.lua

for _, item in ipairs(buylist) do
    sessionBuylist[item.name] = {
        id = item.id,
        name = item.name,
        price = item.price,
        bidCount = 0, -- number of items bid on
        bidAmount = 0, -- amount spent on bids
        buyCount = 0, -- number of items bought out
        buyAmount = 0 -- amount spent on buyouts
    }
end

-- Buy out all items from buylist on the current ah page, that fit the price
-- Bid on everything that impossible to buyout with at least buylistPrice / overbidProtection (1.05 is default)
-- Use /fuck 10000 (any big number) to make as minimum bids as possible
-- Use /fuck 1 to make bids equal to buylist price
SLASH_FUCK1 = "/fuck"
SlashCmdList["FUCK"] = function(msg)
    -- Check if we on the ah
    if not AuctionFrame or not AuctionFrame:IsShown() then
        return
    end

    -- Get overbidProtection from parameters. Example /fuck 1.04
    if msg and msg ~= "" then
      overbidProtection = tonumber(msg) or 1.05
    end
    
    for i = 1, GetNumAuctionItems("list") 
            do local name, texture, count, quality, canUse, level, minBid, minIncrement, buyoutPrice, bidAmount, highestBidder, owner, sold = GetAuctionItemInfo("list", i)
        
        -- Check if item from our buylist
        if sessionBuylist[name] ~= nil then
            local item = sessionBuylist[name]

            -- If buyout price exists and fits the buylist
            if (buyoutPrice > 0) and (buyoutPrice/count <= item.price) then 
                print("buying [x"..count.."] "..item.name.." "..(buyoutPrice/count/10000).." each"); -- print purchase info
                
                sessionBuylist[name].buyCount = sessionBuylist[name].buyCount + count -- save number of purchased items
                sessionBuylist[name].buyAmount = sessionBuylist[name].buyAmount + buyoutPrice -- save spent amount
                
                PlaceAuctionBid("list", i, buyoutPrice) -- buyout the item
            elseif (not highestBidder) -- if we don't have a bid on the item
                and ((minBid + minIncrement) / count <= item.price) -- if bid amount fits the buylist (for items without bids)
                and ((bidAmount + minIncrement) / count <= item.price) then -- if bid amount fits the buylist (for items that have bids from other players)
                local smartBid = item.price / overbidProtection -- min safe bid per item
                local amountToBid = math.max(minBid + minIncrement, smartBid * count, bidAmount + minIncrement) -- amount to bid shouldn't be less than smartBid
                
                print("bidding [x"..count.."] "..item.name.." "..(amountToBid/count/10000).." each");
                sessionBuylist[name].bidCount = sessionBuylist[name].bidCount + count -- save number of items bid on
                sessionBuylist[name].bidAmount = sessionBuylist[name].bidAmount + amountToBid -- save spent amount
                PlaceAuctionBid("list", i, amountToBid) -- place a bid
            end
        end
    end
end

SLASH_SHOWSESSIONSTAT1= "/showsessionstat"
SlashCmdList["SHOWSESSIONSTAT"] = function()
    local buyoutDiscount = 0;
    local bidDiscount = 0;
    
    for itemName, item in pairs(sessionBuylist) do
        if (item.buyCount > 0) then
            print("flag")
            buyoutDiscount = buyoutDiscount + (item.price * item.buyCount - item.buyAmount)
        end

        if (item.bidCount > 0) then
            bidDiscount = bidDiscount + (item.price * item.bidCount - item.bidAmount)
        end
    end
    
    for itemName, item in pairs(sessionBuylist) do
        if (item.buyCount > 0) then
            print(item.name.." x"..item.buyCount.." "..((item.buyAmount / item.buyCount /10000)).." average price, "..(item.buyAmount / 10000).." total");
        end

        if (item.bidCount > 0) then
            print(item.name.." x"..item.bidCount.." "..((item.bidAmount / item.bidCount /10000)).." average price, "..(item.bidAmount / 10000).." total");
        end
    end

    print("Buy discount: "..buyoutDiscount/10000);
    print("Bid discount: "..bidDiscount/10000);
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
