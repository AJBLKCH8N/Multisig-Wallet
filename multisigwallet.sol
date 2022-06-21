//SPDX-License-Identifier:UNLICENSED
pragma solidity 0.8.15;
pragma abicoder v2;

contract multisigwallet {

address[] public owners;
//this is an array called 'owner' of variable 'address' 

uint limit;
//uint called limit which is a flag to set the amount of approvals required

struct Transfer{
    address transferTo;
    uint transferAmount;
    uint8 numberApprovals;
}
//struct = datastructure.
// this is a datastructure called 'Transfer' which contains address (transferTo, uint transferAmount and uint8 numberApprovals)
//declared at the global context scope and therefore used within the contract

Transfer[] transferRequests;
//array called transfer which is filled up with transferRequests which is created by the struct

mapping(address => mapping(uint => bool)) approvals;
//double mapping - set address to point to a mapping where you input ID of address, and it returns T/F
//mapping[msg.sender][transferID] => True/False
// this is a mapping called 'approvals' that maps an address to an address ID which is mapped to a boolean Y/N
//i.e. approvals {uint: bool}

function addOwner(address _newOwner) public returns(address[] memory) {
    //function to add owners to the owner array (currently no access control to limit who can add owners)
    owners.push(_newOwner);
    //this adds the _newOwner variable to the owners array
    //FUTURE - atm anyone can add owners. this needs to be limited to only specified people or perhaps only the contract owner
    return owners;
}

function removeOwner(uint index) public returns(address[] memory) {
// need a way to remove a particular owner... Cant do this without leaving a 'gap', so will need to move all items in the array
// to the left, and remove the gap item 
    if (index >= owners.length) return(owners);
    // if the index is greater than the length of the owners array, then the function comes to an end
    //FUTURE - change this if statement to a REQUIRE instead
    for (uint i = index; i < owners.length - 1; i++) {
        owners[i] = owners[i+1];
    } delete owners[owners.length-1];
    //this for control flow iterates through the array - as long as index is less than the length of the owners array, it
    //increments the index, going through to removve the specifed index corresponding to the owner
    owners.pop();
    //this removes the last item in the array
    return(owners);
}


function deposit () public payable returns(uint) {
    //Empty function to deposit amount to the contract - this allows anyone to deposit funds
    //In solidity you dont need to specify address(this).balance to receive funds directly to the contract. 
    //As long as a function is payable and you do not specify what to do with msg.value, 
    //all funds will directly go into the contract internal balance.
    //FUTURE: Can include some error handling to require that the sender's balance is greater/equal to sending amount

}

function getBalance() public view returns(uint) {
    //simple function to get the balance of the contract, which anyone can execute
    return address(this).balance;

}


function approval(int nApprovals) public view {
    if (nApprovals == approvals){
    }
    else {
    }

//check if there are enough approvals
}

function transfer(address to, uint amount) public payable {
    //simple function to transfer amount from the contract to an Ethereum wallet
    //Future: add logic for approvals
    payable(to).transfer(amount);
}


}