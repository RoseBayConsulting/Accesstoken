pragma solidity ^0.4.19;

contract AccessToken{

//UserTokenContainer which is a list of accessDetails by account
struct UserTokenContainer{ 

//is this asset is permisible or not 
bool flag;  

address owner;

//list of permissioned asset to view by another owner.
SecOwnerList secownerlist;

bytes32 assetKey;
   }  
struct SecOwnerList{

//address of orginal asset owner
address owner;

// address of secondry ownner 
address secOwner;

// asset orginal key 
bytes32 assetKey;

// flag to set this asset is readable by secOwner
bool flag;
   }

//one to one mapping , this is not suitable for number of permissible key are distributed to n>1
//List of secondary owner address - which make the list of permissiable address  index as asset key 
   mapping(bytes32=>mapping(address=>bool))public  ListOfSecOwnAdd;

   //mapping address of UserTokenContainer with the corrosponding data 
   //this is used for register asset with its corrosponding data
   //utc is the list of transactions -> User Token Container
   //address= address of owner and bytes32=asset key
   mapping(address=>mapping(bytes32=>UserTokenContainer)) utc;

   //sowl-> Secondary OWner List
   mapping(address=>mapping(address=>SecOwnerList)) sowl;
 /*
 remaining work with BDB
// address of user who push the data into both bigchaindb and titan blockchain .
address public AssetCreaterAddress;

// address of user who wants to view the data from bigchaindb.
address public TransactionViewerAddres;

//inorder to view the transation , 'TransactionViewerAddres' must have the private key of the bigchiandb. 
bytes32 public BdbKey;
*/

//to move the address when ever needed like implements for function argument override 
address public TempAddress;

event RegisteredAsset(address , bytes32, bool);

event AssetPermissiable(address _owner_address, address _secowner_address, bytes32 _assetkey, bool flag);

event DeleteAcessSucceed(address _owner_address,address _secowner_address,bytes32 _assetkey);

event GetAssetDone(address,bytes32);
  
/*   
registerAsset
Description: registers asset so owner (account) can be identified for subsequent operations
input variables: asset_key
output:  boolean
Flow
Checks to see if caller is owner of asset
if owner then registers the asset associated with owner name
returns true for success or false for failure
 */
 //send falg as false as parameter using web3js 
function registerAsset (bytes32 _assetkey, bool _flag) public  returns (bool){

utc[msg.sender][_assetkey].owner = msg.sender;

utc[msg.sender][_assetkey].assetKey = _assetkey;

// default must be false
utc[msg.sender][_assetkey].flag = _flag;

RegisteredAsset( msg.sender, _assetkey, _flag);

return true;   
}

//Give access to vew the asset to other users 
function giveAccess(address _owner_address, bytes32 _assetkey, address _secowner_address){
           
UserTokenContainer  currentUserTokenContainer ;

currentUserTokenContainer = utc[_owner_address][_assetkey];

// need to be owner of asset 
assert(currentUserTokenContainer.owner == _owner_address);

assert(currentUserTokenContainer.assetKey == _assetkey);

  if (currentUserTokenContainer.flag==false){

    //this asset is now view by other users.
utc[_owner_address][_assetkey].flag=true;
  }

// specific to users who want to view the asset must have the permision 
//which permission is given by owner of the asset. 
sowl[_owner_address][_secowner_address].owner=msg.sender;

sowl[_owner_address][_secowner_address].secOwner=_secowner_address;

// this is the condition of only one asset can be permissiable to one user.
sowl[_owner_address][_secowner_address].assetKey=_assetkey;

//for this individual asset there must be in and out scope .
sowl[_owner_address][_secowner_address].flag=true;

ListOfSecOwnAdd[_assetkey][_secowner_address]=true;

//event for success
AssetPermissiable(_owner_address, _secowner_address, _assetkey,true);
}

/*    
deleteAccess (only for owner of asset):  Revokes access to a specified asset
*/
function deleteAccess(address _owner_address, address _secowner_address, bytes32 _assetkey)private {

 SecOwnerList  currentSecOwnerList ;

currentSecOwnerList = sowl[_owner_address][_secowner_address];

// need to match both addresses and asset key  
assert(currentSecOwnerList.owner== _owner_address);

assert(currentSecOwnerList.assetKey==_assetkey);

//flag in the SecOwnerList must be 'true'.if  flag is 'false' then it is not permissible.
assert(sowl[_owner_address][_secowner_address].flag);

//set flag to false
sowl[_owner_address][_secowner_address].flag=false;
//TODO: set bool to false for ListOfSecOwnAddr[][] . It means that assetkey and _secOwn_address has no any match.
ListOfSecOwnAdd[_assetkey][_secowner_address] == false;
DeleteAcessSucceed(_owner_address,_secowner_address,_assetkey);
 }

function getAsset(bytes32 _assetkey)public returns(bool) {

//if msg.sender is not the owner of the asset then we have to look whether this
//msg.sender has permission to read.     
if(utc[msg.sender][_assetkey].assetKey != _assetkey){

   //(assetKey,msg.sender)->(n,n) . 
   //number of assetkey have number of secondry address.
   //if true then it means that, asset  have permissoin to see by the requester.
assert(ListOfSecOwnAdd[_assetkey][msg.sender] == true);
 
}    
GetAssetDone(msg.sender,_assetkey);

return true;       
}
}