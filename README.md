# Getting Started

### Veriface is making the web3 smart contract space more secure one actor at a time.

## Tech stack
- Mumbai(Polygon Testnet)
- Solidity
- Python
- Brownie
- Aragon

## Description

Web3 is awesome and fun decentralization makes it quite unique. However, one cannot ignore the increasing number of bad actors in space. 
Since accounts are designed to be anonymous it not always easy for regular users to detect if the account they are interacting with is fraudulent or not.
Veriface is a verification interface and security shield you can implement into your smart contract to limit interactions with bad actors which makes the ecosystem more safer and secure
Veriface integration for your solidity smart contracts is quite simple, as simple as making a contract call to the Veriface protocol. This allows you to take advantage of the large database of accounts that have been identified by the protocol and either whitelisted or blacklisted without having to do so yourself.


# The Interface(Product use)
### Implement the Veriface Interface and watch it start to work.

Integrating veriface in your smart contracts is simple and stress-free with just a few lines of code you have the power of our security protocol at your fingertips.
Declaring the interface to check if an address is marked as blacklisted by our protocol and to require only whitelisted addresses to interact with a specific function in your smart contract

```solidity
interface IVeriface{
    function requireAddressWhiteListed(address sender, bool refuseService) external;
    function checkAddress(address sender, address callerContract, uint256 level) external;
 }
```
After declaring the interface you can use it just like any other interface implementation you have done before.

```solidity
contract GetAddress {
    IVeriface secure;
    constructor(address veriface){
        secure =  IVeriface(veriface);
    }
}
```
Now you can use it by calling any of our functions above before implementing your contract code. 
For example, check if an address is blacklisted and if it is denying it to call that function. This can be implemented like this

```solidity
interface IVeriface{
    function requireAddressWhiteListed(address sender, bool refuseService) external;
    function checkAddress(address sender, address callerContract, uint256 level) external;
 }

contract Owner {
     IVeriface secure;
    constructor(address veriface){
        secure =  IVeriface(veriface);
    }

    
    //prohibit blacklisted users from getting this data
    //code 0
    function getOwnerBlacklistStrict() external returns (address) {
        secure.checkAddress(msg.sender, address(this), 0);
        return address(this);
    }
}
```


# User Interface
### Allows you to check the status of an address

If you're not implementing these checks via a smart contract you can equally implement them manually using our website. 
Input any account's address and get feedback on the address health within the ecosystem. 
A blacklisted Address will typically show the reason for the blacklist and the transactions that were examined before it was blacklisted.
White-listed addresses would have to pass our personal identification to ensure that they are adequate. 


# The Veriface DAO
### A truly decentralized DAO

We know that with much power comes great responsibility and we're not going to let it slide. Veriface is run by a DAO meaning you can become part of veriface once digitally verified. Our blacklist and whitelist processes are as transparent as can be and can be adequately relied upon by third-party contracts and end users. We are a community of a one-member-one-vote DAO which means all members get a say in what goes on. We are aware of sybil attacks that come with this and that's why the Veriface DAO requires all its members to be digitally verified.
