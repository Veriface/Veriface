// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./base64.sol";

error addressBlocked(address sender, string message);
error deniedService(address sender, string message);

contract Veriface is Ownable {
    mapping(address => BlackListData) private _blaclistedAddresses;
    mapping(address => bool) private _whiteListedsAddresses;
    mapping(address => string) private _blaclistedAddressesDetails;
    mapping(address => bool) public admins;

    constructor() {
        admins[msg.sender] = true;
    }

    struct BlackListData {
        uint256 time;
        bool blackListed;
        string uri;
        address by;
    }

    event SuspiciousUser(
        address user,
        address indexed callerContract,
        uint256 indexed time
    );

    event WhiteListedAddresses(address[] addresses, uint256 time);
    event BlackListedAddresses(address[] addresses, uint256 time);

    event RemovedWhiteListedAddresses(address[] addresses, uint256 time);
    event RemovedBlackListedAddresses(address[] addresses, uint256 time);

    event NewAdmin(address indexed newAdmin, uint256 indexed timestamp);
    event RemovedAdmin(
        string reason,
        address indexed newAdmin,
        uint256 indexed timestamp
    );

    modifier onlyAdmin() {
        require(admins[msg.sender] || msg.sender == owner(), "admins only");
        _;
    }

    function retrieveAddressStatus(address userAddress)
        public
        view
        returns (bool isBlaclisted)
    {
        return _blaclistedAddresses[userAddress].blackListed;
    }

    function retrieveWhiteListedAddressStatus(address userAddress)
        public
        view
        returns (bool isWhiteListed)
    {
        return _whiteListedsAddresses[userAddress];
    }

    //only owner

    //blacklist functions
    //remove it from blacklisted if blacklisted
    function blackList(address userAddress, string memory blackListUri)
        external
        onlyAdmin
    {
        _blaclistedAddresses[userAddress] = BlackListData({
            time: block.timestamp,
            blackListed: true,
            uri: blackListUri,
            by: msg.sender
        });
        if (_whiteListedsAddresses[userAddress] = true) {
            _whiteListedsAddresses[userAddress] = false;
        }
        address[] memory user = new address[](1);
        user[0] = userAddress;
        emit BlackListedAddresses(user, block.timestamp);
    }

    function batchBlackList(
        address[] memory userAddresses,
        string[] memory uris
    ) external onlyAdmin {
        require(userAddresses.length == uris.length, "details not not match");
        for (uint256 i = 0; i < userAddresses.length; i++) {
            if (_whiteListedsAddresses[userAddresses[i]] = true) {
                _whiteListedsAddresses[userAddresses[i]] = false;
            }
            if (_blaclistedAddresses[userAddresses[i]].blackListed == false) {
                _blaclistedAddresses[userAddresses[i]] = BlackListData({
                    time: block.timestamp,
                    blackListed: true,
                    uri: uris[i],
                    by: msg.sender
                });
            }
        }
        emit BlackListedAddresses(userAddresses, block.timestamp);
    }

    function removeBlackList(address userAddress) external onlyAdmin {
        delete _blaclistedAddresses[userAddress];
        address[] memory user = new address[](1);
        user[0] = userAddress;
        emit RemovedBlackListedAddresses(user, block.timestamp);
    }

    function removeBatchBlackList(address[] memory userAddresses)
        external
        onlyAdmin
    {
        for (uint256 i = 0; i < userAddresses.length; i++) {
            if (_blaclistedAddresses[userAddresses[i]].blackListed == true) {
                delete _blaclistedAddresses[userAddresses[i]];
            }
        }
        emit RemovedBlackListedAddresses(userAddresses, block.timestamp);
    }

    //require Digital identity verification

    //whitelist functions
    //remove it from blacklisted if blacklisted
    function whitelist(address userAddress) external onlyAdmin {
        _whiteListedsAddresses[userAddress] = true;
        address[] memory user = new address[](1);
        user[0] = userAddress;
        emit WhiteListedAddresses(user, block.timestamp);
    }

    function batchwhiteList(address[] memory userAddresses) external onlyAdmin {
        for (uint256 i = 0; i < userAddresses.length; i++) {
            if (_whiteListedsAddresses[userAddresses[i]] == false) {
                _whiteListedsAddresses[userAddresses[i]] = true;
            }
        }
        emit WhiteListedAddresses(userAddresses, block.timestamp);
    }

    function removeWhitelist(address userAddress) external onlyAdmin {
        _whiteListedsAddresses[userAddress] = false;
        address[] memory user = new address[](1);
        user[0] = userAddress;
        emit RemovedWhiteListedAddresses(user, block.timestamp);
    }

    function batchremoveWhiteList(address[] memory userAddresses)
        external
        onlyAdmin
    {
        for (uint256 i = 0; i < userAddresses.length; i++) {
            if (_whiteListedsAddresses[userAddresses[i]] == true) {
                _whiteListedsAddresses[userAddresses[i]] = false;
            }
        }
        emit RemovedWhiteListedAddresses(userAddresses, block.timestamp);
    }

    //helper functions
    function checkAddress(
        address sender,
        address callerContract,
        uint256 level
    ) public {
        bool isBlackListed = _blaclistedAddresses[sender].blackListed;
        if (isBlackListed == true) {
            if (level == 0) {
                revert addressBlocked({
                    sender: sender,
                    message: "your account was denied interaction"
                });
            } else if (level == 1) {
                emit SuspiciousUser(sender, callerContract, block.timestamp);
            }
        }
    }

    /*
     - requireAddressWhiteListed: that address is whitelised and deny or allow service
     - @sender: sender of the transaction(msg.sender)
     - @refuseService: bool input decide to refuse sender the service
    */
    function requireAddressWhiteListed(address sender, bool refuseService)
        external
        view
    {
        bool isWhiteListed = _whiteListedsAddresses[sender];
        if (isWhiteListed == false) {
            if (refuseService == true) {
                revert deniedService({
                    sender: sender,
                    message: "service only available for whitelisted addresses"
                });
            }
        }
    }

    //
    function addAdmin(address newAdmin) external onlyOwner {
        admins[newAdmin] = true;
        emit NewAdmin(newAdmin, block.timestamp);
    }

    function removeAdmin(address admin, string memory reason)
        external
        onlyOwner
    {
        delete admins[admin];
        emit RemovedAdmin(reason, admin, block.timestamp);
    }

    function isAdmin(address admin) public view returns (bool isAdminAddress) {
        return admins[admin];
    }
}
