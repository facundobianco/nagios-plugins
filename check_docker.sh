#!/bin/bash

help()
{
    echo -e "Nagios plugin for how much docker instances are stoped/exited/dead or if one instance is running\n"
    echo -e "Check not running instances:\tcheck_docker.sh -w 3 -c 6"
    echo -e "Check if instance is running:\tcheck_docker.sh -C <NAME>"
    exit 0
}

[ -z "$1" ] && help

while true
do
    case ${1} in
        -w|--warning) shift ; WARN="$1" ;;
	-c|--critical) shift ; CRIT="$1" ;;
        -C|--container) shift ; CONT="$1" ;;
        -h|--help) help ;;
	"") break ;;
	*) echo "Invalid option: '$1'" ; exit 1 ;;
    esac
    shift
done

if [ -n "$CONT" ]
then
    if docker ps --format "{{ .Names }}" | grep ${CONT}
    then
        echo "Container is runnning"
	exit 0
    else
        docker inspect --format="Paused: {{ .State.Paused }}, Dead: {{ .State.Dead }}, Exit code: {{ .State.ExitCode }}" ${CONT}
	exit 2
    fi
else
    CNTS=`docker ps -aq -f status=paused -f status=exited -f status=dead | wc -l`
    echo "There are $CNTS not runnig container(s)"
    if [ "$CNTS" -ge "$WARN" ] && [ "$CNTS" -lt "$CRIT" ]
    then
	exit 1
    elif [ "$CNTS" -ge "$CRIT" ]
    then
        exit 2
    fi
    exit 0
fi
