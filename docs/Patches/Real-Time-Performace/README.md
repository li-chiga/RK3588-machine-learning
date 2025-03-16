[TOC]

# Rockchip RealTime Linux 实时性系统环境搭建
**产品版本**

| 芯片名称 | 内核版本                 |
| -------- | ------------------------ |
| RK3562   | kernel-5.10              |
| RK3568   | kernel-4.19，kernel-5.10 |
| RK3588   | kernel-5.10              |

## 一、PREEMPT_RT

（1）kernel-5.10 base点：

```c
  commit cae91899b67b031d95f9163fe1fda74fbe0d931a (tag: linux-5.10-stan-rkr1)
  Author: Lan Honglin <helin.lan@rock-chips.com>
  Date:   Wed Jun 7 15:01:26 2023 +0800
  ARM: configs: rockchip: rv1106 enable sc301iot for battery-ipc

  Signed-off-by: Lan Honglin <helin.lan@rock-chips.com>
  Change-Id: Ib844385bfd58f73eaa5f4e415d598d1f983fa4cd
```

（2）kernel-4.19 base点：

```c
commit a46049b85fd7e5e9f58701fbc387e5b4d3793f98 (rk/develop-4.19, m/master)
Author: Shunhua Lan <lsh@rock-chips.com>
Date:   Mon Feb 6 16:45:53 2023 +0800

media: i2c: lt6911uxc: create hdmirx_class devices

Signed-off-by: Shunhua Lan <lsh@rock-chips.com>
Change-Id: I61c840d812b88554aa154bfc7c1435e1345d287e
 ```

####   a). kernel打上补丁：

kernel 5.10:

​    `0001-patch-5.10.180-rt89.patch-on-rockchip-base-cae91899b.patch`
​    `0002-patch-5.10.180-rt89.patch-fix-runtime-error-on-rockc.patch`
​    `0003-arm64-configs-optimize-latency-for-PREEMPT_RT.patch`

kernel 4.19:

​    `0001-patch-4.19.232-rt104.patch-on-rockchip-base-09f54150.patch` 
​    `0002-patch-4.19.232-rt104.patch-fix-runtime-error-on-rock.patch` 
​    `0003-arm64-configs-add-rockchip_rt.config-for-PREEMPT_RT_4.19.patch`

####   b). 编译命令（以RK3588为例）：

```bash
$ cd $sdk/kernel/
$ export CROSS_COMPILE=../prebuilts/gcc/linux-x86/aarch64/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
$ make ARCH=arm64 rockchip_linux_defconfig rockchip_rt.config 
$ make ARCH=arm64 rk3588-evb1-lp4-v10-linux.img -j8
```

####   c). 烧录boot.img 并测试实时性性能

   使用cyclictest测试

```bash
$ cyclictest -m -c 0 -t99 -t4 -l 12000000
```

## 二、XENOMAI

（1）kernel-5.10 base点：

```c
commit cae91899b67b031d95f9163fe1fda74fbe0d931a (tag: linux-5.10-stan-rkr1)
Author: Lan Honglin <helin.lan@rock-chips.com>
Date:   Wed Jun 7 15:01:26 2023 +0800  
ARM: configs: rockchip: rv1106 enable sc301iot for battery-ipc

Signed-off-by: Lan Honglin <helin.lan@rock-chips.com>
Change-Id: Ib844385bfd58f73eaa5f4e415d598d1f983fa4cd
```

（2）kernel 4.19 base点：

```c
commit 09f54150e89f68cece4ba5af11a1fd07dfa35aa3 (rk/develop-4.19)
Author: Zhihuan He <huan.he@rock-chips.com>
Date:   Wed Aug 23 11:37:06 2023 +0800

arm64: configs: rockchip_linux_defconfig: enable rockchip edac

Signed-off-by: Zhihuan He <huan.he@rock-chips.com>
Change-Id: Ie3c9b6150e792cb1bca395f630bf35da82168f2b
```

####   a).在kernel上打上xenomai补丁：

kernel 5.10:

​     `dovetail-core-5.10.161-on-rockchip-base-cae91899b.patch`

kernel 4.19:

​	`0001-ipipe-core-4.19.209-on-rockchip-base-09f54150e89f.patch`

####   b).buildroot打开XENOMAI配置，并编译rootfs.img：

```bash
BR2_PACKAGE_XENOMAI=y
BR2_PACKAGE_XENOMAI_3_2=y
BR2_PACKAGE_XENOMAI_VERSION="v3.2.2"
BR2_PACKAGE_XENOMAI_COBALT=y
BR2_PACKAGE_XENOMAI_TESTSUITE=y
BR2_PACKAGE_XENOMAI_ADDITIONAL_CONF_OPTS="--enable-demo"
```

####   c).把xenomai系统打到内核上：

```bash
$ cd $sdk/kernel
$ ../buildroot/output/rockchip_rk3588/build/xenomai-v3.2.2/scripts/prepare-kernel.sh --arch=arm64
```

####   d).编译内核，并烧录boot.img  rootfs.img

  编译命令：

kernel 5.10(以RK3588为例)：

```bash
$ cd $sdk/kernel
$ export CROSS_COMPILE=../prebuilts/gcc/linux-x86/aarch64/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
$ make ARCH=arm64 rockchip_linux_defconfig rk3588_linux.config
$ make ARCH=arm64 LT0=none LLVM=1 LLVM_IAS=1 rk3588-evb1-lp4-v10-linux.img -j17
```

kernel 4.19(以RK3568为例)：

```bash
$ cd $sdk/kernel
$ export CROSS_COMPILE=../prebuilts/gcc/linux-x86/aarch64/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
$ make ARCH=arm64 rockchip_linux_defconfig
$ make ARCH=arm64 rk3568-evb1-lp4-v10-linux.img -j17
```
####   e)测试实时性能

​    (1).校准latency

```bash
 $ echo 0 > /proc/xenomai/latency 
```

​    (2) 使用cyclictest测试

```bash
 $ ./usr/demo/cyclictest -m -n -c 0 -t99 -t4 -l 1200000
```

