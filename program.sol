
pragma solidity ^0.4.25;

contract SimpleExchange {
    address public owner;
    uint public tradeCount;

    mapping(address => uint) public balances; // Mapping to store balances of each address

    event TradeRequested(address indexed buyer, address indexed seller, string currency, uint amount);
    event TradeCompleted(uint indexed tradeId, address indexed buyer, address indexed seller, uint amount);

    constructor() public {
        owner = msg.sender;
        tradeCount = 0;
    }

    function requestTrade(address _seller, string _currency, uint _amount) external payable {
        require(msg.sender != _seller && _seller != owner, "Buyer and seller cannot be the same, and seller cannot be the owner");

        require(msg.value >= _amount, "Insufficient funds sent by buyer");

        tradeCount++;
        balances[msg.sender] += msg.value; // Increment buyer's balance
        balances[_seller] -= _amount; // Decrement seller's balance

        emit TradeRequested(msg.sender, _seller, _currency, _amount);
    }

    function completeTrade(uint _tradeId) external {
        require(msg.sender == owner, "Only owner can complete trades");

        emit TradeCompleted(_tradeId, msg.sender, address(this), address(this).balance);
        owner.transfer(address(this).balance); // Transfer contract balance to owner
    }

    function getBalance(address _account) external view returns (uint) {
        return balances[_account];
    }
}
