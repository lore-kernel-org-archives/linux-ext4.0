From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: next-20090206: deadlock on ext4
Date: Fri, 6 Feb 2009 20:35:18 +0300
Message-ID: <a4423d670902060935y59e540beta417144935416560@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi

I run dbench on ext4 on loop device.

EXT4-fs: barriers enabled
kjournald2 starting: pid 2420, dev loop0:8, commit interval 5 seconds
EXT4 FS on loop0, internal journal on loop0:8
EXT4-fs: delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs: mounted filesystem loop0 with ordered data mode
JBD: barrier-based sync failed on loop0:8 - disabling barriers

INFO: task pdflush:2339 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
pdflush       D 0000000000000002  3112  2339      2
 ffff88007d861990 0000000000000046 ffff88007d861940 ffffffff802971c6
 ffff88007d8618f8 0000000000004000 0000000000000000 ffff8800790bce40
 ffff880035c7ce40 ffff8800790bd1d8 00000000790bce40 0000000000000282
Call Trace:
 [<ffffffff802971c6>] ? mempool_alloc+0x56/0x150
 [<ffffffff8062dbd5>] ? _spin_unlock_irqrestore+0x65/0x80
 [<ffffffff8062ac47>] ? io_schedule+0x37/0x50
 [<ffffffff8062abe3>] schedule+0x13/0x40
 [<ffffffff8062ac47>] io_schedule+0x37/0x50
 [<ffffffff8029442d>] sync_page+0x6d/0x80
 [<ffffffff8062af52>] __wait_on_bit_lock+0x52/0xb0
 [<ffffffff802943c0>] ? sync_page+0x0/0x80
 [<ffffffff802943a4>] __lock_page+0x64/0x70
 [<ffffffff80259460>] ? wake_bit_function+0x0/0x40
 [<ffffffff8029e252>] ? pagevec_lookup_tag+0x22/0x30
 [<ffffffff8029c687>] write_cache_pages+0x247/0x4a0
 [<ffffffff8032b540>] ? __mpage_da_writepage+0x0/0x1b0
 [<ffffffff8034cafe>] ? jbd2_journal_start+0xce/0x140
 [<ffffffff8032b1e3>] ext4_da_writepages+0x263/0x4e0
 [<ffffffff80269f65>] ? print_lock_contention_bug+0x25/0x120
 [<ffffffff80269f65>] ? print_lock_contention_bug+0x25/0x120
 [<ffffffff80269f65>] ? print_lock_contention_bug+0x25/0x120
 [<ffffffff80269f65>] ? print_lock_contention_bug+0x25/0x120
 [<ffffffff8032d090>] ? ext4_da_get_block_write+0x0/0x190
 [<ffffffff8029c93b>] do_writepages+0x2b/0x50
 [<ffffffff802e56a1>] __writeback_single_inode+0xa1/0x3f0
 [<ffffffff802e5ee2>] ? generic_sync_sb_inodes+0x3a2/0x420
 [<ffffffff802e5e88>] generic_sync_sb_inodes+0x348/0x420
 [<ffffffff802e6145>] writeback_inodes+0x65/0x100
 [<ffffffff8029d050>] background_writeout+0xb0/0xe0
 [<ffffffff8029d840>] pdflush+0x110/0x1f0
 [<ffffffff8029cfa0>] ? background_writeout+0x0/0xe0
 [<ffffffff8029d730>] ? pdflush+0x0/0x1f0
 [<ffffffff8029d730>] ? pdflush+0x0/0x1f0
 [<ffffffff80258f76>] kthread+0x56/0x90
 [<ffffffff8020ce5a>] child_rip+0xa/0x20
 [<ffffffff80235759>] ? finish_task_switch+0x89/0x110
 [<ffffffff8062db46>] ? _spin_unlock_irq+0x36/0x60
 [<ffffffff8020c840>] ? restore_args+0x0/0x30
 [<ffffffff80258f20>] ? kthread+0x0/0x90
 [<ffffffff8020ce50>] ? child_rip+0x0/0x20
INFO: lockdep is turned off.
INFO: task kjournald2:2420 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kjournald2    D ffff88007b8d2090  4776  2420      2
 ffff88003d117d40 0000000000000046 0000000000000000 ffff88007b8d2358
 ffff8800790ba720 0000000000004000 0000000000000002 ffff8800790ba720
 ffff88007c820000 ffff8800790baab8 000000028062dbd5 0000000000000286
Call Trace:
 [<ffffffff8026bf69>] ? trace_hardirqs_on_caller+0x29/0x1e0
 [<ffffffff8034e794>] ? jbd2_journal_commit_transaction+0x1d4/0x19b0
 [<ffffffff8034e799>] ? jbd2_journal_commit_transaction+0x1d9/0x19b0
 [<ffffffff8062abe3>] schedule+0x13/0x40
 [<ffffffff8034e799>] jbd2_journal_commit_transaction+0x1d9/0x19b0
 [<ffffffff8062dba8>] ? _spin_unlock_irqrestore+0x38/0x80
 [<ffffffff80268709>] ? trace_hardirqs_off_caller+0x29/0xe0
 [<ffffffff802358a0>] ? sub_preempt_count+0xc0/0x130
 [<ffffffff80259420>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8024cefc>] ? try_to_del_timer_sync+0x7c/0x90
 [<ffffffff80354577>] kjournald2+0x117/0x380
 [<ffffffff80259420>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff80354460>] ? kjournald2+0x0/0x380
 [<ffffffff80258f76>] kthread+0x56/0x90
 [<ffffffff8020ce5a>] child_rip+0xa/0x20
 [<ffffffff80235759>] ? finish_task_switch+0x89/0x110
 [<ffffffff8062db46>] ? _spin_unlock_irq+0x36/0x60
 [<ffffffff8020c840>] ? restore_args+0x0/0x30
 [<ffffffff80258f20>] ? kthread+0x0/0x90
 [<ffffffff8020ce50>] ? child_rip+0x0/0x20
INFO: lockdep is turned off.
INFO: task dbench:2685 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
dbench        D 0000000000000001  3296  2685      1
 ffff8800793f9a18 0000000000000046 0000000000000000 ffff88007b8d21c8
 ffff880035c78000 0000000000004000 0000000000000003 ffff880035c78000
 ffff88007d2ace40 ffff880035c78398 000000038062dbd5 0000000000000286
Call Trace:
 [<ffffffff8026bf69>] ? trace_hardirqs_on_caller+0x29/0x1e0
 [<ffffffff8034c6a7>] ? start_this_handle+0x3b7/0x5e0
 [<ffffffff8034c6ac>] ? start_this_handle+0x3bc/0x5e0
 [<ffffffff8062abe3>] schedule+0x13/0x40
 [<ffffffff8034c6ac>] start_this_handle+0x3bc/0x5e0
 [<ffffffff80259420>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8034caf7>] jbd2_journal_start+0xc7/0x140
 [<ffffffff8029d5e5>] ? balance_dirty_pages_ratelimited_nr+0x365/0x3f0
 [<ffffffff80336575>] ext4_journal_start_sb+0x55/0x90
 [<ffffffff80329ef3>] ext4_da_write_begin+0xf3/0x260
 [<ffffffff802965d7>] generic_file_buffered_write+0x137/0x340
 [<ffffffff80296c19>] __generic_file_aio_write_nolock+0x269/0x470
 [<ffffffff80296f29>] generic_file_aio_write+0x69/0xd0
 [<ffffffff80325838>] ext4_file_write+0x58/0x170
 [<ffffffff802c66a1>] do_sync_write+0xf1/0x140
 [<ffffffff80259420>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff8026bf69>] ? trace_hardirqs_on_caller+0x29/0x1e0
 [<ffffffff80250a72>] ? sys_kill+0xa2/0x1c0
 [<ffffffff802c6d0b>] vfs_write+0xcb/0x170
 [<ffffffff802c6e42>] sys_pwrite64+0x92/0xa0
 [<ffffffff8020bddb>] system_call_fastpath+0x16/0x1b
