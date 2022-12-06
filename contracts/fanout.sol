// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract Fanout {
  // mapping from user address to whether they have claimed their share
  mapping(address => bool) public claimed;

  // total number of shares available
  uint256 public totalShares;

  // address of the ERC20 token contract
  ERC20Burnable public token;


  // address of the contract that will burn the ERC20 tokens
  address public burner;

  // amount of ether in the contract
  uint256 public balance;

  // amount of ether in the contract
  uint256 public tokBalance;
  uint256 public tokBalanceo;

  // event that is emitted when a user claims their share
  event Claimed(address user, uint256 tokenShares, uint256 etherShares);

  constructor(address _tokenAddress, address _burnerAddress, uint256 _totalShares, uint256 _tokBalance)  {
    // set the initial number of shares to 10
    totalShares = _totalShares;
 // set the initial number of shares to 10
    tokBalance = _tokBalance;

    tokBalanceo = _tokBalance;
    // set the address of the contract that will burn the ERC20 tokens
    burner = _burnerAddress;
    // set the address of the ERC20 token contract
    token = ERC20Burnable(_tokenAddress);
  }

  // function to claim a share of the ERC20 tokens and ether
  function claim() public {
    // check if the caller has already claimed their share
    require(!claimed[msg.sender], "You have already claimed your share!");

    // calculate the number of token shares the caller is entitled to
    uint256 tokenShares = tokBalanceo / totalShares; // wat; I mean sure, but no

    // calculate the number of ether shares the caller is entitled to
    uint256 etherShares = balance / totalShares;

    // transfer the token shares to the caller
    token.transferFrom(burner, msg.sender, tokenShares);
payable(msg.sender).call{value:etherShares, gas: 24138};
    // transfer the ether shares to the caller
    payable(msg.sender).transfer(etherShares);

    // decrease the total number of shares by 1
    totalShares -= 1;

    // decrease the balance of the contract by the amount of ether transferred
    balance -= etherShares;

    // mark the caller as having claimed their share
    claimed[msg.sender] = true;

    // burn the shares on the burner contract
    //ERC20Burnable(burner).burn(tokenShares);
    // emit the Claimed event
    emit Claimed(msg.sender, tokenShares, etherShares);
  }

  // fallback function to accept ether payments
  receive() external payable {
    // increase the balance of the contract by the amount of ether received
    balance += msg.value;
  }
}
