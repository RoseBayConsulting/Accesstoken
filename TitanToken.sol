pragma solidity ^0.4.19;
contract TitanToken{ 
    // Public variables of the token
    bytes32 public name;
    bytes32 public symbol;
    uint8 public decimals = 18;
    // 18 decimals is the strongly suggested default, avoid changing it
    uint256 public totalSupply;

   
   
   struct TokenBucket{
    address Address;
    bytes32 Name;
    bytes32 Symbol;
    uint256 Currentholdings;
    bool Userstatus;
    bool Merchantstatus;
   }      
   mapping ( 
       address => mapping(
           bytes32 => TokenBucket
           )) public ontokenbucket;
       
    event UserRegisteredLog(address,bytes32,bytes32,uint256);

    // This generates a public event on the blockchain that will notify clients
    event TransferLog(address from, address to, uint256 value);
   event InitialRegLog(address, bytes32, bytes32, uint, bool, bool);
    
    /**
     * Constrctor function
     *
     * Initializes contract with initial supply tokens to the creator of the contract
     */
    function TitanToken(uint256 _initialSupply, bytes32 _tokenName, bytes32 _tokenSymbol) public {
        totalSupply = _initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
        name = _tokenName;                                   // Set the name for display purposes
        symbol = _tokenSymbol;                               // Set the symbol for display purposes
        
        
      //  ontokenbucket[msg.sender][_tokenName].Address = msg.sender;
    //    ontokenbucket[msg.sender][_tokenName].Name = _tokenName;
     //   ontokenbucket[msg.sender][_tokenName].Symbol = _tokenSymbol;
      //  ontokenbucket[msg.sender][_tokenName].Currentholdings = totalSupply;
      //  ontokenbucket[msg.sender][_tokenName].Userstatus = false;
        //ontokenbucket[msg.sender][_tokenName].Merchantstatus = true;
        
        initialReg(_tokenName);
    }
    function initialReg(bytes32 _tokenName)public{ 
    
        ontokenbucket[msg.sender][_tokenName].Address = msg.sender;
        ontokenbucket[msg.sender][_tokenName].Name = name;
        ontokenbucket[msg.sender][_tokenName].Symbol = symbol;
        ontokenbucket[msg.sender][_tokenName].Currentholdings = totalSupply;
        ontokenbucket[msg.sender][_tokenName].Userstatus = false;
        ontokenbucket[msg.sender][_tokenName].Merchantstatus = true;
        emit InitialRegLog(
        ontokenbucket[msg.sender][_tokenName].Address,
        ontokenbucket[msg.sender][_tokenName].Name,
        ontokenbucket[msg.sender][_tokenName].Symbol,
        ontokenbucket[msg.sender][_tokenName].Currentholdings,
        ontokenbucket[msg.sender][_tokenName].Userstatus,
        ontokenbucket[msg.sender][_tokenName].Merchantstatus
            
            );
    
    }    
    
        
        //registerUsers is used to register the user with all attributes
  function registerUsers(bytes32 _tokenName, bytes32 _tokenSymbol)public {
        ontokenbucket[msg.sender][_tokenName].Address = msg.sender;
        ontokenbucket[msg.sender][_tokenName].Name = _tokenName;
        ontokenbucket[msg.sender][_tokenName].Symbol = _tokenSymbol;
        ontokenbucket[msg.sender][_tokenName].Currentholdings = 0 ;
        ontokenbucket[msg.sender][_tokenName].Userstatus = true;
        ontokenbucket[msg.sender][_tokenName].Merchantstatus=false;
        
       emit UserRegisteredLog(msg.sender, _tokenName, _tokenSymbol, ontokenbucket[msg.sender][_tokenName].Currentholdings);
   }
  
  
    

    /**
     * Internal transfer, only can be called by this contract
     */
    function _transfer(address _from, address _to, uint _value, bytes32 _tokenName) internal {


         require(_to != 0x0);
         
        // Check if the sender has enough
        require(ontokenbucket[_from][_tokenName].Currentholdings >= _value);
        // Check for overflows
        
        require(ontokenbucket[_to][_tokenName].Currentholdings + _value > ontokenbucket[_to][_tokenName].Currentholdings);
        // Save this for an assertion in the future
       
        uint previousBalances = ontokenbucket[_from][_tokenName].Currentholdings + ontokenbucket[_to][_tokenName].Currentholdings;
    
        // Subtract from the sender
        ontokenbucket[_from][_tokenName].Currentholdings -= _value;
        // Add the same to the recipient
        ontokenbucket[_to][_tokenName].Currentholdings += _value;
    
        emit TransferLog(_from, _to, _value);
        // Asserts are used to use static analysis to find bugs in your code. They should never fail
        assert(ontokenbucket[_from][_tokenName].Currentholdings + ontokenbucket[_to][_tokenName].Currentholdings == previousBalances);

    }
    
    /**
     * Transfer tokens
     *
     * Send `_value` tokens to `_to` from your account
     *
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transfer(address _to, uint256 _value, bytes32 _tokenName) public {
        _transfer(msg.sender, _to, _value, _tokenName);
    }

   /*
    function exchangeTo(uint256 _value )private {
        balanceOf[msg.sender] += _value;
        Eventexchangeto(name,symbol,_value);
        
    }
    function exchangeFrom(uint256 _value) private{
    balanceOf[msg.sender] -= _value;  
     Eventexchangefrom(name,symbol,_value);
    }  */
    
    //this trading frunction is used to trade one token types to another one 
    function tradingfrom(uint _value)external{
         // Check if the sender has enough
        require(ontokenbucket[msg.sender][name].Currentholdings >= _value);
         ontokenbucket[msg.sender][name].Currentholdings -= _value;
        
    }
    function tradingto(uint _value)external{
        uint tempholdings = ontokenbucket[msg.sender][name].Currentholdings;
        
        ontokenbucket[msg.sender][name].Currentholdings += _value;
        require(ontokenbucket[msg.sender][name].Currentholdings == tempholdings + _value); 
               
        
    }
}

