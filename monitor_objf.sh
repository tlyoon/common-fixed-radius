#! /bin/bash

### Execute this file in the presence of dakota_mycal.out. The output is monitor_objf.dat containing sorted values of smallest obj_fn values.

noa=$(cat workdir.1/bk7s2.k | awk 'NR==2 {print}') 

fn=monitor_objf.dat
rm -rf $fn 

nobjf=$(cat dakota_mycal.out | grep obj_fn | awk 'END {print NR}')
cat dakota_mycal.out | grep obj_fn | awk '{print $1}' > temp;
grep -v ":" temp > filename2; mv filename2 temp

echo 'Total number of function evaluations in dakota_mycal.out is' $nobjf > $fn
echo 'Full record of all of obj_fn abstracted from dakota_mycal.out' >> $fn
count=0
for i in $(cat temp)
	do
        count=$(( $count + 1 ))
	echo $count $i >> $fn
	done

rm -rf monitor_objf_sorted.dat temp

ilast=10
echo The following is the list of $ilast smallest distinct obj_fns \(and the indices of corresponding LLS\) based on a dakota_mycal.out file when it contains $nobjf evaluated functions: >> monitor_objf_sorted.dat

#firstfew=$(cat dakota_mycal.out | grep obj_fn | awk '{print $1}' |  sort -te -k2,2n -k1,1n  | uniq | awk -v ilast=$ilast 'NR<=ilast {print}')

firstfew=$(cat dakota_mycal.out | grep obj_fn | awk '{print $1}' > temp;grep -v ":" temp > filename2; mv filename2 temp; cat temp |  sort -te -k2,2n -k1,1n  | uniq | awk -v ilast=$ilast 'NR<=ilast {print}')


array=($firstfew)
rm -rf nr.dat
hi=0
for c in "${array[@]}"
do
  hi=$(( $hi + 1 ))
  #echo c= $c
  nr=($(cat dakota_mycal.out | awk -v last="$c" '$1==last {print NR-2}'))
#  echo "${nr[@]}" >> nr.dat
#  echo ' ' >> nr.dat
  count=0
  for i in "${nr[@]}"
    do
	count=$(( $count + 1 ))
	if [ "$count" -le 10 ]; then
		index=$(cat dakota_mycal.out | awk -v nr=$i 'NR==nr {print}')
		ifn=$(echo $index | awk -F " " '{print $NF}' | awk -F ":" '{print $1}')
		#echo 'ifn' $ifn
		re='^[0-9]+$'
		if [[ $ifn =~ $re ]] ; then
					#echo "error: Not a number" >&2; exit 1
					state='Parameters for evaluation '"$ifn"':'
#					echo $hi $count $ifn $c $state # $nrbgn $nrend
					echo $hi $count $ifn $c $state >> monitor_objf_sorted.dat
		fi
	fi
	done
done

