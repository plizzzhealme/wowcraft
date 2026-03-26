# WOWCRAFT

## Overview
This addon provides various slash commands to automate auction house interactions

## Commands

### /postitems
Posts items to the auction house based on your configured settings.

**Usage:** `/postitems`

**Description:** Automatically lists items from your inventory to the auction house. This will use your predefined settings for pricing and duration.

---

### `/vendorbuy`
Sells items to vendors for profit.

**Usage:** `/vendorbuy`

**Description:** Automatically sells items from your inventory to the current vendor that have a vendor sell price higher than their market value or purchase price. Identifies profitable items to flip for vendor profit.

---

### `/buybidmats [value]`
Places bids on material items in the auction house.

**Usage:** `/buybidmats [value]`

**Parameters:**
- `[value]` (optional): The overbid protection multiplier. If not specified, uses the default `BID_INCREMENT_MULTIPLIER`.

**Description:** Scans the current auction house list and places bids on all items that are classified as materials. The bid amount is calculated using the configured bidding strategy.

**Examples:**
- `/buybidmats` - Uses default multiplier
- `/buybidmats 1.5` - Uses 1.5x multiplier for bids

---

### `/buybidall [value]`
Places bids on all items in the auction house.

**Usage:** `/buybidall [value]`

**Parameters:**
- `[value]` (optional): The overbid protection multiplier. If not specified, uses the default `BID_INCREMENT_MULTIPLIER`.

**Description:** Scans the current auction house list and places bids on all items. The bid amount is calculated using the configured bidding strategy.

**Examples:**
- `/buybidall` - Uses default multiplier
- `/buybidall 2.0` - Uses 2.0x multiplier for bids

---

### `/buyall`
Buys all relevant items from the auction house.

**Usage:** `/buyall`

**Description:** Purchases all items that match your configured criteria from the current auction house listing. Unlike the bid commands, this performs immediate buyout purchases rather than placing bids.

---

## Notes
- All auction house commands require the Auction House frame to be open
- Bids will only be placed on items that match your configured filters
- The bid amount is calculated by the `getBidAmount()` function based on current auction prices and your protection multiplier
- Vendor selling requires a vendor window to be open

## Configuration
Make sure to configure the following settings in your addon:
- `BID_INCREMENT_MULTIPLIER` - Default multiplier for bid calculations
- `IsItemFromList()` - Function that defines which items are included in "all" operations
- `IsMat()` - Function that defines which items are considered materials
- `getBidAmount()` - Function that calculates the bid amount for each item