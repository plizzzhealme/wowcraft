AH_CUT_MULTIPLIER = 0.95
BID_INCREMENT_MULTIPLIER = 1.05

local Queue = {
    data = {},
    head = 1,
    tail = 1,
    maxSize = 50
}

function Queue:Push(item)
    if (self.tail - self.head) >= self.maxSize then
        table.remove(self.data, 1)  -- Remove oldest if full
        self.head = self.head + 1
    end
    self.data[self.tail] = item
    self.tail = self.tail + 1
end

function Queue:Pop()
    if self.head >= self.tail then return nil end
    local item = self.data[self.head]
    self.data[self.head] = nil
    self.head = self.head + 1
    return item
end

function Queue:Size()
    return self.tail - self.head
end

local function getBidAmount(i, overbidProtection)
    local _, _, count, _, _, _, minBid, minIncrement, buyoutPrice, bidAmount, highestBidder, _, _ = GetAuctionItemInfo("list", i)
    local itemLink = GetAuctionItemLink("list", i)
    local itemId = tonumber(itemLink:match("item:(%d+):"))
    
    local itemCost = GetCost(itemId)
    local nextBid = math.max(minBid, bidAmount) + minIncrement
    local nextBidCost = nextBid / count
    
    if nextBidCost > itemCost then
        return
    end
    
    local buyoutCost = buyoutPrice / count
    
    if 0 < buyoutCost and buyoutCost <= itemCost  then
        return buyoutPrice
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

local function isItemFromList(itemId)
    return MATS[itemId] ~= nil or BOES[itemId] ~= nil
end

function Purchase(msg)
    if not AuctionFrame or not AuctionFrame:IsShown() then
        return
    end

    local overbidProtection = tonumber(msg) or BID_INCREMENT_MULTIPLIER
    local numAuctionItems = GetNumAuctionItems("list")
    
    for i = 1, numAuctionItems do
        local itemLink = GetAuctionItemLink("list", i)
        local itemId = tonumber(itemLink:match("item:(%d+):"))
        
        if isItemFromList(itemId) then
            local amountToBid = getBidAmount(i, overbidProtection)
            
            if amountToBid then
                PlaceAuctionBid("list", i, amountToBid)
                
                local _, _, count, _, _, _, _, _, _, _, _, _, _ = GetAuctionItemInfo("list", i)
                --print(string.format("%s: [%d] x [%s] = [%s]", itemLink, count, GetMoneyString(amountToBid / count), GetMoneyString(amountToBid)))
                Queue:Push(string.format("%s: [%d] x [%s] = [%s]", itemLink, count, GetMoneyString(amountToBid / count), GetMoneyString(amountToBid)))
            end
        end
    end
end

local frame = CreateFrame("FRAME")
frame:RegisterEvent("CHAT_MSG_SYSTEM")
frame:SetScript("OnEvent", function(self, event, message)
    if string.find(message, "Bid accepted.") then
        print(Queue:Pop())
    end
end)

