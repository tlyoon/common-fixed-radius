## This script needs the presence of (1) config.xyz in current directory, (2) dakota_mycal.out in current direcotry, (3) templatedir/radius.dat, (4) templatedir/experimental.dat

import numpy as np
import pandas as pd
import os

os.system('mkdir output')
os.system('cp -r templatedir/* output/')
os.system('cd output/; ./clean.sh')
os.system('cp dakota_output.xyz output/')
os.system('cp dakota_mycal.out output/')
os.system('cp mycal.sh output/')
os.system('cp dakota_mycal.in output/')
os.system('cp dakota_output.xyz output/')
os.system('cp monitor_objf.dat monitor_objf_sorted.dat data.dat sigma_workdir.pdf output/')

os.chdir('output')

df=pd.read_csv('dakota_output.xyz',header=None,skiprows=0)

if os.path.isfile('mycal.in'):
    os.system('cp mycal.in mycal.in.orig')

## Create a new file mycal.in from config.xyz

f=open('mycal.in','w')
f.write('** total number of varaibles'+'\n')
f.write('** data begins from line 27 and onwards'+'\n')
f.write('** the rest are all dummies'+'\n')

for i in range(4,27):
    f.write('**'+'\n')
    
count=0    
#print('len(df):',len(df))
for i in range(2,len(df)):
    line=df.iloc[i].tolist()[0]
#    print('i, line',i,line)
#    print('line.split()',line.split())
    x=line.split()[1]
    y=line.split()[2]
    z=line.split()[3]
    count=count+1;
    state='variable '+ str(count) + ' ' + x
    #print(state)
    f.write(state+'\n')
    
    count=count+1;
    #print(count,y);
    state='variable '+ str(count) + ' ' + y
    #print(state)
    f.write(state+'\n')
    
    count=count+1
    #print(count,z);
    state='variable '+ str(count) + ' ' + z
    #print(state)
    f.write(state+'\n')
f.write('end'+'\n')	
f.close()

####### execute mycal.sh to generate the output gmt.dat, sigma.csv
os.system('./mycal.sh')
#os.system('python visuallize_sigma.py')

