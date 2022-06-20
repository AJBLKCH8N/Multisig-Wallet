//SPDX-License-Identifier:UNLICENSED
pragma solidity 0.8.15;
pragma abicoder v2;

contract multisigwallet {

address[] public owners;
uint limit;

struct Transfer{
    address transferTo;
    uint transferAmount;
    uint8 numberApprovals;
}

Transfer[] transferRequests;

mapping(address => mapping(uint => bool)) approvals;
//double mapping - set address to point to a mapping where you input ID of address, and it returns T/F
//mapping[msg.sender][transferID] => True/False

function addOwner(address Owner) public{

}

function removeOwner(address Owner) public{

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