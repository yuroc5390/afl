#!/bin/bash
USR=`logname`
AFL_PATH="./"
PROG_PATH="$AFL_PATH/testcases/openssl"
NTHREAD=$2

# usage

function usage
{
echo "Usage of this testing script:"
echo "---sudo ./auto.bash PACKET_SEQ_Number Number_of_Threads"
echo "---currently only support:"
echo "------Number_of_Threads: int from 1 to N, don't be greedy and leave some cores for others"
}

# check arg format

if [ $# -ne 2 ] || [ $1 -lt 1 ] || [ $2 -lt 1]
then
echo "invalid arguments, check usage below:"
usage
exit -1
fi

# check if the output dir is empty or not


function clearDir
{
path=$1
if [ ! -d "$path" ]
then
mkdir -p "$path" -m 777
else
rm -rf $path/*
fi
}


function createDir
{
path=$1
if [ ! -d "$path" ]
then
mkdir -p "$path" -m 777
fi
}


# always start from p1
for (( i=0;i<$NTHREAD;i++ ))
do
sub_out_dir=fuzzer"$i"
if [ $i -eq 0 ]
then
$AFL_PATH/experimental/asan_cgroups/limit_memory.sh -u $USR $AFL_PATH/afl-fuzz  -i $PROG_PATH/in/  -o $PROG_PATH/out -M $sub_out_dir -m none -t 400 -f $PROG_PATH/input $PROG_PATH/openssl 
else
$AFL_PATH/experimental/asan_cgroups/limit_memory.sh -u $USR $AFL_PATH/afl-fuzz  -i $PROG_PATH/in/ -o $PROG_PATH/out -S $sub_out_dir -m none -t 400 -f $PROG_PATH/input $PROG_PATH/openssl > /dev/null 2>&1 &
fi
done
