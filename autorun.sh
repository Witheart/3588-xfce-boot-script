#!/bin/bash

echo "[witheart] ======/test/autorun.sh 定制开机脚本开始执行======" > /dev/kmsg


# 性能设置======
# 设置 CPU 为 performance 模式
echo "设置 CPU 为 performance 模式" > /dev/kmsg
echo performance | tee /sys/devices/system/cpu/cpufreq/policy*/scaling_governor

# 设置 GPU 为 performance 模式
echo "设置 GPU 为 performance 模式" > /dev/kmsg
echo performance | tee /sys/class/devfreq/fb000000.gpu/governor

# 设置 NPU 为 performance 模式
echo "设置 NPU 为 performance 模式" > /dev/kmsg
echo performance | tee /sys/class/devfreq/fdab0000.npu/governor

# 设置 DMC 为 performance 模式
echo "设置 DMC 为 performance 模式" > /dev/kmsg
echo performance | tee /sys/class/devfreq/dmc/governor

echo "所有设备已设置为 performance 模式" > /dev/kmsg

# 巨型帧设置======
# 设置 eth1 为巨型帧模式
echo "设置 eth1 为巨型帧模式" > /dev/kmsg
ifconfig eth1 mtu 9000


echo "[witheart] ======/test/autorun.sh 定制开机脚本执行完毕======" > /dev/kmsg

exit 0