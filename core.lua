local addonName, addon = {}

SLASH_BUYBID1 = "/buybid"
SlashCmdList["BUYBID"] = function(msg)
    BuyBid(msg)
end

SLASH_BUY1 = "/buy"
SlashCmdList["BUY"] = function() 
    Buy()
end

SLASH_BUYLIST1 = "/buylist"
SlashCmdList["BUYLIST"] = function()
    ShowBuylist()
end

SLASH_BOELIST1 = "/boelist"
SlashCmdList["BOELIST"] = function()
    ShowBoelist()
end
