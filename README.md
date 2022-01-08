# Cardano Block Producer Failover Script
Script for activating failover for cardano block producer

Prerequisites:

1) Set a failover block producer and connect it to your relay nodes. In my case I have configured it with a different port, so I can easily block outgoing traffic to that port, only affecting failover block producer.
2) Set the relay nodes to connect both block producers. (and block outgoing traffic to failover block producer by default with iptables)
3) If you dont't have cncli-sendtip running on your relay, you can comment that lines. I have 2 different pooltool.json files (one per block producer)
4) Telegram alerting is optional too, but recommended.

Simple script to be run on Relay nodes every minute, it needs Andrew Westberg's cncli ping (https://github.com/AndrewWestberg/cncli) command to check main block producer status.

It sends telegram notifications to SPO if there is a problem and the failover become enabled or disabled.

IMPORTANT REMINDER:
NEVER HAVE MORE THAN ONE BLOCK PRODUCER WORKING (VALIDATING TXs WITH INCOMING CONNECTIONS) AT THE SAME TIME.


