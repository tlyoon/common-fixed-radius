#! /bin/bash

cat dakota_mycal.out | awk '/obj_fn/ {print NR, $0}' > temp0; grep -v ":" temp0 > temp1; 

rm -rf monitor_objf2.dat

count=0
for i in $(cat temp1 | awk '{print $1}')
	do 
		nr=$(cat dakota_mycal.out | awk -v i=$i 'NR==i-2 {print i,$0}' | grep -v "approximate" | awk -F" " '{print $1}')
		line=$(cat dakota_mycal.out | awk -v i=$nr 'NR==i{print}' | awk -F" " '{print $1}')
		#echo $nr $line
		if [ ! -z "$nr" ]; then
			count=$(( $count + 1 ))
			echo $count $line $nr  >> monitor_objf2.dat
		fi
	done
rm -rf temp0 temp1 temp2

nobjf=$(tail monitor_objf2.dat | awk 'END {print $1}')
echo Total number of function evaluations in dakota_mycal.out is "$nobjf" > tempp.dat
echo Full record of all of obj_fn abstracted from dakota_mycal.out >> tempp.dat
cat tempp.dat monitor_objf2.dat > temppp; mv temppp monitor_objf2.dat



#### sorted data 
rm -rf monitor_objf_sorted2.dat temp

ilast=10
echo The following is the list of $ilast smallest distinct obj_fns \(and the indices of corresponding LLS\) based on a dakota_mycal.out file when it contains $nobjf evaluated functions: >> monitor_objf_sorted2.dat

firstfew=$( sort -g -k2,2 monitor_objf2.dat | awk 'count=count+1{print count,$2, $3}' |  sort -g -k2,2 monitor_objf2.dat | awk '{print $2}' | uniq | awk -v ilast="$ilast" 'NR<=ilast {print}')

#firstfew=$(cat dakota_mycal.out | grep obj_fn | awk '{print $1}' > temp;grep -v ":" temp > filename2; mv filename2 temp; cat temp |  sort -te -k2,2n -k1,1n  | uniq | awk -v ilast=$ilast 'NR<=ilast {print}')

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
					echo $hi $count $ifn $c $state >> monitor_objf_sorted2.dat
		fi
	fi
	done
done