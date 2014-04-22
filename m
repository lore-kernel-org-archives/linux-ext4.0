From: Ludovic CHERON <ludo.cheron@laposte.net>
Subject: After upgrading from ubutu 13.10 to ubuntu 14.04 system says major
 disk failure when using kernel 3.13.0.24
Date: Tue, 22 Apr 2014 21:42:33 +0200
Message-ID: <5356C629.3050104@laposte.net>
Reply-To: ludo.cheron@laposte.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040307060702020209040804"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:44691 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437AbaDVTmu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Apr 2014 15:42:50 -0400
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id 97A98CABF8B
	for <linux-ext4@vger.kernel.org>; Tue, 22 Apr 2014 21:42:46 +0200 (CEST)
Received: from [IPv6:2a01:e35:2421:bac0:88c3:3ddc:ae46:108d] (unknown [IPv6:2a01:e35:2421:bac0:88c3:3ddc:ae46:108d])
	by smtp5-g21.free.fr (Postfix) with ESMTP id A1566D480D2
	for <linux-ext4@vger.kernel.org>; Tue, 22 Apr 2014 21:42:13 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040307060702020209040804
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit

[1.] One line summary of the problem
-------------------------------------------------------------
After upgrading from 13.10 to 14.04 system says major disk failure when 
using kernel 3.13.0.24 (launchpad bug #1309730)

[2.] Full description of the problem
-------------------------------------------------------------

After upgrading from 13.10 to 14.04 system says major disk failure when 
using default linux kernel 3.13.0.24
Booting into the newest mainline kernel did no resolved the problem.
I obtain a graphical screen from witch i can get a console from where a 
got the informations mentionned in the further steps.

Hardware configuration
Dell inspiron One
Intel® Core™ i3 CPU M 370 @ 2.40GHz × 4

Software installation
2 partitions formatted windows/7
Installed on a partition installed with wubi, filesystem in a 30.6 Gb file
Grub installed with dual boot Windows/7 or Ubuntu

After upgrading to 14.04 system cannot boot with default kernel linux 
3.13.0-24
It shows a terminal with restritected command line or says file system 
is damaged !

Workarround : with grub i could select kernel linux 3.11.0-20 and boot 
(i us this version to send this mail)
However system cannot update saying "Broken packaging: 0"

$ df -h

Sys. de fichiers Taille Utilisé Dispo Uti% Monté sur
/dev/loop0 29G 24G 3,1G 89% /
none 4,0K 0 4,0K 0% /sys/fs/cgroup
udev 1,9G 4,0K 1,9G 1% /dev
tmpfs 390M 1,2M 389M 1% /run
none 5,0M 0 5,0M 0% /run/lock
none 2,0G 84K 2,0G 1% /run/shm
none 100M 40K 100M 1% /run/user
/dev/sda5 313G 287G 26G 92% /host
/dev/sdb1 30G 11G 19G 36% /media/ludovic/9016-4EF8
/dev/sdc1 699G 98G 602G 14% /media/ludovic/FREECOM HDD

df shows file system is installed on a 313 Gb windows partition (/host) 
using 26 Gb for linux fs.

[3.] Keywords
-------------------------------------------------------------


[4.] Kernel version
-------------------------------------------------------------
# cat /proc/version
Linux version 3.15.0-031500rc1-generic (apw@gomeisa) (gcc version 4.6.3 
(Ubuntu/Linaro 4.6.3-1ubuntu5) ) #201404131835 SMP Sun Apr 13 22:56:20 
UTC 2014

[5.] Output of Oops message
-------------------------------------------------------------
not applicable ?

[6.] Shell script to trigger the problem
-------------------------------------------------------------
none : simply boot with grub and the default *ubuntu selection

[7.] Environment
-------------------------------------------------------------
# lsb_release -rd
Description: Ubuntu 14.04 LTS
Release: 14.04

[7.1] Software
-------------------------------------------------------------
# sh ver_linux
sh: 0: Can't open ver_linux

Could not understand why. I was located in the correct directory
#ls /usr/src
total 12
drwxr-xr-x 24 root root 4096 Apr 18 10:57 linux-headers-3.13.0-24
drwxr-xr-x 7 root root 4096 Apr 18 10:57 linux-headers-3.13.0-24-generic
drwxr-xr-x 7 root root 4096 Apr 18 23:40 
linux-headers-3.15.0-031500rc1-generic

# cd linux-headers-3.15.0-031500rc1-generic
# ls -l
total 228
lrwxrwxrwx 1 root root 59 Apr 14 01:12 Kbuild.include -> 
../../linux-headers-3.15.0-031500rc1/scripts/Kbuild.include
lrwxrwxrwx 1 root root 52 Apr 14 01:12 Lindent -> 
../../linux-headers-3.15.0-031500rc1/scripts/Lindent
lrwxrwxrwx 1 root root 53 Apr 14 01:12 Makefile -> 
../../linux-headers-3.15.0-031500rc1/scripts/Makefile
lrwxrwxrwx 1 root root 65 Apr 14 01:12 Makefile.asm-generic -> 
../../linux-headers-3.15.0-031500rc1/scripts/Makefile.asm-generic
lrwxrwxrwx 1 root root 59 Apr 14 01:12 Makefile.build -> 
../../linux-headers-3.15.0-031500rc1/scripts/Makefile.build
lrwxrwxrwx 1 root root 59 Apr 14 01:12 Makefile.clean -> 
../../linux-headers-3.15.0-031500rc1/scripts/Makefile.clean
lrwxrwxrwx 1 root root 60 Apr 14 01:12 Makefile.fwinst -> 
../../linux-headers-3.15.0-031500rc1/scripts/Makefile.fwinst
lrwxrwxrwx 1 root root 65 Apr 14 01:12 Makefile.headersinst -> 
../../linux-headers-3.15.0-031500rc1/scripts/Makefile.headersinst
lrwxrwxrwx 1 root root 58 Apr 14 01:12 Makefile.help -> 
../../linux-headers-3.15.0-031500rc1/scripts/Makefile.help
lrwxrwxrwx 1 root root 58 Apr 14 01:12 Makefile.host -> 
../../linux-headers-3.15.0-031500rc1/scripts/Makefile.host
lrwxrwxrwx 1 root root 57 Apr 14 01:12 Makefile.lib -> 
../../linux-headers-3.15.0-031500rc1/scripts/Makefile.lib
lrwxrwxrwx 1 root root 64 Apr 14 01:12 Makefile.modbuiltin -> 
../../linux-headers-3.15.0-031500rc1/scripts/Makefile.modbuiltin
lrwxrwxrwx 1 root root 61 Apr 14 01:12 Makefile.modinst -> 
../../linux-headers-3.15.0-031500rc1/scripts/Makefile.modinst
lrwxrwxrwx 1 root root 61 Apr 14 01:12 Makefile.modpost -> 
../../linux-headers-3.15.0-031500rc1/scripts/Makefile.modpost
lrwxrwxrwx 1 root root 61 Apr 14 01:12 Makefile.modsign -> 
../../linux-headers-3.15.0-031500rc1/scripts/Makefile.modsign
lrwxrwxrwx 1 root root 63 Apr 14 01:12 analyze_suspend.py -> 
../../linux-headers-3.15.0-031500rc1/scripts/analyze_suspend.py
-rwxr-xr-x 1 root root 21609 Apr 14 01:12 asn1_compiler
lrwxrwxrwx 1 root root 60 Apr 14 01:12 asn1_compiler.c -> 
../../linux-headers-3.15.0-031500rc1/scripts/asn1_compiler.c
drwxr-xr-x 2 root root 4096 Apr 18 23:40 basic
lrwxrwxrwx 1 root root 52 Apr 14 01:12 bin2c.c -> 
../../linux-headers-3.15.0-031500rc1/scripts/bin2c.c
lrwxrwxrwx 1 root root 58 Apr 14 01:12 bloat-o-meter -> 
../../linux-headers-3.15.0-031500rc1/scripts/bloat-o-meter
lrwxrwxrwx 1 root root 57 Apr 14 01:12 bootgraph.pl -> 
../../linux-headers-3.15.0-031500rc1/scripts/bootgraph.pl
lrwxrwxrwx 1 root root 61 Apr 14 01:12 checkincludes.pl -> 
../../linux-headers-3.15.0-031500rc1/scripts/checkincludes.pl
lrwxrwxrwx 1 root root 67 Apr 14 01:12 checkkconfigsymbols.sh -> 
../../linux-headers-3.15.0-031500rc1/scripts/checkkconfigsymbols.sh
lrwxrwxrwx 1 root root 58 Apr 14 01:12 checkpatch.pl -> 
../../linux-headers-3.15.0-031500rc1/scripts/checkpatch.pl
lrwxrwxrwx 1 root root 58 Apr 14 01:12 checkstack.pl -> 
../../linux-headers-3.15.0-031500rc1/scripts/checkstack.pl
lrwxrwxrwx 1 root root 61 Apr 14 01:12 checksyscalls.sh -> 
../../linux-headers-3.15.0-031500rc1/scripts/checksyscalls.sh
lrwxrwxrwx 1 root root 60 Apr 14 01:12 checkversion.pl -> 
../../linux-headers-3.15.0-031500rc1/scripts/checkversion.pl
lrwxrwxrwx 1 root root 54 Apr 14 01:12 cleanfile -> 
../../linux-headers-3.15.0-031500rc1/scripts/cleanfile
lrwxrwxrwx 1 root root 55 Apr 14 01:12 cleanpatch -> 
../../linux-headers-3.15.0-031500rc1/scripts/cleanpatch
lrwxrwxrwx 1 root root 55 Apr 14 01:12 coccicheck -> 
../../linux-headers-3.15.0-031500rc1/scripts/coccicheck
lrwxrwxrwx 1 root root 55 Apr 14 01:12 coccinelle -> 
../../linux-headers-3.15.0-031500rc1/scripts/coccinelle
lrwxrwxrwx 1 root root 51 Apr 14 01:12 config -> 
../../linux-headers-3.15.0-031500rc1/scripts/config
-rwxr-xr-x 1 root root 11867 Apr 14 01:12 conmakehash
lrwxrwxrwx 1 root root 58 Apr 14 01:12 conmakehash.c -> 
../../linux-headers-3.15.0-031500rc1/scripts/conmakehash.c
lrwxrwxrwx 1 root root 55 Apr 14 01:12 decodecode -> 
../../linux-headers-3.15.0-031500rc1/scripts/decodecode
lrwxrwxrwx 1 root root 54 Apr 14 01:12 depmod.sh -> 
../../linux-headers-3.15.0-031500rc1/scripts/depmod.sh
lrwxrwxrwx 1 root root 55 Apr 14 01:12 diffconfig -> 
../../linux-headers-3.15.0-031500rc1/scripts/diffconfig
lrwxrwxrwx 1 root root 54 Apr 14 01:12 docproc.c -> 
../../linux-headers-3.15.0-031500rc1/scripts/docproc.c
lrwxrwxrwx 1 root root 48 Apr 14 01:12 dtc -> 
../../linux-headers-3.15.0-031500rc1/scripts/dtc
lrwxrwxrwx 1 root root 61 Apr 14 01:12 export_report.pl -> 
../../linux-headers-3.15.0-031500rc1/scripts/export_report.pl
lrwxrwxrwx 1 root root 61 Apr 14 01:12 extract-ikconfig -> 
../../linux-headers-3.15.0-031500rc1/scripts/extract-ikconfig
lrwxrwxrwx 1 root root 60 Apr 14 01:12 extract-vmlinux -> 
../../linux-headers-3.15.0-031500rc1/scripts/extract-vmlinux
lrwxrwxrwx 1 root root 56 Apr 14 01:12 gcc-goto.sh -> 
../../linux-headers-3.15.0-031500rc1/scripts/gcc-goto.sh
lrwxrwxrwx 1 root root 51 Apr 14 01:12 gcc-ld -> 
../../linux-headers-3.15.0-031500rc1/scripts/gcc-ld
lrwxrwxrwx 1 root root 59 Apr 14 01:12 gcc-version.sh -> 
../../linux-headers-3.15.0-031500rc1/scripts/gcc-version.sh
lrwxrwxrwx 1 root root 78 Apr 14 01:12 gcc-x86_32-has-stack-protector.sh 
-> 
../../linux-headers-3.15.0-031500rc1/scripts/gcc-x86_32-has-stack-protector.sh
lrwxrwxrwx 1 root root 78 Apr 14 01:12 gcc-x86_64-has-stack-protector.sh 
-> 
../../linux-headers-3.15.0-031500rc1/scripts/gcc-x86_64-has-stack-protector.sh
lrwxrwxrwx 1 root root 66 Apr 14 01:12 gen_initramfs_list.sh -> 
../../linux-headers-3.15.0-031500rc1/scripts/gen_initramfs_list.sh
drwxr-xr-x 2 root root 4096 Apr 18 23:40 genksyms
lrwxrwxrwx 1 root root 62 Apr 14 01:12 get_maintainer.pl -> 
../../linux-headers-3.15.0-031500rc1/scripts/get_maintainer.pl
lrwxrwxrwx 1 root root 58 Apr 14 01:12 gfp-translate -> 
../../linux-headers-3.15.0-031500rc1/scripts/gfp-translate
lrwxrwxrwx 1 root root 57 Apr 14 01:12 headerdep.pl -> 
../../linux-headers-3.15.0-031500rc1/scripts/headerdep.pl
lrwxrwxrwx 1 root root 55 Apr 14 01:12 headers.sh -> 
../../linux-headers-3.15.0-031500rc1/scripts/headers.sh
lrwxrwxrwx 1 root root 61 Apr 14 01:12 headers_check.pl -> 
../../linux-headers-3.15.0-031500rc1/scripts/headers_check.pl
lrwxrwxrwx 1 root root 63 Apr 14 01:12 headers_install.sh -> 
../../linux-headers-3.15.0-031500rc1/scripts/headers_install.sh
-rwxr-xr-x 1 root root 17150 Apr 14 01:12 kallsyms
lrwxrwxrwx 1 root root 55 Apr 14 01:12 kallsyms.c -> 
../../linux-headers-3.15.0-031500rc1/scripts/kallsyms.c
drwxr-xr-x 2 root root 4096 Apr 18 23:40 kconfig
lrwxrwxrwx 1 root root 55 Apr 14 01:12 kernel-doc -> 
../../linux-headers-3.15.0-031500rc1/scripts/kernel-doc
lrwxrwxrwx 1 root root 53 Apr 14 01:12 ksymoops -> 
../../linux-headers-3.15.0-031500rc1/scripts/ksymoops
lrwxrwxrwx 1 root root 58 Apr 14 01:12 ld-version.sh -> 
../../linux-headers-3.15.0-031500rc1/scripts/ld-version.sh
lrwxrwxrwx 1 root root 60 Apr 14 01:12 link-vmlinux.sh -> 
../../linux-headers-3.15.0-031500rc1/scripts/link-vmlinux.sh
lrwxrwxrwx 1 root root 52 Apr 14 01:12 makelst -> 
../../linux-headers-3.15.0-031500rc1/scripts/makelst
lrwxrwxrwx 1 root root 59 Apr 14 01:12 markup_oops.pl -> 
../../linux-headers-3.15.0-031500rc1/scripts/markup_oops.pl
lrwxrwxrwx 1 root root 56 Apr 14 01:12 mkcompile_h -> 
../../linux-headers-3.15.0-031500rc1/scripts/mkcompile_h
lrwxrwxrwx 1 root root 55 Apr 14 01:12 mkmakefile -> 
../../linux-headers-3.15.0-031500rc1/scripts/mkmakefile
lrwxrwxrwx 1 root root 53 Apr 14 01:12 mksysmap -> 
../../linux-headers-3.15.0-031500rc1/scripts/mksysmap
lrwxrwxrwx 1 root root 55 Apr 14 01:12 mkuboot.sh -> 
../../linux-headers-3.15.0-031500rc1/scripts/mkuboot.sh
lrwxrwxrwx 1 root root 54 Apr 14 01:12 mkversion -> 
../../linux-headers-3.15.0-031500rc1/scripts/mkversion
drwxr-xr-x 2 root root 4096 Apr 18 23:40 mod
lrwxrwxrwx 1 root root 62 Apr 14 01:12 module-common.lds -> 
../../linux-headers-3.15.0-031500rc1/scripts/module-common.lds
lrwxrwxrwx 1 root root 57 Apr 14 01:12 namespace.pl -> 
../../linux-headers-3.15.0-031500rc1/scripts/namespace.pl
lrwxrwxrwx 1 root root 52 Apr 14 01:12 objdiff -> 
../../linux-headers-3.15.0-031500rc1/scripts/objdiff
lrwxrwxrwx 1 root root 52 Apr 14 01:12 package -> 
../../linux-headers-3.15.0-031500rc1/scripts/package
lrwxrwxrwx 1 root root 57 Apr 14 01:12 patch-kernel -> 
../../linux-headers-3.15.0-031500rc1/scripts/patch-kernel
lrwxrwxrwx 1 root root 56 Apr 14 01:12 pnmtologo.c -> 
../../linux-headers-3.15.0-031500rc1/scripts/pnmtologo.c
lrwxrwxrwx 1 root root 66 Apr 14 01:12 profile2linkerlist.pl -> 
../../linux-headers-3.15.0-031500rc1/scripts/profile2linkerlist.pl
-rwxr-xr-x 1 root root 21991 Apr 14 01:12 recordmcount
lrwxrwxrwx 1 root root 59 Apr 14 01:12 recordmcount.c -> 
../../linux-headers-3.15.0-031500rc1/scripts/recordmcount.c
lrwxrwxrwx 1 root root 59 Apr 14 01:12 recordmcount.h -> 
../../linux-headers-3.15.0-031500rc1/scripts/recordmcount.h
lrwxrwxrwx 1 root root 60 Apr 14 01:12 recordmcount.pl -> 
../../linux-headers-3.15.0-031500rc1/scripts/recordmcount.pl
lrwxrwxrwx 1 root root 54 Apr 14 01:12 rt-tester -> 
../../linux-headers-3.15.0-031500rc1/scripts/rt-tester
drwxr-xr-x 4 root root 4096 Apr 18 23:40 selinux
lrwxrwxrwx 1 root root 60 Apr 14 01:12 setlocalversion -> 
../../linux-headers-3.15.0-031500rc1/scripts/setlocalversion
lrwxrwxrwx 1 root root 55 Apr 14 01:12 show_delta -> 
../../linux-headers-3.15.0-031500rc1/scripts/show_delta
lrwxrwxrwx 1 root root 54 Apr 14 01:12 sign-file -> 
../../linux-headers-3.15.0-031500rc1/scripts/sign-file
-rwxr-xr-x 1 root root 16637 Apr 14 01:12 sortextable
lrwxrwxrwx 1 root root 58 Apr 14 01:12 sortextable.c -> 
../../linux-headers-3.15.0-031500rc1/scripts/sortextable.c
lrwxrwxrwx 1 root root 58 Apr 14 01:12 sortextable.h -> 
../../linux-headers-3.15.0-031500rc1/scripts/sortextable.h
lrwxrwxrwx 1 root root 52 Apr 14 01:12 tags.sh -> 
../../linux-headers-3.15.0-031500rc1/scripts/tags.sh
lrwxrwxrwx 1 root root 52 Apr 14 01:12 tracing -> 
../../linux-headers-3.15.0-031500rc1/scripts/tracing
lrwxrwxrwx 1 root root 54 Apr 14 01:12 unifdef.c -> 
../../linux-headers-3.15.0-031500rc1/scripts/unifdef.c
lrwxrwxrwx 1 root root 54 Apr 14 01:12 ver_linux -> 
../../linux-headers-3.15.0-031500rc1/scripts/ver_linux
lrwxrwxrwx 1 root root 55 Apr 14 01:12 xz_wrap.sh -> 
../../linux-headers-3.15.0-031500rc1/scripts/xz_wrap.sh

# sh ver_linux
sh: 0: Can't open ver_linux

[7.2] Processor information
-------------------------------------------------------------
processor : 0
vendor_id : GenuineIntel
cpu family : 6
model : 37
model name : Intel(R) Core(TM) i3 CPU M 370 @ 2.40GHz
stepping : 5
microcode : 0x2
cpu MHz : 2394.000
cache size : 3072 KB
physical id : 0
siblings : 4
core id : 0
cpu cores : 2
apicid : 0
initial apicid : 0
fdiv_bug : no
f00f_bug : no
coma_bug : no
fpu : yes
fpu_exception : yes
cpuid level : 11
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx rdtscp lm 
constant_tsc arch_perfmon pebs bts xtopology nonstop_tsc aperfmperf pni 
dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 
sse4_2 popcnt lahf_lm arat dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips : 4787.92
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 1
vendor_id : GenuineIntel
cpu family : 6
model : 37
model name : Intel(R) Core(TM) i3 CPU M 370 @ 2.40GHz
stepping : 5
microcode : 0x2
cpu MHz : 2394.000
cache size : 3072 KB
physical id : 0
siblings : 4
core id : 2
cpu cores : 2
apicid : 4
initial apicid : 4
fdiv_bug : no
f00f_bug : no
coma_bug : no
fpu : yes
fpu_exception : yes
cpuid level : 11
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx rdtscp lm 
constant_tsc arch_perfmon pebs bts xtopology nonstop_tsc aperfmperf pni 
dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 
sse4_2 popcnt lahf_lm arat dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips : 4787.92
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 2
vendor_id : GenuineIntel
cpu family : 6
model : 37
model name : Intel(R) Core(TM) i3 CPU M 370 @ 2.40GHz
stepping : 5
microcode : 0x2
cpu MHz : 2394.000
cache size : 3072 KB
physical id : 0
siblings : 4
core id : 0
cpu cores : 2
apicid : 1
initial apicid : 1
fdiv_bug : no
f00f_bug : no
coma_bug : no
fpu : yes
fpu_exception : yes
cpuid level : 11
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx rdtscp lm 
constant_tsc arch_perfmon pebs bts xtopology nonstop_tsc aperfmperf pni 
dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 
sse4_2 popcnt lahf_lm arat dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips : 4787.92
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

processor : 3
vendor_id : GenuineIntel
cpu family : 6
model : 37
model name : Intel(R) Core(TM) i3 CPU M 370 @ 2.40GHz
stepping : 5
microcode : 0x2
cpu MHz : 2394.000
cache size : 3072 KB
physical id : 0
siblings : 4
core id : 2
cpu cores : 2
apicid : 5
initial apicid : 5
fdiv_bug : no
f00f_bug : no
coma_bug : no
fpu : yes
fpu_exception : yes
cpuid level : 11
wp : yes
flags : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx rdtscp lm 
constant_tsc arch_perfmon pebs bts xtopology nonstop_tsc aperfmperf pni 
dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 
sse4_2 popcnt lahf_lm arat dtherm tpr_shadow vnmi flexpriority ept vpid
bogomips : 4787.92
clflush size : 64
cache_alignment : 64
address sizes : 36 bits physical, 48 bits virtual
power management:

[7.3] Module information
-------------------------------------------------------------
# cat /proc/modules
ip6t_REJECT 12813 1 - Live 0xf8bc7000
xt_hl 12465 6 - Live 0xf8516000
ip6t_rt 13259 3 - Live 0xf8edd000
nf_conntrack_ipv6 18458 11 - Live 0xf85c3000
nf_defrag_ipv6 26297 1 nf_conntrack_ipv6, Live 0xf8dab000
ipt_REJECT 12515 1 - Live 0xf84eb000
xt_LOG 17542 20 - Live 0xf84fd000
xt_multiport 12694 2 - Live 0xf8c0d000
xt_limit 12541 21 - Live 0xf85be000
xt_tcpudp 12788 61 - Live 0xf85b1000
xt_addrtype 12625 4 - Live 0xf8d94000
nf_conntrack_ipv4 14361 11 - Live 0xf85b9000
nf_defrag_ipv4 12649 1 nf_conntrack_ipv4, Live 0xf8c1b000
xt_conntrack 12664 22 - Live 0xf8a24000
mac80211 573514 0 - Live 0xf8de1000
ip6table_filter 12711 1 - Live 0xf84f8000
cfg80211 435161 1 mac80211, Live 0xf8e71000
ip6_tables 18136 1 ip6table_filter, Live 0xf8583000
ssb 56649 0 - Live 0xf8544000
nf_conntrack_netbios_ns 12585 0 - Live 0xf84d9000
gpio_ich 13364 0 - Live 0xf84d4000
dell_wmi_aio 12580 0 - Live 0xf84c6000
nf_conntrack_broadcast 12541 1 nf_conntrack_netbios_ns, Live 0xf84e6000
sparse_keymap 13658 1 dell_wmi_aio, Live 0xf84b1000
nf_nat_ftp 12692 0 - Live 0xf84e1000
nf_nat 21081 1 nf_nat_ftp, Live 0xf8557000
nf_conntrack_ftp 14117 1 nf_nat_ftp, Live 0xf84bd000
dcdbas 14521 0 - Live 0xf84cc000
nf_conntrack 88175 8 
nf_conntrack_ipv6,nf_conntrack_ipv4,xt_conntrack,nf_conntrack_netbios_ns,nf_conntrack_broadcast,nf_nat_ftp,nf_nat,nf_conntrack_ftp, 
Live 0xf852d000
snd_hda_codec_realtek 65688 1 - Live 0xf8504000
iptable_filter 12706 1 - Live 0xf8491000
intel_powerclamp 18561 0 - Live 0xf84ab000
snd_hda_codec_generic 63743 1 snd_hda_codec_realtek, Live 0xf8480000
ip_tables 18304 1 iptable_filter, Live 0xf84f2000
snd_hda_intel 29400 0 - Live 0xf8cf2000
uvcvideo 72319 0 - Live 0xf8c90000
radeon 1475890 1 - Live 0xf8f56000
snd_hda_controller 30246 1 snd_hda_intel, Live 0xf8d0f000
coretemp 13358 0 - Live 0xf8bdf000
snd_hda_codec 121022 4 
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,snd_hda_controller, 
Live 0xf8d24000
x_tables 22180 14 
ip6t_REJECT,xt_hl,ip6t_rt,ipt_REJECT,xt_LOG,xt_multiport,xt_limit,xt_tcpudp,xt_addrtype,xt_conntrack,ip6table_filter,ip6_tables,iptable_filter,ip_tables, 
Live 0xf8bb8000
videobuf2_vmalloc 13048 1 uvcvideo, Live 0xf8b4f000
snd_hwdep 13276 1 snd_hda_codec, Live 0xf8be6000
kvm_intel 138187 0 - Live 0xf8cae000
videobuf2_memops 13170 1 videobuf2_vmalloc, Live 0xf8ba6000
kvm 400338 1 kvm_intel, Live 0xf9156000
snd_pcm 96792 3 snd_hda_intel,snd_hda_controller,snd_hda_codec, Live 
0xf8bf4000
videobuf2_core 39843 1 uvcvideo, Live 0xf8bd4000
snd_seq_midi 13324 0 - Live 0xf8ad3000
videodev 122550 2 uvcvideo,videobuf2_core, Live 0xf8cd3000
hid_multitouch 17400 0 - Live 0xf8bb2000
joydev 17311 0 - Live 0xf8b84000
snd_seq_midi_event 14475 1 snd_seq_midi, Live 0xf8bad000
ttm 77855 1 radeon, Live 0xf8c7b000
snd_rawmidi 25518 1 snd_seq_midi, Live 0xf8b8e000
snd_seq 56978 2 snd_seq_midi,snd_seq_midi_event, Live 0xf8b6f000
drm_kms_helper 49335 1 radeon, Live 0xf8b98000
snd_seq_device 14137 3 snd_seq_midi,snd_rawmidi,snd_seq, Live 0xf8b7f000
drm 251130 4 radeon,ttm,drm_kms_helper, Live 0xf8c3c000
microcode 19509 0 - Live 0xf8bc1000
snd_timer 29035 2 snd_pcm,snd_seq, Live 0xf8beb000
ir_lirc_codec 12869 0 - Live 0xf8adf000
i2c_algo_bit 13316 1 radeon, Live 0xf8ace000
ir_mce_kbd_decoder 13151 0 - Live 0xf8ac9000
lirc_dev 19354 1 ir_lirc_codec, Live 0xf8b49000
ir_sanyo_decoder 12727 0 - Live 0xf8b44000
ir_sharp_decoder 12628 0 - Live 0xf8aa8000
ir_jvc_decoder 12655 0 - Live 0xf8b3c000
ir_rc6_decoder 12754 0 - Live 0xf8b34000
ir_rc5_decoder 12622 0 - Live 0xf8b2f000
ir_sony_decoder 12625 0 - Live 0xf8a95000
ir_nec_decoder 12787 0 - Live 0xf8afc000
snd 61616 10 
snd_hda_codec_realtek,snd_hda_codec_generic,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_rawmidi,snd_seq,snd_seq_device,snd_timer, 
Live 0xf8b1e000
psmouse 97301 0 - Live 0xf8b56000
soundcore 12600 2 snd_hda_codec,snd, Live 0xf8478000
rc_rc6_mce 12454 0 - Live 0xf8ac1000
serio_raw 13251 0 - Live 0xf8ab9000
mei_me 18104 0 - Live 0xf8aa2000
nuvoton_cir 17653 0 - Live 0xf8aae000
mei 71783 1 mei_me, Live 0xf8b0b000
rc_core 27285 13 
ir_lirc_codec,ir_mce_kbd_decoder,lirc_dev,ir_sanyo_decoder,ir_sharp_decoder,ir_jvc_decoder,ir_rc6_decoder,ir_rc5_decoder,ir_sony_decoder,ir_nec_decoder,rc_rc6_mce,nuvoton_cir, 
Live 0xf8a9a000
lpc_ich 17000 0 - Live 0xf8a89000
bcma 65052 1 - Loading 0xf8aef000
wmi 18843 1 dell_wmi_aio, Live 0xf8a79000
mac_hid 13099 0 - Live 0xf8ab4000
video 19348 0 - Live 0xf8a3c000
parport_pc 32154 1 - Live 0xf8a80000
ppdev 17423 0 - Live 0xf8a31000
lp 13359 0 - Live 0xf8a37000
parport 40945 3 parport_pc,ppdev,lp, Live 0xf8d81000
hid_generic 12503 0 - Live 0xf8434000
usb_storage 48923 0 - Live 0xf8a66000
usbhid 47452 0 - Live 0xf844b000
hid 87868 3 hid_multitouch,hid_generic,usbhid, Live 0xf8a4f000
ahci 29816 1 - Live 0xf8442000
r8169 62873 0 - Live 0xf8467000
libahci 30899 1 ahci, Live 0xf845a000
mii 13693 1 r8169, Live 0xf843d000

[7.4] Loaded driver and hardware
-------------------------------------------------------------
# cat /proc/ioports
0000-0cf7 : PCI Bus 0000:00
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0071 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0200-020f : pnp 00:01
0240-024e : nuvoton-cir
0250-025e : nuvoton-cir
02f8-02ff : serial
0378-037a : parport0
03c0-03df : vesafb
0400-0403 : ACPI PM1a_EVT_BLK
0404-0405 : ACPI PM1a_CNT_BLK
0408-040b : ACPI PM_TMR
0410-0415 : ACPI CPU throttle
0420-042f : ACPI GPE0_BLK
0430-0433 : iTCO_wdt
0450-0450 : ACPI PM2_CNT_BLK
0460-047f : iTCO_wdt
04d0-04d1 : pnp 00:06
0500-057f : gpio_ich
0500-057f : pnp 00:08
0530-053f : gpio_ich
0540-054f : gpio_ich
0a00-0a0f : pnp 00:01
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
1180-119f : pnp 00:08
d000-dfff : PCI Bus 0000:11
d000-d0ff : 0000:11:00.0
d000-d0ff : r8169
e000-efff : PCI Bus 0000:01
e000-e0ff : 0000:01:00.0
f000-f01f : 0000:00:1f.3
f020-f03f : 0000:00:1f.2
f020-f03f : ahci
f040-f043 : 0000:00:1f.2
f040-f043 : ahci
f050-f057 : 0000:00:1f.2
f050-f057 : ahci
f060-f063 : 0000:00:1f.2
f060-f063 : ahci
f070-f077 : 0000:00:1f.2
f070-f077 : ahci

# cat /proc/iomem
00000000-00000fff : reserved
00001000-0009d7ff : System RAM
0009d800-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000a0000-000bffff : Video RAM area
000c0000-000ce9ff : Video ROM
000e0000-000fffff : reserved
000f0000-000fffff : System ROM
00100000-bf595fff : System RAM
01000000-016a170c : Kernel code
016a170d-01a2657f : Kernel data
01b0f000-01bf3fff : Kernel bss
bf596000-bf5ddfff : ACPI Non-volatile Storage
bf5de000-bf5e6fff : ACPI Tables
bf5e7000-bf5e9fff : ACPI Non-volatile Storage
bf5ea000-bf616fff : reserved
bf617000-bf617fff : System RAM
bf618000-bf620fff : ACPI Non-volatile Storage
bf621000-bf623fff : reserved
bf624000-bf627fff : ACPI Non-volatile Storage
bf628000-bf647fff : reserved
bf648000-bf68afff : ACPI Non-volatile Storage
bf68b000-bf7fffff : System RAM
bf800000-bfffffff : RAM buffer
c0000000-ffffffff : PCI Bus 0000:00
c0000000-cfffffff : PCI Bus 0000:01
c0000000-cfffffff : 0000:01:00.0
d0100000-d01fffff : PCI Bus 0000:11
d0100000-d0103fff : 0000:11:00.0
d0100000-d0103fff : r8169
d0104000-d0104fff : 0000:11:00.0
d0104000-d0104fff : r8169
e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]
e0000000-efffffff : reserved
e0000000-efffffff : pnp 00:00
fe500000-fe5fffff : PCI Bus 0000:12
fe500000-fe503fff : 0000:12:00.0
fe500000-fe503fff : bcma-pci-bridge
fe600000-fe6fffff : PCI Bus 0000:01
fe600000-fe61ffff : 0000:01:00.0
fe620000-fe63ffff : 0000:01:00.0
fe700000-fe703fff : 0000:00:1b.0
fe700000-fe703fff : ICH HD audio
fe704000-fe7040ff : 0000:00:1f.3
fe705000-fe7057ff : 0000:00:1f.2
fe705000-fe7057ff : ahci
fe706000-fe7063ff : 0000:00:1d.0
fe706000-fe7063ff : ehci_hcd
fe707000-fe7073ff : 0000:00:1a.0
fe707000-fe7073ff : ehci_hcd
fe708000-fe70800f : 0000:00:16.0
fe708000-fe70800f : mei_me
fec00000-fec003ff : IOAPIC 0
fed00000-fed003ff : HPET 0
fed08000-fed08fff : pnp 00:08
fed14000-fed19fff : pnp 00:00
fed1c000-fed1ffff : reserved
fed1c000-fed1ffff : pnp 00:08
fed1f410-fed1f414 : iTCO_wdt
fed20000-fed3ffff : pnp 00:00
fed90000-fed93fff : pnp 00:00
fee00000-fee0ffff : pnp 00:00
fee00000-fee00fff : Local APIC
ff000000-ffffffff : reserved
ff000000-ffffffff : pnp 00:08
100000000-137ffffff : System RAM

[7.5.] PCI Information
-------------------------------------------------------------
#whoami
root
# sudo lspci -vvv

00:00.0 Host bridge: Intel Corporation Core Processor DRAM Controller 
(rev 18)
Subsystem: Dell Device 0478
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ >SERR- <PERR- INTx-
Latency: 0
Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:01.0 PCI bridge: Intel Corporation Core Processor PCI Express x16 
Root Port (rev 18) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
I/O behind bridge: 0000e000-0000efff
Memory behind bridge: fe600000-fe6fffff
Prefetchable memory behind bridge: 00000000c0000000-00000000cfffffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [88] Subsystem: Dell Device 0478
Capabilities: [80] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee0f00c Data: 4161
Capabilities: [a0] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE+
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #2, Speed 2.5GT/s, Width x16, ASPM L0s L1, Exit Latency L0s 
<256ns, L1 <4us
ClockPM- Surprise- LLActRep- BwNot+
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- 
BWMgmt+ ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet+ LinkState-
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF Not 
Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF 
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- 
ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, 
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [100 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
Status: NegoPending- InProgress-
Kernel driver in use: pcieport

00:16.0 Communication controller: Intel Corporation 5 Series/3400 Series 
Chipset HECI Controller (rev 06)
Subsystem: Dell Device 0478
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 43
Region 0: Memory at fe708000 (64-bit, non-prefetchable) [size=16]
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0f00c Data: 41b1
Kernel driver in use: mei_me

00:1a.0 USB controller: Intel Corporation 5 Series/3400 Series Chipset 
USB2 Enhanced Host Controller (rev 06) (prog-if 20 [EHCI])
Subsystem: Dell Device 0478
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 16
Region 0: Memory at fe707000 (32-bit, non-prefetchable) [size=1K]
Capabilities: [50] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Debug port: BAR=1 offset=00a0
Capabilities: [98] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: ehci-pci

00:1b.0 Audio device: Intel Corporation 5 Series/3400 Series Chipset 
High Definition Audio (rev 06)
Subsystem: Dell Device 0478
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 44
Region 0: Memory at fe700000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [50] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0f00c Data: 41d1
Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
Capabilities: [100 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
Status: NegoPending- InProgress-
VC1: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=1 ArbSelect=Fixed TC/VC=02
Status: NegoPending- InProgress-
Capabilities: [130 v1] Root Complex Link
Desc: PortNumber=0f ComponentID=00 EltType=Config
Link0: Desc: TargetPort=00 TargetComponent=00 AssocRCRB- 
LinkType=MemMapped LinkValid+
Addr: 00000000fed1c000
Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI 
Express Root Port 1 (rev 06) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=11, subordinate=11, sec-latency=0
I/O behind bridge: 0000d000-0000dfff
Memory behind bridge: fff00000-000fffff
Prefetchable memory behind bridge: 00000000d0100000-00000000d01fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE+
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s 
<256ns, L1 <4us
ClockPM- Surprise- LLActRep+ BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ 
BWMgmt- ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #0, PowerLimit 10.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet+ LinkState+
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not 
Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF 
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- 
ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, 
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
Address: 00000000 Data: 0000
Capabilities: [90] Subsystem: Dell Device 0478
Capabilities: [a0] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 5 Series/3400 Series Chipset PCI 
Express Root Port 2 (rev 06) (prog-if 00 [Normal decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Bus: primary=00, secondary=12, subordinate=12, sec-latency=0
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fe500000-fe5fffff
Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort+ <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0
ExtTag- RBE+
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
LnkCap: Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s 
<256ns, L1 <4us
ClockPM- Surprise- LLActRep+ BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ 
BWMgmt- ABWMgmt-
SltCap: AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
Slot #1, PowerLimit 10.000W; Interlock- NoCompl+
SltCtl: Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
SltSta: Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
Changed: MRL- PresDet+ LinkState+
RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
RootCap: CRSVisible-
RootSta: PME ReqID 0000, PMEStatus- PMEPending-
DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not 
Supported ARIFwd-
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF 
Disabled ARIFwd-
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- 
ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, 
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [80] MSI: Enable- Count=1/1 Maskable- 64bit-
Address: 00000000 Data: 0000
Capabilities: [90] Subsystem: Dell Device 0478
Capabilities: [a0] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 5 Series/3400 Series Chipset 
USB2 Enhanced Host Controller (rev 06) (prog-if 20 [EHCI])
Subsystem: Dell Device 0478
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin A routed to IRQ 23
Region 0: Memory at fe706000 (32-bit, non-prefetchable) [size=1K]
Capabilities: [50] Power Management version 2
Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Debug port: BAR=1 offset=00a0
Capabilities: [98] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: ehci-pci

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev a6) 
(prog-if 01 [Subtractive decode])
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
Latency: 0
Bus: primary=00, secondary=20, subordinate=20, sec-latency=32
I/O behind bridge: 0000f000-00000fff
Memory behind bridge: fff00000-000fffff
Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
Capabilities: [50] Subsystem: Dell Device 0478

00:1f.0 ISA bridge: Intel Corporation Mobile 5 Series Chipset LPC 
Interface Controller (rev 06)
Subsystem: Dell Device 0478
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Capabilities: [e0] Vendor Specific Information: Len=10 <?>
Kernel driver in use: lpc_ich

00:1f.2 SATA controller: Intel Corporation 5 Series/3400 Series Chipset 
6 port SATA AHCI Controller (rev 06) (prog-if 01 [AHCI 1.0])
Subsystem: Dell Device 0478
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0
Interrupt: pin B routed to IRQ 42
Region 0: I/O ports at f070 [size=8]
Region 1: I/O ports at f060 [size=4]
Region 2: I/O ports at f050 [size=8]
Region 3: I/O ports at f040 [size=4]
Region 4: I/O ports at f020 [size=32]
Region 5: Memory at fe705000 (32-bit, non-prefetchable) [size=2K]
Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
Address: fee0f00c Data: 41a1
Capabilities: [70] Power Management version 3
Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
Capabilities: [b0] PCI Advanced Features
AFCap: TP+ FLR+
AFCtrl: FLR-
AFStatus: TP-
Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 5 Series/3400 Series Chipset SMBus 
Controller (rev 06)
Subsystem: Dell Device 0478
Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
Interrupt: pin C routed to IRQ 11
Region 0: Memory at fe704000 (64-bit, non-prefetchable) [size=256]
Region 4: I/O ports at f000 [size=32]

01:00.0 VGA compatible controller: Advanced Micro Devices, Inc. 
[AMD/ATI] Park [Mobility Radeon HD 5430/5450/5470] (prog-if 00 [VGA 
controller])
Subsystem: Dell Device 0478
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 45
Region 0: Memory at c0000000 (64-bit, prefetchable) [size=256M]
Region 2: Memory at fe620000 (64-bit, non-prefetchable) [size=128K]
Region 4: I/O ports at e000 [size=256]
Expansion ROM at fe600000 [disabled] [size=128K]
Capabilities: [50] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [58] Express (v2) Legacy Endpoint, MSI 00
DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
LnkCap: Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Exit Latency L0s 
<64ns, L1 <1us
ClockPM- Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- 
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Range ABCD, TimeoutDis+, LTR-, OBFF Not 
Supported
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- 
ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-, 
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0f00c Data: 41e1
Capabilities: [100 v1] Vendor Specific Information: ID=0001 Rev=1 
Len=010 <?>
Capabilities: [150 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- 
ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- 
ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ 
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
Kernel driver in use: radeon

11:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
Subsystem: Dell Device 0478
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx+
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 41
Region 0: I/O ports at d000 [size=256]
Region 2: Memory at d0104000 (64-bit, prefetchable) [size=4K]
Region 4: Memory at d0100000 (64-bit, prefetchable) [size=16K]
Capabilities: [40] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [50] MSI: Enable+ Count=1/1 Maskable- 64bit+
Address: 00000000fee0f00c Data: 4181
Capabilities: [70] Express (v2) Endpoint, MSI 01
DevCap: MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s 
<512ns, L1 <64us
ClockPM+ Surprise- LLActRep- BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- 
BWMgmt- ABWMgmt-
DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, OBFF Not 
Supported
DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF Disabled
LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
Transmit Margin: Normal Operating Range, EnterModifiedCompliance- 
ComplianceSOS-
Compliance De-emphasis: -6dB
LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-, 
EqualizationPhase1-
EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
Capabilities: [b0] MSI-X: Enable- Count=4 Masked-
Vector table: BAR=4 offset=00000000
PBA: BAR=4 offset=00000800
Capabilities: [d0] Vital Product Data
Unknown small resource type 00, will not decode more.
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- 
ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- 
ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ 
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
Capabilities: [140 v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
Status: NegoPending- InProgress-
Capabilities: [160 v1] Device Serial Number 23-00-00-00-68-4c-e0-00
Kernel driver in use: r8169

12:00.0 Network controller: Broadcom Corporation BCM4313 802.11bgn 
Wireless Network Adapter (rev 01)
Subsystem: Dell Inspiron M5010 / XPS 8300
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 17
Region 0: Memory at fe500000 (64-bit, non-prefetchable) [size=16K]
Capabilities: [40] Power Management version 3
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=2 PME-
Capabilities: [58] Vendor Specific Information: Len=78 <?>
Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
Address: 0000000000000000 Data: 0000
Capabilities: [d0] Express (v1) Endpoint, MSI 00
DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
MaxPayload 128 bytes, MaxReadReq 128 bytes
DevSta: CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Exit Latency L0s 
<4us, L1 <64us
ClockPM+ Surprise- LLActRep+ BwNot-
LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- CommClk+
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ 
BWMgmt- ABWMgmt-
Capabilities: [100 v1] Advanced Error Reporting
UESta: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- 
ECRC- UnsupReq- ACSViol-
UEMsk: DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- 
ECRC- UnsupReq- ACSViol-
UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ 
MalfTLP+ ECRC- UnsupReq- ACSViol-
CESta: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
CEMsk: RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
AERCap: First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
Capabilities: [13c v1] Virtual Channel
Caps: LPEVC=0 RefClk=100ns PATEntryBits=1
Arb: Fixed- WRR32- WRR64- WRR128-
Ctrl: ArbSelect=Fixed
Status: InProgress-
VC0: Caps: PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
Arb: Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
Ctrl: Enable+ ID=0 ArbSelect=Fixed TC/VC=01
Status: NegoPending- InProgress-
Capabilities: [160 v1] Device Serial Number 00-00-4c-ff-ff-7f-5c-ac
Capabilities: [16c v1] Power Budgeting <?>
Kernel driver in use: bcma-pci-bridge

ff:00.0 Host bridge: Intel Corporation Core Processor QuickPath 
Architecture Generic Non-core Registers (rev 05)
Subsystem: Dell Device 0478
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:00.1 Host bridge: Intel Corporation Core Processor QuickPath 
Architecture System Address Decoder (rev 05)
Subsystem: Dell Device 0478
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:02.0 Host bridge: Intel Corporation Core Processor QPI Link 0 (rev 05)
Subsystem: Dell Device 0478
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:02.1 Host bridge: Intel Corporation Core Processor QPI Physical 0 
(rev 05)
Subsystem: Dell Device 0478
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:02.2 Host bridge: Intel Corporation Core Processor Reserved (rev 05)
Subsystem: Dell Device 0478
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
Latency: 0

ff:02.3 Host bridge: Intel Corporation Core Processor Reserved (rev 05)
Subsystem: Dell Device 0478
Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
Latency: 0

[7.6] SCSI Information
-------------------------------------------------------------
# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
Vendor: HL-DT-ST Model: DVD+-RW GT32N Rev: A102
Type: CD-ROM ANSI SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
Vendor: ATA Model: WDC WD7501AAES-7 Rev: 05.0
Type: Direct-Access ANSI SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 00
Vendor: SAMSUNG Model: HM750LI Rev: 2AM1
Type: Direct-Access ANSI SCSI revision: 02
Host: scsi7 Channel: 00 Id: 00 Lun: 00
Vendor: TSSTcorp Model: CDDVDW SE-S204N Rev: TS01
Type: CD-ROM ANSI SCSI revision: 00

[7.7.] Other information
-------------------------------------------------------------
# ls /proc
1
10
11
12
13
134
135
136
137
138
139
140
141
142
143
144
145
146
15
153
159
16
160
161
162
163
164
17
177
18
184
185
186
19
2
20
207
21
22
223
23
24
25
26
27
28
29
3
30
303
31
32
33
34
35
353
358
36
37
38
39
40
41
413
416
43
430
433
45
459
46
460
462
47
471
495
5
542
59
60
61
62
63
7
712
717
742
759
773
777
778
8
82
83
9
acpi
asound
buddyinfo
bus
cgroups
cmdline
consoles
cpuinfo
crypto
devices
diskstats
dma
driver
execdomains
fb
filesystems
fs
interrupts
iomem
ioports
irq
kallsyms
kcore
key-users
kmsg
kpagecount
kpageflags
latency_stats
loadavg
locks
mdstat
meminfo
misc
modules
mounts
mtrr
net
pagetypeinfo
partitions
sched_debug
schedstat
scsi
self
slabinfo
softirqs
stat
swaps
sys
sysrq-trigger
sysvipc
timer_list
timer_stats
tty
uptime
version
vmallocinfo
vmstat
zoneinfo

[X.] Other note, patchs, fixes, workarrounds
Launchpad bug report
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1309730

Workarround : with grub i could select kernel linux 3.11.0-20 and boot 
(i us this version to send this mail)
However system cannot update saying "Broken packaging: 0"

Feel free to :
- ask me more information. Please provide the procedure to get it.
- forward this bug to any other list if you consider they could be more 
involved than your list
Thanks





--------------040307060702020209040804
Content-Type: text/x-vcard; charset=utf-8;
 name="ludo_cheron.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ludo_cheron.vcf"

begin:vcard
fn:Ludovic CHERON
n:CHERON;Ludovic
email;internet:ludo.cheron@laposte.net
tel;cell:06.18.04.71.41
note;quoted-printable:Ce compte de messagerie est d=C3=A9di=C3=A9 aux abonnements et fournisseu=
	rs sollicit=C3=A9s uniquement.=0D=0A=
	L'usage sans accord =C3=A9crit des informations de cooordonn=C3=A9es e-ma=
	il, t=C3=A9l=C3=A9phonique, postales =
	=0D=0A=
	ou de toute autre information personnelle incluse dans cet e-mail, parunm=
	oyen manuel ou automatis=C3=A9 entrainera des poursuites.
version:2.1
end:vcard


--------------040307060702020209040804--
