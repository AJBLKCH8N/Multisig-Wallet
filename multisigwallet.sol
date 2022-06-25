//SPDX-License-Identifier:UNLICENSED
pragma solidity 0.8.15;
pragma abicoder v2;

contract multisigwallet {
    address[] public owners;
    //this is an array called 'owner' of variable 'address' 
    uint public limit;
    //uint called limit which is a flag to set the amount of approvals and number of owners required
    struct Transfer{
        address transferTo;
        uint transferAmount;
        bool executed;
        //mapping(address => bool) txnApproved;
        uint8 numberApprovals;
    }
    //struct = datastructure.
    // this is a datastructure called 'Transfer' which contains address (transferTo, uint transferAmount and uint8 numberApprovals)
    //declared at the global context scope and therefore used within the contract
    Transfer[] transferRequests;
    //array called transferRequests which is filled up with Transfer data structures which is created by the struct
    constructor() {
        owners.push(msg.sender);
        //specifies the contract owner at at the beginning of contract deployment, and adds it to the owners array, position 1
        //FUTURE - need to include provision to make it so that the contract owner cant be deleted from the array
        limit = 3;
        //this sets the default limit of number of approvals as 3
    }
    //mapping(address => mapping(uint => bool)) approvals;
    //double mapping - set address to point to a mapping where you input ID of address, and it returns T/F
    //mapping[msg.sender][transferID] => True/False
    // this is a mapping called 'approvals' that maps an address to an address ID which is mapped to a boolean Y/N
    //i.e. approvals {uint: bool}
    function addOwner(address _newOwner) public returns(address[] memory) {
        //function to add owners to the owner array (currently no access control to limit who can add owners
        owners.push(_newOwner);
        //this adds the _newOwner variable to the owners array
        //FUTURE - atm anyone can add owners. this needs to be limited to only specified people or perhaps only the contract owner
        //FUTURE - include provisions to check the specified limit?
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
        //include provisions that make it so that the contract owner cannot be removed from array position 0.
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
    function submitTransferRequest(address _transferTo, uint _transferAmount) public {
        //this function submits the transfer request, populating the Transfer Struct.
        uint txIndex = transferRequests.length;
        transferRequests.push(
            Transfer(
                {
                    transferTo: _transferTo,
                    transferAmount: _transferAmount,
                    executed: false,
                    numberApprovals: 0

                }
            )
        );
    }
    function getTransferRequests() external view returns(Transfer[] memory) {
        //for testing purposes to see if transferRequests are being populated
        return transferRequests;
    }
    function approveTransaction(uint _txIndex) public {  
        //the approval function is called by owners to give their approval of the submitted transaction.
        Transfer storage transaction = transferRequests[_txIndex];
        //declared a local variable, 'transaction' which is an ID/index of the transfer requests array
        //transaction.txnApproved[msg.sender] = true;
        //sets the txnApproved bool to true
        transaction.numberApprovals += 1;
        //increments the number of approvals for the transaction
        //at the moment the same address can approve multiple times. Need to restrict this
        //if (transaction.numberApprovals >= limit) {
            //include require txn.executed = false
            //transaction.executed = true;
        //}
    }
    function executeTransfer(uint _txIndex) public payable {
        //simple function to transfer amount from the contract to an Ethereum wallet
        //Future: add logic for approvals
        //require numberApprovals >= limit
        //require transaction.executed = false
        Transfer storage transaction = transferRequests[_txIndex];
        payable(transaction.transferTo).transfer(transaction.transferAmount);
        transaction.executed = true;
    }
}