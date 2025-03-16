#!/bin/bash

target_board=`echo $@ | sed -rn 's/^.*board=//p' | cut -d' ' -f1`
if [ -z "$target_board" ]; then
	echo "****[Error]: 未指定编译目标****"
	exit 1
fi

case $target_board in
	ATK_DLRK3568)
		RK_ARCH=arm64
		RK_DEFCONFIG="rockchip_linux_defconfig"
		ADDON_ARGS="CROSS_COMPILE=../prebuilts/gcc/linux-x86/aarch64/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-"
		RK_DTS=rk3568-atk-evb1-ddr4-v10-linux
		;;
	ATK_DLRK3588)
		RK_ARCH=arm64
		RK_DEFCONFIG="rockchip_linux_defconfig"
		ADDON_ARGS="CROSS_COMPILE=../prebuilts/gcc/linux-x86/aarch64/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-"
		RK_DTS=rk3588-atk-devkit
		;;
	*)
		echo "****[Error]: ($target_board)编译目标无效****"
		exit 1
		;;
esac

# 默认值
RK_JOBS=16

skip_config=false

while [ $# -gt 0 ]; do
	case $1 in
		arch=*)
			arg=${1#*=}
			if [ -n "$arg" ]; then
				RK_ARCH=$arg
			fi
			shift 1
			;;
		defconfig=*)
			arg=${1#*=}
			if [ -n "$arg" ]; then
				RK_DEFCONFIG=$arg
			fi
			shift 1
			;;
		addon_arg=*)
			ADDON_ARGS=${1#*=}
			shift 1
			;;
		dts=*)
			arg=${1#*=}
			if [ -n "$arg" ]; then
				RK_DTS=$arg
			fi
			shift 1
			;;
		jobs=*)
			arg=${1#*=}
			if [ -n "$arg" ]; then
				RK_JOBS=$arg
			fi
			shift 1
			;;
		--skip-config)
			skip_config=true
			shift 1
			;;
		*)
			shift 1
			;;
	esac
done

if [ "$skip_config" = true ]; then
	echo "Skip kernel configuration..."
	echo "Build Command: make $ADDON_ARGS ARCH=$RK_ARCH $RK_DTS.img -j$RK_JOBS"
	make $ADDON_ARGS ARCH=$RK_ARCH $RK_DTS.img -j$RK_JOBS
else
	echo "Build Command: make clean && make $ADDON_ARGS ARCH=$RK_ARCH $RK_DEFCONFIG && make $ADDON_ARGS ARCH=$RK_ARCH $RK_DTS.img -j$RK_JOBS"
	make clean && make $ADDON_ARGS ARCH=$RK_ARCH $RK_DEFCONFIG && make $ADDON_ARGS ARCH=$RK_ARCH $RK_DTS.img -j$RK_JOBS
fi
