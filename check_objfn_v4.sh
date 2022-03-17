#! /bin/bash

# extract the coordinates from workdir.*/ corresponds to $lowestworkdir
# require the presence of dakota_mycal.out, workdir.*/ directories, ortedworkdirsigma.dat.

noparam=$(cat dakota_mycal.out | grep continuous_design | awk '{print $3}' | grep -v "#" | awk 'END {print }')
#echo noparam= $noparam 
noatom=$(echo $noparam | awk '{print $1/3}')
#echo noatom $noatom
echo $noatom > dakota_output.xyz
lowestworkdir=$(cat sortedworkdirsigma.dat | awk -v i=1 'NR==i {print $1}')
lowestenergy=$(cat sortedworkdirsigma.dat | awk -v i=1 'NR==i {print $2}')
echo 'lowestenergy:' $lowestenergy 'lowestworkdir:' $lowestworkdir >> dakota_output.xyz
symbol='C'

for (( c=1; c<=$noatom; c++ ))
do
  line=$(cat 'workdir.'$lowestworkdir'/bk7s2.k' | awk -v c=$c 'NR==2+c {print $1, $2, $3}')
  echo $symbol $line  >> dakota_output.xyz
done
echo ''
#cat dakota_output.xyz
