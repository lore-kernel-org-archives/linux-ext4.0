From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 19212] New: kernel BUG at
 /build/buildd/linux-2.6.32/fs/ext4/extents.c:1716
Date: Tue, 28 Sep 2010 01:56:26 GMT
Message-ID: <bug-19212-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:39652 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757688Ab0I1B41 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Sep 2010 21:56:27 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o8S1uQF3026377
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 28 Sep 2010 01:56:26 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=19212

           Summary: kernel BUG at
                    /build/buildd/linux-2.6.32/fs/ext4/extents.c:1716
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.32
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: kernel_sm@ChinaNetCloud.com
        Regression: No


Just started hitting this error quite often - server has been fine for months
but now we get these after every reboot, sometimes within a minute or two, or
after a few hours.  Leaves processes in zombie or D/D+ state so have to reboot.

fsck on file system is all clean, but get errors on forced (see below)

On Ubuntu Server - their kernel 2.6.32-24-server

Heavy I/O load with 24 disks on JBOD controller, which is Adaptec 5405, no
RAID, no LVM, no DM - handling 200-300MB/sec across 24 disks, so pretty heavily
loaded.  Running irq balance.  16 core machine with 48GB RAM, 50% for FS cache.

Kernel log all the same:

[ 1131.377420] ------------[ cut here ]------------
[ 1131.382074] kernel BUG at /build/buildd/linux-2.6.32/fs/ext4/extents.c:1716!
[ 1131.389143] invalid opcode: 0000 [#1] SMP 
[ 1131.393307] last sysfs file:
/sys/devices/pci0000:00/0000:00:07.0/0000:05:00.1/irq
[ 1131.400958] CPU 6 
[ 1131.403065] Modules linked in: dm_crypt nf_conntrack ipmi_poweroff
ipmi_devintf iptable_filter ip_tables x_tables ipmi_si ipmi_msghandler psmouse
serio_raw lp ioatdma parport ses enclosure floppy usbhid hid aacraid igb dca
[ 1131.423431] Pid: 17059, comm: transmission-da Not tainted 2.6.32-24-server
#38-Ubuntu X8DT3
[ 1131.431904] RIP: 0010:[<ffffffff812015cf>]  [<ffffffff812015cf>]
ext4_ext_insert_extent+0x45f/0x470
[ 1131.441014] RSP: 0018:ffff880622b31898  EFLAGS: 00010246
[ 1131.446441] RAX: 0000000000000000 RBX: ffff880bc913c780 RCX:
ffff8809ca68f000
[ 1131.453682] RDX: 0000000000028308 RSI: ffff880622b319a8 RDI:
ffff880be7d64930
[ 1131.460841] RBP: ffff880622b31908 R08: ffff880bc913c7e0 R09:
ffffea0022446f50
[ 1131.468003] R10: 0000000000000000 R11: 0000000000000001 R12:
ffff880c14f84218
[ 1131.475213] R13: ffff880bc913c780 R14: ffff8809ca68f00c R15:
0000000000000002
[ 1131.482363] FS:  00007f2e1249e910(0000) GS:ffff880655480000(0000)
knlGS:0000000000000000
[ 1131.490502] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1131.496260] CR2: 00007f2e037fb000 CR3: 0000000c1055e000 CR4:
00000000000006e0
[ 1131.503528] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[ 1131.510674] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[ 1131.517830] Process transmission-da (pid: 17059, threadinfo
ffff880622b30000, task ffff880622478000)
[ 1131.527054] Stack:
[ 1131.529096]  ffff880622b318b8 ffff88017179bff0 ffff880bc913c7e0
ffff8809ca68f000
[ 1131.536420] <0> 01ff880622b318f8 ffff880c111634f8 ffff880622b319a8
ffff880c14f84158
[ 1131.544234] <0> ffff880b6b47aaf0 ffff88017179bff0 ffff880c14f84218
000000000000007c
[ 1131.552280] Call Trace:
[ 1131.554765]  [<ffffffff81202042>]
ext4_ext_convert_to_initialized+0x3f2/0x8a0
[ 1131.561938]  [<ffffffff812026f9>]
ext4_ext_handle_uninitialized_extents+0x209/0x2a0
[ 1131.569640]  [<ffffffff81202a7f>] ext4_ext_get_blocks+0x2ef/0x790
[ 1131.575834]  [<ffffffff810f3e80>] ? find_get_pages_tag+0x40/0x120
[ 1131.582007]  [<ffffffff811df638>] ext4_get_blocks+0xf8/0x2a0
[ 1131.587699]  [<ffffffff810fe995>] ? pagevec_lookup_tag+0x25/0x40
[ 1131.593783]  [<ffffffff811e02ac>] mpage_da_map_blocks+0xac/0x390
[ 1131.599819]  [<ffffffff811f8760>] ? ext4_journal_start_sb+0x100/0x140
[ 1131.606330]  [<ffffffff811e0866>] ext4_da_writepages+0x2d6/0x620
[ 1131.612360]  [<ffffffff810ff0bc>] ? release_pages+0x24c/0x2a0
[ 1131.618134]  [<ffffffff810fdb41>] do_writepages+0x21/0x40
[ 1131.623555]  [<ffffffff810f4b4b>] __filemap_fdatawrite_range+0x5b/0x60
[ 1131.630171]  [<ffffffff810f4e7f>] filemap_fdatawrite+0x1f/0x30
[ 1131.636028]  [<ffffffff810f4ec5>] filemap_write_and_wait+0x35/0x50
[ 1131.642232]  [<ffffffff81154639>] ioctl_fiemap+0x149/0x190
[ 1131.647772]  [<ffffffff811548c3>] do_vfs_ioctl+0x103/0x410
[ 1131.653363]  [<ffffffff8111a128>] ? do_munmap+0x2c8/0x360
[ 1131.658789]  [<ffffffff81154c51>] sys_ioctl+0x81/0xa0
[ 1131.663895]  [<ffffffff810131b2>] system_call_fastpath+0x16/0x1b
[ 1131.669927] Code: 01 00 00 00 2d 00 80 00 00 e9 29 ff ff ff 48 8d 41 0c 49
89 40 10 e9 48 fe ff ff 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe <0f> 0b
eb fe 0f 0b eb fe 0f 0b eb fe 0f 1f 44 00 00 55 48 89 e5 
[ 1131.690470] RIP  [<ffffffff812015cf>] ext4_ext_insert_extent+0x45f/0x470
[ 1131.697237]  RSP <ffff880622b31898>
[ 1131.707232] ---[ end trace a009c388a3f058e1 ]---

fsck forced output on the FS involved:

fsck from util-linux-ng 2.16
e2fsck 1.41.9 (22-Aug-2009)
/dev/sdc1: recovering journal
Pass 1: Checking inodes, blocks, and sizes
Inode 106823682, i_blocks is 8696600, should be 8729368.  Fix<y>? yes

Inode 111018138, i_blocks is 4585784, should be 4586744.  Fix<y>? yes

Running additional passes to resolve blocks claimed by more than one inode...
Pass 1B: Rescanning for multiply-claimed blocks
Multiply-claimed block(s) in inode 106823682: 275167232 275167233 275167234
275167235 275167236 275167237 275167238 275167239 275167240 275167241 275167242
275167243 275167244 275167245 275167246 275167247 275167248 275167249 275167250
275167251 
-- Cut about 5 pages --
415282026 415282027 415282028 415282029 415282030 415282031 415282032 415282033
415282034 415282035 415282036 415282037 415282038 415282039 415282040 415282041
415282042 415282043 415282044 415282045 415282046 415282047
Pass 1C: Scanning directories for inodes with multiply-claimed blocks
Pass 1D: Reconciling multiply-claimed blocks
(There are 2 inodes containing multiply-claimed blocks.)

File
/3_available/6d6482c93f1592a00e154f1e43f842810829976c/[Wii]Resident_Evil_The_Umbrella_Chronicles[PAL][ESPALWii.com].rar
(inode #106823682, mod time Wed Sep 22 16:42:42 2010) 
  has 8192 multiply-claimed block(s), shared with 0 file(s):
Clone multiply-claimed blocks<y>? yes

File
/0_downloading/3f9f5e55ece967f482da0ae8b98e85ee3fe8ce1d/[M-eM-^NM-^FM-eM-^OM-2M-iM-"M-^QM-iM-^AM-^S
M-eM-.M-^GM-eM-.M-^Y M-gM-,M-,M-dM-:M-^LM-eM--M-#6
M-fM-^ZM-^WM-gM-^IM-)M-hM-4M-(
M-eM-^EM-(18M-iM-^[M-^F][MKV][2.18G][720P][M-hM-^KM-1M-hM-/M--M-dM-8M--M-eM--M-^W]/nothing.The.Universe.S02.Ep06.Blu-ray.720p.AC3.HDBRiSe.mkv
(inode #111018138, mod time Sun Sep 26 21:28:53 2010) 
  has 240 multiply-claimed block(s), shared with 0 file(s):
Clone multiply-claimed blocks<y>? yes

Pass 2: Checking directory structure

Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Free blocks count wrong for group #0 (2035, counted=0).
Fix<y>? yes

Free blocks count wrong for group #1 (985, counted=0).
Fix<y>? yes

Free blocks count wrong for group #2 (287, counted=0).
Fix<y>? yes

Free blocks count wrong for group #3 (1, counted=0).
Fix<y>? yes

Free blocks count wrong for group #8 (2608, counted=1700).
Fix<y>? yes

Free blocks count wrong (45373169, counted=45368953).
Fix<y>? yes

/dev/sdc1: ***** FILE SYSTEM WAS MODIFIED *****
/dev/sdc1: 24249/121896960 files (12.3% non-contiguous), 442215837/487584790
blocks

SECOND fsck RUN after above:

root@u01:~# fsck -f -y /dev/sdc1
fsck from util-linux-ng 2.16
e2fsck 1.41.9 (22-Aug-2009)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/sdc1: 24249/121896960 files (12.3% non-contiguous), 442215837/487584790
blocks

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
