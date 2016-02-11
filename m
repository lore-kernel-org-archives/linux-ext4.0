From: Eric Whitney <enwlinux@gmail.com>
Subject: 4.5-rc1 panic when running generic/300 with dioread_nolock
Date: Wed, 10 Feb 2016 19:23:44 -0500
Message-ID: <20160211002344.GA15231@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, jack@suse.cz
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:33346 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbcBKAXj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Feb 2016 19:23:39 -0500
Received: by mail-qg0-f42.google.com with SMTP id b35so27186954qge.0
        for <linux-ext4@vger.kernel.org>; Wed, 10 Feb 2016 16:23:39 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've been seeing a panic and other signs of locking trouble when running
xfstest generic/300 with xfstests-bld's x86-64 test appliance in the
dioread_nolock test configuration.  This began with the 4.5-rc1 kernel and has
continued through 4.5-rc3.  It happens in more than 50% of my test runs and
is accompanied by an inconsistent lock state warning.  It does not occur in
any other xfstest-bld test configuration.

The panic bisects to "ext4: get rid of EXT4_GET_BLOCKS_NO_LOCK flag"
(2dcba4781f).  Reverting this commit (requires minor merging) in a 4.5-rc1
kernel eliminates the panic.

Typical dmesg output follows.

Thanks,
Eric

generic/300 7s ...	[16:06:59][    3.320917] run fstests generic/300 at 2016-02-05 16:06:59
[    4.078053] 
[    4.078330] =================================
[    4.079036] [ INFO: inconsistent lock state ]
[    4.079407] 4.4.0-rc4+ #7 Not tainted
[    4.079724] ---------------------------------
[    4.080007] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-R} usage.
[    4.080007] fio/904 [HC1[1]:SC0[0]:HE0:SE1] takes:
[    4.080007]  (&journal->j_state_lock){+?++..}, at: [<ffffffff812f9bce>] start_this_handle+0xae/0x450
[    4.080007] {HARDIRQ-ON-W} state was registered at:
[    4.080007]   [<ffffffff810fc766>] __lock_acquire+0x896/0x1fb0
[    4.080007]   [<ffffffff810fe756>] lock_acquire+0xb6/0x130
[    4.080007]   [<ffffffff81724df1>] _raw_write_lock+0x31/0x40
[    4.080007]   [<ffffffff812c171d>] ext4_init_journal_params+0x4d/0xc0
[    4.080007]   [<ffffffff812d152e>] ext4_fill_super+0x236e/0x31c0
[    4.080007]   [<ffffffff8121cfe5>] mount_bdev+0x185/0x1b0
[    4.080007]   [<ffffffff812c1285>] ext4_mount+0x15/0x20
[    4.080007]   [<ffffffff8121d8a8>] mount_fs+0x38/0x170
[    4.080007]   [<ffffffff8123ce1b>] vfs_kern_mount+0x6b/0x160
[    4.080007]   [<ffffffff8123fda8>] do_mount+0x218/0xe70
[    4.080007]   [<ffffffff81240cfb>] SyS_mount+0x8b/0xd0
[    4.080007]   [<ffffffff81d49395>] mount_block_root+0xf6/0x284
[    4.080007]   [<ffffffff81d496ad>] mount_root+0x67/0x6a
[    4.080007]   [<ffffffff81d49817>] prepare_namespace+0x167/0x19f
[    4.080007]   [<ffffffff81d491c5>] kernel_init_freeable+0x268/0x278
[    4.080007]   [<ffffffff8171800e>] kernel_init+0xe/0xe0
[    4.080007]   [<ffffffff8172561f>] ret_from_fork+0x3f/0x70
[    4.080007] irq event stamp: 38034
[    4.080007] hardirqs last  enabled at (38033): [<ffffffff811adac7>] context_tracking_exit.part.6+0x37/0x60
[    4.080007] hardirqs last disabled at (38034): [<ffffffff81725d8c>] common_interrupt+0x8c/0x91
[    4.080007] softirqs last  enabled at (36084): [<ffffffff810ae829>] __do_softirq+0x2a9/0x340
[    4.080007] softirqs last disabled at (36063): [<ffffffff810aea8e>] irq_exit+0xbe/0xc0
[    4.080007] 
[    4.080007] other info that might help us debug this:
[    4.080007]  Possible unsafe locking scenario:
[    4.080007] 
[    4.080007]        CPU0
[    4.080007]        ----
[    4.080007]   lock(&journal->j_state_lock);
[    4.080007]   <Interrupt>
[    4.080007]     lock(&journal->j_state_lock);
[    4.080007] 
[    4.080007]  *** DEADLOCK ***
[    4.080007] 
[    4.080007] 1 lock held by fio/904:
[    4.080007]  #0:  (&(&vblk->vqs[i].lock)->rlock){-.-...}, at: [<ffffffff81588193>] virtblk_done+0x43/0xe0
[    4.080007] 
[    4.080007] stack backtrace:
[    4.080007] CPU: 0 PID: 904 Comm: fio Not tainted 4.4.0-rc4+ #7
[    4.080007] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[    4.080007]  ffffffff826152e0 ffff88007fc039b0 ffffffff8138fb82 ffff88007a18c880
[    4.080007]  ffff88007fc03a00 ffffffff811aed8c 0000000000000000 0000000000000000
[    4.080007]  0000000000000001 0000000000000001 ffff88007a18d0d8 ffff88007a18c880
[    4.080007] Call Trace:
[    4.080007]  <IRQ>  [<ffffffff8138fb82>] dump_stack+0x44/0x62
[    4.080007]  [<ffffffff811aed8c>] print_usage_bug+0x1f3/0x208
[    4.080007]  [<ffffffff810fb889>] mark_lock+0x649/0x6c0
[    4.080007]  [<ffffffff810fa9e0>] ? print_shortest_lock_dependencies+0x1d0/0x1d0
[    4.080007]  [<ffffffff810fc8ee>] __lock_acquire+0xa1e/0x1fb0
[    4.080007]  [<ffffffff810f7565>] ? cpuacct_charge+0x5/0x190
[    4.080007]  [<ffffffff810f983d>] ? __lock_is_held+0x4d/0x70
[    4.080007]  [<ffffffff810f983d>] ? __lock_is_held+0x4d/0x70
[    4.080007]  [<ffffffff810fe756>] lock_acquire+0xb6/0x130
[    4.080007]  [<ffffffff812f9bce>] ? start_this_handle+0xae/0x450
[    4.080007]  [<ffffffff81724b34>] _raw_read_lock+0x34/0x50
[    4.080007]  [<ffffffff812f9bce>] ? start_this_handle+0xae/0x450
[    4.080007]  [<ffffffff812f9bce>] start_this_handle+0xae/0x450
[    4.080007]  [<ffffffff812f9700>] ? new_handle+0x20/0x60
[    4.080007]  [<ffffffff812fa10f>] jbd2__journal_start+0xbf/0x190
[    4.080007]  [<ffffffff812dd171>] ? ext4_convert_unwritten_extents+0xb1/0x210
[    4.080007]  [<ffffffff812df221>] __ext4_journal_start_sb+0x71/0xd0
[    4.080007]  [<ffffffff812dd171>] ext4_convert_unwritten_extents+0xb1/0x210
[    4.080007]  [<ffffffff812b4dee>] ext4_put_io_end+0x4e/0x70
[    4.080007]  [<ffffffff812ab13a>] ext4_end_io_dio+0x2a/0x30
[    4.080007]  [<ffffffff81258bcb>] dio_complete+0xcb/0x1b0
[    4.080007]  [<ffffffff81258d2f>] dio_bio_end_aio+0x7f/0x130
[    4.080007]  [<ffffffff8135d06f>] bio_endio+0x3f/0x60
[    4.080007]  [<ffffffff813647c7>] blk_update_request+0x97/0x320
[    4.080007]  [<ffffffff8136e85a>] blk_mq_end_request+0x1a/0x70
[    4.080007]  [<ffffffff8158833f>] virtblk_request_done+0x3f/0x70
[    4.080007]  [<ffffffff8136e92b>] __blk_mq_complete_request+0x7b/0xf0
[    4.080007]  [<ffffffff8136e9bc>] blk_mq_complete_request+0x1c/0x20
[    4.080007]  [<ffffffff815881b4>] virtblk_done+0x64/0xe0
[    4.080007]  [<ffffffff81432ee1>] vring_interrupt+0x31/0x50
[    4.080007]  [<ffffffff81107ac1>] handle_irq_event_percpu+0x81/0x1b0
[    4.080007]  [<ffffffff81107c29>] handle_irq_event+0x39/0x60
[    4.080007]  [<ffffffff8110ac9f>] handle_edge_irq+0x6f/0x150
[    4.080007]  [<ffffffff81056ded>] handle_irq+0x1d/0x30
[    4.080007]  [<ffffffff81727ab1>] do_IRQ+0x61/0x120
[    4.080007]  [<ffffffff81725d91>] common_interrupt+0x91/0x91
[    4.080007]  <EOI>  [<ffffffff811adacc>] ? context_tracking_exit.part.6+0x3c/0x60
[    4.080007]  [<ffffffff811adb0d>] context_tracking_exit+0x1d/0x20
[    4.080007]  [<ffffffff810026bf>] enter_from_user_mode+0x1f/0x50
[    4.080007]  [<ffffffff810027b6>] syscall_trace_enter_phase1+0xc6/0x130
[    4.080007]  [<ffffffff81002017>] ? trace_hardirqs_on_thunk+0x17/0x19
[    4.080007]  [<ffffffff81725335>] tracesys+0xd/0x44
[    4.080007] ------------[ cut here ]------------
[    4.080007] kernel BUG at fs/buffer.c:1281!
[    4.080007] invalid opcode: 0000 [#1] SMP 
[    4.080007] Modules linked in:
[    4.080007] CPU: 0 PID: 904 Comm: fio Not tainted 4.4.0-rc4+ #7
[    4.080007] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[    4.080007] task: ffff88007a18c880 ti: ffff880079144000 task.ti: ffff880079144000
[    4.080007] RIP: 0010:[<ffffffff81252f41>]  [<ffffffff81252f41>] __find_get_block+0x121/0x130
[    4.080007] RSP: 0018:ffff88007fc03a78  EFLAGS: 00010046
[    4.080007] RAX: 0000000000000086 RBX: 0000000000018980 RCX: 0000000002400048
[    4.080007] RDX: 0000000000001000 RSI: 000000000000dde0 RDI: ffff88007c06ca80
[    4.080007] RBP: ffff88007fc03aa8 R08: 0000000000000001 R09: 0000000000000000
[    4.080007] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88007c06ca80
[    4.080007] R13: 000000000000dde0 R14: 0000000000001000 R15: 0000000002400048
[    4.080007] FS:  00007fcfc0cd4740(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
[    4.080007] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.080007] CR2: 000000000258c018 CR3: 000000007a031000 CR4: 00000000000006f0
[    4.080007] Stack:
[    4.080007]  ffffffff81253223 0000000000018980 ffff880079c86af0 000000000000dde0
[    4.080007]  ffff88007a088900 0000000000000001 ffff88007fc03b00 ffffffff812d68d6
[    4.080007]  0000000002408040 000003867fc03b00 ffffffff81841db0 ffffffff00000000
[    4.080007] Call Trace:
[    4.080007]  <IRQ> 
[    4.080007]  [<ffffffff81253223>] ? __getblk_gfp+0x23/0x60
[    4.080007]  [<ffffffff812d68d6>] __read_extent_tree_block+0x46/0x200
[    4.080007]  [<ffffffff812d7b89>] ext4_find_extent+0x139/0x320
[    4.080007]  [<ffffffff812dc2a7>] ext4_ext_map_blocks+0x87/0xdd0
[    4.080007]  [<ffffffff812adbaa>] ? ext4_map_blocks+0xea/0x4b0
[    4.080007]  [<ffffffff812adbce>] ext4_map_blocks+0x10e/0x4b0
[    4.080007]  [<ffffffff812dd171>] ? ext4_convert_unwritten_extents+0xb1/0x210
[    4.080007]  [<ffffffff812dd194>] ext4_convert_unwritten_extents+0xd4/0x210
[    4.080007]  [<ffffffff812b4dee>] ext4_put_io_end+0x4e/0x70
[    4.080007]  [<ffffffff812ab13a>] ext4_end_io_dio+0x2a/0x30
[    4.080007]  [<ffffffff81258bcb>] dio_complete+0xcb/0x1b0
[    4.080007]  [<ffffffff81258d2f>] dio_bio_end_aio+0x7f/0x130
[    4.080007]  [<ffffffff8135d06f>] bio_endio+0x3f/0x60
[    4.080007]  [<ffffffff813647c7>] blk_update_request+0x97/0x320
[    4.080007]  [<ffffffff8136e85a>] blk_mq_end_request+0x1a/0x70
[    4.080007]  [<ffffffff8158833f>] virtblk_request_done+0x3f/0x70
[    4.080007]  [<ffffffff8136e92b>] __blk_mq_complete_request+0x7b/0xf0
[    4.080007]  [<ffffffff8136e9bc>] blk_mq_complete_request+0x1c/0x20
[    4.080007]  [<ffffffff815881b4>] virtblk_done+0x64/0xe0
[    4.080007]  [<ffffffff81432ee1>] vring_interrupt+0x31/0x50
[    4.080007]  [<ffffffff81107ac1>] handle_irq_event_percpu+0x81/0x1b0
[    4.080007]  [<ffffffff81107c29>] handle_irq_event+0x39/0x60
[    4.080007]  [<ffffffff8110ac9f>] handle_edge_irq+0x6f/0x150
[    4.080007]  [<ffffffff81056ded>] handle_irq+0x1d/0x30
[    4.080007]  [<ffffffff81727ab1>] do_IRQ+0x61/0x120
[    4.080007]  [<ffffffff81725d91>] common_interrupt+0x91/0x91
[    4.080007]  <EOI> 
[    4.080007]  [<ffffffff811adacc>] ? context_tracking_exit.part.6+0x3c/0x60
[    4.080007]  [<ffffffff811adb0d>] context_tracking_exit+0x1d/0x20
[    4.080007]  [<ffffffff810026bf>] enter_from_user_mode+0x1f/0x50
[    4.080007]  [<ffffffff810027b6>] syscall_trace_enter_phase1+0xc6/0x130
[    4.080007]  [<ffffffff81002017>] ? trace_hardirqs_on_thunk+0x17/0x19
[    4.080007]  [<ffffffff81725335>] tracesys+0xd/0x44
[    4.080007] Code: de ff d0 49 8b 04 24 48 85 c0 75 e9 eb b3 4c 89 e6 4c 89 ef e8 41 ed ff ff 48 85 c0 48 89 c3 74 b5 48 89 c7 e8 e1 fc ff ff eb ab <0f> 0b 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 
[    4.080007] RIP  [<ffffffff81252f41>] __find_get_block+0x121/0x130
[    4.080007]  RSP <ffff88007fc03a78>
[    4.080007] ---[ end trace 9bbf559562132712 ]---
[    4.080007] Kernel panic - not syncing: Fatal exception in interrupt
[    4.080007] Kernel Offset: disabled
[    4.080007] ---[ end Kernel panic - not syncing: Fatal exception in interrupt





