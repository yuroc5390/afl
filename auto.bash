#!/bin/bash
USR=`logname`
AFL_PATH="./"
VERSION=$1
PROG_PATH="$AFL_PATH/testcases/openssl$VERSION"
BIN="$PROG_PATH/openssl$VERSION"
PACKET=$2
NTHREAD=$3
INDIR="$PROG_PATH/in/p$PACKET"
OUTDIR="$PROG_PATH/out/p$PACKET"


# usage

function usage
{
echo "Usage of this testing script:"
echo "---sudo ./auto.bash OPENSSL_Version PACKET_SEQ_Number Number_of_Threads"
echo "---currently only support:"
echo "------Number_of_Threads: int from 1 to N, don't be greedy and leave some cores for others"
}

# check arg format

if [ $# -ne 3 ] || [ $2 -lt 1 ] || [ $3 -lt 1]
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
$AFL_PATH/experimental/asan_cgroups/limit_memory.sh -u $USR $AFL_PATH/afl-fuzz  -i $INDIR  -o $OUTDIR -M $sub_out_dir -m none -t 400  $BIN $PACKET @@ &
else
$AFL_PATH/experimental/asan_cgroups/limit_memory.sh -u $USR $AFL_PATH/afl-fuzz  -i $INDIR -o $OUTDIR -S $sub_out_dir -m none -t 400  $BIN $PACKET @@ > /dev/null 2>&1 &
fi
done
