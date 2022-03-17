#! /usr/local/bin/gnuplot -persist
set terminal png
set output "sigma_workdir.png" 
set title "sigma vs iwdir; dakota_mycal.in.moga.2 "
set pointsize 1
set yrange [0:0.036458]
plot "data.dat" using 1:2 with points notitle, "minsigmavswdir.dat" using 1:2 with points pointtype 16 t "Min(sigma): (16954,0.018229)"
