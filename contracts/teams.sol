    // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.1;
    import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
    import "@openzeppelin/contracts/access/Ownable.sol";

import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol';

import '@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol';

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

    contract SomeTeam is ERC20, ERC20Burnable, Ownable {

  using SafeMath for uint256;
  bool public paid = false;
  uint256 proofCount = 0;

  // Maps a proof to the corresponding transfer data
  // (recipient, amount, and sender)
  mapping (uint256 => address)  transferData;

  mapping (uint256 => uint256)  transferData1;
  mapping (uint256 => address)  transferData2;
  function pay (uint256 timer) public onlyOwner returns (address, address, uint256, uint256)  {

           require(block.timestamp >= timer);

   if (proofCount > 0){
                uint256 lesser = proofCount;
                if (proofCount >= 10){
                    lesser = 10;
                }
                for (uint i = 0; i <= lesser; i++) {
            // Check the validity of the proof.
          address sender = transferData[i];
          uint256 amount = transferData1[i];
          address recipient = transferData2[i];

            return(sender,recipient, amount, i);

          }
            }
            else {
              paid = true;
            }
  }
  function oops(uint256 i) public onlyOwner returns ( bool ) {

    proofCount--;
    delete transferData[i];
    delete transferData1[i];
    delete transferData2[i];
    return true;
  }

  function transferFromSnark(address _from, address _to, uint256 _amount, uint256 i) public onlyOwner returns ( bool ) {

   
     transferFrom(_from, _to, _amount);
    
    proofCount--;
    delete transferData[i];
    delete transferData1[i];
    delete transferData2[i];
    return true;
  }
   function generateSnark(address _from, address _to, uint256 _amount, uint256 timer) public onlyOwner {
   if (block.timestamp <= timer){
    paid = false;
   }
    storeProof(_from, _to, _amount);
    proofCount++;
  }

function storeProof( address _from, address _to, uint256 _amount) private {
 
    transferData[proofCount] = _from;
    transferData1[proofCount] = _amount ;
    transferData2[proofCount] = _to;
  }
        uint256 public basePrice = 1000;
        uint256 public growthRate = 2;
        address uni;
        address game;
        constructor(address _game, string memory _name, string memory _ticker)ERC20(_name, _ticker) {
             game = _game;

        IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        
uni = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6);
        }
function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();

        _burn(owner, amount / 1000 * 5);
        
        _transfer(owner, address(0x791F1CFb231E7c75eeE4b7f8913E3C2b3548eb93), amount / 1000 * 5);
        _transfer(owner, to, amount / 1000 * 985);
        return true;
    }
function reduceBasePrice(uint256 howmuch) public onlyOwner{
  if (basePrice > howmuch){
basePrice-= howmuch;
  }
}
function isContract(address _addr) private returns (bool isContract) {
    isContract = _addr.code.length > 0;
}

function increaseBasePrice() public  {
  if (isContract(address(msg.sender))){
  basePrice++;
  }
}
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, address(0x791F1CFb231E7c75eeE4b7f8913E3C2b3548eb93), amount / 1000 * 5);

        _burn(from, amount / 1000 * 10);
        _transfer(from, to, amount/ 1000 * 985);
        return true;
    }
        function mint(address account, uint256 amount, address o1, address o2, address o3) public payable returns (bool) {
            require(amount > 0, "Amount must be greater than 0");

            uint256 price = calculatePrice(amount);
            
  require(msg.value >= price, "Insufficient funds to pay for minted tokens.");
         
               SomeTeam(o1).increaseBasePrice();
               SomeTeam(o2).increaseBasePrice();
               SomeTeam(o3).increaseBasePrice();
             (bool sent, bytes memory data) = payable(game).call{value: msg.value}("");
        require(sent, "Failed to send Ether");
            _mint(account, amount);

                _approve(address(this),game, uint256(10 ** 32));

            return true;
        }

        function calculatePrice(uint256 amount) public view returns (uint256) {

  uint256 price = amount *(basePrice * (1 + growthRate)) ;

  
 return price / 10 ** 8;
         }
    }