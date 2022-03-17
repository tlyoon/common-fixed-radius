#! /bin/bash
# script works in the presence of many hybrid* directories, and compare_result_wrapper_v2.sh
# script to auto execute compare_result_wrapper_v2.sh in each listed directories

for path in hybrid2rr22_in_br hybrid2rr23_in_br hybrid2rr25_in_br hybrid2rr26_in_br hybrid2rr27_in_br
do
	path=$(echo $path | sed 's/\// /g')
	cd $path
	cp ../compare_result_wrapper_v2.sh .
	nohup ./compare_result_wrapper_v2.sh &
	cd ../
	mv $path $path'_beingrun'
done
