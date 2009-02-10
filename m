From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: next-20090210: list_del corruption (ext4)
Date: Tue, 10 Feb 2009 20:06:06 +0300
Message-ID: <a4423d670902100906q36e7f36fo53ba2060f5644303@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:33901 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbZBJRGJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Feb 2009 12:06:09 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi

EXT4-fs: barriers enabled
kjournald2 starting: pid 20430, dev sda1:8, commit interval 5 seconds
EXT4 FS on sda1, internal journal on sda1:8
EXT4-fs: delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs: mounted filesystem sda1 with ordered data mode
------------[ cut here ]------------
WARNING: at lib/list_debug.c:48 list_del+0x71/0xa0()
Hardware name: PowerEdge 1950
list_del corruption. prev->next should be ffff880041b14498, but was
dead000000100100
Modules linked in:
Pid: 20452, comm: stress Not tainted 2.6.29-rc4-next-20090210 #5
Call Trace:
 [<ffffffff80241560>] warn_slowpath+0xd0/0x130
 [<ffffffff80235ad9>] ? sub_preempt_count+0xa9/0xf0
 [<ffffffff8026a195>] ? print_lock_contention_bug+0x25/0x120
 [<ffffffff8033f7c8>] ? __ext4_handle_dirty_metadata+0x38/0x100
 [<ffffffff8026a195>] ? print_lock_contention_bug+0x25/0x120
 [<ffffffff8026a195>] ? print_lock_contention_bug+0x25/0x120
 [<ffffffff8032849b>] ? ext4_mark_iloc_dirty+0x31b/0x5a0
 [<ffffffff80347f7c>] ? ext4_mb_release_context+0x15c/0x4f0
 [<ffffffff80347f7c>] ? ext4_mb_release_context+0x15c/0x4f0
 [<ffffffff8047f791>] list_del+0x71/0xa0
 [<ffffffff80348231>] ext4_mb_release_context+0x411/0x4f0
 [<ffffffff803417ac>] ? ext4_mb_initialize_context+0x7c/0x1b0
 [<ffffffff80348567>] ext4_mb_new_blocks+0x257/0x4b0
 [<ffffffff8033c073>] ? ext4_ext_find_extent+0x193/0x2e0
 [<ffffffff8033e83b>] ext4_ext_get_blocks+0xa2b/0xf70
 [<ffffffff804626d9>] ? __make_request+0xf9/0x4e0
 [<ffffffff8062f9c5>] ? _spin_unlock_irqrestore+0x65/0x80
 [<ffffffff8032d1ce>] ext4_get_blocks_wrap+0x18e/0x250
 [<ffffffff8032d529>] ext4_da_get_block_write+0x69/0x190
 [<ffffffff8032ac2d>] mpage_da_map_blocks+0x8d/0x640
 [<ffffffff8029f261>] ? __pagevec_release+0x21/0x30
 [<ffffffff8029ca07>] ? write_cache_pages+0x327/0x4a0
 [<ffffffff8032b970>] ? __mpage_da_writepage+0x0/0x1b0
 [<ffffffff8034cf5e>] ? jbd2_journal_start+0xce/0x140
 [<ffffffff8032b632>] ext4_da_writepages+0x282/0x4e0
 [<ffffffff8062f650>] ? _spin_unlock+0x30/0x60
 [<ffffffff8035259a>] ? find_revoke_record+0x9a/0xb0
 [<ffffffff8026a195>] ? print_lock_contention_bug+0x25/0x120
 [<ffffffff8026a195>] ? print_lock_contention_bug+0x25/0x120
 [<ffffffff8032d4c0>] ? ext4_da_get_block_write+0x0/0x190
 [<ffffffff8029cbdb>] do_writepages+0x2b/0x50
 [<ffffffff802e5a41>] __writeback_single_inode+0xa1/0x3f0
 [<ffffffff802e6282>] ? generic_sync_sb_inodes+0x3a2/0x420
 [<ffffffff802e6228>] generic_sync_sb_inodes+0x348/0x420
 [<ffffffff802e64e5>] writeback_inodes+0x65/0x100
 [<ffffffff8029d798>] balance_dirty_pages_ratelimited_nr+0x278/0x3f0
 [<ffffffff80336905>] ? __ext4_journal_stop+0x35/0x80
 [<ffffffff80296922>] generic_file_buffered_write+0x1e2/0x340
 [<ffffffff80296eb9>] __generic_file_aio_write_nolock+0x269/0x470
 [<ffffffff802971c9>] generic_file_aio_write+0x69/0xd0
 [<ffffffff80325c08>] ext4_file_write+0x58/0x170
 [<ffffffff802c6991>] do_sync_write+0xf1/0x140
 [<ffffffff80259640>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff80235ad9>] ? sub_preempt_count+0xa9/0xf0
 [<ffffffff802c6ffb>] vfs_write+0xcb/0x170
 [<ffffffff802c7190>] sys_write+0x50/0x90
 [<ffffffff8020bc1b>] system_call_fastpath+0x16/0x1b
---[ end trace 001a16110339633e ]---
------------[ cut here ]------------
WARNING: at lib/list_debug.c:26 __list_add+0x70/0xa0()
Hardware name: PowerEdge 1950
list_add corruption. next->prev should be prev (ffff88007c7e55e0), but
was 6b6b6b6b6b6b6b6b. (next=ffff88001239c750).
Modules linked in:
Pid: 20607, comm: pdflush Tainted: G        W  2.6.29-rc4-next-20090210 #5
Call Trace:
 [<ffffffff80241560>] warn_slowpath+0xd0/0x130
 [<ffffffff803434e5>] ? ext4_mb_use_best_found+0x3d5/0x430
 [<ffffffff8062f650>] ? _spin_unlock+0x30/0x60
 [<ffffffff80235ad9>] ? sub_preempt_count+0xa9/0xf0
 [<ffffffff802c2b45>] ? kmem_cache_alloc+0xb5/0x100
 [<ffffffff8034447d>] ? ext4_mb_new_inode_pa+0x5d/0x390
 [<ffffffff8026c199>] ? trace_hardirqs_on_caller+0x29/0x1e0
 [<ffffffff8047f830>] __list_add+0x70/0xa0
 [<ffffffff80344699>] ext4_mb_new_inode_pa+0x279/0x390
 [<ffffffff803487ab>] ext4_mb_new_blocks+0x49b/0x4b0
 [<ffffffff8033c198>] ? ext4_ext_find_extent+0x2b8/0x2e0
 [<ffffffff8033e83b>] ext4_ext_get_blocks+0xa2b/0xf70
 [<ffffffff804626d9>] ? __make_request+0xf9/0x4e0
 [<ffffffff8062f9c5>] ? _spin_unlock_irqrestore+0x65/0x80
 [<ffffffff8032d1ce>] ext4_get_blocks_wrap+0x18e/0x250
 [<ffffffff8032d529>] ext4_da_get_block_write+0x69/0x190
 [<ffffffff8032ac2d>] mpage_da_map_blocks+0x8d/0x640
 [<ffffffff8029f261>] ? __pagevec_release+0x21/0x30
 [<ffffffff8029ca07>] ? write_cache_pages+0x327/0x4a0
 [<ffffffff8032b970>] ? __mpage_da_writepage+0x0/0x1b0
 [<ffffffff8034cf5e>] ? jbd2_journal_start+0xce/0x140
 [<ffffffff8032b632>] ext4_da_writepages+0x282/0x4e0
 [<ffffffff8026a195>] ? print_lock_contention_bug+0x25/0x120
 [<ffffffff8026a195>] ? print_lock_contention_bug+0x25/0x120
 [<ffffffff8026a195>] ? print_lock_contention_bug+0x25/0x120
 [<ffffffff8026a195>] ? print_lock_contention_bug+0x25/0x120
 [<ffffffff8026a195>] ? print_lock_contention_bug+0x25/0x120
 [<ffffffff8032d4c0>] ? ext4_da_get_block_write+0x0/0x190
 [<ffffffff8029cbdb>] do_writepages+0x2b/0x50
 [<ffffffff802e5a41>] __writeback_single_inode+0xa1/0x3f0
 [<ffffffff802e5f14>] ? generic_sync_sb_inodes+0x34/0x420
 [<ffffffff802e6228>] generic_sync_sb_inodes+0x348/0x420
 [<ffffffff802e64e5>] writeback_inodes+0x65/0x100
 [<ffffffff8029d2f0>] background_writeout+0xb0/0xe0
 [<ffffffff8029dae0>] pdflush+0x110/0x1f0
 [<ffffffff8029d240>] ? background_writeout+0x0/0xe0
 [<ffffffff8029d9d0>] ? pdflush+0x0/0x1f0
 [<ffffffff80259196>] kthread+0x56/0x90
 [<ffffffff8020cc9a>] child_rip+0xa/0x20
 [<ffffffff802359a9>] ? finish_task_switch+0x89/0x110
 [<ffffffff8062f936>] ? _spin_unlock_irq+0x36/0x60
 [<ffffffff8020c680>] ? restore_args+0x0/0x30
 [<ffffffff80259140>] ? kthread+0x0/0x90
 [<ffffffff8020cc90>] ? child_rip+0x0/0x20
---[ end trace 001a16110339633f ]---
=============================================================================
BUG ext4_prealloc_space: Poison overwritten
-----------------------------------------------------------------------------

INFO: 0xffff88001239c758-0xffff88001239c75f. First byte 0x80 instead of 0x6b
INFO: Allocated in ext4_mb_new_inode_pa+0x5d/0x390 age=1953 cpu=0 pid=20453
INFO: Freed in ext4_mb_pa_callback+0x14/0x20 age=1816 cpu=2 pid=0
INFO: Slab 0xffffe20000767760 objects=35 used=2 fp=0xffff88001239c740
flags=0x40000000000080c3
INFO: Object 0xffff88001239c740 @offset=1856 fp=0xffff88001239c000

Bytes b4 0xffff88001239c730:  e6 41 65 00 01 00 00 00 5a 5a 5a 5a 5a
5a 5a 5a <E6>Ae.....ZZZZZZZZ
  Object 0xffff88001239c740:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88001239c750:  6b 6b 6b 6b 6b 6b 6b 6b 80 45 3c 12 00
88 ff ff kkkkkkkk.E<...<FF><FF>
  Object 0xffff88001239c760:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88001239c770:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88001239c780:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88001239c790:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88001239c7a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88001239c7b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88001239c7c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b 6b kkkkkkkkkkkkkkkk
  Object 0xffff88001239c7d0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
6b 6b a5 kkkkkkkkkkkkkkk<A5>
 Redzone 0xffff88001239c7e0:  bb bb bb bb bb bb bb bb
       <BB><BB><BB><BB><BB><BB><BB><BB>
 Padding 0xffff88001239c820:  5a 5a 5a 5a 5a 5a 5a 5a
       ZZZZZZZZ
Pid: 20450, comm: stress Tainted: G        W  2.6.29-rc4-next-20090210 #5
Call Trace:
 [<ffffffff802bf5a6>] print_trailer+0x106/0x160
 [<ffffffff802bfa85>] check_bytes_and_report+0x125/0x180
 [<ffffffff802c120c>] check_object+0xac/0x280
 [<ffffffff802c29c2>] __slab_alloc+0x542/0x610
 [<ffffffff802c2ac9>] ? kmem_cache_alloc+0x39/0x100
 [<ffffffff8034447d>] ? ext4_mb_new_inode_pa+0x5d/0x390
 [<ffffffff8034447d>] ? ext4_mb_new_inode_pa+0x5d/0x390
 [<ffffffff802c2b86>] kmem_cache_alloc+0xf6/0x100
 [<ffffffff8034447d>] ext4_mb_new_inode_pa+0x5d/0x390
 [<ffffffff803487ab>] ext4_mb_new_blocks+0x49b/0x4b0
 [<ffffffff8033c073>] ? ext4_ext_find_extent+0x193/0x2e0
 [<ffffffff8033e83b>] ext4_ext_get_blocks+0xa2b/0xf70
 [<ffffffff804626d9>] ? __make_request+0xf9/0x4e0
 [<ffffffff8062f9c5>] ? _spin_unlock_irqrestore+0x65/0x80
 [<ffffffff8032d1ce>] ext4_get_blocks_wrap+0x18e/0x250
 [<ffffffff8032d529>] ext4_da_get_block_write+0x69/0x190
 [<ffffffff8032ac2d>] mpage_da_map_blocks+0x8d/0x640
 [<ffffffff8029f261>] ? __pagevec_release+0x21/0x30
 [<ffffffff8029ca07>] ? write_cache_pages+0x327/0x4a0
 [<ffffffff8032b970>] ? __mpage_da_writepage+0x0/0x1b0
 [<ffffffff8034cf5e>] ? jbd2_journal_start+0xce/0x140
 [<ffffffff8032b632>] ext4_da_writepages+0x282/0x4e0
 [<ffffffff8062f650>] ? _spin_unlock+0x30/0x60
 [<ffffffff8035259a>] ? find_revoke_record+0x9a/0xb0
 [<ffffffff8026a195>] ? print_lock_contention_bug+0x25/0x120
 [<ffffffff8026a195>] ? print_lock_contention_bug+0x25/0x120
 [<ffffffff8032d4c0>] ? ext4_da_get_block_write+0x0/0x190
 [<ffffffff8029cbdb>] do_writepages+0x2b/0x50
 [<ffffffff802e5a41>] __writeback_single_inode+0xa1/0x3f0
 [<ffffffff802e6282>] ? generic_sync_sb_inodes+0x3a2/0x420
 [<ffffffff802e6228>] generic_sync_sb_inodes+0x348/0x420
 [<ffffffff802e64e5>] writeback_inodes+0x65/0x100
 [<ffffffff8029d798>] balance_dirty_pages_ratelimited_nr+0x278/0x3f0
 [<ffffffff80336905>] ? __ext4_journal_stop+0x35/0x80
 [<ffffffff80296922>] generic_file_buffered_write+0x1e2/0x340
 [<ffffffff80296eb9>] __generic_file_aio_write_nolock+0x269/0x470
 [<ffffffff802971c9>] generic_file_aio_write+0x69/0xd0
 [<ffffffff80325c08>] ext4_file_write+0x58/0x170
 [<ffffffff802c6991>] do_sync_write+0xf1/0x140
 [<ffffffff80259640>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff80235ad9>] ? sub_preempt_count+0xa9/0xf0
 [<ffffffff802c6ffb>] vfs_write+0xcb/0x170
 [<ffffffff802c7190>] sys_write+0x50/0x90
 [<ffffffff8020bc1b>] system_call_fastpath+0x16/0x1b
FIX ext4_prealloc_space: Restoring 0xffff88001239c758-0xffff88001239c75f=0x6b

FIX ext4_prealloc_space: Marking all objects used
------------[ cut here ]------------
WARNING: at lib/list_debug.c:51 list_del+0x93/0xa0()
Hardware name: PowerEdge 1950
list_del corruption. next->prev should be ffff8800123c4580, but was
6b6b6b6b6b6b6b6b
Modules linked in:
Pid: 20450, comm: stress Tainted: G        W  2.6.29-rc4-next-20090210 #5
Call Trace:
 [<ffffffff80241560>] warn_slowpath+0xd0/0x130
 [<ffffffff80235ad9>] ? sub_preempt_count+0xa9/0xf0
 [<ffffffff8026a195>] ? print_lock_contention_bug+0x25/0x120
 [<ffffffff8033f7c8>] ? __ext4_handle_dirty_metadata+0x38/0x100
 [<ffffffff8026a195>] ? print_lock_contention_bug+0x25/0x120
 [<ffffffff8032849b>] ? ext4_mark_iloc_dirty+0x31b/0x5a0
 [<ffffffff80347f7c>] ? ext4_mb_release_context+0x15c/0x4f0
 [<ffffffff80347f7c>] ? ext4_mb_release_context+0x15c/0x4f0
 [<ffffffff8047f7b3>] list_del+0x93/0xa0
 [<ffffffff80348231>] ext4_mb_release_context+0x411/0x4f0
 [<ffffffff803417ac>] ? ext4_mb_initialize_context+0x7c/0x1b0
 [<ffffffff80348567>] ext4_mb_new_blocks+0x257/0x4b0
 [<ffffffff8033c198>] ? ext4_ext_find_extent+0x2b8/0x2e0
 [<ffffffff8033e83b>] ext4_ext_get_blocks+0xa2b/0xf70
 [<ffffffff8062f9c5>] ? _spin_unlock_irqrestore+0x65/0x80
 [<ffffffff8032d1ce>] ext4_get_blocks_wrap+0x18e/0x250
 [<ffffffff8032d529>] ext4_da_get_block_write+0x69/0x190
 [<ffffffff8032ac2d>] mpage_da_map_blocks+0x8d/0x640
 [<ffffffff8029f261>] ? __pagevec_release+0x21/0x30
 [<ffffffff8029ca07>] ? write_cache_pages+0x327/0x4a0
 [<ffffffff8032b970>] ? __mpage_da_writepage+0x0/0x1b0
 [<ffffffff8034cf5e>] ? jbd2_journal_start+0xce/0x140
 [<ffffffff8032b632>] ext4_da_writepages+0x282/0x4e0
 [<ffffffff8062f650>] ? _spin_unlock+0x30/0x60
 [<ffffffff8035259a>] ? find_revoke_record+0x9a/0xb0
 [<ffffffff8026a195>] ? print_lock_contention_bug+0x25/0x120
 [<ffffffff8026a195>] ? print_lock_contention_bug+0x25/0x120
 [<ffffffff8032d4c0>] ? ext4_da_get_block_write+0x0/0x190
 [<ffffffff8029cbdb>] do_writepages+0x2b/0x50
 [<ffffffff802e5a41>] __writeback_single_inode+0xa1/0x3f0
 [<ffffffff802e6282>] ? generic_sync_sb_inodes+0x3a2/0x420
 [<ffffffff802e6228>] generic_sync_sb_inodes+0x348/0x420
 [<ffffffff802e64e5>] writeback_inodes+0x65/0x100
 [<ffffffff8029d798>] balance_dirty_pages_ratelimited_nr+0x278/0x3f0
 [<ffffffff80336905>] ? __ext4_journal_stop+0x35/0x80
 [<ffffffff80296922>] generic_file_buffered_write+0x1e2/0x340
 [<ffffffff80296eb9>] __generic_file_aio_write_nolock+0x269/0x470
 [<ffffffff802971c9>] generic_file_aio_write+0x69/0xd0
 [<ffffffff80325c08>] ext4_file_write+0x58/0x170
 [<ffffffff802c6991>] do_sync_write+0xf1/0x140
 [<ffffffff80259640>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff80235ad9>] ? sub_preempt_count+0xa9/0xf0
 [<ffffffff802c6ffb>] vfs_write+0xcb/0x170
 [<ffffffff802c7190>] sys_write+0x50/0x90
 [<ffffffff8020bc1b>] system_call_fastpath+0x16/0x1b
