#!/bin/bash

cd ~/

git clone https://github.com/homeauto/toolchains.git

git clone https://github.com/Official-Ayrton990/Quantic-Kernel-AOSP-Cepheus.git -b PELT

cp ~/nethunter/build.sh ~/Quantic-Kernel-AOSP-Cepheus

cd ~/Quantic-Kernel-AOSP-Cepheus

chmod +x build.sh
