biddingQueue = {
    data = {},
    head = 1,
    tail = 1,
    maxSize = 50000
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
    if self.head >= self.tail then
        return nil
    end
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

local frame = CreateFrame("FRAME")
frame:RegisterEvent("CHAT_MSG_SYSTEM")
frame:SetScript("OnEvent", function(self, event, message)
    if string.find(message, "Bid accepted.") then
        print(biddingQueue:Pop())
    end
end)
