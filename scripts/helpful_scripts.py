from brownie import (
    accounts,
    config,
    network,
    Contract,
)

FORKED_LOCAL_ENV = ["mainnet-fork", "mainnet-fork-dev"]
LOCAL_BLOCKCHIANS_ENV = ["development", "ganache-local"]
DECIMALS = 8
STARTING_PRICE = 2000000000000000000000


def get_account(index=None, id=None):
    if index:
        return accounts[index]
    if id:
        return accounts.load(id)
    if (
        network.show_active() in LOCAL_BLOCKCHIANS_ENV
        or network.show_active() in FORKED_LOCAL_ENV
    ):
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])


# def deploy_mocks():
#     print(f"The active network is {network.show_active()}")
#     print("Deploying mocks")
#     account = get_account()
#     # MockV3Aggregator.deploy(DECIMALS, STARTING_PRICE, {"from": account})
#     # print("MockV3Agg... Deployed")
#     # print("Deploying Mock Dai")
#     coin_token = CoinToken.deploy({"from": account})
#     (f"Mock coin deployed to {coin_token.address}")

#     # print("Deploying Mock Weth")
#     # weth_token = MockWeth.deploy({"from": account})
#     # print(f"Mock weth deployed to {weth_token.address}")
