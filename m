From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12689] New: kernel oops fs/jbd/checkpoint.c:164 __log_wait_for_space
Date: Wed, 11 Feb 2009 05:18:55 -0800 (PST)
Message-ID: <bug-12689-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754403AbZBKNTb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Feb 2009 08:19:31 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n1BDIuar013774
	for <linux-ext4@vger.kernel.org>; Wed, 11 Feb 2009 05:18:57 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12689

           Summary: kernel oops fs/jbd/checkpoint.c:164 __log_wait_for_space
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.29-rc4
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: dmaciejak@fortinet.com


Latest working kernel version: NA
Earliest failing kernel version: NA
Distribution: Ubuntu
Hardware Environment: Dell Optiplex 740
Software Environment: NA
Problem Description: 

Hi,

playing around with crafted filesystems got a kernel oops, seems this can be
reproduce when mounting successively filesystems

Regards,

David Maciejak
Fortinet's FortiGuard Global Security Research Team

See kernel logs below:

Feb 11 12:00:15 koma-lab kernel: [ 2151.458822] EXT3-fs: mounted filesystem
with ordered data mode.
Feb 11 12:00:15 koma-lab kernel: [ 2151.463055] __log_wait_for_space: needed
256 blocks and only had 0 space available
Feb 11 12:00:15 koma-lab kernel: [ 2151.463060] __log_wait_for_space: no way to
get more journal space
Feb 11 12:00:15 koma-lab kernel: [ 2151.463068] ------------[ cut here
]------------
Feb 11 12:00:15 koma-lab kernel: [ 2151.463070] WARNING: at
fs/jbd/checkpoint.c:164 __log_wait_for_space+0x16e/0x180()
Feb 11 12:00:15 koma-lab kernel: [ 2151.463072] Hardware name: OptiPlex 740
Feb 11 12:00:15 koma-lab kernel: [ 2151.463074] Modules linked in: loop
af_packet isofs udf crc_itu_t binfmt_misc ipv6 power
now_k8 cpufreq_userspace cpufreq_stats cpufreq_ondemand freq_table
cpufreq_powersave cpufreq_conservative video output conta
iner sbs sbshc ac pci_slot battery hid_pl hid_cypress hid_gyration hid_sony
hid_ntrig hid_samsung hid_microsoft hid_monterey
 hid_ezkey hid_apple hid_a4tech hid_logitech hid_cherry hid_sunplus
hid_petalynx usbhid hid_belkin hid_chicony hid fuse ehci
_hcd ohci_hcd sg serio_raw tg3 usbcore libphy i2c_nforce2 i2c_core shpchp
pci_hotplug button dcdbas sd_mod crc_t10dif ata_ge
neric sata_nv pata_acpi libata evdev thermal processor fan fbcon tileblit font
bitblit softcursor
Feb 11 12:00:15 koma-lab kernel: [ 2151.463120] Pid: 9686, comm: ls Not tainted
2.6.29-rc4 #5
Feb 11 12:00:15 koma-lab kernel: [ 2151.463122] Call Trace:
Feb 11 12:00:15 koma-lab kernel: [ 2151.463129]  [<c01311c6>]
warn_slowpath+0x86/0xa0
Feb 11 12:00:15 koma-lab kernel: [ 2151.463134]  [<c04e0030>] ?
kvm_setup_secondary_clock+0x10/0x40
Feb 11 12:00:15 koma-lab kernel: [ 2151.463137]  [<c013193f>] ?
release_console_sem+0x1bf/0x1e0
Feb 11 12:00:15 koma-lab kernel: [ 2151.463141]  [<c04e40d8>] ?
_spin_lock+0x8/0x10
Feb 11 12:00:15 koma-lab kernel: [ 2151.463144]  [<c0270694>] ?
cleanup_journal_tail+0x134/0x190
Feb 11 12:00:15 koma-lab kernel: [ 2151.463149]  [<c039f44b>] ?
blk_backing_dev_unplug+0xb/0x10
Feb 11 12:00:15 koma-lab kernel: [ 2151.463152]  [<c0131f0b>] ?
printk+0x1b/0x20
Feb 11 12:00:15 koma-lab kernel: [ 2151.463154]  [<c0270f1e>]
__log_wait_for_space+0x16e/0x180
Feb 11 12:00:15 koma-lab kernel: [ 2151.463157]  [<c026c767>]
start_this_handle+0xf7/0x4d0
Feb 11 12:00:15 koma-lab kernel: [ 2151.463160]  [<c03b4d9e>] ?
copy_to_user+0x3e/0x60
Feb 11 12:00:15 koma-lab kernel: [ 2151.463163]  [<c026cb94>] ?
journal_start+0x54/0xc0
Feb 11 12:00:15 koma-lab kernel: [ 2151.463165]  [<c026cbc8>]
journal_start+0x88/0xc0
Feb 11 12:00:15 koma-lab kernel: [ 2151.463169]  [<c023cb19>]
ext3_journal_start_sb+0x29/0x50
Feb 11 12:00:15 koma-lab kernel: [ 2151.463171]  [<c0234b9d>]
ext3_dirty_inode+0x2d/0xc0
Feb 11 12:00:15 koma-lab kernel: [ 2151.463176]  [<c01ca92c>]
__mark_inode_dirty+0x2c/0x170
Feb 11 12:00:15 koma-lab kernel: [ 2151.463180]  [<c01c1cc4>]
touch_atime+0xc4/0x110
Feb 11 12:00:15 koma-lab kernel: [ 2151.463183]  [<c01bd22b>]
vfs_readdir+0x9b/0xa0
Feb 11 12:00:15 koma-lab kernel: [ 2151.463185]  [<c01bcfe0>] ?
filldir64+0x0/0xe0
Feb 11 12:00:15 koma-lab kernel: [ 2151.463188]  [<c01bd486>]
sys_getdents64+0x66/0xc0
Feb 11 12:00:15 koma-lab kernel: [ 2151.463192]  [<c010336b>]
sysenter_do_call+0x12/0x2f
Feb 11 12:00:15 koma-lab kernel: [ 2151.463194] ---[ end trace 05521cfc19061f46
]---
Feb 11 12:00:15 koma-lab kernel: [ 2151.463197] Aborting journal on device
loop1.
Feb 11 12:00:15 koma-lab kernel: [ 2151.463239] EXT3-fs error (device loop1):
ext3_readdir: directory #2 contains a hole at 
offset 2048


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
