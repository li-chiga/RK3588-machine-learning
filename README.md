# RK3588-machine-learning
For learning and testing projects for RK3588 development board, we look forward to developing more interesting and fun content. Welcome to join this open source development team.

(1)First, test the feasibility of remote pushing of codes tested onto the specified branch.


(2)Here is a test whether Vscode changes can be used normally in the Ubuntu repository? Can the patient be synchronized normally?

(3)下边是文件夹目录，我们高这个的为了给我们后续分步提交代码作前期说明.
SDK根目录下包含有：app  buildroot  build.sh  debian  device  docs  envsetup.sh  external  kernel  Makefile  prebuilts  rkbin  rkflash.sh  tools  u-boot  uefi  yocto等多个主目录:
app：存放上层应用app，包括Qt应用程序，以及其它的C/C++应用程序。
buildroot：基于buildroot 开发的根文件系统。 
debian：基于Debian开发的根文件系统。 
device/rockchip：存放各芯片板级配置文件和Parameter分区表文件，以及一些编译与打包固件的脚本和预备文件。
docs：存放芯片模块开发指导文档、平台支持列表、芯片平台相关文档、Linux开发指南等。
external：存放所需的第三方库，包括音频、视频、网络、recovery等。 
kernel：Linux 5.10 版本内核源码。
prebuilts：存放交叉编译工具链。
rkbin：存放Rockchip相关的Binary和工具。
rockdev：存放编译输出固件，编译SDK后才会生成该文件夹。
tools：存放Linux和Windows操作系统环境下常用的工具，包括镜像烧录工具、SD卡升级启动制作工具、批量烧录工具等，譬如前面给大家介绍的 RKDevTool 工具以及Linux_Upgrade_Tool 工具都存放在该目录。
u-boot：基于v2017.09版本进行开发的uboot源码。
yocto：基于Yocto开发的根文件系统。


由于有部分文件夹它本身比较大：
5.7G	external
4.7G	rk3588_linux_sdk
1.6G	buildroot
1.4G	kernel
1.2G	prebuilts
1.1G	debian
713M	docs
672M	tools
522M	uefi
271M	device
122M	u-boot
112M	app
103M	yocto
54M	rkbin
36K	LICENSE
4.0K	README.md
0	rkflash.sh
0	Makefile
0	envsetup.sh
0	build.sh
那些超过2G 的都不能一次性上传，现在只能分布分包上传内容了。我们的宗旨是先上传文件在上传目录，从小到达依次上传，5.7G的external目录和4.7G的rk3588_linux_sdk目录我们决定拆分步包上传，
以体力换空间。


#重要说明：在external文件夹下的部分大文件和tools文件夹下的部分大文件没有上传上去，因为大文件限制的原因，我是穷鬼，只想薅资本主义羊毛，充值美元的服务咱没钱干。所以我下次有空再想象办法.











