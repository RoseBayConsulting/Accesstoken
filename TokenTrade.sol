pragma solidity ^0.4.19;
import "./SuperTitan.sol";
import "./TitanToken.sol";
contract TokenTrade is SuperTitan{
  
    //Trade function is used to trade form one token types to another one .
    function trade(bytes32 _from, uint256 _value, bytes32 _to)public{
    address addressofcontractfrom;
    
    //_from is name of token
    addressofcontractfrom = selectToken(_from);
    
    //TitanToken titaninstance = new TitanToken(addressofcontractfrom);
    addressofcontractfrom.call(bytes4(keccak256("tradingfrom(uint)")), _value);
     
     
     //_to is name of token 
    addressofcontractfrom = selectToken(_to);
    
    //setting factor to 1;
    uint factor = 1;
    _value *=factor;
    //calling contract for to and passing value
    addressofcontractfrom.call(bytes4(keccak256("tradingto(uint)")), _value);
   }
    //this selectToken 
    //function select the token types that is find the address of the contract 
    function selectToken(bytes32 _tokenName) public view returns(address) {
      
         
        for(uint i=0; i<counter; i++){
        
        if (tokendetails[i].name == _tokenName)return tokendetails[i].tokenaddress;
        
        }
        
    }
    
}
