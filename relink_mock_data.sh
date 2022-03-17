#! /bin/bash

## run this script in output/ in the presence of samples/ to automatically remove all nwl* directories except the one being in use


nwldir=$(ls -la config.dat | awk -F'/' '{print $2}')
cp -r samples/$nwldir .
unlink samples
mkdir  samples
mv $nwldir samples/
rm -rf $nwldir

