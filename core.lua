local addonName, addon = {}

SLASH_BUYBID1 = "/buybid"
SlashCmdList["BUYBID"] = function(msg)
    buyBid(msg)
end

SLASH_BUY1 = "/buy"
SlashCmdList["BUY"] = function() 
    buy()
end

SLASH_BUYLIST1 = "/buylist"
SlashCmdList["BUYLIST"] = function()
    showBuylist()
end

SLASH_BOELIST1 = "/boelist"
SlashCmdList["BOELIST"] = function()
    showBoelist
end
