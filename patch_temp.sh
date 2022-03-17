##### patch

# execute this script in templatedir/ to update the newly added/modified scripts in template/templatdir/ and template/
cp /home/tlyoon/dakota/dakota-gmt/common_fixed_radius/template/templatedir/convert_XINIB_2_xyz.sh .
cp /home/tlyoon/dakota/dakota-gmt/common_fixed_radius/template/templatedir/wdir_orientate_wrapper.py .
cp /home/tlyoon/dakota/dakota-gmt/common_fixed_radius/template/templatedir/orientate.py .
cp /home/tlyoon/dakota/dakota-gmt/common_fixed_radius/template/templatedir/similarity.py .
cp /home/tlyoon/dakota/dakota-gmt/common_fixed_radius/template/templatedir/gen_sorted_wd_sigma_si.sh .
cp /home/tlyoon/dakota/dakota-gmt/common_fixed_radius/template/gplot_si_vs_sigma.sh .

# correct the wrong version of sortedworkdirsigma.dat
cd output
cat data.dat | awk '$2 != 99999 {print $1, $2}' > data_filtered.dat
cat data_filtered.dat | sort -k2,2g > sortedworkdirsigma.dat 
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

#execute ./gen_sorted_wd_sigma_si.sh from within /templatedir. It will call convert_XINIB_2_xyz.sh and wdir_orientate_wrapper.py in each workdir.* to generate si.dat in each workdir.* to result in a single file kept as sortedworkdirsigma_si.dat in output/
cd ../templatedir
nohup ./gen_sorted_wd_sigma_si.sh &

cd ../output
cp ../gplot_si_vs_sigma.sh .
./gplot_si_vs_sigma.sh