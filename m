From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [REGRESSION] xfstests #269 without journal failure against 'dev'
 branch
Date: Mon, 18 Feb 2013 01:09:18 +0800
Message-ID: <20130217170918.GA4059@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:62656 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab3BQQyg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Feb 2013 11:54:36 -0500
Received: by mail-da0-f46.google.com with SMTP id p5so2086739dak.19
        for <linux-ext4@vger.kernel.org>; Sun, 17 Feb 2013 08:54:36 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted,

There is a regression in 'dev' branch of ext4.  I can trigger it by
xfstests #269 in my desktop with a SSD when journal is disabled.  I
run this test case in 3.8-rc7 and it is ok.  So I think this is a
regression in 'dev' branch.

I know you are on vacation and maybe you don't have time to take a look
at it.  But I think I need to let you know, and other folks might take a
look at it.

Enjoy your vacation. :-)

                                                - Zheng

FSTYP         -- ext4
PLATFORM      -- Linux/x86_64 lz-desktop 3.8.0-rc3+
MKFS_OPTIONS  -- -O ^has_journal /dev/sda2
MOUNT_OPTIONS -- -o acl,user_xattr /dev/sda2 /mnt/sda2

269 32s ... [failed, exit status 1] - output mismatch (see 269.out.bad)
    --- 269.out	2013-02-07 22:56:14.000000000 +0800
    +++ 269.out.bad	2013-02-17 22:09:21.000000000 +0800
    @@ -3,3 +3,4 @@
     Run fsstress
     
     Run dd writers in parallel
    +_check_generic_filesystem: filesystem on /dev/sda2 is inconsistent (see
269.full)
     ...
     (Run 'diff -u 269.out 269.out.bad' to see the entire diff)
Ran: 269
Failures: 269
Failed 1 of 1 tests

wenqing: run xfstest 269
kernel: EXT4-fs (sda2): mounted filesystem without journal. Opts: acl,user_xattr
kernel: EXT4-fs (sda2): ext4_da_update_reserve_space: ino 1166, allocated 1 with
only 0 reserved metadata blocks
kernel:
kernel: ------------[ cut here ]------------
kernel: WARNING: at fs/ext4/inode.c:359 ext4_da_update_reserve_space+0x10f/0x21b
[ext4]()
kernel: Hardware name: OptiPlex 780                 
kernel: Modules linked in: ext4 jbd2 crc16 cpufreq_ondemand acpi_cpufreq mperf
ipv6 dm_mirror dm_region_hash dm_log dm_mod parport_pc parport dcdbas serio_raw
sg button pcspkr i2c_i801 i2c_core ehci_pci ehci_hcd e1000e ext3 jbd sd_mod ahci
libahci libata scsi_mod uhci_hcd
kernel: Pid: 2860, comm: flush-8:0 Not tainted 3.8.0-rc3+ #3
kernel: Call Trace:
kernel: [<ffffffff82031d5c>] warn_slowpath_common+0x85/0x9d
kernel: [<ffffffff82031d8e>] warn_slowpath_null+0x1a/0x1c
kernel: [<ffffffffa0203fa8>] ext4_da_update_reserve_space+0x10f/0x21b [ext4]
kernel: [<ffffffffa022b9a5>] ext4_ext_map_blocks+0xdad/0xf68 [ext4]
kernel: [<ffffffff820ba234>] ? release_pages+0x169/0x178
kernel: [<ffffffffa020557b>] ? write_cache_pages_da+0x107/0x416 [ext4]
kernel: [<ffffffffa02049ac>] ext4_map_blocks+0x135/0x1ef [ext4]
kernel: [<ffffffffa02051ad>] mpage_da_map_and_submit+0x111/0x3d8 [ext4]
kernel: [<ffffffffa0226265>] ? ext4_ext_index_trans_blocks+0x17/0x3a [ext4]
kernel: [<ffffffffa0205c12>] ext4_da_writepages+0x388/0x530 [ext4]
kernel: [<ffffffff821161cd>] ? __getblk+0x2d/0x264
kernel: [<ffffffff820b8465>] do_writepages+0x20/0x29
kernel: [<ffffffff8210f9ff>] __writeback_single_inode+0x48/0x119
kernel: [<ffffffff82110be8>] writeback_sb_inodes+0x1ec/0x2fd
kernel: [<ffffffff82110f4d>] wb_writeback+0x131/0x230
kernel: [<ffffffff821110e1>] wb_do_writeback+0x95/0x1ea
kernel: [<ffffffff8237ced9>] ? schedule_timeout+0x158/0x178
kernel: [<ffffffff8203f7c5>] ? add_timer_on+0xae/0xae
kernel: [<ffffffff821112f8>] bdi_writeback_thread+0xc2/0x1e2
kernel: [<ffffffff82111236>] ? wb_do_writeback+0x1ea/0x1ea
kernel: [<ffffffff82111236>] ? wb_do_writeback+0x1ea/0x1ea
kernel: [<ffffffff8204e9f3>] kthread+0xb5/0xbd
kernel: [<ffffffff8204e93e>] ? kthread_freezable_should_stop+0x65/0x65
kernel: [<ffffffff8238615c>] ret_from_fork+0x7c/0xb0
kernel: [<ffffffff8204e93e>] ? kthread_freezable_should_stop+0x65/0x65
kernel: ---[ end trace 72c02955946d0799 ]---
kernel: EXT4-fs (sda1): mounted filesystem without journal. Opts: acl,user_xattr

