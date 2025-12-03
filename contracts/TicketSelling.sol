// SPDX-License-Identifier: MIT

pragma solidity 0.8.30;
contract TicketSelling {

    uint8 public constant MAX_TICKETS_PER_ADDRESS = 3;

    struct Ticket {
        uint256 id;
        address owner;
        uint256 seatNumber;
    }
    

    uint256 public remainingTickets = 50_000;  // this will be a huge event!
    uint256 internal nextTicketId = 1;

    mapping(uint256 => Ticket) tickets;
    mapping(address => uint8) ticketsBoughtPerAddress;
    mapping (uint256 => bool) seatTaken;


    modifier checkRemainingTickets(){
        if (remainingTickets == 0) revert("There are no remaining tickets");
        _;
    }

    modifier checkTicketBuyingLimit(){
        // if buyer has already bought 3 tickets, revert (count starts with 0)
        if (ticketsBoughtPerAddress[msg.sender] >= MAX_TICKETS_PER_ADDRESS) revert("You already bought 3 tickets");
        _;
    }

    modifier checkSeatAvailable(uint256 seatNumber){
        if (seatTaken[seatNumber]) revert("Seat already taken");
        _;
    }

    modifier checkSeatNumberInRange(uint256 seatNumber){
        if (seatNumber < 1 || seatNumber > 50_000) revert("Seat number does not exist");
        _;
    }


    event TicketSold(uint256 ticketId, address ticketBuyer);
    event EventSoldOut();
    
    function buyTicket(uint256 seatNumber_) public checkRemainingTickets checkTicketBuyingLimit checkSeatNumberInRange(seatNumber_) checkSeatAvailable(seatNumber_)  returns (Ticket memory newTicket_){

        newTicket_ = Ticket({
            id: nextTicketId,
            owner: msg.sender,
            seatNumber: seatNumber_
        });


        tickets[newTicket_.id] = newTicket_;
        seatTaken[seatNumber_] = true;

        ticketsBoughtPerAddress[msg.sender]++;


        emit TicketSold(newTicket_.id, msg.sender);

        remainingTickets--;
            
        if (remainingTickets == 0) emit EventSoldOut();
            
        nextTicketId++;
        
        return newTicket_;
    }


}