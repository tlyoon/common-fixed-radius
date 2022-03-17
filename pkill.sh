#! /bin/bash

pkill -9 WolframKernel
pkill -9 runpsn.sh
pkill -9 watch
pkill -9 math
pkill -9 gmm01f
pkill -9 MathKernel
pkill -9 Mathematica
pkill -9 run.sh
pkill -9 run_parallel.sh
pkill -9 runlocal.sh
pkill -9 mpirun
pkill -9 gmm01f
pkill -9 gfortran
pkill -9 mycal.sh
pkill -9 sed
pkill -9 gen_miecurveN.sh
pkill -9 dakota
pkill -9 simulator_scrip
ps -u $USER
