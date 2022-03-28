//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Dicegame {
    struct Createbet {
        uint8 presentbet; //it is used to set a new bet
        bool isbetset; //ultimate value of this is false
        uint8 finl; //finl is actually final, but since in solidity final is a reserved keyword so i used finl.
    }

    mapping(address => Createbet) private bets;

    uint8 private randomfactor;

    //Creating two new events:
    event newbetisset(address bidder, uint8 presentbet);

    event gameresult(address bidder, uint8 presentbet, uint8 finl);

    constructor() {
        randomfactor = 10;
    }

    function isbetset() public view returns (bool) {
        return bets[msg.sender].isbetset;
    }

    //getting a new bet
    function getNewbet() public returns (uint8) {
        require(bets[msg.sender].isbetset == false);
        bets[msg.sender].isbetset = true;
        bets[msg.sender].presentbet = random();
        randomfactor += bets[msg.sender].presentbet;
        emit newbetisset(msg.sender, bets[msg.sender].presentbet);
        return bets[msg.sender].presentbet;
    }

    //roll a dice
    function roll()
        public
        returns (
            address,
            uint8,
            uint8
        )
    {
        require(bets[msg.sender].isbetset == true);
        bets[msg.sender].finl = random();
        randomfactor += bets[msg.sender].finl;
        bets[msg.sender].isbetset = false;
        if (bets[msg.sender].finl == bets[msg.sender].presentbet) {
            payable(msg.sender).transfer(100000000000000);
            emit gameresult(
                msg.sender,
                bets[msg.sender].presentbet,
                bets[msg.sender].finl
            );
        } else {
            emit gameresult(
                msg.sender,
                bets[msg.sender].presentbet,
                bets[msg.sender].finl
            );
        }

        return (msg.sender, bets[msg.sender].presentbet, bets[msg.sender].finl);
    }

    function random() private view returns (uint8) {
        uint256 blockValue = uint256(
            blockhash(block.number - 1 + block.timestamp)
        );
        blockValue = blockValue + uint256(randomfactor);
        return uint8(blockValue % 5) + 1;
    }

    //function is executed if a contract is called and no other function matches the specified function identifier, or if no data is supplied.
    fallback() external payable {}

    //receiving ether function
    receive() external payable {}
}
