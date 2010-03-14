#!/bin/sh

if [ $# -lt 1 ]; then
  echo 'Usage fixcase.sh <case-name>'
  exit 1
fi

CaseName=$1

cd test-${CaseName}

cp ../base/testpkg.yaml .
specify -N -o output.spec testpkg.yaml 1>output.1.o 2>output.2.o
mv output.spec output.spec.o
patch < input.p
specify -N -o output.spec testpkg.yaml 1>output.1 2>output.2

diff output.spec.o output.spec > output.p
if [ $? != 0 ]; then
  echo 'Output diff:'
  cat output.p
else
  rm -f output.p
fi
diff output.1.o output.1 > output.1p
if [ $? != 0 ]; then
  echo 'Stdout diff:'
  cat output.1p
else
  rm -f output.1p
fi
diff output.2.o output.2 > output.2p
if [ $? != 0 ]; then
  echo 'Stderr diff:'
  cat output.2p
else
  rm -f output.2p
fi

mkdir tmp-files
mv *.yaml *.spec *.[12o] tmp-files
