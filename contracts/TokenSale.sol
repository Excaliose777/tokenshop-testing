// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IMyERC20 is IERC20{
    function mint(address to, uint256 amount) external;
    function burnFrom(address from, uint256 amount) external;
}

interface IMyERC721 {
    function safeMint(address to, uint256 tokenId) external;
    function burnFrom(uint256 tokenId) external;
}

contract TokenSale {

    uint256 public ratio;
    uint256 public price;
    IMyERC721 public nftContract;
    IMyERC20 public paymentToken;

    constructor(uint256 _ratio, uint256 _price, address _paymentToken, address _nftContract) {
        ratio = _ratio;
        price = _price;
        paymentToken = IMyERC20(_paymentToken);
        nftContract = IMyERC721(_nftContract);
    }

    function buyTokens() external payable {
        uint256 amount = msg.value / ratio;
        paymentToken.mint(msg.sender, amount);
    }

    function returnTokens(uint256 amount) external payable {
        paymentToken.burnFrom(msg.sender, amount);
        payable(msg.sender).transfer(amount * ratio);
    }

    function buyNFT(uint256 tokenId) external {
        paymentToken.transferFrom(msg.sender, address(this), price);
        nftContract.safeMint(msg.sender, tokenId);
    }
}