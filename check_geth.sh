#!/bin/bash

help()
{
    echo "usage: check_geth [-q] -c <listen|miner> -a http://example.com:8545"
    echo ""
    echo "Check GETH status through CURL"
    echo ""
    exit 0
}

[ -z "$1" ] && help

while true
do
    case ${1} in
        -c|--command) shift ; CMMD="$1" ;;
        -a|--address) shift ; ADDR="$1" ;;
	-q|--quiet) QIET=true ;;
        -h|--help) help ;;
        "") break ;;
        *) echo "Invalid option: '$1'" ; exit 1 ;;
    esac
    shift
done

if [ -z "$ADDR" ]
then
    echo "Address is required. Quit."
    exit 1
fi

if [ "$CMMD" == "listen" ]
then
    if  curl -s -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"net_listening","params":[],"id":67}' ${ADDR} | grep -q true
    then
	if [ -z "$QIET" ]
	then
        	echo "Node is listening"
        fi
	exit 0
    else
	if [ -z "$QIET" ]
	then
        	echo "Node returned false"
	fi
        exit 2
    fi
fi

if [ "$CMMD" == "miner" ]
then
    if curl -s -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_mining","params":[],"id":71}' ${ADDR} | grep -q true
    then
	if [ -z "$QIET" ]
	then
        	echo "Geth is mining"
	fi
        exit 0
    else
	if [ -z "$QIET" ]
	then
        	echo "Geth returned false"
       	fi
	exit 2
    fi
fi
