# Multisig-Wallet
Multisig-Wallet Smart Contract
Multi-sig wallets is a wallet where multiple signatures or approvals are needed for an outgoing transfer to take place. I.e. create a Multisig wallet with me and my 2 friends. I configure the wallet such that it requires at least 2 of us to sign any transfer before it is valid.
Anyone can deposit funds into this wallet but as soon as we need to spend funds, it requires 2/3 approvals.

Requirements:
1) anyone can deposit Ether into the Smart Contract
2) the contract creator should be able to input 
    a) addresses of owners, 
    b) number of approvals required for a transfer in the constructor
Example- input 3x addresses and set the approval limit to 2
3) Any of the owners should be able to create a transfer request. The creator of the transfer request will specify what amount and to what address the transfer will be made
4) Owners should be able to approve transfer requests
5) When the transfer request has the required approvals, the transfer should be sent
