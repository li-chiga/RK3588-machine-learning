#!/usr/bin/env python
# SPDX-License-Identifier: (GPL-2.0+ OR MIT)
# Copyright (c) 2018 Fuzhou Rockchip Electronics Co., Ltd
#


"""
Multiple dtb package tool

Usage: scripts/mkmultidtb.py board
The board is what you defined in DTBS dictionary like DTBS['board'],
Such as: PX30-EVB, RK3308-EVB

"""
import os
import sys
import shutil
from collections import OrderedDict

DTBS = {}

DTBS['PX30-EVB'] = OrderedDict([('px30-evb-ddr3-v10', '#_saradc_ch0=1024'),
				('px30-evb-ddr3-lvds-v10', '#_saradc_ch0=512')])

DTBS['RK3308-EVB'] = OrderedDict([('rk3308-evb-dmic-i2s-v10', '#_saradc_ch3=288'),
				  ('rk3308-evb-dmic-pdm-v10', '#_saradc_ch3=1024'),
				  ('rk3308-evb-amic-v10', '#_saradc_ch3=407')])

DTBS['ATK_DLRK3588'] = OrderedDict([('rk3588-atk-mipi-10p1_800x1280', '#_saradc_ch7=2748'),
				  ('rk3588-atk-mipi-5p5_1080x1920', '#_saradc_ch7=1410'),
				  ('rk3588-atk-mipi-5p5_720x1280', '#_saradc_ch7=0')])

DTBS['ATK_DLRK3568'] = OrderedDict([('rk3568-atk-evb1-mipi-dsi-10p1_800x1280', '#_saradc_ch2=702'),
				  ('rk3568-atk-evb1-mipi-dsi-1080p', '#_saradc_ch2=341'),
				  ('rk3568-atk-evb1-mipi-dsi-720p', '#_saradc_ch2=0')])

DEF_DTB_LIST = {'ATK_DLRK3588': 'rk3588-atk-non-mipi',
		'ATK_DLRK3568': 'rk3568-atk-evb1-non-mipi'}

def main():
    if (len(sys.argv) < 2) or (sys.argv[1] == '-h'):
        print __doc__
        sys.exit(2)

    BOARD = sys.argv[1]
    TARGET_DTBS = DTBS[BOARD]
    target_dtb_list = ''
    default_dtb = True

    def_dtb = DEF_DTB_LIST.get(BOARD)
    if def_dtb:
        ori_file = 'arch/arm64/boot/dts/rockchip/' + def_dtb + '.dtb'
        shutil.copyfile(ori_file, "rk-kernel.dtb")
        target_dtb_list += 'rk-kernel.dtb '
        default_dtb = False

    for dtb, value in TARGET_DTBS.items():
        if default_dtb:
            ori_file = 'arch/arm64/boot/dts/rockchip/' + dtb + '.dtb'
            shutil.copyfile(ori_file, "rk-kernel.dtb")
            target_dtb_list += 'rk-kernel.dtb '
            default_dtb = False
        new_file = dtb + value + '.dtb'
        ori_file = 'arch/arm64/boot/dts/rockchip/' + dtb + '.dtb'
        shutil.copyfile(ori_file, new_file)
        target_dtb_list += ' ' + new_file

    print target_dtb_list
    os.system('scripts/resource_tool logo.bmp logo_kernel.bmp ' + target_dtb_list)
    os.system('rm ' + target_dtb_list)

if __name__ == '__main__':
    main()
