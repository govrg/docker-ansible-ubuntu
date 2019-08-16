#!/bin/bash

cd
adb devices
. ./myvars.sh
cd e2e-test
adb devices
./gradlew test --info