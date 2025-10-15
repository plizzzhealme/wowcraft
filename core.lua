--local addonName, addon = {}

SLASH_BUYBIDALL1 = "/buybidall"
SlashCmdList["BUYBIDALL"] = function(msg)
    BuyBidAll(msg)
end

SLASH_BUYALL1 = "/buyall"
SlashCmdList["BUYALL"] = function()
    BuyAll()
end
