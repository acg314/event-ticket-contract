// SPDX-License-Identifier: MIT

pragma solidity 0.8.30;

contract TicketSelling {
    uint8 public constant MAX_TICKETS_PER_ADDRESS = 3;
    uint256 public constant MAX_SEAT_NUMBER = 50_000;

    uint256 public remainingTickets = 50_000; // this will be a huge event!
    uint256 internal nextTicketId = 1;

    struct Ticket {
        uint256 id;
        address owner;
        uint256 seatNumber;
    }

    
    mapping(uint256 => Ticket) tickets;
    mapping(address => uint8) ticketsBoughtPerAddress;
    mapping(uint256 => bool) seatTaken;

    modifier checkRemainingTickets() {
        if (remainingTickets == 0) revert("There are no remaining tickets");
        _;
    }

    modifier checkTicketBuyingLimit() {
        // if buyer has already bought 3 tickets, revert (count starts with 0)
        if (ticketsBoughtPerAddress[msg.sender] >= MAX_TICKETS_PER_ADDRESS)
            revert("You already bought 3 tickets");
        _;
    }

    modifier checkSeatAvailable(uint256 seatNumber) {
        if (seatTaken[seatNumber]) revert("Seat already taken");
        _;
    }

    modifier checkSeatNumberInRange(uint256 seatNumber) {
        if (seatNumber < 1 || seatNumber > MAX_SEAT_NUMBER)
            revert("Seat number does not exist");
        _;
    }

    event TicketSold(uint256 ticketId, uint256 seatNumber, address ticketBuyer);
    event EventSoldOut();

    /**
     * @notice Allows the caller to purchase a ticket for a specific seat number.
     * @dev 
     * - Applies several checks through modifiers:
     *      - Ensures tickets are still available (`checkRemainingTickets`).
     *      - Ensures the caller has not exceeded the ticket limit (`checkTicketBuyingLimit`).
     *      - Ensures the seat number is within the valid range (`checkSeatNumberInRange`).
     *      - Ensures the seat has not already been purchased (`checkSeatAvailable`).
     * - Creates a new `Ticket` struct, stores it in the `tickets` mapping, and marks the seat as taken.
     * - Increments the count of tickets bought by the caller.
     * - Emits a `TicketSold` event for every purchase.
     * - Emits an `EventSoldOut` event if this purchase causes all tickets to be sold.
     *
     * @param seatNumber_ The seat number the buyer wishes to purchase (must be between 1 and MAX_SEAT_NUMBER).
     * @return newTicket_ The newly created `Ticket` struct containing the ticket ID, owner, and seat number.
     */

    function buyTicket(
        uint256 seatNumber_
    )
        public
        checkRemainingTickets
        checkTicketBuyingLimit
        checkSeatNumberInRange(seatNumber_)
        checkSeatAvailable(seatNumber_)
        returns (Ticket memory newTicket_)
    {
        newTicket_ = Ticket({
            id: nextTicketId,
            owner: msg.sender,
            seatNumber: seatNumber_
        });

        tickets[newTicket_.id] = newTicket_;
        seatTaken[seatNumber_] = true;

        ticketsBoughtPerAddress[msg.sender]++;

        emit TicketSold(newTicket_.id, newTicket_.seatNumber, msg.sender);

        remainingTickets--;

        if (remainingTickets == 0) emit EventSoldOut();

        nextTicketId++;

        return newTicket_;
    }
}
