// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract TicketSelling {
    // Constants
    uint8 public constant MAX_TICKETS_PER_ADDRESS = 3;
    uint256 public constant MAX_SEAT_NUMBER = 50_000;
    uint256 public constant TOTAL_TICKETS = 50_000;

    // State variables
    uint256 public remainingTickets = TOTAL_TICKETS;
    uint256 internal nextTicketId = 1;

    // Structs
    struct Ticket {
        uint256 id;
        address owner;
        uint256 seatNumber;
    }

    // Mappings
    mapping(uint256 => Ticket) public tickets;
    mapping(address => uint8) ticketsBoughtPerAddress;
    mapping(uint256 => bool) seatTaken;

    // Events
    event TicketSold(
        uint256 indexed ticketId,
        uint256 seatNumber,
        address indexed ticketBuyer
    );
    event EventSoldOut();

    // Modifiers
    modifier checkRemainingTickets() {
        if (remainingTickets == 0) revert("There are no remaining tickets");
        _;
    }

    modifier checkTicketBuyingLimit() {
        // Revert if buyer has already reached the maximum allowed tickets
        if (ticketsBoughtPerAddress[msg.sender] >= MAX_TICKETS_PER_ADDRESS)
            revert("You already bought the maximum number of tickets");
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

    /// @notice Buys a ticket for a specific seat in the event.
    /// @dev 
    /// - Reverts if no tickets remain.
    /// - Reverts if the buyer already purchased the maximum number of tickets allowed.
    /// - Reverts if the seat number is out of the valid range.
    /// - Reverts if the seat is already taken.
    ///
    /// Effects:
    /// - Creates a new Ticket with a unique ID.
    /// - Marks the seat as taken.
    /// - Increments the buyer’s ticket count.
    /// - Decrements the remaining ticket supply.
    /// - Emits `TicketSold`.
    /// - Emits `EventSoldOut` if this purchase sells the final ticket.
    ///
    /// @param seatNumber_ The seat number that the buyer wants to reserve.
    /// @return newTicket_ A Ticket struct containing ticket ID, owner, and seat number.
    function buyTicket(uint256 seatNumber_)
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

        if (remainingTickets == 0) {
            emit EventSoldOut();
        }

        nextTicketId++;

        return newTicket_;
    }
}