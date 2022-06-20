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
    address(this).balance += msg.value;
    //deposit amount to the contract

}

function withdrawl () public {

}

function getBalance() public view returns(uint) {
    return address(this).balance;

}


function approval(int nApprovals) public view returns() {
    if (nApprovals == approvals){
    }
    else {
    }

//check if there are enough approvals
}

function transfer(address to, uint amount) public {




}


}