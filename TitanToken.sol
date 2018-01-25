pragma solidity ^0.4.19;

interface tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;}

contract SuperTitan{
    //this is only for testing purpose 
    address public addr ;
    //List of Token name associated with its contract address.
    mapping(
        address => bytes32
        ) public TokenList;
    event TokenAddedToTitan(address, bytes32);
    
    //add new token in the list of token types 
    function addToken(address _tokenaddress, bytes32 _tokenname)internal {
        //check if token name already exist with its contract address. 
        assert(!(TokenList[_tokenaddress] == _tokenname));
        TokenList[_tokenaddress] = _tokenname;
        //Event for addToken 
        TokenAddedToTitan(_tokenaddress, _tokenname);
    }
    
    //Generating new Token . 
    function newToken(uint256 _initialSupply, bytes32 _name, bytes32 symbol)
    public
    returns(address, bytes32){
        TitanToken T = new TitanToken(_initialSupply,_name,symbol);
        addToken(T, _name);
        //used for testing purpose
        addr = T;
        return (T, _name);
    }
}

//This contract is Titan Factory templete derivative of ERC20 standard .
contract TitanToken{ 
    // Public variables of the token
    bytes32 public name;
    bytes32 public symbol;
    uint8 public decimals = 18;
    // 18 decimals is the strongly suggested default, avoid changing it
    uint256 public totalSupply;

    // This creates an array with all balances
    mapping (
        address => uint256
        ) public balanceOf;
        
    mapping (
        address => mapping (
            address => uint256
            )
        ) public allowance;

    // This generates a public event on the blockchain that will notify clients
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Eventexchangeto(bytes32,bytes32,uint256);
    event Eventexchangefrom(bytes32,bytes32,uint256);
    
    /**
     * Constrctor function
     *
     * Initializes contract with initial supply tokens to the creator of the contract
     */
    function TitanToken(uint256 initialSupply, bytes32 tokenName, bytes32 tokenSymbol) public {
        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
        name = tokenName;                                   // Set the name for display purposes
        symbol = tokenSymbol;                               // Set the symbol for display purposes
    }

    /**
     * Internal transfer, only can be called by this contract
     */
    function _transfer(address _from, address _to, uint _value) internal {
        // Prevent transfer to 0x0 address. Use burn() instead
        require(_to != 0x0);
        // Check if the sender has enough
        require(balanceOf[_from] >= _value);
        // Check for overflows
        require(balanceOf[_to] + _value > balanceOf[_to]);
        // Save this for an assertion in the future
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        // Subtract from the sender
        balanceOf[_from] -= _value;
        // Add the same to the recipient
        balanceOf[_to] += _value;
        Transfer(_from, _to, _value);
        // Asserts are used to use static analysis to find bugs in your code. They should never fail
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

    /**
     * Transfer tokens
     *
     * Send `_value` tokens to `_to` from your account
     *
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }

    /**
     * Transfer tokens from other address
     *
     * Send `_value` tokens to `_to` on behalf of `_from`
     *
     * @param _from The address of the sender
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowance[_from][msg.sender]);     // Check allowance
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    /**
     * Set allowance for other address
     *
     * Allows `_spender` to spend no more than `_value` tokens on your behalf
     *
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     */
    function approve(address _spender, uint256 _value) public
        returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }

    /**
     * Set allowance for other address and notify
     *
     * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
     *
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     * @param _extraData some extra information to send to the approved contract
     */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData)
        public
        returns (bool success) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, this, _extraData);
            return true;
        }
    }

    function exchangeTo(uint256 _value){
        balanceOf[msg.sender] += _value;
        Eventexchangeto(name,symbol,_value);
        
    }
    function exchangeFrom(uint256 _value){
    balanceOf[msg.sender] -= _value;  
     Eventexchangefrom(name,symbol,_value);
    }
}

contract ExchangeToken{
    function ExchangeToken(){}
    //used for testing purpose 
    uint public constant factor = 10 ;
    //assumed that both token exist for that wallet . To check, use web3js
    function exchange( uint256 _value)public returns(uint256){
    //passes the value of token from which we are exchanging to another token vaue . exchanged value is returned 
    return _value *= factor;
    }
}
