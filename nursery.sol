pragma solidity ^0.4.24;

import "./plant.sol";

contract Nursery {
    
    address public owner;
    uint256 plantTimer = 60; //adjust
    uint256 public nextPlantTime;
    uint256 public plantsDeployed;
    string[] seeds;
   
    constructor () public {
        owner = msg.sender;
        nextPlantTime = now;
        plantsDeployed = 0;
        seeds = ["STRAWBERRY","WATERMELON","PINEAPPLE","PASSIONFRUIT","DRAGONFRUIT","GOLDEN MUSHROOM"];
    }
    
    function deployPlant() public payable{
        require(now > nextPlantTime);
        require(msg.value > 10 wei);
        uint seedMod;
        string memory seed;
        seedMod = msg.value > 1 ether ? 5 : 4;
        uint rand = uint(keccak256(abi.encodePacked(now)));
        uint i = rand % seedMod;
        seed = seeds[i];
        uint256 lifespan = rand % 864000; // 8 days as initial upper bound
        lifespan = lifespan + 172800; // Add 2 days, setting lifespan to be bounded between 2 and 10 days
        address myPlant = new Plant(msg.sender, seed, lifespan);
        myPlant.transfer(msg.value);
        nextPlantTime = now + plantTimer;
        plantsDeployed++;
    }
    
    function destroy() public {
        require(owner == msg.sender);
        selfdestruct(owner);
    }
    
    function () public payable{
        
    }
}
