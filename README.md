# cardano-failover-script
Script for activating failover for cardano block producer

Simple script to be run on Relay nodes every minute, it needs Andrew Westberg's cncli --ping command to check main block producer status.

It sends telegram notifications to SPO if there is a problem and the failover become enabled or disabled.


