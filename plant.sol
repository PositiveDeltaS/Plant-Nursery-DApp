pragma solidity ^0.4.24;
contract Plant {
    address public owner;
    string private fruit;
    uint public deathTime;
    uint public target;
    Waterer[] public waterers;
 
    constructor (address powner, string seed, uint lifespan) public payable {
        owner = powner;
        //passed in from nursery contract
        fruit = seed;
        //amount of waterings from contributors regardless of contribution size
        target = 1;
        //lifespan randomly generated amount of seconds between 2-10 days
        deathTime = now + lifespan;
    }
    //people contributing to plant watering
    struct Waterer {
        address gardenerAddress;
        uint amount;
    }
    
    function waterPlant() public payable {
        require(!isDead());
        waterers.push(Waterer(msg.sender, msg.value));
    }
    
    function isDead() public view returns (bool) {
        return now >= deathTime ? true : false;
    }
    function redistribute() private {
        for(uint i = 0; i < waterers.length; ++i){
            waterers[i].gardenerAddress.transfer(waterers[i].amount);
        } 
    }
  
    function decompose() private {
        redistribute();
        selfdestruct(owner);
    }   
 
    function balance() public view returns(uint){
        return address(this).balance;
    }
 
    function harvest() public returns(string) {
        require(owner == msg.sender);
        if(isDead()) {
            decompose();
        }
        require(address(this).balance >= target);
        redistribute();
        return fruit; 
    }
    
}
