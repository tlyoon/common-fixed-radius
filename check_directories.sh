#! /bin/bash
# script to check directory to see if the run is completed or broken


for path in hybrid7 hybrid76
do

nofdir=$(ls $path | awk 'END {print NR}')
if [ $nofdir -gt 1000 ]
then
        echo 'the path' $path 'is correct because $nofiir=' $nofdir
fi

if [ $nofdir -gt 1000 ]
then
	wc=$(tail $path/dakota_mycal.out | grep 'wall clock')
	if [ -z "$wc" ]
        then
                echo 'dakota_mycal.out is not completed'
		no=$(ls $path | awk 'END {print NR}')
		wcstatus='in_'"$no"
        else
                echo 'dakota_mycal.out has been completed with' $wc
		wcstatus='co'
        fi
	echo The status of $path is $path'_'$wcstatus
fi


if [ $nofdir -le 1000 ]
then
        echo 'the path' "$path" 'is not correct because $nofiir = ' $nofdir
	mv $path  $path'_nr'
	echo $path 'is renamed' $path'_nr'
else 
	mv $path  $path'_'$wcstatus
	echo $path 'is renamed' $path'_'$wcstatus
fi
done
