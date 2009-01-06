From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12371] New: oops in ext4_get_group_desc
Date: Tue,  6 Jan 2009 03:24:32 -0800 (PST)
Message-ID: <bug-12371-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751292AbZAFLZE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jan 2009 06:25:04 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n06BOWDY025158
	for <linux-ext4@vger.kernel.org>; Tue, 6 Jan 2009 03:24:33 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12371

           Summary: oops in ext4_get_group_desc
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.28
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: dmaciejak@fortinet.com


Latest working kernel version: none
Earliest failing kernel version: unknow
Distribution: ubuntu
Hardware Environment: dell optiplex 740
Software Environment:
Problem Description:
kernel oops and mount fives me a seg fault when I tried to mount a specially
crafted ext4 image (enclosed)
Steps to reproduce:
*gunzip the image file provided
*mount it with the command below 
mount -t ext4  -o loop ext4.72.img /media/tmp

I got this in the kern.log:

Jan  6 12:19:40 koma-lab kernel: [  715.256099] BUG: unable to handle kernel
NULL pointer dereference at 00000010
Jan  6 12:19:40 koma-lab kernel: [  715.256112] IP: [<c023e8b5>]
ext4_get_group_desc+0x45/0xd0
Jan  6 12:19:40 koma-lab kernel: [  715.256128] *pde = 00000000 
Jan  6 12:19:40 koma-lab kernel: [  715.256136] Oops: 0000 [#2] SMP 
Jan  6 12:19:40 koma-lab kernel: [  715.256142] last sysfs file:
/sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed
Jan  6 12:19:40 koma-lab kernel: [  715.256150] Modules linked in: loop
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
Jan  6 12:19:40 koma-lab kernel: [  715.256242] 
Jan  6 12:19:40 koma-lab kernel: [  715.256248] Pid: 4382, comm: mount Tainted:
G      D    (2.6.28 #1) OptiPlex 740
Jan  6 12:19:40 koma-lab kernel: [  715.256254] EIP: 0060:[<c023e8b5>] EFLAGS:
00210256 CPU: 0
Jan  6 12:19:40 koma-lab kernel: [  715.256260] EIP is at
ext4_get_group_desc+0x45/0xd0
Jan  6 12:19:40 koma-lab kernel: [  715.256265] EAX: 00000010 EBX: ec658000
ECX: 00000006 EDX: 00000040
Jan  6 12:19:40 koma-lab kernel: [  715.256270] ESI: 00000000 EDI: 00000000
EBP: ec619d70 ESP: ec619d40
Jan  6 12:19:40 koma-lab kernel: [  715.256275]  DS: 007b ES: 007b FS: 00d8 GS:
0033 SS: 0068
Jan  6 12:19:40 koma-lab kernel: [  715.256280] Process mount (pid: 4382,
ti=ec618000 task=ec64cb60 task.ti=ec618000)
Jan  6 12:19:40 koma-lab kernel: [  715.256284] Stack:
Jan  6 12:19:40 koma-lab kernel: [  715.256287]  00000001 ec430200 0000011b
ec430f80 c0552de0 00000040 00000000 f4fcf400
Jan  6 12:19:40 koma-lab kernel: [  715.256298]  00000000 ec658000 00000000
ec658000 ec619e9c c02505c6 c0496a40 ec658064
Jan  6 12:19:40 koma-lab kernel: [  715.256311]  00000000 00000000 ec619dd0
00040403 00000000 ffffffff 000007ff ec45a005
Jan  6 12:19:40 koma-lab kernel: [  715.256323] Call Trace:
Jan  6 12:19:40 koma-lab kernel: [  715.256328]  [<c02505c6>] ?
ext4_fill_super+0xf66/0x2400
Jan  6 12:19:40 koma-lab kernel: [  715.256340]  [<c03490c0>] ?
exact_match+0x0/0x10
Jan  6 12:19:40 koma-lab kernel: [  715.256350]  [<c047db1b>] ?
mutex_lock+0xb/0x20
Jan  6 12:19:40 koma-lab kernel: [  715.256358]  [<c035765d>] ?
snprintf+0x1d/0x20
Jan  6 12:19:40 koma-lab kernel: [  715.256365]  [<c01ef549>] ?
disk_name+0x39/0xc0
Jan  6 12:19:40 koma-lab kernel: [  715.256372]  [<c01aef02>] ?
get_sb_bdev+0x112/0x140
Jan  6 12:19:40 koma-lab kernel: [  715.256382]  [<c018d145>] ?
kstrdup+0x35/0x60
Jan  6 12:19:40 koma-lab kernel: [  715.256389]  [<c024c771>] ?
ext4_get_sb+0x21/0x30
Jan  6 12:19:40 koma-lab kernel: [  715.256396]  [<c024f660>] ?
ext4_fill_super+0x0/0x2400
Jan  6 12:19:40 koma-lab kernel: [  715.256403]  [<c01ae3c8>] ?
vfs_kern_mount+0x58/0x120
Jan  6 12:19:40 koma-lab kernel: [  715.256411]  [<c01ae4e9>] ?
do_kern_mount+0x39/0xd0
Jan  6 12:19:40 koma-lab kernel: [  715.256418]  [<c01c291e>] ?
do_mount+0x55e/0x6e0
Jan  6 12:19:40 koma-lab kernel: [  715.256427]  [<c0186015>] ?
__get_free_pages+0x25/0x30
Jan  6 12:19:40 koma-lab kernel: [  715.256436]  [<c01c0485>] ?
copy_mount_options+0x35/0x140
Jan  6 12:19:40 koma-lab kernel: [  715.256443]  [<c01c2b0f>] ?
sys_mount+0x6f/0xb0
Jan  6 12:19:40 koma-lab kernel: [  715.256449]  [<c0103e0b>] ?
sysenter_do_call+0x12/0x2f
Jan  6 12:19:40 koma-lab kernel: [  715.256457] Code: 01 00 00 8b 47 1c 39 d0
76 4e 0f ae e8 66 90 8b 55 ec 89 f0 8b 9a a0 01 00 00 8b 4b 58 d3 e8 89 45 f0
8b 47 38 8b 7d f0 8b 53 18 <8b> 0c b8 83 ea 01 21 f2 85 c9 74 48 89 d0 0f af 03
8b 5d e8 03 
Jan  6 12:19:40 koma-lab kernel: [  715.256518] EIP: [<c023e8b5>]
ext4_get_group_desc+0x45/0xd0 SS:ESP 0068:ec619d40
Jan  6 12:19:40 koma-lab kernel: [  715.256528] ---[ end trace b76702c8f157530e
]---


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
