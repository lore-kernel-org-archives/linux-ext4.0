From: Thomas Backlund <tmb@mageia.org>
Subject: INFO: task jbd2/dm-0-8:3993 blocked for more than 120 seconds
Date: Wed, 17 Aug 2011 16:31:02 +0300
Message-ID: <4E4BC296.1040004@mageia.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.yrkesakademin.fi ([85.134.44.20]:58476 "EHLO
	mail.yrkesakademin.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab1HQNgi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Aug 2011 09:36:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

One of our buildnodes, a 8-core Supermicro X7DA8 system,
and a WDC WD1002FAEX-0 sata disk hits the "blocked for more than 120 
seconds" several times, and ends up resetting the ata bus.

The disk does not report any errors with smart, and we have the same 
model in a 24-core Supermicro X8DTN, and it does not show this problem.

This does kill the performance, so I'd like to get it fixed if possible.

Kernel is 2.6.33.18 (and the same problem was there in 2.6.33.7)

dm-0 is a lvm partition where the buildbots work:

/dev/mapper/vg0-1 on /home type ext4 (rw,relatime,acl)


Any ideas ?


--
Thomas



EXT4-fs (dm-0): mounted filesystem with ordered data mode
INFO: task jbd2/dm-0-8:3993 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
jbd2/dm-0-8   D 0000000000000002     0  3993      2 0x00000000
  ffff8801d985db40 0000000000000046 0000000000000004 ffff8801d985dc30
  ffff8800991d0f80 0000000000000282 ffff8801d985daf0 00000000019e7a71
  ffff8801d985dfd8 000000000000faf0 ffff88018318ada0 ffff88022b32ada0
Call Trace:
  [<ffffffff8108492b>] ? ktime_get_ts+0xab/0xe0
  [<ffffffff810e9ae0>] ? sync_page+0x0/0x50
  [<ffffffff813c4b33>] io_schedule+0x73/0xc0
  [<ffffffff810e9b1d>] sync_page+0x3d/0x50
  [<ffffffff813c518f>] __wait_on_bit+0x5f/0x90
  [<ffffffff810e9ca3>] wait_on_page_bit+0x73/0x80
  [<ffffffff8107a4c0>] ? wake_bit_function+0x0/0x40
  [<ffffffff810f4165>] ? pagevec_lookup_tag+0x25/0x40
  [<ffffffff810ea0bd>] filemap_fdatawait_range+0x10d/0x1a0
  [<ffffffff811e5caa>] ? submit_bio+0x7a/0x100
  [<ffffffff810ea17b>] filemap_fdatawait+0x2b/0x30
  [<ffffffffa0008df5>] jbd2_journal_commit_transaction+0x745/0x12f0 [jbd2]
  [<ffffffff8106b7eb>] ? try_to_del_timer_sync+0x7b/0xe0
  [<ffffffffa000f193>] kjournald2+0xb3/0x200 [jbd2]
  [<ffffffff8107a480>] ? autoremove_wake_function+0x0/0x40
  [<ffffffffa000f0e0>] ? kjournald2+0x0/0x200 [jbd2]
  [<ffffffff81079f56>] kthread+0x96/0xa0
  [<ffffffff8100ae24>] kernel_thread_helper+0x4/0x10
  [<ffffffff81079ec0>] ? kthread+0x0/0xa0
  [<ffffffff8100ae20>] ? kernel_thread_helper+0x0/0x10
INFO: task flush-252:0:3575 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
flush-252:0   D ffff88000914faf0     0  3575      2 0x00000000
  ffff8801b7c356b0 0000000000000046 0000000000000000 000000008107a46f
  0000000000000000 000312007fc5a8c0 ffff88018318b158 00000001006c71b4
  ffff8801b7c35fd8 000000000000faf0 ffff88022f145b40 ffff88018318ada0
Call Trace:
  [<ffffffffa0006855>] do_get_write_access+0x2c5/0x500 [jbd2]
  [<ffffffff8107a4c0>] ? wake_bit_function+0x0/0x40
  [<ffffffffa0006c21>] jbd2_journal_get_write_access+0x31/0x50 [jbd2]
  [<ffffffffa00523e8>] __ext4_journal_get_write_access+0x38/0x70 [ext4]
  [<ffffffffa005470a>] ext4_mb_mark_diskspace_used+0x7a/0x2f0 [ext4]
  [<ffffffffa00540d1>] ? ext4_mb_use_preallocated+0x221/0x230 [ext4]
  [<ffffffffa00535b2>] ? ext4_mb_initialize_context+0x82/0x1d0 [ext4]
  [<ffffffffa005ae49>] ext4_mb_new_blocks+0x2a9/0x560 [ext4]
  [<ffffffffa004ec59>] ? ext4_ext_find_extent+0x2b9/0x2f0 [ext4]
  [<ffffffffa00504d7>] ext4_ext_get_blocks+0x4b7/0x1720 [ext4]
  [<ffffffff810114f9>] ? read_tsc+0x9/0x20
  [<ffffffff8108492b>] ? ktime_get_ts+0xab/0xe0
  [<ffffffff810eb560>] ? find_get_pages_tag+0x40/0x140
  [<ffffffffa0030251>] ext4_get_blocks+0x1c1/0x210 [ext4]
  [<ffffffffa00315d9>] mpage_da_map_blocks+0xa9/0x430 [ext4]
  [<ffffffffa0031c35>] ext4_da_writepages+0x2d5/0x620 [ext4]
  [<ffffffff810f31e1>] do_writepages+0x21/0x40
  [<ffffffff81155b5a>] writeback_single_inode+0xea/0x3b0
  [<ffffffff81156236>] writeback_inodes_wb+0x2e6/0x500
  [<ffffffff8115656a>] wb_writeback+0x11a/0x1e0
  [<ffffffff813c4e26>] ? schedule_timeout+0x196/0x2f0
  [<ffffffff811568a4>] wb_do_writeback+0x194/0x1a0
  [<ffffffff81156903>] bdi_writeback_task+0x53/0xf0
  [<ffffffff81102ab0>] ? bdi_start_fn+0x0/0xe0
  [<ffffffff81102b21>] bdi_start_fn+0x71/0xe0
  [<ffffffff81102ab0>] ? bdi_start_fn+0x0/0xe0
  [<ffffffff81079f56>] kthread+0x96/0xa0
  [<ffffffff8100ae24>] kernel_thread_helper+0x4/0x10
  [<ffffffff81079ec0>] ? kthread+0x0/0xa0
  [<ffffffff8100ae20>] ? kernel_thread_helper+0x0/0x10
INFO: task urpmq:18484 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
urpmq         D ffff88000914faf0     0 18484  18483 0x00000000
  ffff88016357bcd8 0000000000000082 0000000000000000 ffffffff8108492b
  ffff880183189a88 ffff88022b1ad878 ffff880183189a88 00000001006c6dd7
  ffff88016357bfd8 000000000000faf0 ffff88022f145b40 ffff8801831896d0
Call Trace:
  [<ffffffff8108492b>] ? ktime_get_ts+0xab/0xe0
  [<ffffffff810e9ae0>] ? sync_page+0x0/0x50
  [<ffffffff813c4eb5>] schedule_timeout+0x225/0x2f0
  [<ffffffff811e58ef>] ? generic_make_request+0x1af/0x4f0
  [<ffffffff810ebf55>] ? mempool_alloc_slab+0x15/0x20
  [<ffffffff813c3bfd>] wait_for_common+0xcd/0x180
  [<ffffffff8104dac0>] ? default_wake_function+0x0/0x20
  [<ffffffff811e5caa>] ? submit_bio+0x7a/0x100
  [<ffffffff813c3d6d>] wait_for_completion+0x1d/0x20
  [<ffffffff811e8cce>] blkdev_issue_flush+0xae/0xf0
  [<ffffffff810f31e1>] ? do_writepages+0x21/0x40
  [<ffffffffa00292d3>] ext4_sync_file+0x183/0x260 [ext4]
  [<ffffffff8115a291>] vfs_fsync_range+0xa1/0xe0
  [<ffffffff8115a34d>] vfs_fsync+0x1d/0x20
  [<ffffffff8115a38e>] do_fsync+0x3e/0x60
  [<ffffffff8115a3c3>] sys_fdatasync+0x13/0x20
  [<ffffffff8100a002>] system_call_fastpath+0x16/0x1b
INFO: task rm:18632 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rm            D ffff88000908faf0     0 18632  18631 0x00020000
  ffff8801db6618d8 0000000000000086 0000000000000000 0000000000000002
  ffff8801db661868 ffffffff8107a46f ffff88022b3183b8 00000001006c6399
  ffff8801db661fd8 000000000000faf0 ffff88022f0f2da0 ffff88022b318000
Call Trace:
  [<ffffffff8107a46f>] ? wake_up_bit+0x2f/0x40
  [<ffffffff8115c190>] ? sync_buffer+0x0/0x50
  [<ffffffff813c4b33>] io_schedule+0x73/0xc0
  [<ffffffff8115c1d5>] sync_buffer+0x45/0x50
  [<ffffffff813c503a>] __wait_on_bit_lock+0x5a/0xc0
  [<ffffffff8115c190>] ? sync_buffer+0x0/0x50
  [<ffffffff813c5118>] out_of_line_wait_on_bit_lock+0x78/0x90
  [<ffffffff8107a4c0>] ? wake_bit_function+0x0/0x40
  [<ffffffff8115c356>] __lock_buffer+0x36/0x40
  [<ffffffffa0006a04>] do_get_write_access+0x474/0x500 [jbd2]
  [<ffffffff8115d834>] ? __getblk+0x24/0x2e0
  [<ffffffffa0006c21>] jbd2_journal_get_write_access+0x31/0x50 [jbd2]
  [<ffffffffa00523e8>] __ext4_journal_get_write_access+0x38/0x70 [ext4]
  [<ffffffffa00590ef>] ext4_free_blocks+0x2af/0xac0 [ext4]
  [<ffffffffa004dcca>] ? __ext4_ext_check+0xfa/0x230 [ext4]
  [<ffffffffa002f478>] ? ext4_mark_inode_dirty+0x78/0x1d0 [ext4]
  [<ffffffff8112b33d>] ? __kmalloc+0xdd/0x1a0
  [<ffffffffa0051f3a>] ext4_ext_truncate+0x7fa/0x940 [ext4]
  [<ffffffffa0032be5>] ext4_truncate+0x495/0x630 [ext4]
  [<ffffffffa002e0b1>] ? ext4_mark_iloc_dirty+0x331/0x5c0 [ext4]
  [<ffffffffa002f478>] ? ext4_mark_inode_dirty+0x78/0x1d0 [ext4]
  [<ffffffffa0033e98>] ext4_delete_inode+0x2b8/0x2d0 [ext4]
  [<ffffffffa0033be0>] ? ext4_delete_inode+0x0/0x2d0 [ext4]
  [<ffffffff8114b806>] generic_delete_inode+0xc6/0x180
  [<ffffffff8114baf5>] generic_drop_inode+0x55/0x70
  [<ffffffff8114a4e2>] iput+0x62/0x70
  [<ffffffff81141a82>] do_unlinkat+0x112/0x1d0
  [<ffffffff8116903c>] ? dnotify_flush+0x7c/0x130
  [<ffffffff8113263d>] ? filp_close+0x5d/0x90
  [<ffffffff81141cb2>] sys_unlinkat+0x22/0x40
  [<ffffffff8103d760>] sysenter_dispatch+0x7/0x2e
INFO: task flush-252:0:3575 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
flush-252:0   D ffff8800090cfaf0     0  3575      2 0x00000000
  ffff8801b7c356b0 0000000000000046 0000000000000000 ffffffff8107a46f
  ffff8801916d5380 ffff8801666bf310 ffff88018318b158 0000000100715810
  ffff8801b7c35fd8 000000000000faf0 ffff88022f1216d0 ffff88018318ada0
Call Trace:
  [<ffffffff8107a46f>] ? wake_up_bit+0x2f/0x40
  [<ffffffffa0006855>] do_get_write_access+0x2c5/0x500 [jbd2]
  [<ffffffff8107a4c0>] ? wake_bit_function+0x0/0x40
  [<ffffffffa0055221>] ? ext4_mb_complex_scan_group+0x181/0x240 [ext4]
  [<ffffffffa0006c21>] jbd2_journal_get_write_access+0x31/0x50 [jbd2]
  [<ffffffffa00523e8>] __ext4_journal_get_write_access+0x38/0x70 [ext4]
  [<ffffffffa005470a>] ext4_mb_mark_diskspace_used+0x7a/0x2f0 [ext4]
  [<ffffffffa00535b2>] ? ext4_mb_initialize_context+0x82/0x1d0 [ext4]
  [<ffffffffa005ae49>] ext4_mb_new_blocks+0x2a9/0x560 [ext4]
  [<ffffffffa004ec59>] ? ext4_ext_find_extent+0x2b9/0x2f0 [ext4]
  [<ffffffffa00504d7>] ext4_ext_get_blocks+0x4b7/0x1720 [ext4]
  [<ffffffff810f46fc>] ? release_pages+0x20c/0x240
  [<ffffffff810eb560>] ? find_get_pages_tag+0x40/0x140
  [<ffffffff81069e9c>] ? lock_timer_base+0x3c/0x70
  [<ffffffffa0030251>] ext4_get_blocks+0x1c1/0x210 [ext4]
  [<ffffffffa00315d9>] mpage_da_map_blocks+0xa9/0x430 [ext4]
  [<ffffffffa00071a5>] ? jbd2_journal_start+0xb5/0x100 [jbd2]
  [<ffffffffa0031c35>] ext4_da_writepages+0x2d5/0x620 [ext4]
  [<ffffffff810f31e1>] do_writepages+0x21/0x40
  [<ffffffff81155b5a>] writeback_single_inode+0xea/0x3b0
  [<ffffffff81156236>] writeback_inodes_wb+0x2e6/0x500
  [<ffffffff8115656a>] wb_writeback+0x11a/0x1e0
  [<ffffffff813c4e26>] ? schedule_timeout+0x196/0x2f0
  [<ffffffff811568a4>] wb_do_writeback+0x194/0x1a0
  [<ffffffff81156903>] bdi_writeback_task+0x53/0xf0
  [<ffffffff81102ab0>] ? bdi_start_fn+0x0/0xe0
  [<ffffffff81102b21>] bdi_start_fn+0x71/0xe0
  [<ffffffff81102ab0>] ? bdi_start_fn+0x0/0xe0
  [<ffffffff81079f56>] kthread+0x96/0xa0
  [<ffffffff8100ae24>] kernel_thread_helper+0x4/0x10
  [<ffffffff81079ec0>] ? kthread+0x0/0xa0
  [<ffffffff8100ae20>] ? kernel_thread_helper+0x0/0x10
INFO: task urpmi:26058 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
urpmi         D ffff88000914faf0     0 26058  26057 0x00000000
  ffff88020360bcc8 0000000000000082 0000000000000000 ffff8802255128e0
  0000000000000282 0000000000000282 ffff88022d03c828 00000001007157d0
  ffff88020360bfd8 000000000000faf0 ffff88022f145b40 ffff88022d03c470
Call Trace:
  [<ffffffff810e9ae0>] ? sync_page+0x0/0x50
  [<ffffffff813c4b33>] io_schedule+0x73/0xc0
  [<ffffffff810e9b1d>] sync_page+0x3d/0x50
  [<ffffffff813c518f>] __wait_on_bit+0x5f/0x90
  [<ffffffff810e9ca3>] wait_on_page_bit+0x73/0x80
  [<ffffffff8107a4c0>] ? wake_bit_function+0x0/0x40
  [<ffffffff810f4165>] ? pagevec_lookup_tag+0x25/0x40
  [<ffffffff810ea0bd>] filemap_fdatawait_range+0x10d/0x1a0
  [<ffffffff810f31e1>] ? do_writepages+0x21/0x40
  [<ffffffff810ea1db>] ? __filemap_fdatawrite_range+0x5b/0x60
  [<ffffffff810ea250>] filemap_write_and_wait_range+0x70/0x80
  [<ffffffff8115a26e>] vfs_fsync_range+0x7e/0xe0
  [<ffffffff8115a34d>] vfs_fsync+0x1d/0x20
  [<ffffffff8115a38e>] do_fsync+0x3e/0x60
  [<ffffffff8115a3c3>] sys_fdatasync+0x13/0x20
  [<ffffffff8100a002>] system_call_fastpath+0x16/0x1b
INFO: task jbd2/dm-0-8:3993 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
jbd2/dm-0-8   D ffff88000904faf0     0  3993      2 0x00000000
  ffff8801d985da60 0000000000000046 0000000000000000 ffffffff810114f9
  ffff8801d985da10 0000000000000286 ffff88022b32b158 000000010071c114
  ffff8801d985dfd8 000000000000faf0 ffff88022f0cc470 ffff88022b32ada0
Call Trace:
  [<ffffffff810114f9>] ? read_tsc+0x9/0x20
  [<ffffffff810e9ae0>] ? sync_page+0x0/0x50
  [<ffffffff813c4b33>] io_schedule+0x73/0xc0
  [<ffffffff810e9b1d>] sync_page+0x3d/0x50
  [<ffffffff813c518f>] __wait_on_bit+0x5f/0x90
  [<ffffffff810e9ca3>] wait_on_page_bit+0x73/0x80
  [<ffffffff8107a4c0>] ? wake_bit_function+0x0/0x40
  [<ffffffff810f4165>] ? pagevec_lookup_tag+0x25/0x40
  [<ffffffff810f304d>] write_cache_pages+0x2bd/0x400
  [<ffffffff810f1ec0>] ? __writepage+0x0/0x40
  [<ffffffff810be6b9>] ? delayacct_end+0x89/0xa0
  [<ffffffff8120e4d8>] ? __percpu_counter_add+0x58/0x80
  [<ffffffff810f31b4>] generic_writepages+0x24/0x30
  [<ffffffffa0008459>] journal_submit_data_buffers+0xb9/0x170 [jbd2]
  [<ffffffff810499b3>] ? __wake_up+0x53/0x70
  [<ffffffffa00089c5>] jbd2_journal_commit_transaction+0x315/0x12f0 [jbd2]
  [<ffffffff81069e9c>] ? lock_timer_base+0x3c/0x70
  [<ffffffff8106b7eb>] ? try_to_del_timer_sync+0x7b/0xe0
  [<ffffffffa000f193>] kjournald2+0xb3/0x200 [jbd2]
  [<ffffffff8107a480>] ? autoremove_wake_function+0x0/0x40
  [<ffffffffa000f0e0>] ? kjournald2+0x0/0x200 [jbd2]
  [<ffffffff81079f56>] kthread+0x96/0xa0
  [<ffffffff8100ae24>] kernel_thread_helper+0x4/0x10
  [<ffffffff81079ec0>] ? kthread+0x0/0xa0
  [<ffffffff8100ae20>] ? kernel_thread_helper+0x0/0x10
INFO: task flush-252:0:3575 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
flush-252:0   D ffff8800090cfaf0     0  3575      2 0x00000000
  ffff8801b7c35970 0000000000000046 0000000000000000 ffffffff811e58ef
  ffff8801b7c35948 0000000000000286 ffff88018318b158 000000010071bded
  ffff8801b7c35fd8 000000000000faf0 ffff88022f1216d0 ffff88018318ada0
Call Trace:
  [<ffffffff811e58ef>] ? generic_make_request+0x1af/0x4f0
  [<ffffffff810e9ae0>] ? sync_page+0x0/0x50
  [<ffffffff813c4b33>] io_schedule+0x73/0xc0
  [<ffffffff810e9b1d>] sync_page+0x3d/0x50
  [<ffffffff813c503a>] __wait_on_bit_lock+0x5a/0xc0
  [<ffffffff810e9ab7>] __lock_page+0x67/0x70
  [<ffffffff8107a4c0>] ? wake_bit_function+0x0/0x40
  [<ffffffff810f4165>] ? pagevec_lookup_tag+0x25/0x40
  [<ffffffff810f30fc>] write_cache_pages+0x36c/0x400
  [<ffffffffa0032050>] ? __mpage_da_writepage+0x0/0x1a0 [ext4]
  [<ffffffffa00071a5>] ? jbd2_journal_start+0xb5/0x100 [jbd2]
  [<ffffffffa0031c19>] ext4_da_writepages+0x2b9/0x620 [ext4]
  [<ffffffff810f31e1>] do_writepages+0x21/0x40
  [<ffffffff81155b5a>] writeback_single_inode+0xea/0x3b0
  [<ffffffff81156236>] writeback_inodes_wb+0x2e6/0x500
  [<ffffffff8115656a>] wb_writeback+0x11a/0x1e0
  [<ffffffff813c4e26>] ? schedule_timeout+0x196/0x2f0
  [<ffffffff811568a4>] wb_do_writeback+0x194/0x1a0
  [<ffffffff81156903>] bdi_writeback_task+0x53/0xf0
  [<ffffffff81102ab0>] ? bdi_start_fn+0x0/0xe0
  [<ffffffff81102b21>] bdi_start_fn+0x71/0xe0
  [<ffffffff81102ab0>] ? bdi_start_fn+0x0/0xe0
  [<ffffffff81079f56>] kthread+0x96/0xa0
  [<ffffffff8100ae24>] kernel_thread_helper+0x4/0x10
  [<ffffffff81079ec0>] ? kthread+0x0/0xa0
  [<ffffffff8100ae20>] ? kernel_thread_helper+0x0/0x10
INFO: task urpmi:26058 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
urpmi         D ffff88022d03c470     0 26058  26057 0x00000000
  ffff88020360bcd8 0000000000000082 ffff88020360bcb8 ffffffff810f12e6
  000000000000003a 000000020000001f ffff88022f104530 0000000000000030
  ffff88020360bfd8 000000000000faf0 ffff88022f254470 ffff88022d03c470
Call Trace:
  [<ffffffff810f12e6>] ? free_pcppages_bulk+0x2c6/0x350
  [<ffffffff813c4eb5>] schedule_timeout+0x225/0x2f0
  [<ffffffff811e58ef>] ? generic_make_request+0x1af/0x4f0
  [<ffffffff810ebf55>] ? mempool_alloc_slab+0x15/0x20
  [<ffffffff813c3bfd>] wait_for_common+0xcd/0x180
  [<ffffffff8104dac0>] ? default_wake_function+0x0/0x20
  [<ffffffff811e5caa>] ? submit_bio+0x7a/0x100
  [<ffffffff813c3d6d>] wait_for_completion+0x1d/0x20
  [<ffffffff811e8cce>] blkdev_issue_flush+0xae/0xf0
  [<ffffffff810f31e1>] ? do_writepages+0x21/0x40
  [<ffffffffa00292d3>] ext4_sync_file+0x183/0x260 [ext4]
  [<ffffffff8115a291>] vfs_fsync_range+0xa1/0xe0
  [<ffffffff8115a34d>] vfs_fsync+0x1d/0x20
  [<ffffffff8115a38e>] do_fsync+0x3e/0x60
  [<ffffffff8115a3c3>] sys_fdatasync+0x13/0x20
  [<ffffffff8100a002>] system_call_fastpath+0x16/0x1b
INFO: task jbd2/dm-0-8:3993 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
jbd2/dm-0-8   D ffff88000914faf0     0  3993      2 0x00000000
  ffff8801d985dd30 0000000000000046 0000000000000000 ffff8801b6b02620
  ffff88022ca46a80 ffff88022d06abd0 ffff88022b32b158 0000000100b91ae0
  ffff8801d985dfd8 000000000000faf0 ffff88022f145b40 ffff88022b32ada0
Call Trace:
  [<ffffffffa000886a>] jbd2_journal_commit_transaction+0x1ba/0x12f0 [jbd2]
  [<ffffffff81069e9c>] ? lock_timer_base+0x3c/0x70
  [<ffffffff8107a480>] ? autoremove_wake_function+0x0/0x40
  [<ffffffffa000f193>] kjournald2+0xb3/0x200 [jbd2]
  [<ffffffff8107a480>] ? autoremove_wake_function+0x0/0x40
  [<ffffffffa000f0e0>] ? kjournald2+0x0/0x200 [jbd2]
  [<ffffffff81079f56>] kthread+0x96/0xa0
  [<ffffffff8100ae24>] kernel_thread_helper+0x4/0x10
  [<ffffffff81079ec0>] ? kthread+0x0/0xa0
  [<ffffffff8100ae20>] ? kernel_thread_helper+0x0/0x10
at-spi-registry[6190]: segfault at c ip 00000000f73c7161 sp 
00000000ffa2c7f0 error 4 in libgconf-2.so.4.1.5[f73a6000+37000]
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
ata3.00: failed command: FLUSH CACHE EXT
ata3.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
          res 40/00:00:01:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: soft resetting link
ata3.00: configured for UDMA/133
ata3.00: retrying FLUSH 0xea Emask 0x4
ata3: EH complete
