From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: BUG: unable to handle kernel NULL pointer dereference at 0000000000000006
Date: Wed, 04 Jul 2012 18:36:50 +0800
Message-ID: <4FF41CC2.70706@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>
To: ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:15335 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756963Ab2GDK0t (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jul 2012 06:26:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I happen to hit this [1] while testing btrfs's latest upstream, which is based on 3.4.0.

And I'm not sure if this has been fixed, so I post a bug report here.

thanks,
liubo

===
[1]:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000006
IP: [<ffffffffa013348a>] jbd2__journal_start+0x4a/0x100 [jbd2]
PGD 0 
Oops: 0000 [#2] SMP 
CPU 1 
Modules linked in: btrfs(O) zlib_deflate libcrc32c iptable_filter ip_tables ebtable_nat ebtables 
ipt_REJECT bridge stp llc autofs4 cpufreq_ondemand acpi_cpufreq freq_table mperf be2iscsi iscsi_b
oot_sysfs bnx2i cnic uio cxgb3i libcxgbi cxgb3 mdio ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_c
ore ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ext3 jbd dm_mirror dm_region_has
h dm_log dm_mod ppdev sg coretemp hwmon i2c_i801 serio_raw iTCO_wdt iTCO_vendor_support parport_p
c parport pcspkr sky2 ext4 mbcache jbd2 sd_mod crc_t10dif pata_acpi ata_generic ata_piix i915 drm
_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: btrfs]

Pid: 4147, comm: fio Tainted: G      D    O 3.4.0+ #21 LENOVO QiTianM7150/To be filled by O.E.M.
RIP: 0010:[<ffffffffa013348a>]  [<ffffffffa013348a>] jbd2__journal_start+0x4a/0x100 [jbd2]
RSP: 0018:ffff88003434cff8  EFLAGS: 00010286
RAX: 0000000000000006 RBX: ffff880077ab3190 RCX: 0000000000000003
RDX: 0000000000000050 RSI: 0000000000000024 RDI: ffff88007540c800
RBP: ffff88003434d028 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000014 R12: ffff88007540c800
R13: ffff880037424a90 R14: 0000000000000024 R15: ffff880079156920
FS:  0000000000000000(0000) GS:ffff88007da80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000006 CR3: 0000000001a0b000 CR4: 00000000000407e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process fio (pid: 4147, threadinfo ffff88003434c000, task ffff880037424a90)
Stack:
 ffffea0001252038 ffffea00013202f8 ffff88007540c800 ffff88007626b800
 0000000000000024 ffffffffa0161d2c ffff88003434d038 ffffffffa0133553
 ffff88003434d0a8 ffffffffa0178f43 0000000000000002 000000020000001f
Call Trace:
 [<ffffffffa05352fc>] ? free_extent_buffer+0x3c/0xa0 [btrfs]
 [<ffffffffa0161d2c>] ? ext4_evict_inode+0x12c/0x440 [ext4]
 [<ffffffffa0133553>] jbd2_journal_start+0x13/0x20 [jbd2]
 [<ffffffffa0178f43>] ext4_journal_start_sb+0x83/0x1b0 [ext4]
 [<ffffffffa0161d2c>] ext4_evict_inode+0x12c/0x440 [ext4]
 [<ffffffff8117e13f>] evict+0x9f/0x1b0
 [<ffffffff8117e364>] iput+0x114/0x210
 [<ffffffff8117bad8>] d_kill+0xf8/0x110
 [<ffffffff8117c2e2>] dput+0xe2/0x1b0
 [<ffffffff81166978>] fput+0x1c8/0x2a0
 [<ffffffff81162b43>] filp_close+0x63/0x90
 [<ffffffff8105016f>] put_files_struct+0x7f/0xf0
 [<ffffffff8105022c>] exit_files+0x4c/0x60
 [<ffffffff81051f02>] do_exit+0x192/0x900
 [<ffffffff81487fec>] oops_end+0xac/0xf0
 [<ffffffff8101665b>] die+0x5b/0x90
 [<ffffffff81487b44>] do_trap+0xc4/0x170
 [<ffffffff810144c5>] do_invalid_op+0x95/0xb0
 [<ffffffffa051747c>] ? cow_file_range+0x42c/0x4b0 [btrfs]
 [<ffffffffa053736a>] ? clear_extent_bit+0x15a/0x3f0 [btrfs]
 [<ffffffff8148ff9b>] invalid_op+0x1b/0x20
 [<ffffffffa051747c>] ? cow_file_range+0x42c/0x4b0 [btrfs]
 [<ffffffffa04f4199>] ? btrfs_search_slot+0x389/0x970 [btrfs]
 [<ffffffffa051b2a3>] run_delalloc_nocow+0x363/0x880 [btrfs]
 [<ffffffffa051bb0e>] run_delalloc_range+0x34e/0x3b0 [btrfs]
 [<ffffffffa053919d>] __extent_writepage+0x5dd/0x770 [btrfs]
 [<ffffffff810775ef>] ? walk_tg_tree_from+0x6f/0xd0
 [<ffffffff81106b5f>] ? find_get_pages_tag+0xcf/0x170
 [<ffffffffa0539812>] extent_write_cache_pages.clone.3+0x332/0x3d0 [btrfs]
 [<ffffffffa05398f6>] extent_writepages+0x46/0x60 [btrfs]
 [<ffffffffa051c440>] ? btrfs_mknod+0x200/0x200 [btrfs]
 [<ffffffffa0515d77>] btrfs_writepages+0x27/0x30 [btrfs]
 [<ffffffff81110981>] do_writepages+0x21/0x40
 [<ffffffff81105bab>] __filemap_fdatawrite_range+0x5b/0x60
 [<ffffffff81105e83>] filemap_fdatawrite_range+0x13/0x20
 [<ffffffffa0532765>] btrfs_wait_ordered_range+0x45/0x120 [btrfs]
 [<ffffffffa0555e6e>] __btrfs_write_out_cache+0x72e/0x950 [btrfs]
 [<ffffffffa05020a4>] ? btrfs_run_delayed_refs+0x254/0x4d0 [btrfs]
 [<ffffffffa0556202>] btrfs_write_out_cache+0xb2/0xf0 [btrfs]
 [<ffffffffa05027d3>] btrfs_write_dirty_block_groups+0x4b3/0x580 [btrfs]
 [<ffffffffa051169f>] commit_cowonly_roots+0x13f/0x210 [btrfs]
 [<ffffffffa05127c8>] btrfs_commit_transaction+0x5f8/0xaa0 [btrfs]
 [<ffffffffa0510da3>] ? btrfs_record_root_in_trans+0x63/0x80 [btrfs]
 [<ffffffffa0513032>] ? start_transaction+0x92/0x320 [btrfs]
 [<ffffffff8106f8d0>] ? wake_up_bit+0x40/0x40
 [<ffffffffa05222c8>] btrfs_sync_file+0x168/0x250 [btrfs]
 [<ffffffff8119136b>] vfs_fsync_range+0x2b/0x30
 [<ffffffff8119138c>] vfs_fsync+0x1c/0x20
 [<ffffffff811915ca>] do_fsync+0x3a/0x60
 [<ffffffff81191620>] sys_fsync+0x10/0x20
 [<ffffffff8148ee29>] system_call_fastpath+0x16/0x1b
Code: 8b 2c 25 80 c6 00 00 48 85 ff 49 89 fc 41 89 f6 49 8b 85 d0 07 00 00 48 c7 c3 e2 ff ff ff 74 18 48 85 c0 48 89 c3 74 29 48 8b 00 <48> 3b 38 0f 85 a9 00 00 00 83 43 0c 01 48 89 d8 4c 8b 65 e8 48 
RIP  [<ffffffffa013348a>] jbd2__journal_start+0x4a/0x100 [jbd2]
 RSP <ffff88003434cff8>
CR2: 0000000000000006
---[ end trace 30963075824b267c ]---
Fixing recursive fault but reboot is needed!
