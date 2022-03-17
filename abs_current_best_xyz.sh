## Execute this in presence of abs_current_best_xyz.sh to generate *.png files and summary.dat based on the current best configuration found in dakota_mycal.out (which may or may not complete). The output files from this scripts in output/ will be the same as that generated with compare_result_wrapper.sh. So, be careful not to confused between these two. abs_current_best_xyz_wrapper.sh is meant to monitor the temporay results in dakota_mycal.out on-the-fly while the final answer should be monitored using compare_result_wrapper.sh after dakota_mycal.out is completed.

#! /bin/bash

rm -rf minsigmavswdir.dat; ./monitor_workdir.sh

noparam=$(cat dakota_mycal.out | grep continuous_design | awk -F"=" '{print $2}' | xargs)
echo noparam $noparam

ifn=$(cat minsigmavswdir.dat | awk 'END {print $1}')
echo 'ifn:' $ifn

nrbgn=$(cat dakota_mycal.out | awk '/Parameters for evaluation/ {print NR}' | awk -v ifn=$ifn 'NR==ifn')
echo 'nrbgn:' $nrbgn
paramlist=$(cat dakota_mycal.out | awk -v nrbgn="$nrbgn" -v noparam=$noparam 'NR>=nrbgn+1 && NR<=nrbgn+noparam')
noatom=$(echo $noparam | awk '{print $1/3}')
echo noatom $noatom
energy=$(cat dakota_mycal.out | awk -v nrbgn="$nrbgn" -v noparam=$noparam ' NR>=nrbgn+noparam && NR<=nrbgn+noparam+12' | grep obj_fn | awk -F" " '{print $1}')
echo energy $energy

fn=current_best.xyz
echo $noatom > $fn
echo 'energy:' $energy >> $fn
symbol='C'

lbegin=$(( $nrbgn + 1 ))
lend=$(( $nrbgn + $noparam ))

for (( i=1; i <= $noatom; i++ ))
do
  lbx=$(echo $lbegin $i | awk '{print $1 + 3*($2 -1)} ')
  x=$(cat dakota_mycal.out | awk -v lbx=$lbx 'NR==lbx {print $1}')
  lby=$(( $lbx + 1 )); 
  y=$(cat dakota_mycal.out | awk -v lby=$lby 'NR==lby {print $1}')
  lbz=$(( $lbx + 2 )); 
  z=$(cat dakota_mycal.out | awk -v lbz=$lbz 'NR==lbz {print $1}')
  echo $symbol $x $y $z >> $fn
done
cat $fn

cp $fn dakota_output.xyz

python compare_result.py

mv $fn output/
