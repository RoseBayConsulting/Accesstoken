pragma solidity ^0.4.19;
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
