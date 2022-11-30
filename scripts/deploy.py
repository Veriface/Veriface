##imports
from brownie import (
    accounts,
    config,
    network,
    Veriface,
)
from scripts.helpful_scripts import get_account
from web3 import Web3
import time

def deploy_Veriface():
    ##set up
    account = get_account()
    veriface = Veriface.deploy({"from": account})
    print("deployed veriface successfully")


def deploy_test():
    ##set up
    account = get_account()
    test = Veriface.deploy({"from": account})
    print("deployed veriface successfully")

