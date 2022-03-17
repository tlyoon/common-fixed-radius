#! /bin/bash

noparam=$(cat dakota_mycal.out | grep continuous_design | awk '{print $3}')
noatom=$(( $noparam / 3))
echo $noatom > dakota_output.xyz
lnobof=$(cat dakota_mycal.out | awk '/Best objective function/ {print NR+1}' | awk 'END {print $NF}')
lowestenergy=$(cat dakota_mycal.out | awk -v lnobof=$lnobof 'NR==lnobof {print}' | xargs)
echo ''
echo 'lowestenergy:' $lowestenergy >> dakota_output.xyz
symbol='C'

#lbegin=$(cat dakota_mycal.out | awk '/Best parameters/ {print NR+1}')
lbegin=$(cat dakota_mycal.out | awk '/Best parameters/ {print NR+1}' | awk 'END {print}')
lend=$(( $lnobof -2 ))
#echo '$lbegin $lend' $lbegin $lend

for (( i=1; i <= $noatom; i++ ))
do
  lbx=$(echo $lbegin $i | awk '{print $1 + 3*($2 -1)} ')
  x=$(cat dakota_mycal.out | awk -v lbx=$lbx 'NR==lbx {print $1}')
  lby=$(( $lbx + 1 )); 
  y=$(cat dakota_mycal.out | awk -v lby=$lby 'NR==lby {print $1}')
  lbz=$(( $lbx + 2 )); 
  z=$(cat dakota_mycal.out | awk -v lbz=$lbz 'NR==lbz {print $1}')
  echo $symbol $x $y $z >> dakota_output.xyz
done
echo 'best parameters are extracted into dakota_output.xyz'
echo ''
cat dakota_output.xyz
