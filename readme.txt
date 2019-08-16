To make container to detect the device then
-on the host
> adb kill-server
-then start the container with the flags
> sudo docker run -it --privileged -v /dev/bus/usb:/dev/bus/usb   container_name


aapt has been moved to build-tools/26.0.3/aapt
> cp ANDROID_HOME:build-tools/26.0.3/aapt ANDROID_HOME:tool/bin/aapt
or
> cp ../android-sdk-linux/build-tools/26.0.3/aapt ../android-sdk-linux/tools/bin/