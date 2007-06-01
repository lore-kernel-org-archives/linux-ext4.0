From: Andrew Morton <akpm@linux-foundation.org>
Subject: Fw: ext3 dir_index causes an error
Date: Thu, 31 May 2007 21:15:46 -0700
Message-ID: <20070531211546.86fc9db8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: hooanon05@yahoo.co.jp, sct@redhat.com, adilger@clusterfs.com,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58909 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754227AbXFAEQ3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Jun 2007 00:16:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Ted is dir_index maintainer ;)

That's a nice-looking bug report, btw.  Thanks.


Begin forwarded message:

Date: Fri, 01 Jun 2007 13:01:07 +0900
From: hooanon05@yahoo.co.jp
To: sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com
Subject: ext3 dir_index causes an error



Hello,

First of all, I really appricate your great works.
Now I've found a problem around dir_index feature.
Here is a report following linux/REPORTING-BUGS.


[1.] One line summary of the problem:
ext3 dir_index causes an error

[2.] Full description of the problem/report:
This is my local test program to reproduce this problem. The
readdir1.c calls creat(2), opendir(3) and readdir(3). And the shell
script execute it repeatedly with a brand-new ext3fs image on a
loopback device.
When the script adds '-O dir_index' to mkfs, some errors appear.

On a system with linux-2.6.21.3, ext3fs produces these error message,
and the filesystem seems to be corrupted.
----------------------------------------------------------------------
kjournald starting.  Commit interval 5 seconds
EXT3 FS on loop0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
	:::
EXT3-fs: mounted filesystem with ordered data mode.
EXT3-fs error (device loop0): htree_dirblock_to_tree: bad entry in directory #2: rec_len is too small for name_len - offset=6924, inode=26, rec_len=244, name_len=249
EXT3-fs error (device loop0): htree_dirblock_to_tree: bad entry in directory #2: rec_len is too small for name_len - offset=6924, inode=26, rec_len=244, name_len=249
EXT3-fs error (device loop0): htree_dirblock_to_tree: bad entry in directory #2: rec_len is too small for name_len - offset=6924, inode=26, rec_len=244, name_len=249
kjournald starting.  Commit interval 5 seconds
	:::
----------------------------------------------------------------------

On the other system with linux-2.6.18 (debian etch kernel), the same
error appears.
When the script adds '-O ^dir_index' to mkfs, the problem never appears.

It is not everytime that these errors appear. So the shell script
executes the readdir1 test program repeatedly.
Recently I upgraded my debian system from version 3.1 'sarge' to 4.0
'etch'. The debian etch sets the dir_index feature by default. So I
found this problem.

[3.] Keywords (i.e., modules, networking, kernel):
ext3 dir_index

[4.] Kernel information
[4.1.] Kernel version (from /proc/version):
[4.2.] Kernel .config file:
[5.] Most recent kernel version which did not have the bug:
[6.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/oops-tracing.txt)
[7.] A small shell script or example program which triggers the
     problem (if possible)

(readdir1.c)

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <assert.h>
#include <string.h>
#include <errno.h>

void fin(char *s)
{
	perror(s);
	exit(1);
}

void msg(int found, char *fname)
{
	printf("%s%s found\n", fname, found?"":" not");
}

int
main(int argc, char *argv[])
{
	DIR *dp;
	struct dirent *de;
	int err, found, i;
	char a[250];

	err = chdir(argv[1]);
	if (err)
		fin("chdir");

	memset(a, 'a', sizeof(a)-1);
	a[sizeof(a)-1] = 0;
	for (i = 0; i < 16+1; i++) {
		a[0]++;
		err = creat(a, 0644);
		if (err < 0)
			fin("creat");

		err = creat(argv[2], 0644);
		if (err < 0)
			fin("creat");
	}

#if 0
	err = unlink(argv[2]);
	if (err && errno != ENOENT)
		fin("unlink");
#endif

	dp = opendir(".");
	if (!dp)
		fin("opendir");

	de = readdir(dp);
	if (!de)
		fin("1st readdir");
	assert(strcmp(argv[2], de->d_name));

#if 0
	argv[2][0]++;
	err = creat(argv[2], 0644);
	if (err < 0)
		fin("creat");

	argv[2][0]--;
#endif
	err = creat(argv[2], 0644);
	if (err < 0)
		fin("creat");

#if 0
	err = unlink(argv[2]);
	if (err && errno != ENOENT)
		fin("unlink");
#endif

	found = 0;
	while ((de = readdir(dp)) && !found)
		found = !strcmp(argv[2], de->d_name);
	msg(found, argv[2]);

	found = 0;
	rewinddir(dp);
	while ((de = readdir(dp)) && !found)
		found = !strcmp(argv[2], de->d_name);
	msg(found, argv[2]);

	closedir(dp);
	dp = opendir(".");
	if (!dp)
		fin("opendir");

	found = 0;
	while ((de = readdir(dp)) && !found)
		found = !strcmp(argv[2], de->d_name);
	msg(found, argv[2]);

	return 0;
}
----------------------------------------------------------------------
#!/bin/sh

img=rw.img
dir=rw
set -e
make /tmp/readdir1

cd /dev/shm
dd if=/dev/zero of=$img bs=1k count=4k 2> /dev/null
mkdir -p $dir
ulimit -c unlimited

while true
do
	mkfs -t ext3 -q -F -b 1024 -i 1024 -O dir_index $img > /dev/null
	#mkfs -t ext3 -q -F -b 1024 -i 1024 -O ^dir_index $img > /dev/null
	sudo mount -o loop $img $dir
	sudo chmod a+w $dir
	/tmp/readdir1 $dir test_readdir1 > /dev/null
	sudo umount $dir
done
----------------------------------------------------------------------

[8.] Environment
[8.1.] Software (add the output of the ver_linux script here)
$ ../linux-2.6.21.3/scripts/ver_linux 
If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux jrous 2.6.21.3jrousD #12 SMP PREEMPT Thu May 31 16:37:42 JST 2007 i686 GNU/Linux
 
Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17
util-linux             2.12r
mount                  2.12r
module-init-tools      3.3-pre2
e2fsprogs              1.40-WIP
reiserfsprogs          3.6.19
xfsprogs               2.8.11
Linux C Library        2.3.6
Dynamic linker (ldd)   2.3.6
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
oprofile               0.9.2
Sh-utils               5.97
udev                   105
Modules Loaded         loop ipt_LOG nfsd exportfs nfs lockd nfs_acl sunrpc xt_state iptable_filter ide_cd rtc cdrom evdev

[8.2.] Processor information (from /proc/cpuinfo):
$ cat /proc/cpuinfo 
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 15
model		: 2
model name	: Intel(R) Pentium(R) 4 CPU 1.80GHz
stepping	: 4
cpu MHz		: 1816.213
cache size	: 512 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 2
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm up
bogomips	: 3635.24
clflush size	: 64

[8.3.] Module information (from /proc/modules):
$ cat /proc/modules 
loop 13352 2 - Live 0xc4867000
ipt_LOG 6272 1 - Live 0xc4828000
nfsd 91560 13 - Live 0xc895f000
exportfs 4992 1 nfsd, Live 0xc4831000
nfs 116432 1 - Live 0xc8941000
lockd 56680 3 nfsd,nfs, Live 0xc8894000
nfs_acl 3200 2 nfsd,nfs, Live 0xc482f000
sunrpc 145468 11 nfsd,nfs,lockd,nfs_acl, Live 0xc88aa000
xt_state 2304 1 - Live 0xc482d000
iptable_filter 2688 1 - Live 0xc482b000
ide_cd 34080 0 - Live 0xc486c000
rtc 10136 0 - Live 0xc4821000
cdrom 33312 1 ide_cd, Live 0xc4834000
evdev 8064 0 - Live 0xc4825000

[8.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
::::::::::::::
/proc/ioports
::::::::::::::
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:02.5
  0170-0177 : ide1
01f0-01f7 : 0000:00:02.5
  01f0-01f7 : ide0
0376-0376 : 0000:00:02.5
  0376-0376 : ide1
03c0-03df : vga+
03f0-03f1 : pnp 00:0c
03f6-03f6 : 0000:00:02.5
  03f6-03f6 : ide0
03f8-03ff : serial
0480-048f : pnp 00:02
0cf8-0cff : PCI conf1
a000-a0ff : 0000:00:03.0
  a000-a0ff : sis900
a400-a47f : 0000:00:02.7
a800-a8ff : 0000:00:02.7
b800-b80f : 0000:00:02.5
  b800-b807 : ide0
  b808-b80f : ide1
d000-dfff : PCI Bus #01
  d800-d87f : 0000:01:00.0
e400-e47f : pnp 00:02
  e400-e403 : ACPI PM1a_EVT_BLK
  e404-e405 : ACPI PM1a_CNT_BLK
  e408-e40b : ACPI PM_TMR
  e420-e423 : ACPI GPE0_BLK
  e430-e433 : ACPI GPE1_BLK
e480-e4ff : pnp 00:02
e600-e61f : 0000:00:02.1
  e600-e61f : pnp 00:02
::::::::::::::
/proc/iomem
::::::::::::::
00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cbfff : Video ROM
000f0000-000fffff : System ROM
00100000-03ffffff : System RAM
  00100000-002e9d05 : Kernel code
  002e9d06-003ca1bb : Kernel data
10000000-1001ffff : 0000:00:03.0
ce000000-ce000fff : 0000:00:03.0
  ce000000-ce000fff : sis900
ce800000-ce800fff : 0000:00:02.3
cf000000-cf000fff : 0000:00:02.2
cf800000-cfffffff : PCI Bus #01
  cf800000-cf81ffff : 0000:01:00.0
    cf800000-cf81ffff : sisfb MMIO
d0000000-dfffffff : 0000:00:00.0
f0000000-febfffff : PCI Bus #01
  f0000000-f7ffffff : 0000:01:00.0
    f0000000-f3ffffff : sisfb FB
fec00000-fecfffff : pnp 00:00
ffee0000-ffefffff : pnp 00:02
fffe0000-ffffffff : pnp 00:03

[8.5.] PCI information ('lspci -vvv' as root)
$ sudo lspci -vvv
00:00.0 Host bridge: Silicon Integrated Systems [SiS] 650/M650 Host (rev 01)
	Subsystem: ASUSTeK Computer Inc. Unknown device 8079
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR-
	Latency: 32
	Region 0: Memory at d0000000 (32-bit, non-prefetchable) [size=256M]
	Capabilities: [c0] AGP version 2.0
		Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2,x4
		Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>

00:01.0 PCI bridge: Silicon Integrated Systems [SiS] Virtual PCI-to-PCI bridge (AGP) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 64
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: cf800000-cfffffff
	Prefetchable memory behind bridge: f0000000-febfffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-

00:02.0 ISA bridge: Silicon Integrated Systems [SiS] SiS961 [MuTIOL Media IO]
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 0

00:02.1 SMBus: Silicon Integrated Systems [SiS] SiS961/2 SMBus Controller
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin B routed to IRQ 0
	Region 4: I/O ports at e600 [size=32]

00:02.2 USB Controller: Silicon Integrated Systems [SiS] USB 1.0 Controller (rev 07) (prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc. Unknown device 807a
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR+
	Latency: 32 (20000ns max), Cache Line Size: 32 bytes
	Interrupt: pin D routed to IRQ 3
	Region 0: Memory at cf000000 (32-bit, non-prefetchable) [size=4K]

00:02.3 USB Controller: Silicon Integrated Systems [SiS] USB 1.0 Controller (rev 07) (prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc. Unknown device 807a
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (20000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 6
	Region 0: Memory at ce800000 (32-bit, non-prefetchable) [size=4K]

00:02.5 IDE interface: Silicon Integrated Systems [SiS] 5513 [IDE] (rev d0) (prog-if 80 [Master])
	Subsystem: ASUSTeK Computer Inc. Unknown device 807a
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 128
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
	Region 4: I/O ports at b800 [size=16]

00:02.7 Multimedia audio controller: Silicon Integrated Systems [SiS] AC'97 Sound Controller (rev a0)
	Subsystem: ASUSTeK Computer Inc. Unknown device 8072
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (13000ns min, 2750ns max)
	Interrupt: pin C routed to IRQ 7
	Region 0: I/O ports at a800 [size=256]
	Region 1: I/O ports at a400 [size=128]
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:03.0 Ethernet controller: Silicon Integrated Systems [SiS] SiS900 PCI Fast Ethernet (rev 90)
	Subsystem: ASUSTeK Computer Inc. Unknown device 807c
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Latency: 32 (13000ns min, 2750ns max)
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at a000 [size=256]
	Region 1: Memory at ce000000 (32-bit, non-prefetchable) [size=4K]
	[virtual] Expansion ROM at 10000000 [disabled] [size=128K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:00.0 VGA compatible controller: Silicon Integrated Systems [SiS] 65x/M650/740 PCI/AGP VGA Display Adapter (prog-if 00 [VGA])
	Subsystem: ASUSTeK Computer Inc. Unknown device 8079
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin A routed to IRQ 11
	BIST result: 00
	Region 0: Memory at f0000000 (32-bit, prefetchable) [size=128M]
	Region 1: Memory at cf800000 (32-bit, non-prefetchable) [size=128K]
	Region 2: I/O ports at d800 [size=128]
	Capabilities: [40] Power Management version 1
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] AGP version 2.0
		Status: RQ=16 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2,x4
		Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=<none>

[8.6.] SCSI information (from /proc/scsi/scsi)
[8.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
[X.] Other notes, patches, fixes, workarounds:
