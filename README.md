# 🎟️ Ticket Selling Smart Contract

A Solidity smart contract that simulates a ticketing system for a large event.
Users can purchase tickets by selecting a unique seat number, with constraints on availability and per-user limits.

## 📌 Overview

This contract allows users to:

* Purchase tickets for specific seat numbers
* Enforce uniqueness of seats (no double booking)
* Limit the number of tickets per address
* Track ownership of tickets on-chain
* Detect when the event is sold out

This project is applies core Solidity concepts such as:

* Structs and mappings
* Modifiers
* Events
* State management
* Input validation


## ⚙️ Contract Utility

### Key Features

* ✅ **Seat-based ticketing system**
  Each ticket corresponds to a unique seat number.

* ✅ **Ownership tracking**
  Each ticket stores the buyer’s address.

* ✅ **Purchase limits**
  Each address can buy up to `MAX_TICKETS_PER_ADDRESS`.

* ✅ **Seat validation**
  Prevents:

  * Invalid seat numbers
  * Double booking of seats

* ✅ **Event tracking via events**

  * `TicketSold` emitted on each purchase
  * `EventSoldOut` emitted when all tickets are sold


## 🧱 Contract Structure

### Constants

* `MAX_TICKETS_PER_ADDRESS`: Maximum tickets per user
* `MAX_SEAT_NUMBER`: Maximum seat number allowed
* `TOTAL_TICKETS`: Total tickets available

### State Variables

* `remainingTickets`: Tracks remaining supply
* `nextTicketId`: Auto-incrementing ticket ID

### Struct

```solidity
struct Ticket {
    uint256 id;
    address owner;
    uint256 seatNumber;
}
```

### Mappings

* `tickets`: Stores all tickets by ID
* `ticketsBoughtPerAddress`: Tracks purchases per user
* `seatTaken`: Tracks whether a seat is already sold

### Modifiers

* `checkRemainingTickets`
* `checkTicketBuyingLimit`
* `checkSeatAvailable`
* `checkSeatNumberInRange`

These enforce all business rules before executing the purchase.

### Main Function

#### `buyTicket(uint256 seatNumber_)`

Handles the full purchase flow:

* Validates constraints
* Creates and stores ticket
* Updates state
* Emits events

Returns the created `Ticket`.

---

## 🧪 How to Test in Remix

### 1️⃣ Open Remix

Go to: [https://remix.ethereum.org](https://remix.ethereum.org)

---

### 2️⃣ Import the Contract

* Create a new file: `TicketSelling.sol`
* Paste the contract code

---

### 3️⃣ Compile

* Go to **Solidity Compiler**
* Select version `0.8.30`
* Click **Compile**

---

### 4️⃣ Deploy

* Go to **Deploy & Run Transactions**
* Environment: `Remix VM (London)`
* Click **Deploy**

---

### 5️⃣ Interact with the Contract

#### Buy a ticket:

* Call `buyTicket`
* Input a seat number (e.g., `1`, `42`, `50000`)

#### Expected behavior:

* Successful purchase emits `TicketSold`
* Buying same seat again → ❌ revert
* Invalid seat number → ❌ revert
* Buying more than 3 tickets → ❌ revert
* When sold out → emits `EventSoldOut`

---

### 6️⃣ Read Contract State

You can inspect:

* `remainingTickets`
* `tickets(ticketId)`
* `ticketsBoughtPerAddress(address)`
* `seatTaken(seatNumber)`

---

## 🔐 Notes & Limitations

* This contract does **not handle payments (ETH)** — purely logical simulation
* No ticket transfer or resale functionality
* No access control (anyone can buy tickets)
* No off-chain integration (frontend/UI)

---

## 🚀 Possible Improvements

If you want to extend this project:

* 💰 Add ticket pricing with `msg.value`
* 🔄 Allow ticket transfers
* ❌ Add ticket cancellation/refunds
* 🎫 Generate NFT tickets (ERC-721)
* 🌐 Build a frontend (React + ethers.js)
* 🧪 Add automated tests (Hardhat / Foundry)

---

## 📄 License

MIT License
