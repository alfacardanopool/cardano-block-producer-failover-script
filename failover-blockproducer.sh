#!/bin/bash
# Once set and tested create cron
# * * * * * /root/scripts/failover-blockproducer.sh
# Are we blocking traffic to FAILOVER Block Producer? In other words, we ARE NOT in failover mode
isblocking=`/usr/sbin/iptables --list OUTPUT --numeric | grep REJECT | grep 6001 | wc -l`
error=`/usr/local/bin/cncli ping --host <<MAIN-BLOCK-PRODUCER-IP>> --port <<MAIN-BLOCK-PRODUCER-PORT>> | jq .status | grep error | wc -l`

if [[ $error -eq 1 ]]
then
  echo "MAIN BLOCK PRODUCER ERROR"
  sleep 10
  if [[ $isblocking -eq 1 ]]
  then
        echo "$(date): Enter FAILOVER mode..."
        # WE REMOVE remove the BACKUP BLOCK PRODUCER BLOCKING - WE ALLOW OUTGOING TRAFFIC FROM RELAY NODE TO FAILOVER BLOCK PRODUCER
        /usr/sbin/iptables --delete OUTPUT -p tcp --dport <<FAILOVER-BLOCK-PRODUCER-PORT>> --jump REJECT 2> /dev/null
        
        #REBOOT CNCLI-SENDTIP TO ATTACK FAILOVER BLOCK PRODUCER.
        /usr/bin/systemctl stop cncli-sendtip.service
        cp /root/scripts/pooltool.json.backupbp /root/scripts/pooltool.json
        /usr/bin/systemctl start cncli-sendtip.service

        #WE SEND NOTIFICATION TO TELEGRAM ALERT CHANNEL
        /usr/bin/curl -X POST -H 'Content-Type: application/json' -d '{"chat_id": "-<<CHANNEL-ID>>", "text": "[ALERT] FAILOVER BLOCK PRODUCER STATUS ENABLED - MAIN BLOCK PRODUCER NOT AVAILABLE OR SYNCED", "disable_notification": true> https://api.telegram.org/<<BOTID>>:<<SECRET>>/sendMessage
   fi
  exit 0
fi

if [[ $error -eq 0 ]]
then
  echo "MAIN BP RESPONDING AND SYNCED. ARE WE BLOCKING TRAFFIC TO FAILOVER BLOCK PRODUCER?"
  if [[ $isblocking -eq 0 ]]
  then
  # we're not blocking local traffic, but we SHOULD be. Turn on the blocks
  echo "$(date): Return to NORMAL mode..."

  #WE BLOCK TRAFFIC TO FAILOVER BLOCK PRODUCER
  /usr/sbin/iptables --insert OUTPUT -p tcp --dport <<FAILOVER-BLOCK-PRODUCER-PORT>> --jump REJECT 2> /dev/null

  #WE SEND NOTIFICATION TO TELEGRAM ALERT CHANNEL
  /usr/bin/curl -X POST -H 'Content-Type: application/json' -d '{"chat_id": "-<<CHANNEL-ID>>", "text": "[OK] FAILOVER BLOCK PRODUCER STATUS DISABLED - MAIN BLOCK PRODUCER AND NORMAL MODE ENABLED.", "disable_notification": true>  https://api.telegram.org/<<BOTID>>:<<SECRET>>/sendMessage
  
  #REBOOT CNCLI-SENDTIP TO ATTACK MAIN BLOCK PRODUCER.
  /usr/bin/systemctl stop cncli-sendtip.service
  cp /root/scripts/pooltool.json.bp /root/scripts/pooltool.json
  /usr/bin/systemctl start cncli-sendtip.service
  fi
 exit 0
fi
