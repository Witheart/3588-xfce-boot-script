#!/bin/bash
sleep 1

HDMI_STATUS=$(cat /sys/class/drm/card0-HDMI-A-1/status)
eDP_STATUS=$(cat /sys/class/drm/card0-eDP-1/status)
if [[ $eDP_STATUS = "connected" ]];then
	edp_mode=$(cat /sys/class/drm/card0-eDP-1/modes)
fi

if [[ $HDMI_STATUS = "connected" ]];then
	xrandr --output HDMI-1 --same-as eDP-1
	xrandr --output HDMI-1 --primary
fi

#resize2fs 
rootdir=/dev/block/by-name/rootfs
userdata=/dev/block/by-name/userdata
if [ ! -e /etc/resize2fs.conf ]
then
	d1=`date +%H:%M:%S`
	echo "$d1" > /etc/resize2fs.conf
	resize2fs $rootdir
	resize2fs $userdata	
fi

#killall pulseaudio
#sleep 1
#amixer set 'Left Headphone Mixer Left DAC' on
#amixer set 'Right Headphone Mixer Right DAC' on
#amixer set "Headphone" 3
#amixer set 'Headphone Mixer' 11
#amixer set "DAC" 192
#amixer set 'ADC' 192
#pulseaudio -D
#sleep 1
#pactl set-default-sink 0


#for i in {1..2}
#do
#        lsmod | grep bcmdhd
#        if [[ $? -ne 0 ]];then
#		insmod /lib/modules/dhd_static_buf.ko >/dev/null
#		insmod /lib/modules/bcmdhd.ko >/dev/null
#        fi
#        sleep 1
#done
ifconfig wlan0 > /dev/null
if [[ $? -eq 0 ]];then
	#echo 0 > /sys/class/rfkill/rfkill0/state
	#sleep 1
	#echo 1 > /sys/class/rfkill/rfkill0/state
	rfkill unblock all
	sleep 1
        /test/brcm_patchram_plus1-68 --enable_hci --no2bytes --use_baudrate_for_download --tosleep 200000 --baudrate 1500000 --patchram /test/4343A1_Generic.hcd     /dev/ttyS9 &

	hciattach -s 1500000  /dev/ttyS9 any &
fi

#systemctl stop bluetooth
#sleep 1
#systemctl start bluetooth

#4g ec20
#sleep 15
echo "witheart: EC20拨号" > /dev/kmsg
echo -e "AT+QCFG=\"usbnet\",0\r\n" > /dev/ttyUSB2
#echo -e "AT+CFUN=1,1\r\n" > /dev/ttyUSB2
sleep 2
/etc/Quectel_QConnectManager_Linux_V1.6.5/quectel-CM &

#gpio
echo 15 >/sys/class/gpio/export
echo 16 >/sys/class/gpio/export
echo 34 >/sys/class/gpio/export
echo 35 >/sys/class/gpio/export
echo 36 >/sys/class/gpio/export
echo 128 >/sys/class/gpio/export
echo 129 >/sys/class/gpio/export
echo 130 >/sys/class/gpio/export

echo in >/sys/class/gpio/gpio15/direction
echo in >/sys/class/gpio/gpio34/direction
echo in >/sys/class/gpio/gpio36/direction
echo in >/sys/class/gpio/gpio129/direction

echo out>/sys/class/gpio/gpio16/direction
echo out>/sys/class/gpio/gpio35/direction
echo out>/sys/class/gpio/gpio128/direction
echo out>/sys/class/gpio/gpio130/direction

# 解决桌面环境下，5GHz WiFi只显示2.4GHz问题
systemctl restart NetworkManager
