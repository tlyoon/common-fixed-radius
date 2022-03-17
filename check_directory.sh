#! /bin/bash
# script to check directory to see if the run is completed or broken

path=hybrid7
#TEMPLATES_0824152627/hybrid76
#TEMPLATES_0113051418/hybrid76
#TEMPLATES_0112124842/hybrid7
#TEMPLATES_01121142943/hybrid76
#TEMPLATES_0824152515/hybrid7
#TEMPLATES_0113054927_co_br/hybrid76




nofdir=$(ls $path | awk 'END {print NR}')
if [ $nofdir -gt 1000 ]
then
        echo the path $path is correct because '$nofiir'=$nofdir
        linkstatus=$(file $path/workdir.1000/experimental.dat | grep broken)
        if [ -z $linkstatus ]
        then
                echo 'no broken link' $linkstatus
				lnstatus='nb'
        else
                echo 'broken link:' $linkstatus
				lnstatus='br'
        fi
fi

if [ $nofdir -gt 1000 ]
then
	wc=$(tail $path/dakota_mycal.out | grep 'wall clock')
	if [ -z "$wc" ]
        then
                echo 'dakota_mycal.out is not completed'
		wcstatus='in'
        else
                echo 'dakota_mycal.out has been completed with' $wc
		wcstatus='co'
        fi
	echo The status of $path is $path'_'$wcstatus'_'$lnstatus
fi


if [ $nofdir -le 1000 ]
then
        echo the path $path is not correct because '$nofiir'=$nofdir
else 
	mv $path  $path'_'$wcstatus'_'$lnstatus
	
fi
