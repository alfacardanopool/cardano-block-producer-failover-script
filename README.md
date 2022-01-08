# Cardano Block Producer Failover Script
Script for activating failover for cardano block producer

Simple script to be run on Relay nodes every minute, it needs Andrew Westberg's cncli ping (https://github.com/AndrewWestberg/cncli) command to check main block producer status.

It sends telegram notifications to SPO if there is a problem and the failover become enabled or disabled.

IMPORTANT REMINDER:
NEVER HAVE MORE THAN ONE BLOCK PRODUCER WORKING (VALIDATING TXs WITH INCOMING CONNECTIONS) AT THE SAME TIME.


