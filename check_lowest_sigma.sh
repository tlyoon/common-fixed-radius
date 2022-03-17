#! /bin/bash

## This is a rewritten script to double check compare_result_wrapper.sh

## Execute this script in the presence of dakota_mycal.out and a host of workdir.*/
## This code will work irrespective of whether dakota_mycal.out is completed or otherwise. It will not abstract the lowest sigma from dakota_mycal.out but obtain it from workdir.*/. 
# lowest_sigma_workdir.dat contains the output of lowest sigma and its corresponding workdir.*/
## Check the file data.dat to see if column 2 (sigma from workdir.*/) and column 3 (sigma from dakota_mycal.out) are tallied to each other. They should. 
## a plot in terms of sigma vs workdir will be produced as sigma_workdir.png.
## The lowest sigma and its correspoingding workdir will also be exported into the file lowest_sigma_workdir.dat

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
rm -rf temp.dat
sort -t, -nk1 temp2.dat > temp3.dat
rm -rf temp2.dat
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

# abstracting lowest sigma and lowestworkdir from data.dat
lowestsigma=$(cat data.dat | awk '{print $2}' > temp; grep -v "nan" temp > filename2; grep -v "inf" filename2 > temp; cat temp |  sort -te -k2,2n -k1,1n  | uniq | awk 'NR== 1 {print}')

lowestworkdir=$(cat data.dat | awk -v lowestsigma=$lowestsigma '$2==lowestsigma {print $1}'); echo 'lowestworkdir:' $lowestworkdir
echo '$lowestsigma' $lowestsigma > templ1.dat
echo '$lowestworkdir' $lowestworkdir >> templ2.dat
#paste temp3.dat checksigmatally2.dat checksigmatally1.dat  | pr -t -e24 > data.data
paste templ1.dat templ2.dat | pr -t -e24 > lowest_sigma_workdir.dat

# end abstracting lowest sigma and lowestworkdir from data.dat

# prepare initial data required for gnuplot

# prepare minsigmavswdir.dat for gnuplot 
rm -rf minsigmavswdir.dat
for i in $lowestworkdir
	do
	echo $i $lowestsigma >> minsigmavswdir.dat
	done
# end prepare minsigmavswdir.dat for gnuplot 
rm -rf sigma_workdir.pdf sigma_workdir.png
gnuplot=$(which gnuplot)
infile=$(cat dakota_mycal.out | awk '/Begin DAKOTA input file/ {print NR+1}' > s1; cat dakota_mycal.out | awk -v s1="$(cat s1)" 'NR==s1 {print}'; rm s1)
ymax=$(echo "$lowestsigma" | awk '{print $1*2}')
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
echo 'state' $state
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

# merge plot from plt.1 and gplot.sh
convert +append *.png out.png; 
rm sigma_workdirf.png
mv out.png sigma_workdir.png
rm plt.1 
# end merge plot from plt.1 and gplot.sh

## call check_objfn_v3.sh to extract the coordinates from workdir.*/ corresponds to $lowestworkdir
./check_objfn_v3.sh
