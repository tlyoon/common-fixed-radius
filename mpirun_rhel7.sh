#! /bin/bash

dakota_mycalin=dakota_mycal.in.set3_c23

### need not touch the lines below unneccesarily
nproc=$(echo $npr | awk '{print $1/2}')
mpirun=/usr/lib64/openmpi/bin/mpirun
#dakota=/state/partition1/ext_storage/Dakota/bin/dakota
dakota=/state/partition1/ext_storage/dakota-6.14.0.Linux.x86_64/bin/dakota
nohup $mpirun -np $nproc $dakota -i $dakota_mycalin -o dakota_mycal.out > dakota_mycal.stdout &



