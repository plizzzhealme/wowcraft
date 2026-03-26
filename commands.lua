SLASH_POSTITEMS1 = "/postitems"
SlashCmdList["POSTITEMS"] = function()
    PostItems()
end

SLASH_VENDORBUY1 = "/vendorbuy"
SlashCmdList["VENDORBUY"] = function()
    BuyToVendor()
end

SLASH_BUYBIDMATS1 = "/buybidmats"
SlashCmdList["BUYBIDMATS"] = function(msg)
    BuyBidMats(msg)
end

local frame = CreateFrame("FRAME")
frame:RegisterEvent("CHAT_MSG_SYSTEM")
frame:SetScript("OnEvent", function(self, event, message)
    if string.find(message, "Bid accepted.") then
        print(biddingQueue:Pop())
    end
end)

SLASH_BUYBIDALL1 = "/buybidall"
SlashCmdList["BUYBIDALL"] = function(msg)
    BuyBidAll(msg)
end

SLASH_BUYALL1 = "/buyall"
SlashCmdList["BUYALL"] = function()
    BuyAll()
end