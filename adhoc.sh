#! /bin/bash

## adhoc script to perform some unfinished tasks

cp  ~/dakota/dakota-gmt/common_fixed_radius/template/monitor_objf.sh    .
cp  ~/dakota/dakota-gmt/common_fixed_radius/template/monitor_workdir.sh .
cp  ~/dakota/dakota-gmt/common_fixed_radius/template/gplotp.sh          .
cp  ~/dakota/dakota-gmt/common_fixed_radius/template/compare_result_wrapper.sh .
cp  ~/dakota/dakota-gmt/common_fixed_radius/template/check_objfn_v* .
cp  ~/dakota/dakota-gmt/common_fixed_radius/template/grep_LLS.py .

cp  ~/dakota/dakota-gmt/common_fixed_radius/template/templatedir/orientate.py templatedir/
cp  ~/dakota/dakota-gmt/common_fixed_radius/template/templatedir/orientate_wrapper.py templatedir/
cp  ~/dakota/dakota-gmt/common_fixed_radius/template/templatedir/visuallize_sigma.py templatedir/
cp  ~/dakota/dakota-gmt/common_fixed_radius/template/templatedir/gen_sigma.py templatedir/ 
cp  ~/dakota/dakota-gmt/common_fixed_radius/template/templatedir/similarity.py templatedir/

chmod +x ~/dakota/dakota-gmt/common_fixed_radius/template/*.sh 

./compare_result_wrapper.sh

