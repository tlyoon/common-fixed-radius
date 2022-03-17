#! /bin/bash

npr=$(cat /proc/cpuinfo | grep siblings | awk 'END {print $3}')
nproc=$(echo $npr | awk '{print $1/2}')
####

### specify your dakota_mycal.in file here
dakota_mycalin=dakota_mycal.in.diy6.1
#dakota_mycal.in.hybrid.in
#dakota_mycalin=dakota_mycal.in  ### default: dakota_mycalin=dakota_mycal.in.hybrid.in 
dakota=/state/partition1/ext_storage/dakota-6.14.0.Linux.x86_64/bin/dakota

#set 0  ### default setting, without mpi
nohup $dakota -i $dakota_mycalin -o dakota_mycal.out > dakota_mycal.stdout &

#set 1  ### 
#export LD_LIBRARY_PATH=/share/apps/openmpi-3.1.2/gnu/lib:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=/share/apps/Dakota/lib:$LD_LIBRARY_PATH
#mpirun=/share/apps/openmpi-3.1.2/gnu/bin/mpirun
#dakota=/share/apps/Dakota/bin/dakota
#nohup $mpirun -np $nproc $dakota -i $dakota_mycalin -o dakota_mycal.out > dakota_mycal.stdout &

#set 2  ###
#dakota=/state/partition1/ext_storage/dakota-6.14.0.Linux.x86_64/bin/dakota
#nohup $dakota -i $dakota_mycalin -o dakota_mycal.out > dakota_mycal.stdout &

#set 3
#mpirun=/usr/lib64/openmpi/bin/mpirun
#dakota=/share/apps/local/bin/dakota
#nohup $mpirun -np $nproc $dakota -i $dakota_mycalin -o dakota_mycal.out > dakota_mycal.stdout &

#set 4
#export LD_LIBRARY_PATH=/usr/lib64/openmpi/lib:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=/state/partition1/ext_storage/dakota-6.14.0.Linux.x86_64/lib:$LD_LIBRARY_PATH
#mpirun=/usr/lib64/openmpi/bin/mpirun
#dakota=/state/partition1/ext_storage/dakota-6.14.0.Linux.x86_64/bin/dakota
#nohup $mpirun -np $nproc $dakota -i $dakota_mycalin -o dakota_mycal.out > dakota_mycal.stdout &

#set 5  ### 
#export LD_LIBRARY_PATH=$HOME/dakota-6.14.0.Linux.x86_64/lib:$LD_LIBRARY_PATH
#export LD_LIBRARY_PATH=/usr/lib64/openmpi/lib:$LD_LIBRARY_PATH
#mpirun=/usr/lib64/openmpi/bin/mpirun
#dakota=$HOME/dakota-6.14.0.Linux.x86_64/bin/dakota
#nohup $mpirun -np $nproc $dakota -i $dakota_mycalin -o dakota_mycal.out > dakota_mycal.stdout & 


