// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Exchange is ERC20{
    ERC20 token;
    constructor(address token) ERC20("LPtoken","LP"){
        token=ERC20(token);
    }
    function getTokenReserve() public view returns(uint256){
        return token.balanceOf(address(this));
    }

    function addLiquidity(uint tokenAmount) public payable returns(uint256) {
        uint256 tokenReserve=getTokenReserve();
        uint256 ethReserve=address(this).balance;
        if(tokenReserve==0){
            token.transferFrom(msg.sender,address(this),tokenAmount);
            uint lpTokensToMint = ethReserve;
             _mint(msg.sender, lpTokensToMint);

              return lpTokensToMint;

        }
        else{

            uint256 EthBeforeFunctionCall=ethReserve-msg.value;
            uint256 minTokens=(msg.value*tokenReserve)/ethReserve;
            require(tokenAmount>=minTokens,'Insuffient Amount of tokens provided');
            token.transferFrom(msg.sender,address(this),minTokens);
            uint256 LPtokens=(totalSupply()*msg.value)/EthBeforeFunctionCall;
            _mint(msg.sender, LPtokens);
             return LPtokens;



        }
    }


    function removeLiquidity(uint256 LPtokenAmount) public returns(uint256,uint256) {

        require(LPtokenAmount>0,"LP tokens should be greater than 0");
         uint256 tokenReserve=getTokenReserve();
        uint256 ethReserve=address(this).balance;
        uint256 totalLpTokens=totalSupply();

        uint256 ethToReturn=(LPtokenAmount*ethReserve)/totalLpTokens;
        uint256 tokensToReturn=(LPtokenAmount*tokenReserve)/totalLpTokens;
        _burn(msg.sender, LPtokenAmount);
        payable(msg.sender).transfer(ethToReturn);
        token.transfer(msg.sender, tokensToReturn);

         return (ethToReturn, tokensToReturn);


    }

    function convert(uint xReserve,uint yReserve,uint xdeposited) public pure returns(uint256){
        uint256 yamount=(xdeposited*yReserve)/(xReserve+xdeposited);
        return (yamount*99)/100;
    }

   
   
}
