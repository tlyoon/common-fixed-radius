
#! /bin/bash

username=root;
B=comsics.usm.my;
C=anicca.usm.my;

path2file=/share/tmp/112142943_diy6_co_sigma_0.002850_si_0.122
scp -r -oProxyCommand="ssh -W %h:%p $username@$B" $username@$C:$path2file .


#/home/yl/dakota/dakota-gmt/common_fixed_radius/TEMPLATES_0824152627/hybrid2rr99_compld
#path2file=/home/yl/dakota/dakota-gmt/common_fixed_radius/TEMPLATES_0824152627/hybrid2rr99_compld/output/*
#/home/tlyoon/dakota/dakota-gmt/common_fixed_radius/template/check_directories.sh
