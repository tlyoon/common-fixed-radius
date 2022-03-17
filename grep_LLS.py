## To use this script, mandatory requirements are
## 'dakota_mycal.out'
## 'workdir.1/bk7s2.k'
## 'monitor_objf_sorted.dat'. This file occurs after ./monitor_objf_sorted.sh

import os
import numpy as np
f=open(os.path.join('workdir.1', 'bk7s2.k'))
rawdata=f.readlines()
f.close()
noa=int(rawdata[1].strip())
print('noa:',noa)

f=open('dakota_mycal.out','r')
rawdata=f.readlines()
f.close()
nr=0
g=open("monitor_objf_sorted.dat",'r')
rd2=g.readlines()
g.close()
coor={};listobj={}
listfnno=[]
for i in rawdata:
    nr=nr+1
    line=i.strip()
    if 'Parameters for evaluation' in line:
        fnno=int(line.split()[-1].split(":")[0])
        if fnno==24478:
            print('fnno***',fnno)
        nrbgn=nr
        nrend=nrbgn+3*noa
        #print(line,fnno,nr,nrbgn,nrend)
        state=str(fnno) + " " + str(nrbgn) + " " +str(nrend)
        #print('state',state)
        for j in range(1, len(rd2)):
            fnnog=int(rd2[j].strip().split()[2])
            obj_fn=rd2[j].strip().split()[:4]
            if fnnog==fnno:
                print('fnnog,fnno=',fnnog,fnno)
                fnno=int(fnno)
                listfnno.append(fnno)
                #print('lineg',lineg,'state',state)
                lcoor=[]
                for k in range(nrbgn,nrend):
                    xs=rawdata[k].strip().split()[0]
                    print('j,fnno,k,xs',j,fnno,k,xs)
                    lcoor.append(xs)
                lcoor=[ float(i) for i in lcoor ]
                coor[fnno]=lcoor
                listobj[fnno]=obj_fn
                print('')
            
listfnno=list(set(listfnno))
for k in range(len(listfnno)):
    fnno=listfnno[k]
    obj_fn=listobj[fnno]
    obj_fn.insert(0, "LLS:")
    ll=obj_fn
    obj_fn=ll[0] +' '+ ll[1] +' '+ ll[2] +' '+ ll[3] +' '+ ll[4]
    ll4=str(np.round(float(ll[4]),7))
    llsfn='LLS_'+ll[1] +'_'+ ll[2] +'_'+ ll[3] +'_'+ ll4+'.xyz'
    f=open(llsfn,'w')
    #print(noa);
    f.write(str(noa)+'\n')
    #print(obj_fn);
    f.write(obj_fn+'\n')
    for q in range(noa):
        nx=3*q;ny=3*q+1;nz=3*q+2;
        xq=coor[fnno][nx]
        yq=coor[fnno][ny]
        zq=coor[fnno][nz]
        #print('C',xq,yq,zq)
        f.write('C ' + str(xq) + ' ' + str(yq) + ' '+str(zq) + '\n')
    print(llsfn)
    f.close()
    print('')
    