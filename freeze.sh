#!/bin/bash
# Freeze Process
# Sends SIGSTOP or SIGCONT depending on the process's state
# https://major.io/2009/06/15/two-great-signals-sigstop-and-sigcont/
# http://unlicense.org/UNLICENSE do whatever with it
# Usage: freeze <PROCESS NAME>

if [ $# != 1 ]; then
	echo "$0: error: process name missing"
	echo "$0: usage: $0 <PROCESS NAME>"
	exit
fi

PIDS="$(pgrep -i $1)"
echo $PIDS
SIG="$(ps ax -o s,comm | grep $1 | head -n1 | awk '{ print $1 }')"

if [ "$SIG" == "S" ]; then
	echo $0: $1 state: running
	echo $0: sending SIGSTOP
	for PID in $PIDS
	do
		kill -s 19 $PID
	done
	notify-send "$0:" "$1 STOP"
elif [ "$SIG" == "T" ]; then
	echo $0: $1 state: stopped
	echo $0: sending SIGCONT
	for PID in $PIDS
	do
		kill -s 18 $PID
	done
	notify-send "$0:" "$1 CONT"
fi
