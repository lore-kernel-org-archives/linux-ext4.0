From: Sage Weil <sage@newdream.net>
Subject: Null pointer deref in do_aio_submit
Date: Fri, 10 Feb 2012 09:27:51 -0800 (PST)
Message-ID: <Pine.LNX.4.64.1202100921580.1530@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:33953 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab2BJR1y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Feb 2012 12:27:54 -0500
Received: from cobra.newdream.net (localhost [127.0.0.1])
	by cobra.newdream.net (Postfix) with ESMTP id 96711BC7A7
	for <linux-ext4@vger.kernel.org>; Fri, 10 Feb 2012 09:27:51 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by cobra.newdream.net (Postfix) with ESMTP id 323D8BC7A7
	for <linux-ext4@vger.kernel.org>; Fri, 10 Feb 2012 09:27:51 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I hit the following under a reasonable simple aio workload:

 - reasonably heavy load
 - lots of threads doing buffered io to random files
 - one thread submitting O_DIRECT aio to a single file (journal), all 
   sequential (wrapping), 100MB
 - probably somewhere between 1 and 50 aios outstanding at any point in 
   time.

The kernel was v3.2 mainline, plus unrelated btrfs and ceph patches.

Is this a known issue?  Any other information that would be helpful?

sage


[26383.806034] BUG: unable to handle kernel NULL pointer dereference at 0000000000000088
[26383.810008] IP: [<ffffffff8109f582>] __lock_acquire+0x62/0x15d0
[26383.810008] PGD 36bb9067 PUD 368a9067 PMD 0 
[26383.810008] Oops: 0000 [#1] SMP 
[26383.850056] CPU 1 
[26383.850056] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs exportfs reiserfs ceph libceph cryptd aes_x86_64 aes_generic radeon ttm drm_kms_helper drm shpchp i2c_piix4 i2c_algo_bit k8temp psmouse amd64_edac_mod edac_core serio_raw edac_mce_amd lp parport btrfs tg3 sata_svw pata_serverworks floppy zlib_deflate crc32c libcrc32c [last unloaded: rbd]
[26383.850056] 
[26383.850056] Pid: 31861, comm: ceph-osd Not tainted 3.2.0-ceph-00149-geda84b5 #1 Supermicro H8SSL-I2/H8SSL-I2
[26383.850056] RIP: 0010:[<ffffffff8109f582>]  [<ffffffff8109f582>] __lock_acquire+0x62/0x15d0
[26383.850056] RSP: 0018:ffff88003b7d3968  EFLAGS: 00010046
[26383.850056] RAX: 0000000000000046 RBX: 0000000000000088 RCX: 0000000000000000
[26383.850056] RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000088
[26383.850056] RBP: ffff88003b7d3a38 R08: 0000000000000002 R09: 0000000000000001
[26383.850056] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000002
[26383.850056] R13: 0000000000000000 R14: 0000000000000000 R15: ffff8800e5905e50
[26383.850056] FS:  00007f294006a700(0000) GS:ffff8800edd00000(0000) knlGS:0000000000000000
[26383.850056] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[26383.850056] CR2: 0000000000000088 CR3: 00000000d1eb3000 CR4: 00000000000006e0
[26383.850056] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[26383.850056] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[26383.850056] Process ceph-osd (pid: 31861, threadinfo ffff88003b7d2000, task ffff8800e5905e50)
[26383.850056] Stack:
[26383.850056]  ffff88003b7d39b8 ffffffff8109ee2d ffffffff81605f70 0000000000000003
[26383.850056]  0000000000000001 ffff8800e5905e50 ffffffff81165bd7 ffffea00038e7e00
[26383.850056]  ffffffff8126b385 0000000000000202 ffff88003b7d39d8 ffffffff8109f1a5
[26383.850056] Call Trace:
[26383.850056]  [<ffffffff8109ee2d>] ? mark_held_locks+0x7d/0x120
[26383.850056]  [<ffffffff81605f70>] ? _raw_spin_unlock_irqrestore+0x40/0x70
[26383.850056]  [<ffffffff81165bd7>] ? kmem_cache_free+0x87/0x160
[26383.850056]  [<ffffffff8126b385>] ? jbd2_journal_stop+0x1e5/0x2d0
[26383.850056]  [<ffffffff8109f1a5>] ? trace_hardirqs_on_caller+0x105/0x190
[26383.850056]  [<ffffffff8109f23d>] ? trace_hardirqs_on+0xd/0x10
[26383.850056]  [<ffffffff811bceb6>] ? aio_complete+0x46/0x230
[26383.850056]  [<ffffffff810a10e2>] lock_acquire+0xa2/0x120
[26383.850056]  [<ffffffff811bceb6>] ? aio_complete+0x46/0x230
[26383.850056]  [<ffffffff8160588e>] _raw_spin_lock_irqsave+0x4e/0x70
[26383.850056]  [<ffffffff811bceb6>] ? aio_complete+0x46/0x230
[26383.850056]  [<ffffffff812481ea>] ? ext4_convert_unwritten_extents+0xca/0x130
[26383.850056]  [<ffffffff811bceb6>] aio_complete+0x46/0x230
[26383.850056]  [<ffffffff8121d201>] ? ext4_sync_file+0xb1/0x3e0
[26383.850056]  [<ffffffff81228130>] ext4_end_io_nolock+0x60/0x100
[26383.850056]  [<ffffffff8121d108>] ext4_flush_completed_IO+0x78/0xc0
[26383.850056]  [<ffffffff8121d258>] ext4_sync_file+0x108/0x3e0
[26383.850056]  [<ffffffff8111e86c>] ? generic_file_aio_write+0x5c/0xf0
[26383.850056]  [<ffffffff81603de9>] ? __mutex_unlock_slowpath+0xd9/0x180
[26383.850056]  [<ffffffff8109f1a5>] ? trace_hardirqs_on_caller+0x105/0x190
[26383.850056]  [<ffffffff811a4d0b>] vfs_fsync_range+0x2b/0x40
[26383.850056]  [<ffffffff811a4d81>] generic_write_sync+0x41/0x50
[26383.850056]  [<ffffffff8111e8de>] generic_file_aio_write+0xce/0xf0
[26383.850056]  [<ffffffff8121ce0f>] ext4_file_write+0x6f/0x2a0
[26383.850056]  [<ffffffff811bdd57>] ? do_io_submit+0x2c7/0xb80
[26383.850056]  [<ffffffff81605f20>] ? _raw_spin_unlock_irq+0x30/0x40
[26383.850056]  [<ffffffff8121cda0>] ? ext4_file_mmap+0x60/0x60
[26383.850056]  [<ffffffff811bb8bc>] aio_rw_vect_retry+0x7c/0x1d0
[26383.850056]  [<ffffffff811bb840>] ? aio_fsync+0x30/0x30
[26383.850056]  [<ffffffff811bd106>] aio_run_iocb+0x66/0x1a0
[26383.850056]  [<ffffffff811be128>] do_io_submit+0x698/0xb80
[26383.850056]  [<ffffffff810a0b98>] ? lock_release_non_nested+0xa8/0x330
[26383.850056]  [<ffffffff81315d1e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[26383.850056]  [<ffffffff811be620>] sys_io_submit+0x10/0x20
[26383.850056]  [<ffffffff8160e1c2>] system_call_fastpath+0x16/0x1b
[26383.850056] Code: 48 89 5d d8 4c 89 75 f0 45 0f 45 e0 85 c0 48 89 fb 4c 8b 55 10 0f 84 ee 03 00 00 44 8b 35 ab 4d d6 00 45 85 f6 0f 84 fe 03 00 00 <48> 81 3b 20 7d e6 81 b8 01 00 00 00 44 0f 44 e0 83 fe 01 0f 86 
[26383.850056] RIP  [<ffffffff8109f582>] __lock_acquire+0x62/0x15d0
[26383.850056]  RSP <ffff88003b7d3968>
[26383.850056] CR2: 0000000000000088
[26383.850056] ---[ end trace ea74669fb6eba98a ]---
[26383.850056] ------------[ cut here ]------------
[26383.850056] WARNING: at /srv/autobuild-ceph/gitbuilder.git/build/kernel/exit.c:898 do_exit+0x55/0x880()
[26383.850056] Hardware name: H8SSL-I2
[26383.850056] Modules linked in: ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs exportfs reiserfs ceph libceph cryptd aes_x86_64 aes_generic radeon ttm drm_kms_helper drm shpchp i2c_piix4 i2c_algo_bit k8temp psmouse amd64_edac_mod edac_core serio_raw edac_mce_amd lp parport btrfs tg3 sata_svw pata_serverworks floppy zlib_deflate crc32c libcrc32c [last unloaded: rbd]
[26383.850056] Pid: 31861, comm: ceph-osd Tainted: G      D      3.2.0-ceph-00149-geda84b5 #1
[26383.850056] Call Trace:
[26383.850056]  [<ffffffff810634af>] warn_slowpath_common+0x7f/0xc0
[26383.850056]  [<ffffffff8106350a>] warn_slowpath_null+0x1a/0x20
[26383.850056]  [<ffffffff81066b25>] do_exit+0x55/0x880
[26383.850056]  [<ffffffff81063c65>] ? kmsg_dump+0x105/0x140
[26383.850056]  [<ffffffff81063bd5>] ? kmsg_dump+0x75/0x140
[26383.850056]  [<ffffffff81607100>] oops_end+0xb0/0xf0
[26383.850056]  [<ffffffff8103f88d>] no_context+0xfd/0x270
[26383.850056]  [<ffffffff8103fb45>] __bad_area_nosemaphore+0x145/0x230
[26383.850056]  [<ffffffff8103fca1>] bad_area+0x51/0x60
[26383.850056]  [<ffffffff81609a3e>] ? do_page_fault+0xfe/0x4b0
[26383.850056]  [<ffffffff81609da2>] do_page_fault+0x462/0x4b0
[26383.850056]  [<ffffffff8109ee2d>] ? mark_held_locks+0x7d/0x120
[26383.850056]  [<ffffffff81315d5d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[26383.850056]  [<ffffffff81606535>] page_fault+0x25/0x30
[26383.850056]  [<ffffffff8109f582>] ? __lock_acquire+0x62/0x15d0
[26383.850056]  [<ffffffff8109ee2d>] ? mark_held_locks+0x7d/0x120
[26383.850056]  [<ffffffff81605f70>] ? _raw_spin_unlock_irqrestore+0x40/0x70
[26383.850056]  [<ffffffff81165bd7>] ? kmem_cache_free+0x87/0x160
[26383.850056]  [<ffffffff8126b385>] ? jbd2_journal_stop+0x1e5/0x2d0
[26383.850056]  [<ffffffff8109f1a5>] ? trace_hardirqs_on_caller+0x105/0x190
[26383.850056]  [<ffffffff8109f23d>] ? trace_hardirqs_on+0xd/0x10
[26383.850056]  [<ffffffff811bceb6>] ? aio_complete+0x46/0x230
[26383.850056]  [<ffffffff810a10e2>] lock_acquire+0xa2/0x120
[26383.850056]  [<ffffffff811bceb6>] ? aio_complete+0x46/0x230
[26383.850056]  [<ffffffff8160588e>] _raw_spin_lock_irqsave+0x4e/0x70
[26383.850056]  [<ffffffff811bceb6>] ? aio_complete+0x46/0x230
[26383.850056]  [<ffffffff812481ea>] ? ext4_convert_unwritten_extents+0xca/0x130
[26383.850056]  [<ffffffff811bceb6>] aio_complete+0x46/0x230
[26383.850056]  [<ffffffff8121d201>] ? ext4_sync_file+0xb1/0x3e0
[26383.850056]  [<ffffffff81228130>] ext4_end_io_nolock+0x60/0x100
[26383.850056]  [<ffffffff8121d108>] ext4_flush_completed_IO+0x78/0xc0
[26383.850056]  [<ffffffff8121d258>] ext4_sync_file+0x108/0x3e0
[26383.850056]  [<ffffffff8111e86c>] ? generic_file_aio_write+0x5c/0xf0
[26383.850056]  [<ffffffff81603de9>] ? __mutex_unlock_slowpath+0xd9/0x180
[26383.850056]  [<ffffffff8109f1a5>] ? trace_hardirqs_on_caller+0x105/0x190
[26383.850056]  [<ffffffff811a4d0b>] vfs_fsync_range+0x2b/0x40
[26383.850056]  [<ffffffff811a4d81>] generic_write_sync+0x41/0x50
[26383.850056]  [<ffffffff8111e8de>] generic_file_aio_write+0xce/0xf0
[26383.850056]  [<ffffffff8121ce0f>] ext4_file_write+0x6f/0x2a0
[26383.850056]  [<ffffffff811bdd57>] ? do_io_submit+0x2c7/0xb80
[26383.850056]  [<ffffffff81605f20>] ? _raw_spin_unlock_irq+0x30/0x40
[26383.850056]  [<ffffffff8121cda0>] ? ext4_file_mmap+0x60/0x60
[26383.850056]  [<ffffffff811bb8bc>] aio_rw_vect_retry+0x7c/0x1d0
[26383.850056]  [<ffffffff811bb840>] ? aio_fsync+0x30/0x30
[26383.850056]  [<ffffffff811bd106>] aio_run_iocb+0x66/0x1a0
[26383.850056]  [<ffffffff811be128>] do_io_submit+0x698/0xb80
[26383.850056]  [<ffffffff810a0b98>] ? lock_release_non_nested+0xa8/0x330
[26383.850056]  [<ffffffff81315d1e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[26383.850056]  [<ffffffff811be620>] sys_io_submit+0x10/0x20
[26383.850056]  [<ffffffff8160e1c2>] system_call_fastpath+0x16/0x1b
[26383.850056] ---[ end trace ea74669fb6eba98b ]---

