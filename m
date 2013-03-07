From: Jan Kara <jack@suse.cz>
Subject: Re: [BUG][data=journal] general protection fault is hitted when we
 run xfstests #074
Date: Thu, 7 Mar 2013 13:26:38 +0100
Message-ID: <20130307122638.GD6723@quack.suse.cz>
References: <20130307122019.GC2800@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Zheng Liu <gnehzuil.liu@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59683 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229Ab3CGM0j (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Mar 2013 07:26:39 -0500
Content-Disposition: inline
In-Reply-To: <20130307122019.GC2800@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 07-03-13 20:20:19, Zheng Liu wrote:
> Hi all,
> 
> This bug can be hitted in 3.8 kernel, and it doesn't be fixed in dev
> branch.  When #074 runs in a ext4 file system with '-o data=journal', I
> will get a general protection fault in my sand box.  I need to run
> several times to hit this bug.
> 
> My sand box is a Dell Desktop with a Intel(R) Core(TM)2 Duo CPU E8400
> @ 3.00GHz, 4G memory, a 160G HDD and a Intel SSD.  The test runs against
> SSD.
> 
> The messages from dmesg:
> 
> wenqing: run xfstest 074
> kernel: EXT4-fs (sda1): mounted filesystem with journalled data mode.
> Opts: acl,user_xattr,data=journal
> kernel: EXT4-fs (sda1): mounted filesystem with journalled data mode.
> Opts: acl,user_xattr,data=journal
> kernel: EXT4-fs (sda1): mounted filesystem with journalled data mode.
> Opts: acl,user_xattr,data=journal
> kernel: EXT4-fs (sda1): mounted filesystem with journalled data mode.
> Opts: acl,user_xattr,data=journal
> kernel: general protection fault: 0000 [#1] SMP 
> kernel: Modules linked in: ext4 jbd2 crc16 cpufreq_ondemand ipv6
> dm_mirror dm_region_hash dm_log dm_mod parport_pc parport dcdbas
> acpi_cpufreq mperf sg button pcspkr serio_raw i2c_i801 i2c_core ehci_pci
> ehci_hcd e1000e ext3 jbd sd_mod ahci libahci libata scsi_mod uhci_hcd
> kernel: CPU 1 
> kernel: Pid: 2786, comm: flush-8:0 Not tainted 3.8.0 #1 Dell Inc.
> OptiPlex 780                 /0V4W66
> kernel: RIP: 0010:[<ffffffffa01da0a0>]  [<ffffffffa01da0a0>]
> jbd2_journal_dirty_metadata+0x147/0x211 [jbd2]
> kernel: RSP: 0000:ffff880107a93868  EFLAGS: 00010206
> kernel: RAX: 0000000000000000 RBX: ffff88010a674540 RCX: 5c5c5c5c5c5c5c5c
> kernel: RDX: 000000000034402d RSI: ffff88010a674540 RDI: ffff880105bd6ca0
> kernel: RBP: ffff880107a938b8 R08: 0000000000000000 R09: 0000000000000000
> kernel: R10: ffff880105bd6ca0 R11: 000000000000000c R12: ffff88008e4ee518
> kernel: R13: ffff8801114fb800 R14: ffff880105bd6ca0 R15: ffff88010a658c80
> kernel: FS:  0000000000000000(0000) GS:ffff880117c40000(0000)
> knlGS:0000000000000000
> kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> kernel: CR2: 00007f60256a5000 CR3: 0000000117834000 CR4: 00000000000407e0
> kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> kernel: Process flush-8:0 (pid: 2786, threadinfo ffff880107a92000, task
> ffff880112cde6b0)
> kernel: Stack:
> kernel: ffff880105bd6ca0 0000000000001000 ffff880107a938a8 ffffffffa01da6de
> kernel: ffff8801114fb868 0000000000000000 00000000000003bf ffffffffa023f0e0
> kernel: ffff88010a674540 0000000000001000 ffff880107a938f8 ffffffffa022bb07
> kernel: Call Trace:
> kernel: [<ffffffffa01da6de>] ? jbd2_journal_get_write_access+0x36/0x40 [jbd2]
> kernel: [<ffffffffa022bb07>] __ext4_handle_dirty_metadata+0xd7/0xe6 [ext4]
> kernel: [<ffffffffa01ff4a5>] write_end_fn+0x37/0x3d [ext4]
> kernel: [<ffffffffa01ff167>] ext4_walk_page_buffers+0x65/0x9b [ext4]
> kernel: [<ffffffffa01ff46e>] ? ext4_nonda_switch+0xbd/0xbd [ext4]
> kernel: [<ffffffffa0203367>] __ext4_journalled_writepage+0x156/0x1ee [ext4]
> kernel: [<ffffffffa0203c10>] ext4_writepage+0x1b8/0x20d [ext4]
> kernel: [<ffffffff820b7ab4>] __writepage+0x17/0x30
> kernel: [<ffffffff820b8554>] write_cache_pages+0x276/0x37f
> kernel: [<ffffffff820b7a9d>] ? set_page_dirty+0x64/0x64
> kernel: [<ffffffff820b86a2>] generic_writepages+0x45/0x5c
> kernel: [<ffffffff820b86e0>] do_writepages+0x27/0x29
> kernel: [<ffffffff8210fc93>] __writeback_single_inode+0x48/0x119
> kernel: [<ffffffff82110e7c>] writeback_sb_inodes+0x1ec/0x2fd
> kernel: [<ffffffff82110fff>] __writeback_inodes_wb+0x72/0xb0
> kernel: [<ffffffff821111ee>] wb_writeback+0x13e/0x230
> kernel: [<ffffffff820b8dae>] ? global_dirty_limits+0x36/0x134
> kernel: [<ffffffff821114aa>] wb_do_writeback+0x1ca/0x1ea
> kernel: [<ffffffff8211158c>] bdi_writeback_thread+0xc2/0x1e2
> kernel: [<ffffffff821114ca>] ? wb_do_writeback+0x1ea/0x1ea
> kernel: [<ffffffff821114ca>] ? wb_do_writeback+0x1ea/0x1ea
> kernel: [<ffffffff8204eadf>] kthread+0xb5/0xbd
> kernel: [<ffffffff8204ea2a>] ? kthread_freezable_should_stop+0x65/0x65
> kernel: [<ffffffff8238689c>] ret_from_fork+0x7c/0xb0
> kernel: [<ffffffff8204ea2a>] ? kthread_freezable_should_stop+0x65/0x65
> kernel: Code: 08 49 8b 4c 24 28 4c 39 f9 0f 84 81 00 00 00 4d 8b 4d 58 31 c0
> 4c 39 c9 74 36 4d 85 c9 74 04 41 8b 41 08 45 31 c0 48 85 c9 74 04 <44> 8b 41
> 08 48 8b 53 18 49 8d b5 58 03 00 00 89 04 24 48 c7 c7 
> kernel: RIP  [<ffffffffa01da0a0>] jbd2_journal_dirty_metadata+0x147/0x211 [jbd2]
> kernel: RSP <ffff880107a93868>
> kernel: ---[ end trace d8e02cf12f9b2b79 ]---
  Hum, clearly we hit some poison value (RCX which was dereferenced was
0x5c5c5c5c5c5c5c5c). Can you post full disassembly of
jbd2_journal_dirty_metadata()? I was trying to match decoded 'Code' section
with the C code but I failed...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
