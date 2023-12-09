#!/bin/bash

MOREINDEX=1
# Prompt for more governance actions
gov_action_prompt() {
        echo -e "\nDo you want to vote on another governance action? (yes/no): "
        read next_action_prompt
        case $next_action_prompt in      
          yes)
               MOREINDEX=$((MOREINDEX+1))
               building_action_vote                  
          ;;
          no)
  
          ;;
          *)
             echo "Invalid option."
             sleep 1 # Add a small delay to allow reading of "Invalid option" before restarting the function
             gov_action_prompt
          ;;
        esac    
}       

building_action_vote() {
    echo "What is the governance action ID?"
    read GOVID
    sleep 0.5
    echo "What is its highest index number?"
    read INDEXNO
    sleep 0.5
    echo "What is your Vote? yes,no,abstain?"
    read VOTE
    echo "------------------------------------------"
    echo "              Creating Vote"
    echo "------------------------------------------"
    sleep 0.5
    
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
                    --out-file action-votes/action${MOREINDEX}-${INDEXNO}.vote
                echo " --vote-file action-votes/action${MOREINDEX}-${INDEXNO}.vote" >> action-votes/txvar.txt
                echo -ne "\rPreparing vote number ${INDEXNO} of action ${MOREINDEX}   "
                sleep 0.2
                INDEXNO=$((INDEXNO-1))
            else
                    cardano-cli conway governance vote create \
                    --${VOTE} \
                    --governance-action-tx-id "${GOVID}" \
                    --governance-action-index "${INDEXNO}" \
                    --drep-verification-key-file drep.vkey \
                    --out-file action-votes/action${MOREINDEX}-${INDEXNO}.vote
                    echo -ne "\rPreparing vote number ${INDEXNO} of action ${MOREINDEX}   "
                    echo " --vote-file action-votes/action${MOREINDEX}-${INDEXNO}.vote" >> action-votes/txvar.txt
                    sleep 1
                    gov_action_prompt
                    break  
            fi
    done
}

building_action_vote           
echo "------------------------------------------"
echo "           Building Transaction"
echo "------------------------------------------"
sleep 0.5

        #build the Transaction
        cardano-cli conway transaction build \
        --testnet-magic 4 \
        --tx-in "$(cardano-cli query utxo --address $(cat payment.addr) --testnet-magic 4 --out-file /dev/stdout | jq -r 'keys[0]')" \
        --change-address $(cat payment.addr) \
        $(cat action-votes/txvar.txt) \
        --witness-override 2 \
        --out-file vote-tx.raw
        
# Remove the action index options file        
rm action-votes/txvar.txt
  
echo "           Signing Transaction"
echo "------------------------------------------"
sleep 0.5

        #Sign the transaction
        cardano-cli transaction sign --tx-body-file vote-tx.raw \
        --signing-key-file drep.skey \
        --signing-key-file payment.skey \
        --testnet-magic 4 \
        --out-file vote-tx.signed

echo "      Submiting Transaction On-Chain"
echo "------------------------------------------"
sleep 0.5

        #Submit the Transaction
        cardano-cli transaction submit \
        --testnet-magic 4 \
        --tx-file vote-tx.signed

echo "Vote complete on ${GOVID}"
