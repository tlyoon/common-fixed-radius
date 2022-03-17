## This script needs the presence of 
# 1. monitor_objf.sh 
# 2. monitor_workdir.sh
# 3. gplotp.sh
# 4. templatedir/orientate.py          
# 5. templatedir/orientate_wrapper.py
# 6. templatedir/similarity.exe
# 7. templatedir/visuallize_sigma.py

## check_objfn_v2.sh, check_objfn_v2a.sh, check_objfn_v2b.sh, compare_result.py,   dakota_mycal.out, workdir*/ 
## all output from this script will be saved in output/
    rm -rf output
    mkdir output

    ./abs_current_best_xyz.sh	

    python compare_result.py    #### gives output/gmt.dat output/sigma.csv

    mv monitor_objf.dat monitor_objf_sorted.dat sigma_workdir.* data.dat minsigmavswdir.dat LLS_*.xyz output/
	
    for i in amp.out gmm01f_s.par Makefile.s a.out gmm01s bk7s2.k gmm01s.f results.tmp clean.sh gmm01f multiply.f90 gmm01f.f mycal.in.sample trim_exp_data.sh gmm01f.in mycal.sh gmm01f.o mycal.sh.sample XINIB.dat gmm01f.orig mycal.sh.template gmm01f.out Makefile pkill.sh gmm01f.par Makefile.f plt.gmt_mock.norm.py gmm01f_f.par gmm01s.o sample_experimental.dat experimental_trimmed.dat gmt.dat.sample gen_mock_exp.py gen_sigma.py plt.gmt.py
    do     
#            echo output/"$i"
	    rm output/$i
    done

    cd output
    rm sigma.csv
    python visuallize_sigma.py  ### gives /output/dakota_output_ro.xyz, output/config_ro.xyz
    rm results.tmp 
	
	#### abstract best-fit common radius
	bestradius=$(cat radius.dat)  ### modify this if radius is a varible to be optimized by DAKOTA
	
	echo $bestradius > bestradius.dat
	f1=$(cat radius.dat);f2=$(cat bestradius.dat);

	####
	

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
echo 'compare_result_wrapper.sh done. Check your output in output/'

