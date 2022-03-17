#! /bin/bash

rm -rf data.dat
numbers=$(ls -d */ | grep workdir. | awk -F"." '{print $2}' | awk -F "/" '{print $1}' | sort -n)
for i in $numbers
	do 
		cd workdir.$i
		echo $i $(cat results.out) >> ../data.dat
		cd ../
	done

chmod +x gplotp.sh
./gplotp.sh
