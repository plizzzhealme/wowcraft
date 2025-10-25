AH_CUT_MULTIPLIER = 0.95
BID_INCREMENT_MULTIPLIER = 1.05

local biddingQueue = {
    data = {},
    head = 1,
    tail = 1,
    maxSize = 500
}

function biddingQueue:Push(item)
    if (self.tail - self.head) >= self.maxSize then
        table.remove(self.data, 1)  -- Remove oldest if full
        self.head = self.head + 1
    end
    self.data[self.tail] = item
    self.tail = self.tail + 1
end

function biddingQueue:Pop()
    if self.head >= self.tail then return nil end
    local item = self.data[self.head]
    self.data[self.head] = nil
    self.head = self.head + 1
    return item
end

function biddingQueue:Reset()
    biddingQueue.data = {}
    biddingQueue.head = 1
    biddingQueue.tail = 1
end

local function getBidAmount(i, overbidProtection)
    local _, _, count, _, _, _, minBid, minIncrement, buyoutPrice, bidAmount, highestBidder, _, _ = GetAuctionItemInfo("list", i)
    local itemLink = GetAuctionItemLink("list", i)
    local itemId = tonumber(itemLink:match("item:(%d+):"))
    
    local itemCost = GetCost(itemId)
    local nextBid = math.max(minBid, bidAmount) + minIncrement
    local nextBidCost = nextBid / count
    
    local buyoutCost = buyoutPrice / count
    
    if 0 < buyoutCost and buyoutCost <= itemCost  then
        return buyoutPrice
    end
    
    if nextBidCost > itemCost then
        return
    end
    
    if highestBidder then
        return
    end
    
    local safeBid = count * itemCost / overbidProtection
    
    if buyoutPrice == 0 then
        return math.max(safeBid, nextBid)
    end
    
    return math.max(math.min(safeBid, buyoutPrice / BID_INCREMENT_MULTIPLIER), nextBid)
end

function BuyBidAll(msg)
    if not AuctionFrame or not AuctionFrame:IsShown() then
        return
    end
    
    biddingQueue:Reset()

    local overbidProtection = tonumber(msg) or BID_INCREMENT_MULTIPLIER
    local numAuctionItems = GetNumAuctionItems("list")
    
    for i = 1, numAuctionItems do
        local itemLink = GetAuctionItemLink("list", i)
        local itemId = tonumber(itemLink:match("item:(%d+):"))
        
        if IsItemFromList(itemId) then
            local _, _, count, _, _, _, _, _, buyoutPrice, _, _, owner, _ = GetAuctionItemInfo("list", i)
            local amountToBid = getBidAmount(i, overbidProtection)
            
            if amountToBid then
                
                biddingQueue:Push(string.format("%s: [%d] x [%s] = [%s] from [%s]", itemLink, count, GetMoneyString(amountToBid / count), GetMoneyString(amountToBid), owner or "noname"))
                PlaceAuctionBid("list", i, amountToBid)
            end
        end
    end
end

function BuyBidMats(msg)
    if not AuctionFrame or not AuctionFrame:IsShown() then
        return
    end
    
    biddingQueue:Reset()

    local overbidProtection = tonumber(msg) or BID_INCREMENT_MULTIPLIER
    local numAuctionItems = GetNumAuctionItems("list")
    
    for i = 1, numAuctionItems do
        local itemLink = GetAuctionItemLink("list", i)
        local itemId = tonumber(itemLink:match("item:(%d+):"))
        
        if IsMat(itemId) then
            local _, _, count, _, _, _, _, _, buyoutPrice, _, _, owner, _ = GetAuctionItemInfo("list", i)
            local amountToBid = getBidAmount(i, overbidProtection)
            
            if amountToBid then
                
                biddingQueue:Push(string.format("%s: [%d] x [%s] = [%s] from [%s]", itemLink, count, GetMoneyString(amountToBid / count), GetMoneyString(amountToBid), owner or "noname"))
                PlaceAuctionBid("list", i, amountToBid)
            end
        end
    end
end

function BuyAll()
    if not AuctionFrame or not AuctionFrame:IsShown() then
        return
    end
    
    biddingQueue:Reset()
    local numAuctionItems = GetNumAuctionItems("list")
    
    for i = 1, numAuctionItems do
        local itemLink = GetAuctionItemLink("list", i)
        local itemId = tonumber(itemLink:match("item:(%d+):"))
        
        if IsItemFromList(itemId) then
            local _, _, count, _, _, _, _, _, buyoutPrice, _, _, owner, _ = GetAuctionItemInfo("list", i)
            local itemLink = GetAuctionItemLink("list", i)
            local itemId = tonumber(itemLink:match("item:(%d+):"))
            local buyoutCost = buyoutPrice / count
            local itemCost = GetCost(itemId)
    
            if 0 < buyoutCost and buyoutCost <= itemCost  then
                biddingQueue:Push(string.format("%s: [%d] x [%s] = [%s] from [%s]", itemLink, count, GetMoneyString(buyoutPrice / count), GetMoneyString(buyoutPrice), owner or "noname"))
                PlaceAuctionBid("list", i, buyoutPrice)
            end
        end
    end
end

local DURATION = 3  -- 3 = 48 hours (0:12h, 1:24h, 2:48h, 3:48h in 3.3.5a)

-- Function to post BoE items from bags
function PostItems()
    for bag = 0, 3 do
        local numSlots = GetContainerNumSlots(bag)
        
        for slot = 1, numSlots do
            local itemLink = GetContainerItemLink(bag, slot)
            
            if itemLink then
                local itemId = GetItemInfoFromHyperlink(itemLink)
                
                if not IsMat(itemId) and IsProfessionItem(itemId) then
                    local price = GetCost(itemId) / AH_CUT_MULTIPLIER
                    local _, itemCount, _, _, _, _, _ = GetContainerItemInfo(bag, slot)
                    local stackSize = 1
                    local randomProfit = math.random(0,10000)
                    PickupContainerItem(bag, slot)
                    ClickAuctionSellItemButton()
                    ClearCursor()
                    StartAuction(price + randomProfit, price + randomProfit, DURATION, stackSize, itemCount)
                    print(format("%s %s x %d", itemLink, GetMoneyString(price + randomProfit), itemCount))
                end
            end
        end
    end
end

-- Helper function to extract item ID from hyperlink
function GetItemInfoFromHyperlink(hyperlink)
    if not hyperlink then return nil end
    local _, _, itemString = string.find(hyperlink, "|H(.+)|h%[.+%]")
    if itemString then
        local _, itemId = strsplit(":", itemString)
        return tonumber(itemId)
    end
    return nil
end

SLASH_POSTITEMS1 = "/postitems"
SlashCmdList["POSTITEMS"] = function()
    PostItems()
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

