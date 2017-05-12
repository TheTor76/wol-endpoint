#!/usr/bin/env bash
MAC_ADDR=$1;
wakeonlan -i $WOL_BROADCAST_ADDR $MAC_ADDR;
