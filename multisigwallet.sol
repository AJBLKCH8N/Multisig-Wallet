//SPDX-License-Identifier:UNLICENSED
pragma solidity 0.8.15;
pragma abicoder v2;

contract multisigwallet {
    //contractOwner
    address public contractOwner;
    //array of addresses who are co-owners and are able to approve/suggest transactions
    address[] public owners;
    //limit will be a variable to set the initial number of owners allowed in the array
    uint public limit;
    //mapping to keep track of whether an owner exists within owners group
    mapping(address => bool) ownersMember;
    //a Struct called transfer, which is a block of data pertaining to each transaction
    struct Transfer{
        address transferTo;
        uint transferAmount;
        //executed variable to track whether the transaction has actually been executed
        bool executed;
        //number of approvals to track how many owners have approved the transaction
        uint8 numberApprovals;
    }
    //an array called transferRequests for the Transfer struct
    Transfer[] transferRequests;
    //Constructor set to push the contract owner as position 1 within the owners array & set the default limit as 3
    constructor() {
        contractOwner = msg.sender;
        owners.push(msg.sender);
        ownersMember[msg.sender] = true;
        limit = 3;
        //FUTURE - need to include provision to make it so that the contract owner cant be deleted from the array
    }
    //onlyOwner modifier for access control - contract owner specific restrictions
    modifier onlyContractOwner {
        require(msg.sender == contractOwner, "Only the contract owner can execute this function"); 
        _;
    }
    //onlyOwners modifier for access control - restrictions limited to only those added to the owner array
    modifier onlyOwners {
        require(ownersMember[msg.sender], "Only owners added to the owners group execute this function"); 
        _;
    }
    
    //mapping(address => mapping(uint => bool)) approvals;
    //double mapping - set address to point to a mapping where you input ID of address, and it returns T/F
    //mapping[msg.sender][transferID] => True/False
    // this is a mapping called 'approvals' that maps an address to an address ID which is mapped to a boolean Y/N
    //i.e. approvals {uint: bool}
    function addOwner(address _newOwner) public onlyContractOwner returns(address[] memory) {
        //function to add owners to the owner array (currently no access control to limit who can add owners - onlyOwners or onlyOwner
        owners.push(_newOwner);
        //this adds the _newOwner variable to the owners array
        ownersMember[_newOwner] = true;
        //FUTURE - atm anyone can add owners. this needs to be limited to only specified people or perhaps only the contract owner
        //FUTURE - include provisions to check the specified limit?
        return owners;
    }
    function removeOwner(uint index) public onlyContractOwner returns(address[] memory) {
        //function to remove an owner from the array
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
    function submitTransferRequest(address _transferTo, uint _transferAmount) public onlyOwners {
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
    function approveTransaction(uint _txIndex) public onlyOwners {  
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
    function executeTransfer(uint _txIndex) public payable onlyContractOwner {
        //locks down this function to just the contract owner
        Transfer storage transaction = transferRequests[_txIndex];
        require(transaction.executed = false, "this transaction has already been executed");
        payable(transaction.transferTo).transfer(transaction.transferAmount);
        transaction.executed = true;
    }
}