#!/bin/bash

echo "What is the governance action ID?"
read GOVID
sleep 1
echo "What is the index?"
read INDEX
sleep 1
echo "What is your Vote? yes,no,abstain?"
read VOTE
sleep 1

#create the vote file

cardano-cli conway governance vote create \
--${VOTE} \
--governance-action-tx-id "${GOVID}" \
--governance-action-index "${INDEX}" \
--drep-verification-key-file drep.vkey \
--out-file action.vote
sleep 1

#build the Transaction

cardano-cli conway transaction build \
--testnet-magic 4 \
--tx-in "$(cardano-cli query utxo --address $(cat payment.addr) --testnet-magic 4 --out-file /dev/stdout | jq -r 'keys[0]')" \
--change-address $(cat payment.addr) \
--vote-file action.vote \
--witness-override 2 \
--out-file vote-tx.raw
sleep 1

#Sign the transaction

cardano-cli transaction sign --tx-body-file vote-tx.raw \
--signing-key-file drep.skey \
--signing-key-file payment.skey \
--testnet-magic 4 \
--out-file vote-tx.signed
sleep 1

#Submit the Transaction

cardano-cli transaction submit --testnet-magic 4 --tx-file vote-tx.signed

echo "Vote on ${GOVID} complete"
