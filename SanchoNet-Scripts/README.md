# SanchoNet commands and scripts

### To query a specific governance action

```
cardano-cli conway query gov-state --testnet-magic 4 | jq -r '.proposals.psGovActionStates["YOUR_GOVERNANCE_ACTION_WITH_ITS_INDEX"]'
```
Replace *YOUR_GOVERNANCE_ACTION_WITH_ITS_INDEX* with for example: `df58f714c0765f3489afb6909384a16c31d600695be7e86ff9c59cf2e8a48c79#0`

### To Install Drep vote script

From your SanchoNet keys directory:
```
wget https://raw.githubusercontent.com/Hornan7/Documentation/main/SanchoNet-Scripts/drep-vote.sh
sudo chmod 700 drep-vote.sh
```
Then you can run the script using `./drep-vote.sh` command. 
You can see the content of the script [here](https://raw.githubusercontent.com/Hornan7/Documentation/main/SanchoNet-Scripts/drep-vote.sh)
