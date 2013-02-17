From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [BUG] xfstests #68 with data=journal hang against 3.8-rc7 and 'dev'
 branch
Date: Mon, 18 Feb 2013 01:22:08 +0800
Message-ID: <20130217172208.GB4059@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61771 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3BQRH0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Feb 2013 12:07:26 -0500
Received: by mail-pa0-f46.google.com with SMTP id kp14so2393533pab.19
        for <linux-ext4@vger.kernel.org>; Sun, 17 Feb 2013 09:07:25 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

Xfstests #68 will hang with data=journal in 3.8-rc7 and 'dev' branch. I
remember that there has a patch for ext4 to fix filesystem freeze bug
but I am not sure whether it can fix this bug and it has been applied
into 'dev' branch.  So I file this bug here.

Regards,
                                                - Zheng

FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 lz-desktop 3.8.0-rc3+
MKFS_OPTIONS  -- /dev/sda2
MOUNT_OPTIONS -- -o acl,user_xattr,data=journal /dev/sda2 /mnt/sda2

068 46s ...

wenqing: run xfstest 068
kernel: EXT4-fs (sda2): mounted filesystem with journalled data mode.
Opts: acl,user_xattr,data=journal
kernel: ------------[ cut here ]------------
kernel: kernel BUG at fs/jbd2/transaction.c:2011!
kernel: invalid opcode: 0000 [#1] SMP 
kernel: Modules linked in: ext4 jbd2 crc16 cpufreq_ondemand acpi_cpufreq
mperf ipv6 dm_mirror dm_region_hash dm_log dm_mod parport_pc parport
dcdbas pcspkr serio_raw i2c_i801 i2c_core sg button ehci_pci ehci_hcd
e1000e ext3 jbd sd_mod ahci libahci libata scsi_mod uhci_hcd
kernel: CPU 1 
kernel: Pid: 10646, comm: fstest Not tainted 3.8.0-rc3+ #2 Dell Inc.
OptiPlex 780 /0V4W66
kernel: RIP: 0010:[<ffffffffa01ee9de>] [<ffffffffa01ee9de>]
jbd2_journal_invalidatepage+0x265/0x2ec [jbd2]
kernel: RSP: 0018:ffff88010cf4d948  EFLAGS: 00010206
kernel: RAX: 0000000000000000 RBX: ffff88010f8e2000 RCX: 0000000000000000
kernel: RDX: 00000000001c4025 RSI: 0000000000000376 RDI: ffff88010f8e2028
kernel: RBP: ffff88010cf4d9b8 R08: 0000000000000002 R09: ffff88010d79d6e0
kernel: R10: ffffea00038738a8 R11: 0000000000000002 R12: ffffea00038738a8
kernel: R13: ffff88010d79d6e0 R14: ffff88010a8b13c8 R15: ffff88010f8e2678
kernel: FS:  00007f7d834ac700(0000) GS:ffff880112a00000(0000) knlGS:0000000000000000
kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: CR2: 00007f7d834aa000 CR3: 00000001179ca000 CR4: 00000000000407e0
kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
kernel: Process fstest (pid: 10646, threadinfo ffff88010cf4c000, task ffff8801015289c0)
kernel: Stack:
kernel: ffff8801015289c0 0000000000000000 ffff88010d79d6e0 00001000015289c0
kernel: ffff88010d79d6e0 0000000000000000 000000010b419bb0 ffff88010f8e2028
kernel: ffff88010cf4d9a8 ffffea00038738a8 ffffea00038738a8 0000000000000000
kernel: Call Trace:
kernel: [<ffffffffa0218435>] __ext4_journalled_invalidatepage+0x7a/0x83 [ext4]
kernel: [<ffffffffa0219c51>] ext4_journalled_invalidatepage+0xe/0x25 [ext4]
kernel: [<ffffffff820d2b64>] do_invalidatepage+0x28/0x2a
kernel: [<ffffffff820d30bf>] truncate_inode_page+0x4b/0x6c
kernel: [<ffffffff820d31cb>] truncate_inode_pages_range+0xeb/0x3a5
kernel: [<ffffffff823c9742>] ? __mutex_unlock_slowpath+0x110/0x11c
kernel: [<ffffffff820d34f8>] truncate_inode_pages+0x12/0x14
kernel: [<ffffffff820d353e>] truncate_pagecache+0x44/0x5e
kernel: [<ffffffffa0219ae9>] ext4_setattr+0x55a/0x5ff [ext4]
kernel: [<ffffffff8211f8e8>] notify_change+0x1fc/0x2de
kernel: [<ffffffff821081a4>] ? generic_file_llseek_size+0x50/0xf7
kernel: [<ffffffff821069cc>] do_truncate+0x6c/0x89
kernel: [<ffffffff821142d9>] do_last+0xbcc/0xbea
kernel: [<ffffffff821143ca>] path_openat+0xd3/0x481
kernel: [<ffffffff8206320e>] ? sched_clock_cpu+0xc3/0xd1
kernel: [<ffffffff82114887>] do_filp_open+0x3d/0x89
kernel: [<ffffffff82121fac>] ? __alloc_fd+0x1c5/0x1d7
kernel: [<ffffffff82105aba>] do_sys_open+0x119/0x1ab
kernel: [<ffffffff82105b83>] sys_open+0x21/0x23
kernel: [<ffffffff823d45c2>] system_call_fastpath+0x16/0x1b
kernel: Code: 0f 0b eb fe f0 41 80 65 02 ef 48 8b 7d c8 89 45 98 e8 a0 da 1d
e2 8b 45 98 f0 41 80 65 00 fd 49 8b 55 00 f7 c2 00 00 08 00 74 04 <0f> 0b eb
fe f0 41 80 65 00 df f0 41 80 65 00 f7 f0 41 80 65 00 
kernel: RIP  [<ffffffffa01ee9de>] jbd2_journal_invalidatepage+0x265/0x2ec [jbd2]
kernel: RSP <ffff88010cf4d948>
kernel: ---[ end trace 6314db6c587d0c29 ]---
