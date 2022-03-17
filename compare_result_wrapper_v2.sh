#! /bin/bash

## This is a rewritten script to double check compare_result_wrapper.sh

## Execute this script in the presence of dakota_mycal.out and a host of workdir.*/

## This code will work irrespective of whether dakota_mycal.out is completed or otherwise. It will not abstract the lowest sigma from dakota_mycal.out but obtain it from workdir.*/. 


## Check the file data.dat to see if column 2 (sigma from workdir.*/) and column 3 (sigma from dakota_mycal.out) are tallied to each other. They should. 


## a plot in terms of sigma vs workdir will be produced as sigma_workdir.png.

## The lowest sigma and its correspoingding workdir will also be exported into the file sortedworkdirsigma.dat 

## begin 
# Check whether the run has completed or pending
wc=$(tail dakota_mycal.out | awk '/Total wall clock/')
if [ -z "$wc" ]
then
      	echo "\$wc is empty: dakota_mycal.out is NOT completed"
else
      	echo "dakota_mycal.out has completed." $wc
fi
# end of Check whether the run has completed or pending


# Comparison between sigma from workdir.*/ and dakota_mycal.out 

# sigma from dakota_mycal.out
rm -rf  checksigmatally1.dat
nobjf=$(cat dakota_mycal.out | awk '/obj_fn/' | awk 'END {print NR}')
cat dakota_mycal.out | awk '/obj_fn/ {print $1}' | awk '$0==($0+0)' >  checksigmatally1.dat
echo 'Total items containing obj_fn is dakota_mycal.out is' $nobjf
# end sigma from dakota_mycal.out

# sigma from workdir.*/
ls -d * | awk /workdir./ | awk -F'.' '{print $2}' > temp.dat
rm -rf temp2.dat
for i in $(cat temp.dat)
	do
	if ! [[ "$i" =~ ^[0-9]+$ ]]
    		then
	        #echo "non integer item" $i
		zero=0
	else
		echo $i >> temp2.dat
	fi
	done
#rm -rf temp.dat
sort -t, -nk1 temp2.dat > temp3.dat
#rm -rf temp2.dat
nowd=$(tail -1 temp3.dat)
echo 'Total number of workdir is ' "$nowd"

rm -rf checksigmatally2.dat
for i in $(cat temp3.dat)
	do
	dir='workdir.'$i
        echo -e "$(cat "$dir"/results.out)" >> checksigmatally2.dat
		#cat $dir/results.out #>> checksigmatally2.dat
		#echo $i $(cat results.out) >> ../data.dat
	done
# end sigma from workdir.*/

paste temp3.dat checksigmatally2.dat checksigmatally1.dat  | pr -t -e24 > data.dat
#rm -rf  checksigmatally2.dat temp3.dat 
# end of Comparison between sigma from workdir.*/ and dakota_mycal.out 

## begin sortintg sigma and workdir.*/ based on data.dat
##lowestsigma=$(cat data.dat | awk '{print $2}' > temp; grep -v "nan" temp > filename2; grep -v "inf" filename2 > temp; cat temp |  sort -te -k2,2n -k1,1n  | uniq | awk 'NR== 1 {print}')

# sort sigma from data.dat acsendingly into sortedsigma.dat
cat data.dat | awk '{print $2}' > temp; grep -v "nan" temp > filename2; grep -v "inf" filename2 > temp; cat temp |  sort -te -k2,2n -k1,1n  | uniq > sortedsigma.dat; sed -i '/^$/d' sortedsigma.dat

# locate the correponsponding workdir.*/ for the sorted sigma
rm -rf sortedworkdir.dat
for i in $(cat sortedsigma.dat)
	do 
		cat data.dat | awk -v sigma="$i" '$2==sigma {print $1}' >> sortedworkdir.dat
	done
paste sortedworkdir.dat sortedsigma.dat | pr -t -e24 > sortedworkdirsigma.dat

# prepare initial data required for gnuplot
# prepare minsigmavswdir.dat, lowestworkdir and lowestsigma for gnuplot for the first clast lowest sigma and workdir
rm -rf minsigmavswdir.dat
rm -rf lowestworkdir.dat lowestsigma.dat
clast=2
for (( c=1; c<=$clast; c++ ))
do
   cat sortedworkdirsigma.dat | awk -v i=$c 'NR==i' >> minsigmavswdir.dat
   cat sortedworkdirsigma.dat | awk -v i=$c 'NR==i {print $1}' >> lowestworkdir.dat
   cat sortedworkdirsigma.dat | awk -v i=$c 'NR==i {print $2}' >> lowestsigma.dat 
done
lowestworkdir=$(cat lowestworkdir.dat) 
lowestsigma=$(cat lowestsigma.dat)
# end prepare minsigmavswdir.dat, lowestworkdir and lowestsigma for gnuplot for the first 10 lowest sigma and workdir

rm -rf sigma_workdir.pdf sigma_workdir.png gplot.sh
gnuplot=$(which gnuplot)
infile=$(cat dakota_mycal.out | awk '/Begin DAKOTA input file/ {print NR+1}' > s1; cat dakota_mycal.out | awk -v s1="$(cat s1)" 'NR==s1 {print}'; rm s1)
#ymax=$(echo "$lowestsigma" | awk '{print $1*2}')
ymax=$(cat sortedsigma.dat | awk 'NR==1 {print $1*2}')
# end prepare initial data required for gnuplot

# prepare gplot.sh script
#echo 'infile' $infile
echo '#!' $gnuplot '-persist' > gplot.sh
echo 'set terminal png' >> gplot.sh
echo 'set output "sigma_workdir.png" ' >> gplot.sh
#echo 'set terminal pdf' >> gplot.sh
#echo 'set output "sigma_workdir.pdf" ' >> gplot.sh
echo set title '"'sigma vs iwdir';' $infile '"' >> gplot.sh
echo 'set pointsize 1' >> gplot.sh
echo 'set yrange [0:'"$ymax"']' >> gplot.sh
state='plot "data.dat" using 1:2 with points notitle, "minsigmavswdir.dat" using 1:2 with points  pointtype 16 t "Min(sigma): ('"$lowestworkdir"','"$lowestsigma"')"'
echo $state >> gplot.sh
#echo 'plot "data.dat" using 1:2 with points notitle, \
#            "lsgvwd.dat" 'using 1:2 with points pt 28 t' "Min(sigma): \($lowestworkdir, $lowestsigma\) #'"' >> gplot.sh
# end prepare gplot.sh script

# execute gplot.sh
chmod +x gplot.sh; ./gplot.sh
# end execute gplot.sh

#prepare plt.1 and execute script. 
# plt.1 plot zoom-in version of gplot.sh
cat gplot.sh | sed '/pointsize 1/{n;s/.*/set yrange [0:5]/}' | sed '/terminal png/{n;s/.*/set output "sigma_workdirf.png" /}' > plt.1; chmod +x plt.1
./plt.1
#prepare plt.1 and execute script

# merge plot from plt.1 and gplot.sh to produce sigma_workdir.png
convert +append *.png out.png; 
rm sigma_workdirf.png
mv out.png sigma_workdir.png
rm plt.1 
# end merge plot from plt.1 and gplot.sh


#################
#./check_objfn_v4.sh	 ### to extract the coordinates from workdir.*/ corresponds to $lowestworkdir, gives dakota_output.xyz

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
#################

./monitor_objf.sh    ### gives monitor_objf.dat, monitor_objf_sorted.dat
python grep_LLS.py	 ### gives LLS_N_M_NOobj_fn_obj_fn.xyz

rm -rf output
python compare_result.py	#### gives output/gmt.dat, output/sigma.csv

mv monitor_objf.dat monitor_objf_sorted.dat sigma_workdir.* data.dat minsigmavswdir.dat LLS_*.xyz output/
mv sortedworkdirsigma.dat output/
cp dakota_output.xyz output/

for i in amp.out gmm01f_s.par Makefile.s a.out gmm01s bk7s2.k gmm01s.f results.tmp clean.sh gmm01f multiply.f90 gmm01f.f mycal.in.sample trim_exp_data.sh gmm01f.in mycal.sh gmm01f.o mycal.sh.sample XINIB.dat gmm01f.orig mycal.sh.template gmm01f.out Makefile pkill.sh gmm01f.par Makefile.f plt.gmt_mock.norm.py gmm01f_f.par gmm01s.o sample_experimental.dat experimental_trimmed.dat gmt.dat.sample gen_mock_exp.py gen_sigma.py plt.gmt.py
    do     
	    rm -rf output/$i
    done
	
cd output
rm sigma.csv
python visuallize_sigma.py  ### gives /output/dakota_output_ro.xyz, output/config_ro.xyz, sigma.png, sigma.csv, si.dat
rm results.tmp 

#### abstract best-fit common radius
bestradius=$(cat radius.dat)  ### modify this if radius is a varible to be optimized by DAKOTA
echo $bestradius > bestradius.dat
f1=$(cat radius.dat);f2=$(cat bestradius.dat);

### consolidate all output information in output/
summary=summary.dat
touch $summary

echo '1. config.xyz'   >>  $summary
cat config.xyz       >>  $summary
echo ''>>  $summary

echo '2. dakota_output.xyz'   >>  $summary
cat dakota_output.xyz       >>  $summary
echo '' >>  $summary

echo '3. config_ro.xyz'   >>  $summary
cat config_ro.xyz       >>  $summary
echo ''>>  $summary

echo '4. dakota_output_ro.xyz'   >>  $summary
cat dakota_output_ro.xyz       >>  $summary
echo '' >>  $summary

echo '5. similarity index' $(cat si.dat)   >>  $summary
echo >>  $summary

echo '6.   sigma.csv' >>  $summary
cat sigma.csv >>  $summary
echo '' >>  $summary

f1=$(cat radius.dat);f2=$(cat bestradius.dat)
echo '7.   common radius='$f1'; best-fit common radius='$f2  >>  $summary
echo '' >>  $summary

echo '' >>  $summary
echo 'monitor_objf_sorted.dat' >>  $summary
cat monitor_objf_sorted.dat >>  $summary
echo '' >>  $summary

echo '' >>  $summary
echo 'Input parameters' >>  $summary
nrbgn=$(cat dakota_mycal.out | awk ' /Begin DAKOTA input file/ {print NR} ')
nrend=$(cat dakota_mycal.out | awk ' /End DAKOTA input file/ {print NR} ')
cat dakota_mycal.out | awk -v nrbgn=$nrbgn -v nrend=$nrend 'NR>=nrbgn && NR <= nrend {print}' >>  $summary

### end consolidate all output information
#echo 'compare_result_wrapper.sh done. Check your output in output/'

#cp ../dakota_mycal.in.* .
#cp ../run.sh .
#cp ../dakota_mycal.stdout .
#sigma=$(head sigma.csv | grep sigma | awk '{print $4}' | awk -F"=" '{print $2}' | awk -F";" '{print $1}')
#cd ../
#mv output output.sigma_$sigma

clock=$(tail ../dakota_mycal.out | grep clock)

if [ -z "$clock" ]; then
        cstatus='in'
        #echo 'completion status:' $cstatus
else
        #echo $clock
        cstatus='co'
        #echo 'completion status:' $cstatus
fi

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


