from brownie import accounts, Dicegame

# running on my kovan testnet
def dicegame():
    account = accounts[0]
    dicgame = Dicegame.deploy({"from": account})
    Isbetset = Dicegame.isbetset()
    Getnewbet = Dicegame.getnewbet()
    Roll = Dicegame.roll()

    print(Roll)


def main():
    dicegame
