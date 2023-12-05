#!/bin/bash

echo "What is the governance action ID?"
read GOVID
sleep 1
echo "What is its highest index number?"
read INDEXNO
sleep 1
echo "What is your Vote? yes,no,abstain?"
read VOTE
echo "------------------------------------------"
echo "              Creating Vote"
echo "------------------------------------------"
sleep 1
#create the action file directory   
mkdir action-votes 2>/dev/null

#create the vote files
while true; do
        if [ "$INDEXNO" != "0" ]; then
                cardano-cli conway governance vote create \
                --${VOTE} \
                --governance-action-tx-id "${GOVID}" \
                --governance-action-index "${INDEXNO}" \
                --drep-verification-key-file drep.vkey \

                --out-file action-votes/action${INDEXNO}.vote
                sleep 1
            echo " --vote-file action-votes/action${INDEXNO}.vote" >> action-votes/txvar.txt
            echo "         Preparing vote number ${INDEXNO}"
            INDEXNO=$((INDEXNO-1))
        else
                cardano-cli conway governance vote create \
                --${VOTE} \
                --governance-action-tx-id "${GOVID}" \
                --governance-action-index "${INDEXNO}" \
                --drep-verification-key-file drep.vkey \
                --out-file action-votes/action${INDEXNO}.vote
                sleep 1
                echo "         Preparing vote number ${INDEXNO}"
                echo " --vote-file action-votes/action${INDEXNO}.vote" >> action-votes/txvar.txt
                break #breaking the loop
        fi
done

echo "------------------------------------------"
echo "           Building Transaction"
echo "------------------------------------------"
sleep 1

#build the Transaction

  cardano-cli conway transaction build \
  --testnet-magic 4 \
  --tx-in "$(cardano-cli query utxo --address $(cat payment.addr) --testnet-magic 4 --out-file /dev/stdout | jq -r 'keys[0]')" \
  --change-address $(cat payment.addr) \
  $(cat action-votes/txvar.txt) \
  --witness-override 2 \
  --out-file vote-tx.raw
  rm action-votes/txvar.txt
  
echo "           Signing Transaction"
echo "------------------------------------------"
sleep 1

#Sign the transaction

  cardano-cli transaction sign --tx-body-file vote-tx.raw \
  --signing-key-file drep.skey \
  --signing-key-file payment.skey \
  --testnet-magic 4 \
  --out-file vote-tx.signed

echo "      Submiting Transaction On-Chain"
echo "------------------------------------------"
sleep 1

#Submit the Transaction

cardano-cli transaction submit --testnet-magic 4 --tx-file vote-tx.signed

echo "Vote complete on ${GOVID}"
