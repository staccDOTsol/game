
pragma solidity ^0.8.1;
import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol';

import "./fanout.sol";
import "./teams.sol";
  contract Game { 
      uint256 public price; //price of the key. starts at 1 eth. increases by 1% each time a key is purchased. 
      uint256 public pot; //pot of the game. 90% goes to the winner and 10% remains for the next round. 
      uint256 public timer; //timer of the game. starts at 5 minutes after initialization. if a key is purchased, timer is extended to block.timestamp + 5 minutes. if timer runs out, game ends and winner is determined. 
      address payable public owner; //owner of the contract. can withdraw funds from the pot at any time. 
      uint256  redStake = 0; //stake of red team members in wei. must be greater than other teams' stakes in order to purchase a key. 
      uint256  blueStake = 0; //stake of blue team members in wei. must be greater than other teams' stakes in order to purchase a key. 
      uint256  greenStake = 0; //stake of green team members in wei. must be greater than other teams' stakes in order to purchase a key. 
      uint256  yellowStake = 0; //stake of yellow team members in wei. must be greater than other teams' stakes in order to purchase a key. 
      uint256  redStakeDef = 0; //stake of red team members in wei. must be greater than other teams' stakes in order to purchase a key. 
      uint256  blueStakeDef = 0; //stake of blue team members in wei. must be greater than other teams' stakes in order to purchase a key. 
      uint256  greenStakeDef = 0; //stake of green team members in wei. must be greater than other teams' stakes in order to purchase a key. 
      uint256  yellowStakeDef = 0; //stake of yellow team members in wei. must be greater than other teams' stakes in order to purchase a key. 
    SomeTeam public  redTeam  ;//= new SomeTeam(address(this), "Red Team", "RED");
    SomeTeam public  blueTeam ;//= new SomeTeam(address(this), "Blue Team", "BLUE");
    SomeTeam  public yellowTeam;//= new SomeTeam(address(this), "Yellow Team", "YELL") ;
    SomeTeam public greenTeam;// new SomeTeam(address(this), "Green Team", "GREE") ;
    uint256 basePrice;
    function setTeams(address r, address b, address g, address y) public  {
                  require(msg.sender == owner);

        redTeam = SomeTeam(r);
        blueTeam = SomeTeam(b);
        greenTeam = SomeTeam(g);
        yellowTeam = SomeTeam(y);
    }
      constructor(uint256 _price) {
          price = _price;
          basePrice = _price;
          owner = payable(msg.sender);
          timer = block.timestamp + 5 minutes;
      }
      receive () external payable{
          require(msg.value > 0);
          pot += msg.value;
      }
      // each team has a mapping for all its members, and members can join and leave the team at any time. 
      mapping(address => bool) public redTeamMembers;
      mapping(address => bool) public blueTeamMembers;
      mapping(address => bool) public greenTeamMembers;
      mapping(address => bool) public yellowTeamMembers;
      uint256 rt = 0;
      uint256 bt = 0;
      
      uint256 gt = 0;
      
      uint256 yt = 0;
      

// each team has a function to join and leave the team. 
      function joinRedTeam() public {
          require(!redTeamMembers[msg.sender]);
          redTeamMembers[msg.sender] = true;
          rt++;
      }
      function leaveRedTeam() public {
          require(redTeamMembers[msg.sender]);
          redTeamMembers[msg.sender] = false;
          rt--;
      }
      function joinBlueTeam() public {
          require(!blueTeamMembers[msg.sender]);
          blueTeamMembers[msg.sender] = true;
          bt++;
      }
      function leaveBlueTeam() public {
          require(blueTeamMembers[msg.sender]);
          blueTeamMembers[msg.sender] = false;
          bt--;
      }
      function joinGreenTeam() public {
          require(!greenTeamMembers[msg.sender]);
          greenTeamMembers[msg.sender] = true;
          gt++;
      }
      function leaveGreenTeam() public {
          require(greenTeamMembers[msg.sender]);
          greenTeamMembers[msg.sender] = false;
          gt--;
      }

      function joinYellowTeam() public {
          require(!yellowTeamMembers[msg.sender]);
          yellowTeamMembers[msg.sender] = true;
          yt++;

      }

      function leaveYellowTeam() public {

          require(yellowTeamMembers[msg.sender]);

          yellowTeamMembers[msg.sender] = false;
          yt--;

      }

// team members can stake their tokens to the contract to increase that teams stake. 
      function stakeRedTeamTokens(uint256 _3, uint256 amount, uint256 _4) public {
          require(redTeamMembers[msg.sender]);
          require(amount > 0);
          require(redTeam.balanceOf(msg.sender) >= amount);
          redStake += amount;
          redTeam.generateSnark(msg.sender, address(this), amount, timer);

      }

      function stakeBlueTeamTokens(uint256 _3, uint256 amount, uint256 _4) public {

          require(blueTeamMembers[msg.sender]);

          require(amount > 0);

          

          require(blueTeam.balanceOf(msg.sender) >= amount);

          blueStake += amount;

          blueTeam.generateSnark(msg.sender, address(this), amount, timer);

      }

      function stakeGreenTeamTokens(uint256 _3, uint256 amount, uint256 _4) public {

          require(greenTeamMembers[msg.sender]);

          require(amount > 0);

          

          require(greenTeam.balanceOf(msg.sender) >= amount);

          greenStake += amount;

          greenTeam.generateSnark(msg.sender, address(this), amount, timer);

      }

      function stakeYellowTeamTokens(uint256 _3, uint256 amount, uint256 _4) public {

          require(yellowTeamMembers[msg.sender]);

          require(amount > 0);

          

          require(yellowTeam.balanceOf(msg.sender) >= amount);

          yellowStake += amount;

          yellowTeam.generateSnark(msg.sender, address(this), amount, timer);
      }

// team members can stake their tokens to the contract to increase that teams stake. 
      function stakeRedTeamTokensDef(uint256 _3, uint256 amount, uint256 _4) public {
          require(redTeamMembers[msg.sender]);
          require(amount > 0);
          require(redTeam.balanceOf(msg.sender) >= amount);
          redStakeDef += amount;
         redTeam.generateSnark(msg.sender, address(this), amount, timer);

      }

      function stakeBlueTeamTokensDef(uint256 _3, uint256 amount, uint256 _4) public {

          require(blueTeamMembers[msg.sender]);

          require(amount > 0);

          

          require(blueTeam.balanceOf(msg.sender) >= amount);

          blueStakeDef += amount;

         blueTeam.generateSnark(msg.sender, address(this), amount, timer);

      }

      function stakeGreenTeamTokensDef(uint256 _3, uint256 amount, uint256 _4) public {

          require(greenTeamMembers[msg.sender]);

          require(amount > 0);

          

          require(greenTeam.balanceOf(msg.sender) >= amount);

          greenStakeDef += amount;

         greenTeam.generateSnark(msg.sender, address(this), amount, timer);

      }

      function stakeYellowTeamTokensDef(uint256 _3, uint256 amount, uint256 _4) public {

          require(yellowTeamMembers[msg.sender]);

          require(amount > 0);

          

          require(yellowTeam.balanceOf(msg.sender) >= amount);

          yellowStakeDef += amount;

          yellowTeam.generateSnark(msg.sender, address(this), amount, timer);
      }
      function purchaseKey(uint256 amount) public payable {
          require(msg.value > 0);
          require(msg.value == amount);
          require(msg.value == price);
          require(block.timestamp < timer);
          require(redTeamMembers[msg.sender] || blueTeamMembers[msg.sender] || greenTeamMembers[msg.sender] || yellowTeamMembers[msg.sender]);
          if (redTeamMembers[msg.sender]) {
              require(redStake >= blueStake && redStake >= greenStake && redStake >= yellowStake);
              pot += msg.value;
              redTeam.reduceBasePrice(3);
              timer = block.timestamp + 5 minutes;
          } else if (blueTeamMembers[msg.sender]) {
              require(blueStake >= redStake && blueStake >= greenStake && blueStake >= yellowStake);
              pot += msg.value;
              timer = block.timestamp + 5 minutes;
              blueTeam.reduceBasePrice(3);

          } else if (greenTeamMembers[msg.sender]) {

              require(greenStake >= redStake && greenStake >= blueStake && greenStake >= yellowStake);


              pot += msg.value;

              timer = block.timestamp + 5 minutes;

              greenTeam.reduceBasePrice(3);
          } else if (yellowTeamMembers[msg.sender]) {

              require(yellowStake >= redStake && yellowStake >= blueStake && yellowStake >= greenStake);



              pot += msg.value;

              timer = block.timestamp + 5 minutes;
              
              yellowTeam.reduceBasePrice(3);
           
          }
          price = price * 101 / 100;
      }
      // at the conclusion of a round, the proportional amount of tokens are allocated to a mapping that can be later claimed if a teammember has one and pays gas for the transaction. 
      mapping(address => uint256) public redTeamTokens;
      mapping(address => uint256) public blueTeamTokens;
      mapping(address => uint256) public greenTeamTokens;
      mapping(address => uint256) public yellowTeamTokens;
      address public recentFanout1;
      address public recentFanout2;
      
      address public recentFanout3;
      
      address public recentFanout4;
      

// at the conclusion of a round, the proportional amount of tokens are allocated to a mapping that can be later claimed if a teammember has one and pays gas for the transaction. 
     
// at the conclusion of a round, the proportional amount of tokens are allocated to a mapping that can be later claimed if a teammember has one and pays gas for the transaction, and the timer is set to now + 5 minutes and the pot is reset to 10% of its previous value and the price is increased by 1%. 
      function concludeRound() public {
          require(block.timestamp >= timer);
          if (redStake != 0 ){
            
          
          if (!redTeam.paid()){
                        (address a1,address a2,uint256 a3, uint256 i) = redTeam.pay(timer);

            try redTeam.transferFromSnark(a1,a2,a3,i) returns (bool) {

                }
        catch (bytes memory err) {
        redTeam.oops(i);
        }
    
          }
          }
          if (blueStake != 0){
           if (!blueTeam.paid()){
            (address a1,address a2,uint256 a3, uint256 i) = blueTeam.pay(timer);
   try blueTeam.transferFromSnark(a1,a2,a3,i) returns (bool) {

                }
        catch (bytes memory err) {
        blueTeam.oops(i);
        }
              }
          }
          if (greenStake != 0){
           if (!greenTeam.paid()){
            (address a1,address a2,uint256 a3, uint256 i) = greenTeam.pay(timer);
   try greenTeam.transferFromSnark(a1,a2,a3,i) returns (bool) {

                }
        catch (bytes memory err) {
        greenTeam.oops(i);
        }
              }
          }
           if (yellowStake != 0){
          if (!yellowTeam.paid()){
            (address a1,address a2,uint256 a3, uint256 i) = yellowTeam.pay(timer);
   try yellowTeam.transferFromSnark(a1,a2,a3,i) returns (bool) {

                }
        catch (bytes memory err) {
        yellowTeam.oops(i);
        }
    
          }
           }
           if ((redStake == 0 || redTeam.paid()) && 
           (blueStake == 0 || blueTeam.paid()) && 
          ( greenStake == 0 || greenTeam.paid()) && 
           (yellowStake == 0 || yellowTeam.paid())){
            
          bool redAttacking = false;
          bool blueAttacking = false;
          bool greenAttacking = false;
          bool yellowAttacking = false;
         uint256 c = 0;
          if (redStake > redStakeDef){
              redAttacking = true;
              c++;
          }
          if (blueStake > blueStakeDef){
              blueAttacking = true;
              c++;
          }
          if (greenStake > greenStakeDef){
              greenAttacking = true;
              c++;
          }
          if (yellowStake > yellowStakeDef){
              yellowAttacking = true;
              c++;
          }
        IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        
            redTeam.approve(address(uniswapV2Router), redTeam.balanceOf(address(this))/ 2);
            blueTeam.approve(address(uniswapV2Router), blueTeam.balanceOf(address(this))/ 2);
            greenTeam.approve(address(uniswapV2Router), greenTeam.balanceOf(address(this))/ 2);
            yellowTeam.approve(address(uniswapV2Router), yellowTeam.balanceOf(address(this)) / 2);
    uniswapV2Router.addLiquidityETH{value: address(this).balance/ 10 / 4}(address(redTeam), redTeam.balanceOf(address(this))/2,0,0,address(this),block.timestamp);
    uniswapV2Router.addLiquidityETH{value: address(this).balance/ 10 / 4}(address(blueTeam), blueTeam.balanceOf(address(this))/2,0,0,address(this),block.timestamp);
    uniswapV2Router.addLiquidityETH{value: address(this).balance/ 10 / 4}(address(greenTeam), greenTeam.balanceOf(address(this))/2,0,0,address(this),block.timestamp);
    uniswapV2Router.addLiquidityETH{value: address(this).balance / 10 / 4}(address(yellowTeam), yellowTeam.balanceOf(address(this))/2,0,0,address(this),block.timestamp);

        // everyone defends; share 30%
        if (c == 0) {
                Fanout rhydra = new Fanout(address(redTeam), address(this), rt, redTeam.balanceOf(address(this))/ 2);
                
                payable(address(rhydra)).call{value:address(this).balance / 100 * 30 / 4, gas: 24138}("");
                recentFanout1 = address(rhydra);


                redTeam.approve(address(rhydra), redTeam.balanceOf(address(this)));
                Fanout bhydra = new Fanout(address(blueTeam), address(this), bt, blueTeam.balanceOf(address(this))/ 2);
                recentFanout2 = address(bhydra);
                payable(address(bhydra)).call{value:address(this).balance / 100 * 30 / 4, gas: 24138}("");

                blueTeam.approve(address(bhydra), blueTeam.balanceOf(address(this)));
                //blueTeam.transferFrom(address(this), (address(bhydra)), blueTeam.balanceOf(address(this)));
                Fanout ghydra = new Fanout(address(greenTeam), address(this), gt, greenTeam.balanceOf(address(this))/ 2);
                 recentFanout3 = address(ghydra);

                payable(address(ghydra)).call{value:address(this).balance / 100 * 30 / 4, gas: 24138}("");
greenTeam.approve(address(ghydra), greenTeam.balanceOf(address(this)));
                Fanout yhydra = new Fanout(address(yellowTeam), address(this), yt, yellowTeam.balanceOf(address(this))/ 2);
                recentFanout4 = address(yhydra);
                payable(address(yhydra)).call{value:address(this).balance / 100 * 30 / 4, gas: 24138}("");

yellowTeam.approve(address(yhydra), yellowTeam.balanceOf(address(this)));
                //yellowTeam.transferFrom(address(this), (address(yhydra)), yellowTeam.balanceOf(address(this)));

        }
        // someone wins; that team get 90% ether n tokenz
      else   if (c == 1){
          // paranoia
          if (redAttacking && !blueAttacking && !greenAttacking && !yellowAttacking){
              // red wins

                Fanout hydra = new Fanout(address(redTeam), address(this), rt, redTeam.balanceOf(address(this))/ 2);
                
                payable(address(hydra)).call{value:address(this).balance / 100 * 80 , gas: 24138}("");
recentFanout1 = address(hydra);
                redTeam.approve(address(hydra), redTeam.balanceOf(address(this)));
                //redTeam.transferFrom(address(this), (address(hydra)), redTeam.balanceOf(address(this)));
                if (blueTeam.balanceOf(address(this)) > 0){
                // burn the shares on the burner contract
                blueTeam.burn(blueTeam.balanceOf(address(this)));
                }
                                if (yellowTeam.balanceOf(address(this)) > 0){

                // burn the shares on the burner contract
                yellowTeam.burn(yellowTeam.balanceOf(address(this)));
                                }
                                if (greenTeam.balanceOf(address(this)) > 0){

                // burn the shares on the burner contract
                greenTeam.burn(greenTeam.balanceOf(address(this)));
                                }
          }
          else  if (blueAttacking && !redAttacking && !greenAttacking && !yellowAttacking){
             
                Fanout hydra = new Fanout(address(blueTeam), address(this), bt, blueTeam.balanceOf(address(this))/ 2);
                recentFanout2 = address(hydra);

                payable(address(hydra)).call{value:address(this).balance / 100 * 80 , gas: 24138}("");
                blueTeam.approve(address(hydra), blueTeam.balanceOf(address(this)));
                //blueTeam.transferFrom(address(this), (address(hydra)), blueTeam.balanceOf(address(this)));
                // burn the shares on the burner contract
                                                if (yellowTeam.balanceOf(address(this)) > 0){

                yellowTeam.burn(yellowTeam.balanceOf(address(this)));
                                                }
                // burn the shares on the burner contract
                                                if (redTeam.balanceOf(address(this)) > 0){

                redTeam.burn(redTeam.balanceOf(address(this)));
                                                }
                // burn the shares on the burner contract
                                                if (greenTeam.balanceOf(address(this)) > 0){

                greenTeam.burn(greenTeam.balanceOf(address(this)));
                                                }
          } else  if (greenAttacking && !blueAttacking && !redAttacking && !yellowAttacking){
              // green wins

                Fanout hydra = new Fanout(address(greenTeam), address(this), gt, greenTeam.balanceOf(address(this))/ 2);
                recentFanout3 = address(hydra);

                payable(address(hydra)).call{value:address(this).balance / 100 * 80 , gas: 24138}("");


                greenTeam.approve(address(hydra), greenTeam.balanceOf(address(this)));
                //greenTeam.transferFrom(address(this), (address(hydra)), greenTeam.balanceOf(address(this)));
                                                if (blueTeam.balanceOf(address(this)) > 0){

                // burn the shares on the burner contract
                blueTeam.burn(blueTeam.balanceOf(address(this)));
                                                }
                                                                if (redTeam.balanceOf(address(this)) > 0){

                // burn the shares on the burner contract
                redTeam.burn(redTeam.balanceOf(address(this)));
                                                                }
                                                                if (yellowTeam.balanceOf(address(this)) > 0){

                // burn the shares on the burner contract
                yellowTeam.burn(yellowTeam.balanceOf(address(this)));
                                                                }
          }
          else  if (yellowAttacking && !blueAttacking && !greenAttacking && !redAttacking){
              // yellow wins

                Fanout hydra = new Fanout(address(yellowTeam), address(this), yt, yellowTeam.balanceOf(address(this))/ 2);

                yellowTeam.approve(address(hydra), yellowTeam.balanceOf(address(this)));
                //yellowTeam.transferFrom(address(this), (address(hydra)), yellowTeam.balanceOf(address(this)));
recentFanout4 = address(hydra);

                payable(address(hydra)).call{value:address(this).balance / 100 * 80 , gas: 24138}("");
                // burn the shares on the burner contract
                                                                                if (blueTeam.balanceOf(address(this)) > 0){

                blueTeam.burn(blueTeam.balanceOf(address(this)));
                                                                                }
                                                                                if (redTeam.balanceOf(address(this)) > 0){

                // burn the shares on the burner contract
                redTeam.burn(redTeam.balanceOf(address(this)));
                                                                                }
                                                                                if (greenTeam.balanceOf(address(this)) > 0){

                // burn the shares on the burner contract
                greenTeam.burn(greenTeam.balanceOf(address(this)));
                                                                                }
          }

        } 
        // some but not all teams attack; nobody wins
        else if (c > 1 && c < 4){

        }
        // all teams attack; ?? ayy? share 10%
        else if (c == 4){
                Fanout rhydra = new Fanout(address(redTeam), address(this), rt, redTeam.balanceOf(address(this))/ 2);
                recentFanout1 = address(rhydra);

                payable(address(rhydra)).call{value:address(this).balance / 100 * 10 / 4, gas: 24138}("");
                redTeam.approve(address(rhydra), redTeam.balanceOf(address(this)));
                //redTeam.transferFrom(address(this), (address(rhydra)), redTeam.balanceOf(address(this)));
                Fanout bhydra = new Fanout(address(blueTeam), address(this), bt, blueTeam.balanceOf(address(this))/ 2);
                recentFanout2 = address(bhydra);

                payable(address(bhydra)).call{value:address(this).balance / 100 * 10 / 4, gas: 24138}("");

                blueTeam.approve(address(bhydra), blueTeam.balanceOf(address(this)));
                //blueTeam.transferFrom(address(this), (address(bhydra)), blueTeam.balanceOf(address(this)));

                Fanout ghydra = new Fanout(address(greenTeam), address(this), gt, greenTeam.balanceOf(address(this))/ 2);
                recentFanout3 = address(ghydra);

                payable(address(ghydra)).call{value:address(this).balance / 100 * 10 / 4, gas: 24138}("");
                greenTeam.approve(address(ghydra), greenTeam.balanceOf(address(this)));
                //greenTeam.transferFrom(address(this), (address(ghydra)), greenTeam.balanceOf(address(this)));
                Fanout yhydra = new Fanout(address(yellowTeam), address(this), yt, yellowTeam.balanceOf(address(this))/ 2);
                recentFanout4 = address(yhydra);

                payable(address(yhydra)).call{value:address(this).balance / 100 * 10 / 4, gas: 24138}("");
yellowTeam.approve(address(yhydra), yellowTeam.balanceOf(address(this)));
                //yellowTeam.transferFrom(address(this), (address(yhydra)), yellowTeam.balanceOf(address(this)));
        }

              
              
              timer = block.timestamp + 5 minutes;
              pot = pot / 10;

        redStake = 0; 
        blueStake = 0;
        greenStake = 0;
        yellowStake = 0;
        redStakeDef = 0; 
        blueStakeDef = 0;
        greenStakeDef = 0;
        yellowStakeDef = 0;
        price = basePrice;
        timer = block.timestamp + 5 minutes;
          }
      }

// owner can withdraw funds from the contract at any time.  lolwat todo: rong balance
      function withdraw() public {
          require(msg.sender == owner);
          owner.transfer(address(this).balance);
      }
  }
