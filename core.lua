local addonName, addon = {}
local overbidProtection = 1.05 -- used to calculate min bid to make next bid more expensive than buylist, 1.05 is default, can be changed with parameters
local sessionBuylist = {} -- hashtable with session buylist and purchase info based on buylist from items.lua

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
        
        if sessionBuylist[name] ~= nil then -- check if item from our buylist
            local item = sessionBuylist[name]
 
            if (buyoutPrice > 0) and (buyoutPrice/count <= item.price) then -- buyout price exists and fits the buylist
				-- Save number of purchased items
                sessionBuylist[name].buyCount = sessionBuylist[name].buyCount + count
				
				-- Save spent amount
                sessionBuylist[name].buyAmount = sessionBuylist[name].buyAmount + buyoutPrice
                
				-- Buyout the item
                PlaceAuctionBid("list", i, buyoutPrice)
            elseif (not highestBidder) -- we don't have a bid on the item
                and ((minBid + minIncrement) / count <= item.price) -- bid amount fits the buylist (for items without bids)
                and ((bidAmount + minIncrement) / count <= item.price) then -- bid amount fits the buylist (for items that have bids from other players)
                
				-- Min safe bid per item
				local smartBid = item.price / overbidProtection
				
				-- Amount to bid shouldn't be less than smartBid
                local amountToBid = math.max(minBid + minIncrement, smartBid * count, bidAmount + minIncrement)
                
				-- Save number of items bid on
                sessionBuylist[name].bidCount = sessionBuylist[name].bidCount + count
				
				-- Save spent amount
                sessionBuylist[name].bidAmount = sessionBuylist[name].bidAmount + amountToBid
				
                PlaceAuctionBid("list", i, amountToBid) -- place a bid
            end
        end
    end
end

SLASH_PURCHASEINFO1 = "/purchaseinfo"
SlashCmdList["PURCHASEINFO"] = function()
    local buyDiscount = 0; -- gold saved on buyouts (based in difference with buylist price)
    local bidDiscount = 0; -- gold saved on bids (based in difference with buylist price)
    
	-- Run through the list to calculate total discounts
    for itemName, item in pairs(sessionBuylist) do
        if (item.buyCount > 0) then -- for buyouts
            buyDiscount = buyDiscount + (item.price * item.buyCount - item.buyAmount)
        end

        if (item.bidCount > 0) then -- for bids
            bidDiscount = bidDiscount + (item.price * item.bidCount - item.bidAmount)
        end
    end
    
	
	print("BUYOUTS:");
    for itemName, item in pairs(sessionBuylist) do
        if (item.buyCount > 0) then
			local itemLink = select(2, GetItemInfo(item.id)) or ("|cff00ff00[Item " .. item.id .. "]|r")
			local average = item.buyAmount / item.buyCount
			
			print(string.format("%s x%d %s", itemLink, item.buyCount, GetCoinTextureString(average, 9)))
        end
	end
	
	
	print("BIDS:");
	for itemName, item in pairs(sessionBuylist) do
        if (item.bidCount > 0) then
			local itemLink = select(2, GetItemInfo(item.id)) or ("|cff00ff00[Item " .. item.id .. "]|r")
			local average = item.bidAmount / item.bidCount
			
			print(string.format("%s x%d %s", itemLink, item.bidCount, GetCoinTextureString(average, 9)))
        end
    end
    
    -- Print bid info
	print(string.format("BID DELTA: %s", GetCoinTextureString(bidDiscount)))
    -- Print buyout info
	print(string.format("BUYOUT DELTA: %s", GetCoinTextureString(buyDiscount)))
end

-- Buy out all items from buylist on the current ah page, that fit the price
-- No bids, only buyouts
SLASH_BUY1 = "/buy"
SlashCmdList["BUY"] = function() 
    -- Check if we on the ah
    if not AuctionFrame or not AuctionFrame:IsShown() then
        return
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
			end
        end
    end
end

-- Show your current buylist in [item link] - [item price] format
SLASH_BUYLIST1 = "/buylist"
SLASH_BUYLIST2 = "/bl"
SlashCmdList["BUYLIST"] = function()
    for _, item in ipairs(buylist) do
        local itemLink = select(2, GetItemInfo(item.id)) or ("|cff00ff00[Item " .. item.id .. "]|r")
        print(string.format("%s %s", itemLink, GetCoinTextureString(item.price)))
    end
end
