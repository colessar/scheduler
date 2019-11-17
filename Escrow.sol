pragma solidity 0.5.11;
                                //Escrow is like a thired party that ensures smooth transaction between a seller and buyer, that none of them cheats
                                //the other as pay and not receive item or vide versa. Escrow holds the money from the buyer, for the seller, till 
                                //buyer confirms that he received the item
                                
contract Escrow {
    enum State { AWATING_PAYMENT, AWAITING_DELIVERY, COMPLETE, REFUNDED}    //enum enumerates states in which the product can be each state have 
    State public currentState;                                              //a binary 0 1 according to what is happening
                                    //above two statements are a single statement as currentState variable 
                                    //holds the current state as in AWAITING_DELIVERY or COMPLETE or etc
    
    address payable public buyer;
    address payable public seller;
    address payable public arbiter;         //arbiter is a person who comes to resolve the issue, if it arrises, between buyer and seller
    
    modifier buyerOnly() {
        require(msg.sender == buyer || msg.sender == arbiter);
        _;
        
    }
    
    modifier inState(State expectedState) {
        require(currentState == expectedState);
        _;
    }
    
    modifier sellerOnly() {
        require(msg.sender == seller || msg.sender == arbiter);
        _;
    }
    
    constructor(address payable _buyer, address payable _seller, address payable _arbiter) public {
        buyer = _buyer;
        seller= _seller;
        arbiter = _arbiter;
    }
    
    function sendPayment() public payable buyerOnly inState(State.AWATING_PAYMENT) {
        currentState=State.AWAITING_DELIVERY;
    } 
    
    function confirmDelivery() external buyerOnly inState(State.AWAITING_DELIVERY) {
        currentState=State.COMPLETE;
        seller.transfer(address(this).balance);         //balance is a data type "address" extention which stores balance //transfer is also an inbuilt function to transfer funds between accounts
    }
    
    function refundBuyer() public sellerOnly inState(State.AWAITING_DELIVERY) {
        currentState=State.REFUNDED;
        buyer.transfer(address(this).balance);
    }
    
    // function reset() public {
    //     require(msg.sender == seller);
    //     currentState=State.AWATING_PAYMENT;
    // }
}
