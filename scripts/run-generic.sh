#!/bin/bash

#
# Simple Script for running all benchmarks in the Renaissance Suite
# with all selected core configurations in the big.LITTLE arch.

#
# Benchmarks configuration
BENCHMARKS="$1"

OUTFORMAT="--csv"
POLICY="-r 5" #fixed iterations, where we consider 2 warmups/3 executions
JAR="jar/renaissance-0.9.0.jar"

#
# System configuration
CONFIGURATIONS="0xff 0xf0 0x0f 0x69 0x60 0x09"
CPUGOVERNOR="performance"
BINDER="taskset"
TIMEOUT="timeout 120m"

#
# VM Configuration
JAVA_HOME="/home/odroid/apps/java/" # oracle java 8
JAVA="${JAVA_HOME}/bin/java" # oracle java 8-802
JAVA="/usr/bin/java" #openJDK 11.0.3

#
# OUTPUT CONFIGS
LOGDIR="logs-${1}"


function buildName {
    rawinput="$1"
    name=""
    for value in $rawinput; do
        re='^[0-9]+$'
        if ! [[ $value =~ $re ]] ; then
            echo "error: Not a number" > /dev/null
        else
            name=$( echo "${name}-${value}")
        fi
    done
    echo $name
}

function setGovernor {
    sudo cpufreq-set -g $CPUGOVERNOR -c 0-3
    sudo cpufreq-set -g $CPUGOVERNOR -c 4-7
}

function run {
    setGovernor
    mkdir -p $LOGDIR
    pkill -9 java
    pkill -9 java

    for config in $CONFIGURATIONS; do
        for benchmark in $BENCHMARKS; do
            while read input; do
                output="${LOGDIR}/${benchmark}-${config}"
                parsedinput=$( buildName "$input" )
                command="$TIMEOUT $BINDER $config $JAVA -jar $JAR $benchmark $input $OUTFORMAT ${output}-${parsedinput}.csv $POLICY >> ${output}.txt 2>&1"

                echo "Iteration started at $(date)"
                echo "  command: $command"
                eval $command
                echo "Iteration finished at $(date)"

                #
                # remove generated files
                if [ -f "target" ]; then
                    rm -r target
                    rm -r tmp-*
                fi
            done <inputs/${benchmark}.txt
        done
    done
}



run
