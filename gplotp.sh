#! /bin/bash

#lowestsigma=$(cat data.dat | awk '{print $2}' | sort -nr | awk 'END {print}'); echo 'lowestsigma:' $lowestsigma; 

#lowestsigma=$(cat data.dat | awk '{print $2}' > temp;grep -v "nan" temp > filename2; mv filename2 temp; cat temp |  sort -te -k2,2n -k1,1n  | uniq | awk 'NR== 1 {print}')

lowestsigma=$(cat data.dat | awk '{print $2}' > temp; grep -v "nan" temp > filename2; grep -v "inf" filename2 > temp; cat temp |  sort -te -k2,2n -k1,1n  | uniq | awk 'NR== 1 {print}')


lowestworkdir=$(cat data.dat | awk -v lowestsigma=$lowestsigma '$2==lowestsigma {print $1}'); echo 'lowestworkdir:' $lowestworkdir

###
rm -rf minsigmavswdir.dat
for i in $lowestworkdir
	do
	echo $i $lowestsigma >> minsigmavswdir.dat
	done
###

rm -rf sigma_workdir.pdf sigma_workdir.png
gnuplot=$(which gnuplot)

infile=$(cat dakota_mycal.out | awk '/Begin DAKOTA input file/ {print NR+1}' > s1; cat dakota_mycal.out | awk -v s1="$(cat s1)" 'NR==s1 {print}'; rm s1)

ymax=$(echo "$lowestsigma" | awk '{print $1*2}')

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

chmod +x gplot.sh
./gplot.sh

###### 
cat gplot.sh | sed '/pointsize 1/{n;s/.*/set yrange [0:5]/}' | sed '/terminal png/{n;s/.*/set output "sigma_workdirf.png" /}' > plt.1; chmod +x plt.1
./plt.1
convert +append *.png out.png; 
rm sigma_workdirf.png
mv out.png sigma_workdir.png
rm plt.1 

