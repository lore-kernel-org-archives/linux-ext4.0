From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14734] New: BUG: unable to handle kernel NULL pointer
 dereference at 0000000000000808
Date: Fri, 4 Dec 2009 15:39:30 GMT
Message-ID: <bug-14734-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43504 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723AbZLDPjY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Dec 2009 10:39:24 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nB4FdUQs026453
	for <linux-ext4@vger.kernel.org>; Fri, 4 Dec 2009 15:39:30 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14734

           Summary: BUG: unable to handle kernel NULL pointer dereference
                    at 0000000000000808
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.31.6
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: stmcdermott@gmail.com
        Regression: No


Just let me know what else I should post in addition to the following. I've
gotten this bug pretty consistently, on 2.6.

CPU:  Intel(R) Core(TM)2 Duo CPU     E8500

Dec  4 10:05:12 absolutegeek kernel: [293145.916266] BUG: unable to handle
kernel NULL pointer dereference at 0000000000000808
Dec  4 10:05:12 absolutegeek kernel: [293145.916307] IP: [<ffffffff810a0f13>]
find_get_pages+0x5f/0xbb
Dec  4 10:05:12 absolutegeek kernel: [293145.916332] PGD 11cce3067 PUD
12bc65067 PMD 0
Dec  4 10:05:12 absolutegeek kernel: [293145.916357] Oops: 0000 [#1] SMP
Dec  4 10:05:12 absolutegeek kernel: [293145.916378] last sysfs file:
/sys/module/ip_tables/initstate
Dec  4 10:05:12 absolutegeek kernel: [293145.916400] CPU 0
Dec  4 10:05:12 absolutegeek kernel: [293145.916417] Modules linked in:
xt_multiport iptable_filter ip_tables x_tables ipv6 nfsd nfs lockd nfs_acl
auth_rpcgss sunrpc sbp2 loop snd_pcm snd_timer arc4 snd soundcore
snd_page_alloc ecb i2c_nforce2 ath5k mac80211 led_class ath i2c_core button
pcspkr processor evdev cfg80211 rfkill serio_raw sg sr_mod usbhid hid cdrom
sd_mod ata_generic sata_nv usb_storage ohci1394 ieee1394 sata_sil24 libata
scsi_mod amd74xx ide_pci_generic ide_core forcedeth ohci_hcd ehci_hcd thermal
fan thermal_sys [last unloaded: scsi_wait_scan]
Dec  4 10:05:12 absolutegeek kernel: [293145.916658] Pid: 21012, comm: rm Not
tainted 2.6.31.6-custom2 #2 System Product Name
Dec  4 10:05:12 absolutegeek kernel: [293145.916693] RIP:
0010:[<ffffffff810a0f13>]  [<ffffffff810a0f13>] find_get_pages+0x5f/0xbb
Dec  4 10:05:12 absolutegeek kernel: [293145.916729] RSP: 0018:ffff88011e32dd38
 EFLAGS: 00010213
Dec  4 10:05:12 absolutegeek kernel: [293145.916750] RAX: ffffffffffffffff RBX:
0000000000000008 RCX: 0000000000000002
Dec  4 10:05:12 absolutegeek kernel: [293145.916784] RDX: 0000000000000002 RSI:
ffffea0002c5fa98 RDI: 0000000000000800
Dec  4 10:05:12 absolutegeek kernel: [293145.916818] RBP: ffff88011e32de18 R08:
0000000000000003 R09: 0000000000000009
Dec  4 10:05:12 absolutegeek kernel: [293145.916852] R10: 0000000000000040 R11:
ffff880059041f58 R12: 0000000000000008
Dec  4 10:05:12 absolutegeek kernel: [293145.916885] R13: ffff88011e32ddd8 R14:
0000000000000009 R15: ffff880059040878
Dec  4 10:05:12 absolutegeek kernel: [293145.916920] FS: 
00007f9a3e6816f0(0000) GS:ffff880028022000(0000) knlGS:0000000000000000
Dec  4 10:05:12 absolutegeek kernel: [293145.916955] CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
Dec  4 10:05:12 absolutegeek kernel: [293145.916976] CR2: 0000000000000808 CR3:
00000001103df000 CR4: 00000000000006f0
Dec  4 10:05:12 absolutegeek kernel: [293145.917010] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Dec  4 10:05:12 absolutegeek kernel: [293145.917044] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Dec  4 10:05:12 absolutegeek kernel: [293145.917078] Process rm (pid: 21012,
threadinfo ffff88011e32c000, task ffff88012d32b740)
Dec  4 10:05:12 absolutegeek kernel: [293145.917113] Stack:
Dec  4 10:05:12 absolutegeek kernel: [293145.917129]  ffff88012f42da40
0000000e810f1201 0000000000000000 ffff88011e32ddc8
Dec  4 10:05:12 absolutegeek kernel: [293145.917156] <0> ffffffff8112bf8b
0000000000000000 00007fff5ac90ae0 0000000000000002
Dec  4 10:05:12 absolutegeek kernel: [293145.917198] <0> ffff880059040870
ffffffff810a9084 ffff880059040758 ffffffff810aa05b
Dec  4 10:05:12 absolutegeek kernel: [293145.917253] Call Trace:
Dec  4 10:05:12 absolutegeek kernel: [293145.917272]  [<ffffffff8112bf8b>] ?
ext3_delete_inode+0x0/0xd1
Dec  4 10:05:12 absolutegeek kernel: [293145.917295]  [<ffffffff810a9084>] ?
pagevec_lookup+0x17/0x1e
Dec  4 10:05:12 absolutegeek kernel: [293145.917317]  [<ffffffff810aa05b>] ?
truncate_inode_pages_range+0x11c/0x318
Dec  4 10:05:12 absolutegeek kernel: [293145.917341]  [<ffffffff810fa158>] ?
fsnotify_clear_marks_by_inode+0x20/0xcc
Dec  4 10:05:12 absolutegeek kernel: [293145.917365]  [<ffffffff8112bf8b>] ?
ext3_delete_inode+0x0/0xd1
Dec  4 10:05:12 absolutegeek kernel: [293145.917387]  [<ffffffff8112bfa2>] ?
ext3_delete_inode+0x17/0xd1
Dec  4 10:05:12 absolutegeek kernel: [293145.917409]  [<ffffffff8112bf8b>] ?
ext3_delete_inode+0x0/0xd1
Dec  4 10:05:12 absolutegeek kernel: [293145.917431]  [<ffffffff810e4c85>] ?
generic_delete_inode+0xdb/0x166
Dec  4 10:05:12 absolutegeek kernel: [293145.917454]  [<ffffffff810dd54f>] ?
do_unlinkat+0xe2/0x134
Dec  4 10:05:12 absolutegeek kernel: [293145.917476]  [<ffffffff810dfb5c>] ?
vfs_readdir+0x92/0xa7
Dec  4 10:05:12 absolutegeek kernel: [293145.917497]  [<ffffffff810dfce2>] ?
sys_getdents+0xb3/0xc1
Dec  4 10:05:12 absolutegeek kernel: [293145.917519]  [<ffffffff8100ba02>] ?
system_call_fastpath+0x16/0x1b
Dec  4 10:05:12 absolutegeek kernel: [293145.917540] Code: 00 45 31 e4 41 89 c6
31 db eb 5b 48 8b 45 00 48 8b 38 48 c7 c0 ff ff ff ff 40 f6 c7 01 48 0f 45 f8
48 85 ff 74 39 48 39 c7 74 bf <8b> 4f 08 48 8d 77 08 85 c9 74 d5 8d 41 01 48 63
d1 4c 63 c0 48
Dec  4 10:05:12 absolutegeek kernel: [293145.917713] RIP  [<ffffffff810a0f13>]
find_get_pages+0x5f/0xbb
Dec  4 10:05:12 absolutegeek kernel: [293145.917736]  RSP <ffff88011e32dd38>
Dec  4 10:05:12 absolutegeek kernel: [293145.917754] CR2: 0000000000000808
Dec  4 10:05:12 absolutegeek kernel: [293145.917983] ---[ end trace
a1e0632aebc6586a ]---


absolutegeek:/usr/src# lspci
00:00.0 Host bridge: nVidia Corporation C55 Host Bridge (rev a2)
00:00.1 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:00.2 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:00.3 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:00.4 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:00.5 RAM memory: nVidia Corporation C55 Memory Controller (rev a2)
00:00.6 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:00.7 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:01.0 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:01.1 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:01.2 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:01.3 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:01.4 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:01.5 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:01.6 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:02.0 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:02.1 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:02.2 RAM memory: nVidia Corporation C55 Memory Controller (rev a1)
00:03.0 PCI bridge: nVidia Corporation C55 PCI Express bridge (rev a1)
00:06.0 PCI bridge: nVidia Corporation C55 PCI Express bridge (rev a1)
00:09.0 RAM memory: nVidia Corporation MCP55 Memory Controller (rev a1)
00:0a.0 ISA bridge: nVidia Corporation MCP55 LPC Bridge (rev a2)
00:0a.1 SMBus: nVidia Corporation MCP55 SMBus (rev a2)
00:0b.0 USB Controller: nVidia Corporation MCP55 USB Controller (rev a1)
00:0b.1 USB Controller: nVidia Corporation MCP55 USB Controller (rev a2)
00:0d.0 IDE interface: nVidia Corporation MCP55 IDE (rev a1)
00:0e.0 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
00:0e.1 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
00:0e.2 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
00:0f.0 PCI bridge: nVidia Corporation MCP55 PCI bridge (rev a2)
00:11.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a2)
00:12.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a2)
00:16.0 PCI bridge: nVidia Corporation MCP55 PCI Express bridge (rev a2)
01:00.0 VGA compatible controller: nVidia Corporation G92 [GeForce 8800 GS]
(rev a2)
02:00.0 Mass storage controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid
II Controller (rev 01)
03:08.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A IEEE-1394a-2000
Controller (PHY/Link)
04:00.0 Ethernet controller: Atheros Communications Inc. AR5001 Wireless
Network Adapter (rev 01)

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
