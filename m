From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12370] kernel BUG at fs/jbd2/journal.c:1108
Date: Tue,  6 Jan 2009 03:16:43 -0800 (PST)
Message-ID: <20090106111643.EC85410800F@picon.linux-foundation.org>
References: <bug-12370-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43968 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751372AbZAFLRN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jan 2009 06:17:13 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n06BGifd024533
	for <linux-ext4@vger.kernel.org>; Tue, 6 Jan 2009 03:16:45 -0800
In-Reply-To: <bug-12370-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12370





------- Comment #2 from dmaciejak@fortinet.com  2009-01-06 03:16 -------
Jan  6 12:09:53 koma-lab kernel: [  127.546104] ------------[ cut here
]------------
Jan  6 12:09:53 koma-lab kernel: [  127.546108] kernel BUG at
fs/jbd2/journal.c:1108!
Jan  6 12:09:53 koma-lab kernel: [  127.546113] invalid opcode: 0000 [#1] SMP 
Jan  6 12:09:53 koma-lab kernel: [  127.546119] last sysfs file:
/sys/block/loop7/dev
Jan  6 12:09:53 koma-lab kernel: [  127.546125] Dumping ftrace buffer:
Jan  6 12:09:53 koma-lab kernel: [  127.546130]    (ftrace buffer empty)
Jan  6 12:09:53 koma-lab kernel: [  127.546134] Modules linked in: loop
af_packet isofs udf crc_itu_t binfmt_misc ipv6 powernow_k8 cpufreq_userspace
cpufreq_stats cpufreq_ondemand freq_table cpufreq_powersave
cpufreq_conservative wmi video output container sbs sbshc ac pci_slot battery
hid_dell hid_pl hid_cypress hid_gyration hid_bright hid_sony hid_samsung
hid_microsoft hid_monterey hid_ezkey hid_apple hid_a4tech hid_logitech usbhid
hid_cherry hid_sunplus hid_petalynx hid_belkin hid_chicony hid fuse sg sr_mod
cdrom ohci_hcd ehci_hcd tg3 serio_raw k8temp libphy i2c_nforce2 usbcore
i2c_core shpchp pci_hotplug button dcdbas sd_mod crc_t10dif ata_generic sata_nv
pata_acpi libata evdev thermal processor fan fbcon tileblit font bitblit
softcursor
Jan  6 12:09:53 koma-lab kernel: [  127.546230] 
Jan  6 12:09:53 koma-lab kernel: [  127.546237] Pid: 4231, comm: mount Not
tainted (2.6.28 #1) OptiPlex 740
Jan  6 12:09:53 koma-lab kernel: [  127.546242] EIP: 0060:[<c0270fb9>] EFLAGS:
00210246 CPU: 1
Jan  6 12:09:53 koma-lab kernel: [  127.546257] EIP is at
jbd2_journal_init_inode+0x159/0x180
Jan  6 12:09:53 koma-lab kernel: [  127.546262] EAX: 00000000 EBX: ec616c00
ECX: ffffffff EDX: 010cd000
Jan  6 12:09:53 koma-lab kernel: [  127.546267] ESI: ec616cb4 EDI: ead34094
EBP: ec4ffd58 ESP: ec4ffd38
Jan  6 12:09:53 koma-lab kernel: [  127.546272]  DS: 007b ES: 007b FS: 00d8 GS:
0033 SS: 0068
Jan  6 12:09:53 koma-lab kernel: [  127.546278] Process mount (pid: 4231,
ti=ec4fe000 task=f4d73240 task.ti=ec4fe000)
Jan  6 12:09:53 koma-lab kernel: [  127.546282] Stack:
Jan  6 12:09:53 koma-lab kernel: [  127.546285]  00000800 c055340a 00000008
00000013 0000c500 ead34094 ec616600 ec616600
Jan  6 12:09:53 koma-lab kernel: [  127.546297]  ec4ffd70 c024c9f1 ec6780cc
00000000 00000008 ec616600 ec4ffe9c c0250ba2
Jan  6 12:09:53 koma-lab kernel: [  127.546309]  00000800 ec678064 00000000
00000000 ec4ffdd0 00000029 00000000 ffffffff
Jan  6 12:09:53 koma-lab kernel: [  127.546322] Call Trace:
Jan  6 12:09:53 koma-lab kernel: [  127.546326]  [<c024c9f1>] ?
ext4_get_journal+0x41/0xd0
Jan  6 12:09:53 koma-lab kernel: [  127.546337]  [<c0250ba2>] ?
ext4_fill_super+0x1542/0x2400
Jan  6 12:09:53 koma-lab kernel: [  127.546348]  [<c03490c0>] ?
exact_match+0x0/0x10
Jan  6 12:09:53 koma-lab kernel: [  127.546357]  [<c047db1b>] ?
mutex_lock+0xb/0x20
Jan  6 12:09:53 koma-lab kernel: [  127.546367]  [<c01ef549>] ?
disk_name+0x39/0xc0
Jan  6 12:09:53 koma-lab kernel: [  127.546374]  [<c01aef02>] ?
get_sb_bdev+0x112/0x140
Jan  6 12:09:53 koma-lab kernel: [  127.546384]  [<c018d145>] ?
kstrdup+0x35/0x60
Jan  6 12:09:53 koma-lab kernel: [  127.546391]  [<c024c771>] ?
ext4_get_sb+0x21/0x30
Jan  6 12:09:53 koma-lab kernel: [  127.546398]  [<c024f660>] ?
ext4_fill_super+0x0/0x2400
Jan  6 12:09:53 koma-lab kernel: [  127.546405]  [<c01ae3c8>] ?
vfs_kern_mount+0x58/0x120
Jan  6 12:09:53 koma-lab kernel: [  127.546413]  [<c01ae4e9>] ?
do_kern_mount+0x39/0xd0
Jan  6 12:09:53 koma-lab kernel: [  127.546419]  [<c01c291e>] ?
do_mount+0x55e/0x6e0
Jan  6 12:09:53 koma-lab kernel: [  127.546427]  [<c0186015>] ?
__get_free_pages+0x25/0x30
Jan  6 12:09:53 koma-lab kernel: [  127.546436]  [<c01c0485>] ?
copy_mount_options+0x35/0x140
Jan  6 12:09:53 koma-lab kernel: [  127.546443]  [<c01c2b0f>] ?
sys_mount+0x6f/0xb0
Jan  6 12:09:53 koma-lab kernel: [  127.546450]  [<c0103e0b>] ?
sysenter_do_call+0x12/0x2f
Jan  6 12:09:53 koma-lab kernel: [  127.546457] Code: 5b 5e 5f 5d c3 c7 44 24
04 70 75 49 c0 c7 04 24 8c 93 56 c0 e8 69 23 ec ff 89 d8 e8 a2 dc ff ff 89 d8
31 db e8 f9 5e f3 ff eb d0 <0f> 0b eb fe 8d 76 00 c7 44 24 04 70 75 49 c0 c7 04
24 60 93 56 
Jan  6 12:09:53 koma-lab kernel: [  127.546521] EIP: [<c0270fb9>]
jbd2_journal_init_inode+0x159/0x180 SS:ESP 0068:ec4ffd38
Jan  6 12:09:53 koma-lab kernel: [  127.546532] ---[ end trace b76702c8f157530e
]---


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
