pragma solidity ^0.4.19;
/*Implements token factory 
*/
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

