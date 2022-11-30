from brownie import (
    accounts,
    config,
    network,
    Veriface,
    TestSpecimen,
    exceptions
)
from scripts.helpful_scripts import get_account
from web3 import Web3
import pytest


def test_deploy():
    account = get_account()
    veriface = Veriface.deploy({"from": account})
    print("deployed veriface successfully")
    test = TestSpecimen.deploy(veriface.address, {'from': account})
    return (veriface, test)

def test_restrictions():
    #arrange
    account = get_account()
    [veriface, test] = test_deploy()
    tx = veriface.blackList(account, "", {"from": account})
    tx.wait(1)

    with pytest.raises(exceptions.VirtualMachineError):
        test.getOwnerBlacklistStrict({"from": account})


def test_restrictions_non():
    #arrange
    account = get_account()
    [veriface, test] = test_deploy()

    tx1 = test.getOwnerBlacklistStrict({"from": account})
    tx1.wait(1)


def test_whitelist():
    #arrange
    account = get_account()
    [veriface, test] = test_deploy()

    with pytest.raises(exceptions.VirtualMachineError):
        test.getOwnerWhitelist({"from": account})
