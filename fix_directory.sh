#! /bin/bash

clock=$(tail ../dakota_mycal.out | grep clock)

if [ -z "$clock" ]; then
	cstatus='in'
        #echo 'completion status:' $cstatus
else
        #echo $clock
	cstatus='co'
        #echo 'completion status:' $cstatus
fi

sigma=$(head sortedworkdirsigma.dat | awk 'NR==1 {print $2}')
si=$(printf "%.3f \n" $(cat si.dat))

cp ../run.sh .
cp ../dakota_mycal.* .
sigma=$(head sortedworkdirsigma.dat | awk 'NR==1 {print $2}')
sigma=$(printf "%.6f \n" $sigma)

cd ../
PD=$( echo $PWD | awk -F"/" '{print $NF}')
origdirname=$PD
suffix='_'$(echo $PD | awk -F"_" '{print $NF}')
dirname=$PD'_'$cstatus'_sigma_'$sigma'_si_'$si
dirnamenew=${dirname/$suffix/}
dirnamenew=$(echo $dirnamenew | sed 's/ //g')
cd ../
mv $origdirname $dirnamenew
echo $origdirname has been renamed $dirnamenew
