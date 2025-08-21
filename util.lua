-- Function to check if item is in MAT
function IsMat(itemId)
    return MAT[itemId] ~= nil
end

-- Function to check if item is in BOE_245_HORDE
function IsBoe264(itemId)
    return BOE_264[itemId] ~= nil
end

-- Function to check if item is in BOE_245_HORDE
function IsBoe245Horde(itemId)
    return BOE_245_HORDE[itemId] ~= nil
end

-- Function to check if item is in BOE_245_ALLIANCE
function IsBoe245Alliance(itemId)
    return BOE_245_ALLIANCE[itemId] ~= nil
end

-- Function to check if item is in BOES_200
function IsBoe200(itemId)
    return BOE_200[itemId] ~= nil
end

-- Function to check if item is in any BOE list
function IsBoe(itemId)
    return IsBoe264(itemId) or IsBoe245Horde(itemId) or IsBoe245Alliance(itemId) or IsBoe200(itemId)
end

--Function to check if item is in any buylist
function IsItemFromList(itemId)
    return IsBoe(itemId) or IsMat(itemId)
end

-- Function to print all BOE 264 item links
function Print264()
    print("=== 264 ===")
    
    for itemId, recipe in pairs(BOE_264) do
        local cost = GetCost(itemId)
        local itemLink = select(2, GetItemInfo(itemId)) or "|cffffffff|Hitem:"..itemId.."|h[Item "..itemId.."]|h|r"
        
        print(string.format("%s [%s]", itemLink, cost))
    end
end

function PrintBoe264()
    print("=== 264 ===")
    
    for itemId, recipe in pairs(BOE_264) do
        local cost = GetCost(itemId)
        local itemLink = select(2, GetItemInfo(itemId)) or "|cffffffff|Hitem:"..itemId.."|h[Item "..itemId.."]|h|r"
        
        print(string.format("%s [%s]", itemLink, GetMoneyString(cost)))
    end
end

function PrintBoe245()
    print("=== 245 ===")
    
    local faction = UnitFactionGroup("player")
    local boe245
    
    if faction == "Horde" then
        boe245 = BOE_245_HORDE
    else
        boe245 = BOE_245_ALLIANCE
    end
    
    for itemId, recipe in pairs(boe245) do
        local cost = GetCost(itemId)
        local itemLink = select(2, GetItemInfo(itemId)) or "|cffffffff|Hitem:"..itemId.."|h[Item "..itemId.."]|h|r"
        
        print(string.format("%s [%s]", itemLink, GetMoneyString(cost)))
    end
end

function PrintBoe200()
    print("=== 200 ===")
    
    for itemId, recipe in pairs(BOE_200) do
        local cost = GetCost(itemId)
        local itemLink = select(2, GetItemInfo(itemId)) or "|cffffffff|Hitem:"..itemId.."|h[Item "..itemId.."]|h|r"
        
        print(string.format("%s [%s]", itemLink, GetMoneyString(cost)))
    end
end

function PrintBoe()
    PrintBoe200()
    PrintBoe245()
    PrintBoe264()
end

function GetMoneyString(money)
    local gold = floor(money / 10000)
    local silver = floor((money - gold * 10000) / 100)
    local copper = mod(money, 100)
    if gold > 0 then
        return format(GOLD_AMOUNT_TEXTURE.." "..SILVER_AMOUNT_TEXTURE.." "..COPPER_AMOUNT_TEXTURE, gold, 0, 0, silver, 0, 0, copper, 0, 0)
    elseif silver > 0 then
        return format(SILVER_AMOUNT_TEXTURE.." "..COPPER_AMOUNT_TEXTURE, silver, 0, 0, copper, 0, 0)
    else
        return format(COPPER_AMOUNT_TEXTURE, copper, 0, 0)
    end
end

function ShowBuylist()
    local buylistOrder = {
        36860, 35627, 35625, 35624, 35623, 35622, 37702, 37703, 37704, 37701, 37700, 37705,
        41163, 36910, 36913, 36912, 37663, 33470, 41510, 41511, 41595, 41593, 41594, 42253,
        34052, 34053, 34054, 34057, 34055, 34056, 36908, 33567, 33568, 38425, 44128, 38557,
        38558, 38561, 36919, 36934, 36925, 36922, 36924, 36784, 41355, 41245, 38426, 47556,
        43102, 45087, 49908
    }
    
    for _, itemId in ipairs(buylistOrder) do
        local itemLink = select(2, GetItemInfo(itemId)) or ("|cff00ff00[Item " .. itemId .. "]|r")
        
        print(string.format("%s [%s]", itemLink, GetMoneyString(MATS[itemId])))
    end
end

function GetCost(itemId)
    local cost = 0
    
    if IsMat(itemId) then
        cost = MAT[itemId]
    elseif IsBoe(itemId) then
        local boe = BOE_264[itemId] or BOE_245_HORDE[itemId] or BOE_245_ALLIANCE[itemId] or BOE_200[itemId]
        
        for matId, quantity in pairs(boe) do
            cost = cost + MAT[matId] * quantity
        end
    end
    
    return cost
end

local function AddNonProfitPriceToTooltip(tooltip, itemId)
    local cost = GetCost(itemId)
    local price = cost / AH_CUT_MULTIPLIER
    local formattedCost = GetCoinTextureString(cost)
    local formattedPrice = GetCoinTextureString(price)
    
    tooltip:AddLine("ID: "..itemId, 1, 1, 1)
    tooltip:AddLine("COST: "..formattedCost, 1, 1, 1)
    tooltip:AddLine("NONPROFIT: "..formattedPrice, 1, 1, 1)
    tooltip:Show()
end

GameTooltip:HookScript("OnTooltipSetItem", function(tooltip)
    local _, itemLink = tooltip:GetItem()
    
    if itemLink then
        local itemID = tonumber(string.match(itemLink, "item:(%d+)"))
        
        if itemID then
            AddNonProfitPriceToTooltip(tooltip, itemID)
        end
    end
end)
