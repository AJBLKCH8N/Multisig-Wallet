//SPDX-License-Identifier:UNLICENSED
pragma solidity 0.8.15;
pragma abicoder v2;

contract multisigwallet {
    //MultiSigWallet Contract
    address public contractOwner;
    //contractOwner
    address[] public owners;
    //array of addresses who are co-owners and are able to approve/suggest transactions
    uint public limit;
    //limit will be a variable to set the initial number of owners allowed in the array
    mapping(address => bool) ownersMember;
    //mapping to keep track of whether an owner exists within owners group
    mapping(uint => mapping(address => bool)) approvalRecord;
    //double mapping that maps an Index (TXN INDEX) to an address which is mapped to a boolean. to keep track of an address approving a txn.
    
    struct Transfer{
        address transferTo;
        //the recipient's address
        uint transferAmount;
        //the amount to be transfered
        bool executed;
        //executed variable to track whether the transaction has actually been executed
        uint8 numberApprovals;
        //number of approvals to track how many owners have approved the transaction 

    }
    //a Struct called transfer, which is a block of data pertaining to each transaction
    
    

    Transfer[] transferRequests;
    //an array called transferRequests for the Transfer struct
    
    constructor() {
        contractOwner = msg.sender;
        //sets the contractOwner as the address that deployed the contract
        owners.push(msg.sender);
        //populate the 'owners' array with contract owner in the first position
        ownersMember[msg.sender] = true;
        //sets the contract owner as the Owners Member
        limit = 3;
        //Default limit to number of owners
    }
    //Constructor set to push the contract owner as position 1 within the owners array & set the default limit as 3
    
    modifier onlyContractOwner {
        require(msg.sender == contractOwner, "Only the contract owner can execute this function"); 
        _;
    }
    //onlyOwner modifier for access control - contract owner specific restrictions
    
    modifier onlyOwners {
        require(ownersMember[msg.sender] == true, "Only owners added to the owners group execute this function"); 
        _;
    }
    //onlyOwners modifier for access control - restrictions limited to only those added to the owner 
    
    modifier addrApproved(uint _txIndex) {
        require(!approvalRecord[_txIndex][msg.sender], "Only owners added to the owners group execute this function"); 
        _;
    }
    //onlyOwners modifier for access control - restrictions limited to only those added to the owner array

    
    //mapping(address => mapping(uint => bool)) approvals;
    function addOwner(address _newOwner) public onlyContractOwner returns(address[] memory) {
        //function to add owners to the owner array - locked down to only the contract owner
        owners.push(_newOwner);
        //this adds the _newOwner variable to the owners array
        ownersMember[_newOwner] = true;
        //FUTURE - include provisions to check the specified limit?
        return owners;
    }
    function removeOwner(uint index) public onlyContractOwner returns(address[] memory) {
        //function to remove an owner from the array
        if (index >= owners.length) return(owners);
        // if the index is greater than the length of the owners array, then the function comes to an end
        address addrHolder = owners[index]; 
        //declares addrHolders as owners[index], as this cannot be executed within the for loop
        ownersMember[addrHolder] = false;
        //this sets the address mapping to the OwnersMember group as false, effectively removing the addr from the priviledged group
        for (uint i = index; i < owners.length - 1; i++) {
            owners[i] = owners[i+1];
        } delete owners[owners.length-1];
        //this for control flow iterates through the array - as long as index is less than the length of the owners array, it
        //increments the index, going through to removve the specifed index corresponding to the owner
        owners.pop();
        //this removes the last item in the array
        //include provisions that make it so that the contract owner cannot be removed from array position 0.
        return owners;
    }
    function deposit() public payable returns(uint) {
        //Empty function to deposit amount to the contract - this allows anyone to deposit funds
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
        //this populates the inputs into the Transfer Struct and pushes it to the 'Queue' awaiting approvals from the owners
    }
    function getTransferRequests() external view returns(Transfer[] memory) {
        //for testing purposes to see if transferRequests are being populated
        return transferRequests;
    }
    function approveTransaction(uint _txIndex) public onlyOwners addrApproved(_txIndex){  
        //the approval function is called by owners to give their approval of the submitted transaction.
        Transfer storage transaction = transferRequests[_txIndex];
        //declared a local variable, 'transaction' which is an ID/index of the transfer requests array
        require(transaction.executed == false, "this transaction has already been executed");
        //this requires that the transaction has not already been executed
        approvalRecord[_txIndex][msg.sender] = true;
        //this sets the approval record corresponding to the txn ID and the caller address to true to ensure they cant confirm twice.
        transaction.numberApprovals += 1;
        //increments the number of approvals for the transaction

    }
    function executeTransfer(uint _txIndex) public payable onlyContractOwner {
        //locks down this function to just the contract owner
        Transfer storage transaction = transferRequests[_txIndex];
        require(transaction.numberApprovals >= limit -1, "this transaction does not have enough approvals");
        //Requires that the transaction has enough approvals (which is one less than the limit) - probably need to rethink this
        require(transaction.executed == false, "this transaction has already been executed");
        //Requires that the transacton.executed flag is false - stops a transaction being executed twice
        require(address(this).balance >= transaction.transferAmount, "this transaction cannot be executed, insufficient balance");
        //requires that the contract balance is greater than the transfer amount - is this even needed?
        payable(transaction.transferTo).transfer(transaction.transferAmount);
        //Executes the transaction, sending amount to the recipient
        transaction.executed = true;
        //Once the transaction has been executed, it sets the transaction executed flag to true.
    }
}