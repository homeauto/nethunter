#!/bin/bash

sudo apt install git
cd ~/

git clone https://github.com/homeauto/nethunter.git

git clone https://github.com/homeauto/toolchains.git

git clone https://github.com/homeauto/QK-AOSP-Cepheus -b nethunter-10.0

cp ~/nethunter/build.sh ~/QK-AOSP-Cepheus

cd ~/
. ./QK-AOSP-Cepheus/build.sh
