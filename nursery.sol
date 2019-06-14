// @Authors Cole Nixon + Kelsey Troeger
// @Title Contract for a "Nursery" which trades plant seeds for donations.
//  Seeds are deployed "Plant" contracts, defined in `plant.sol`. After 
//  deployment, plants are entirely independent of the nursery, and owned
//  by their purchasers. The owner of the nursery can close down shop and
//  run with the money they've earned without affecting the plants sold!

pragma solidity ^0.4.24;

import "./plant.sol";

contract Nursery {
    
    address public owner;
    uint256 plantTimer = 10; //Deploy a plant every 10 seconds at the fastest
    uint256 public nextPlantTime;
    uint256 public seedsSold;
    string[] public seeds;

    constructor () public {
        owner = msg.sender;
        //Allow for immediate plant deployment
        nextPlantTime = now;
        //Track how many seeds we've sold
        seedsSold = 0;
        //All Seeds for sale
        seeds = ["STRAWBERRY","WATERMELON","PINEAPPLE","PASSIONFRUIT","DRAGONFRUIT","GOLDEN MUSHROOM"];
    }
    
    // Donate some wei and receive a seed from our inventory
    function buyPlant() public payable{
        //Anyone can buy a seed for a donation of greater than 10 wei
        require(now > nextPlantTime);
        require(msg.value > 10 wei);
        uint seedMod;
        string memory seed;
        
        // If they pay enough money, they have a chance at receiving a Golden Mushroom seed
        seedMod = msg.value > 1 ether ? 5 : 4;
        
        // Create some entropy, despite it being a manipulatable constant...
        uint rand = uint(keccak256(abi.encodePacked(now)));
        uint i = rand % seedMod;
        seed = seeds[i];
        uint256 lifespan = rand % 864000; // 8 days as initial upper bound
        lifespan = lifespan + 172800; // Add 2 days, setting lifespan of plant to be bounded between 2 and 10 days
        address myPlant = new Plant(msg.sender, seed, lifespan);
        
        // Reset timer and track sold seeds
        nextPlantTime = now + plantTimer;
        seedsSold++;
    }
    
    // Cash out and run with the money
    function destroy() public {
        require(owner == msg.sender);
        selfdestruct(owner);
    }
    
    //Just in case people want to donate without receiving a seed
    function () public payable{
        
    }
}