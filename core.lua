--local addonName, addon = {}

SLASH_BUYBID1 = "/buybid"
SlashCmdList["BUYBID"] = function(msg)
    Purchase(msg)
end

SLASH_BUY1 = "/buy"
SlashCmdList["BUY"] = function()
    Buy()
end

SLASH_BUYLIST1 = "/buylist"
SlashCmdList["BUYLIST"] = function()
    ShowBuylist()
end
