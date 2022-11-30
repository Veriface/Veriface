##imports
from brownie import (
    accounts,
    config,
    network,
    Veriface,
    TestSpecimen
)
from scripts.helpful_scripts import get_account
from web3 import Web3


def test_deploy():
    account = get_account()
    veriface = Veriface.deploy({"from": account})
    print("deployed veriface successfully")
    return veriface

def test_blackList():
    veriface = test_deploy()
    account = get_account()
    tx = veriface.blackList(veriface.address, "", {"from": account})
    tx.wait(1)

    isBlackListed = veriface.retrieveAddressStatus(veriface.address)
    assert isBlackListed == True
    print("blacklisted successfully")

def test_whiteList():
    veriface = test_deploy()
    account = get_account()
    tx = veriface.whitelist(veriface.address, {"from": account})
    tx.wait(1)

    isWhiteListed = veriface.retrieveWhiteListedAddressStatus(veriface.address)
    assert isWhiteListed == True
    print("blacklisted successfully")


