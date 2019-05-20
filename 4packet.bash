#!/bin/bash

AFL_PATH="."
VERSION=$1
PACKET=$2
PROG_PATH="$AFL_PATH/testcases/openssl$VERSION"
BIN="$PROG_PATH/openssl$VERSION"
INDIR="$PROG_PATH/in/p$PACKET"
OUTDIR="$PROG_PATH/out/p$PACKET"

function usage
{
echo "Usage of this testing script:"
echo "---sudo ./4packet.bash OPENSSL_Version PACKETID"
}

if [ $# -ne 2 ]
then
usage
exit -1
fi

$AFL_PATH/afl-fuzz -i $INDIR -o $OUTDIR -m none -t 400 $BIN $PACKET @@
