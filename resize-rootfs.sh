#!/bin/bash

# 作者：吴思含（Witheart）
# 更新时间：20250813
# github.com/Witheart

# 动态获取根设备
ROOT_DEVICE=$(findmnt -n -o SOURCE /)
if [ -z "$ROOT_DEVICE" ]; then
    echo "[witheart] resize-rootfs: Error: Root device not found!" | sudo tee /dev/kmsg
    exit 1
fi

# 记录到 dmesg
echo "[witheart] resize-rootfs: Resizing $ROOT_DEVICE" | sudo tee /dev/kmsg

# 执行扩展
resize2fs "$ROOT_DEVICE" 2>&1 | while read line; do
    echo "[witheart] resize-rootfs: $line" | sudo tee /dev/kmsg
done

# 完成提示
echo "[witheart] resize-rootfs: Operation completed" | sudo tee /dev/kmsg