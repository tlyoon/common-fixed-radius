#! /usr/bin/gnuplot -persist

###### 2
reset
reset session 
set terminal png
set output "si_vs_sigma.png"
set title "si vs sigma"
yrangemax=0.24
xrangemax=16 #0.20
set pointsize 1
#set yrange [0.0:0.24]
set xrange [0.0:16]
set yrange [0.0:0.24]
plot "sortedworkdirsigma_si.dat" using 2:3 with points t "si vs sigma" 	


###### 1
reset
reset session 
set terminal png #what you want to save
set output "sigma_vs_iwdir.png"
set title "sigma vs iwdir"
#yrangemax=0.24
#xrangemax=0.2
set pointsize 1
#set yrange [0.0:"$yrangemax"]
#set xrange [0:0.2]
#set xrange [0:"$xrangemax"]
plot "sortedworkdirsigma_si.dat" using 1:2 with points t "sigma vs iwdir"	


###### third png
reset
reset session
set terminal png
set output "si_vs_iwdir.png"
set title "si vs iwdir"
yrangemax=0.24
#xrangemax=0.2
set pointsize 1
set yrange [0.0:0.24]
#set xrange [0:0.2]
#set xrange [0:"$xrangemax"]
plot "sortedworkdirsigma_si.dat" using 1:3 with points t "si vs iwdir"	 




