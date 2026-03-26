# Wowcraft Commands

## Overview
This addon automates auction house operations including posting crafted items, bidding on materials, and vendor flipping.

## Commands

### `/postitems`
Posts crafted items to the auction house.

**Usage:** `/postitems`

**Description:** Automatically lists all crafted items from your inventory on the auction house for 48 hours. Prices are automatically calculated based on material costs from your configured buylist.

---

### `/buybidmats [value]`
Bids on and buys materials at profitable prices.

**Usage:** `/buybidmats [value]`

**Parameters:**
- `[value]` (optional): Overbid protection multiplier. Defaults to `BID_INCREMENT_MULTIPLIER = 1.05` if not specified.

**Description:** Scans the auction house and places bids or performs buyouts on materials that are priced at or below their value according to your buylist.

The `value` parameter (e.g., `1.025`) sets your bid price to `buylist_price / value`. This ensures that if a competitor outbids you, their bid will exceed the buylist price (since the next bid must be 1.05x higher than yours, making it unprofitable for them).

**Example:**
- If `buylist_price = 100g` and you use `/buybidmats 1.025`:
  - Your bid = `100g / 1.025 ≈ 97.56g`
  - Next minimum bid = `97.56g × 1.05 ≈ 102.44g` (above buylist price)
  - Competitors cannot profitably outbid you

**Examples:**
- `/buybidmats` - Uses default multiplier
- `/buybidmats 1.025` - Sets bid to buylist_price / 1.025

---

### `/buybidall [value]`
Bids on and buys both materials and crafted items.

**Usage:** `/buybidall [value]`

**Parameters:**
- `[value]` (optional): Overbid protection multiplier. Defaults to `BID_INCREMENT_MULTIPLIER` if not specified.

**Description:** Same functionality as `/buybidmats`, but additionally targets crafted items made from materials. Scans the auction house and places bids or performs buyouts on both materials and crafted items that are priced at or below their value according to your buylist.

The same overbid protection logic applies, ensuring competitors cannot profitably outbid your offers.

**Examples:**
- `/buybidall` - Uses default multiplier
- `/buybidall 1.03` - Sets bid to buylist_price / 1.03

---

### `/vendorbuy`
Buys items from auction house for vendor flipping.

**Usage:** `/vendorbuy`

**Description:** Scans the auction house and performs immediate buyouts on items that are listed below their vendor sell price. After purchasing, you can sell these items directly to any vendor for a guaranteed profit.
