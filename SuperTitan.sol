
pragma solidity ^0.4.19;
import "./TitanToken.sol";

/*Implements token factory 
*/
contract SuperTitan{
    //this address is only for testing purpose 
    address public addr ;
    //counter is used to count the token number
    uint public counter;
    struct Tokendetails {
        uint256 initialSupply;
        bytes32 symbol;
        bytes32 name;
        address tokenaddress;
        //currentholdings for initialSupply-spending tokens
        uint256 currentholdings; 
       
        
    }
    mapping(
        uint => Tokendetails
        )public tokendetails;
   
        
    //superowner is the address  who can deploy the contract 
    address superowner;
   
    event TokenAddedToTitan(address, bytes32);
    modifier only_superTitanOwner(address){
        require(msg.sender==superowner);
        _;
    }
    
    function SuperTitan()public{
       superowner = msg.sender;
       //initally setting counter to 0 ;
       counter = 0;
        
    }
    
    //add new token in the list of token types 
    function addToken(address _tokenaddress, bytes32 _tokenname, bytes32 _symbol, uint256 _initialSupply)only_superTitanOwner(msg.sender) private {
        tokendetails[counter].tokenaddress = _tokenaddress;
        tokendetails[counter].name = _tokenname;
        tokendetails[counter].symbol = _symbol;
        tokendetails[counter].initialSupply =_initialSupply;
        tokendetails[counter].currentholdings = _initialSupply; 
        counter++;
        
    }
    /** viewToken give all information of tokens 
    * It includes only initial attributes value for the secified types of tokens */
    function viewTokens()
    view
    public 
    returns(address[], bytes32[], bytes32[], uint256[],uint256[]){
        address[] memory arr_address = new address[](counter);
        bytes32[] memory arr_name = new bytes32[](counter);
        bytes32[] memory arr_symbol = new bytes32[](counter);
        uint256[] memory arr_initialsupply = new uint256[](counter);
        uint256[] memory arr_currentholdings =  new uint256[](counter);
        Tokendetails memory currentTokendetails;
        for(uint i=0; i<=counter; i++){
            currentTokendetails = tokendetails[i];
            arr_address[i] = currentTokendetails.tokenaddress;
            arr_name[i] = currentTokendetails.name;
            arr_symbol[i] = currentTokendetails.symbol;
            arr_initialsupply[i] = currentTokendetails.initialSupply;
            arr_currentholdings[i] = currentTokendetails.currentholdings;
        }
        return(arr_address,arr_name,arr_symbol,arr_initialsupply,arr_currentholdings);
    }

   
    //Generating new Token . 
    function newToken(uint256 _initialSupply, bytes32 _name, bytes32 symbol)
    only_superTitanOwner(msg.sender)
    public
    returns(address, bytes32){
        TitanToken T = new TitanToken(_initialSupply,_name,symbol);
        addToken(T, _name, symbol, _initialSupply);
        TokenAddedToTitan(T, _name);
        //addr variable is used for testing purpose
        addr = T;
        return (T, _name);
    }
}


