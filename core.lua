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
 
            if buyoutPrice > 0 then
				local ahPrice = buyoutPrice / count
				
				if ahPrice <= item.price then
					PlaceAuctionBid("list", i, buyoutPrice)
				elseif (not highestBidder) and  (ahPrice / 1.05 <= item.price) then
					PlaceAuctionBid("list", i, buyoutPrice / 1.05)
				end
            elseif (not highestBidder) and ((minBid + minIncrement) / count <= item.price)and ((bidAmount + minIncrement) / count <= item.price) then
				local smartBid = item.price / overbidProtection
                local amountToBid = math.max(minBid + minIncrement, smartBid * count, bidAmount + minIncrement)
				
                PlaceAuctionBid("list", i, amountToBid)
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
