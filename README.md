# Documentation
## How to download the entire repository

To download all our documents on the CIP-1694, the CLI, as well as our SanchoNet scripts:
```bash
git clone https://github.com/Hornan7/Documentation.git
```
You can now use and share all our all our educational documents.

## (Optional) To download the entire repository and move the SanchoNet scripts in your keys directory:
### Setting the PATH to the keys folder
```bash
export SanchoNet_keys=$HOME/<path_to_your_keys_folder>/
```
### Clone repository and move the script to your keys directory
```bash
git clone https://github.com/Hornan7/Documentation.git
mv Documentation/SanchoNet-Scripts/drep-vote.sh ${SanchoNet_keys}
mv Documentation/SanchoNet-Scripts/cc-vote.sh ${SanchoNet_keys}
sudo chmod 700 ${SanchoNet_keys}/drep-vote.sh ${SanchoNet_keys}/cc-vote.sh
```
### You can now use your SanchoNet scripts from your Keys directory
```bash
cd ${SanchoNet_keys}
```
```bash
./drep-vote.sh
```
```bash
./cc-vote.sh
```
