#! /usr/local/bin/gnuplot -persist


###### 0
set terminal png
set output "si_vs_sigma_z.png"
set title "si vs sigma"
set pointsize 1
set xrange [0.0:0.01]
#set yrange [0.0:0.24]
plot "sortedworkdirsigma_si.dat" using 2:3 with points t "si vs sigma"

###### 1
reset
set terminal png
set output "si_vs_sigma.png"
set title "si vs sigma"
set pointsize 1

#set yrange [0.0:0.24]
plot "sortedworkdirsigma_si.dat" using 2:3 with points t "si vs sigma" 	


###### 2
reset
set terminal png 
set output "sigma_vs_iwdir.png"
set title "sigma vs iwdir"
set pointsize 1
plot "sortedworkdirsigma_si.dat" using 1:2 with points t "sigma vs iwdir"	


###### 3
reset
set terminal png
set output "si_vs_iwdir.png"
set title "si vs iwdir"
set pointsize 1
plot "sortedworkdirsigma_si.dat" using 1:3 with points t "si vs iwdir"	 




