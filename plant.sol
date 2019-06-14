pragma solidity ^0.4.24;
contract Plant {
    address public owner;
    string private fruit;
    uint public deathTime;
    uint public target;
    Waterer[] public waterers;
    bool private successfulHarvest = false;
 
    constructor (address powner, string seed, uint lifespan) public payable {
        owner = powner;
        //passed in from nursery contract
        fruit = seed;
        //amount of waterings from contributors regardless of contribution size
        target = 1;
        //lifespan randomly generated amount of seconds between 2-10 days
        deathTime = now + lifespan;
        //Initialize with something
        //waterers.push(Waterer(msg.sender, 1));
    }
    //people contributing to plant watering
    struct Waterer {
        address gardenerAddress;
        uint amount;
    }
    //check balance
    function balance() public view returns(uint){
        return address(this).balance;
    }
    //is the plant dead? getter for watering and harvest funcs
    function isDead() public view returns (bool) {
        return now >= deathTime ? true : false;
    }
    // contribute eth to get the plant to fruit, adds contributors to Waterers array
    function waterPlant() public payable {
        require(!isDead());
        waterers.push(Waterer(msg.sender, msg.value));
    }
    //checks for plant death and returns fruit if target is reached, calls funds redistribution function in either case
    function harvest() public {
        require(owner == msg.sender);
        if(isDead()) {
            decompose();
        }
        require(address(this).balance >= target, 'Not enough water! No fruit for you.');
        successfulHarvest = true;
        redistribute();
        delete waterers;
    }
    //give funds back to contributors
    function redistribute() private {
        for(uint i = 0; i < waterers.length; ++i){
            waterers[i].gardenerAddress.transfer(waterers[i].amount);
        }
      
    }
    //checks to see if the harvest was successful
    function checkFruitFromHarvest () public view returns(string) {
        require(true == successfulHarvest, "No fruit yet");
        successfulHarvest = false;
        return fruit;
    }
    // give funds back to contributors and kill contract
    function decompose() private {
        redistribute();
        selfdestruct(owner);
    }   
 
    
}
