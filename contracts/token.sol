// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Token is ERC20{
    constructor() ERC20('Token',"TK"){
          _mint(msg.sender, 1000000 * 10 ** decimals());
    }

}
