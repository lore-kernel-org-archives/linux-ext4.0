From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/2] ext4: deadlocks after allocation failure in
 ext4_init_io_end()
Date: Tue, 14 May 2013 23:54:02 +0200
Message-ID: <20130514215402.GC10769@quack.suse.cz>
References: <1368472093-16997-1-git-send-email-khoroshilov@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	spruce-project@linuxtesting.org
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1368472093-16997-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon 13-05-13 23:08:11, Alexey Khoroshilov wrote:
> Hi, Ted!
> 
> Our tests for ext4 with targeted fault injection were stalled in Uninterruptible Sleep State 
> when they simulate a memory allocation failure in ext4_init_io_end() while it is called from 
> mpage_da_submit_io() or ext4_writepage().
> 
> It looks like the problems are that pages left locked after failure handling.
> 
> I am not completely sure that my patches take into account all required aspects, 
> but the tests are passed if the patches are applied.
> 
> Please find below syslog excerpt for the first issue.
> 
> Found by Linux File System Verification project (linuxtesting.org/spruce). 
  Thanks for the patches! As Zheng said, the patch introducing these
problems is reverted from upstream now but we'll push an equivalent version
soon so I'll take care to include your fixes in it as well.

								Honza
> 
> --
> Alexey Khoroshilov
> Linux Verification Center, ISPRAS
> web: http://linuxtesting.org
> 
> 
> 
> [ 1212.454601] Failure is simulated in the following location
> [ 1212.454675] Call Trace:
> [ 1212.454681]  [<ffffffff81637257>] dump_stack+0x19/0x1b
> [ 1212.454687]  [<ffffffff81044fa0>] warn_slowpath_common+0x70/0xa0
> [ 1212.454691]  [<ffffffffa02fa869>] ? indicator_simulate+0x29/0x1a0 [kedr_fsim_indicator_common]
> [ 1212.454701]  [<ffffffffa0314b43>] ? ext4_init_io_end+0x23/0x50 [ext4]
> [ 1212.454705]  [<ffffffff81045086>] warn_slowpath_fmt+0x46/0x50
> [ 1212.454710]  [<ffffffffa020f24e>] ? kedr_fsim_point_simulate+0x7e/0xa0 [kedr_fault_simulation]
> [ 1212.454715]  [<ffffffffa020f1d5>] ? kedr_fsim_point_simulate+0x5/0xa0 [kedr_fault_simulation]
> [ 1212.454719]  [<ffffffffa02c181a>] kedr_repl_kmem_cache_alloc+0x7a/0xb0 [kedr_fsim_cmm]
> [ 1212.454727]  [<ffffffffa0314b43>] ? ext4_init_io_end+0x23/0x50 [ext4]
> [ 1212.454732]  [<ffffffffa02b3f23>] kedr_intermediate_func_kmem_cache_alloc+0x73/0xd0 [kedr_lc_common_mm]
> [ 1212.454740]  [<ffffffffa0314b43>] ? ext4_init_io_end+0x23/0x50 [ext4]
> [ 1212.454746]  [<ffffffffa0314b43>] ext4_init_io_end+0x23/0x50 [ext4]
> [ 1212.454753]  [<ffffffffa030bf6f>] mpage_da_submit_io+0x6f/0x380 [ext4]
> [ 1212.454762]  [<ffffffffa033aeeb>] ? __ext4_handle_dirty_metadata+0xab/0x140 [ext4]
> [ 1212.454769]  [<ffffffffa0280a4b>] ? jbd2_journal_get_write_access+0x3b/0x50 [jbd2]
> [ 1212.454777]  [<ffffffffa03105c8>] ? ext4_mark_iloc_dirty+0x468/0x660 [ext4]
> [ 1212.454784]  [<ffffffffa03108fa>] ? ext4_mark_inode_dirty+0x9a/0x270 [ext4]
> [ 1212.454790]  [<ffffffffa0312a5c>] ? mpage_da_map_and_submit+0x1fc/0x430 [ext4]
> [ 1212.454798]  [<ffffffffa031296e>] mpage_da_map_and_submit+0x10e/0x430 [ext4]
> [ 1212.454804]  [<ffffffffa0313567>] ? ext4_da_writepages+0x377/0x6a0 [ext4]
> [ 1212.454811]  [<ffffffffa03135bc>] ext4_da_writepages+0x3cc/0x6a0 [ext4]
> [ 1212.454815]  [<ffffffff8115360a>] ? __do_fault+0x14a/0x470
> [ 1212.454820]  [<ffffffff8113a123>] do_writepages+0x23/0x40
> [ 1212.454824]  [<ffffffff8112ed29>] __filemap_fdatawrite_range+0x59/0x60
> [ 1212.454828]  [<ffffffff8112ed6a>] filemap_write_and_wait_range+0x3a/0x80
> [ 1212.454835]  [<ffffffffa0311f65>] ext4_punch_hole+0x1f5/0x5c0 [ext4]
> [ 1212.454839]  [<ffffffff81642b88>] ? __do_page_fault+0x108/0x550
> [ 1212.454843]  [<ffffffff8118a981>] ? do_fallocate+0x101/0x190
> [ 1212.454847]  [<ffffffff8118a981>] ? do_fallocate+0x101/0x190
> [ 1212.454855]  [<ffffffffa0339e3c>] ext4_fallocate+0x30c/0x5d0 [ext4]
> [ 1212.454858]  [<ffffffff8118a981>] ? do_fallocate+0x101/0x190
> [ 1212.454862]  [<ffffffff8118de0d>] ? __fput+0x16d/0x2e0
> [ 1212.454865]  [<ffffffff8118a997>] do_fallocate+0x117/0x190
> [ 1212.454869]  [<ffffffff8118aa67>] SyS_fallocate+0x57/0x90
> [ 1212.454877]  [<ffffffff81647782>] system_call_fastpath+0x16/0x1b
> [ 1212.454880] ---[ end trace 16f55656139fb9de ]---
> [ 1443.148536] INFO: task flush-8:16:11233 blocked for more than 120 seconds.
> [ 1443.148628] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1443.148646] flush-8:16      D ffffffff8112d160     0 11233      2 0x00000000
> [ 1443.148669]  ffff88002fe5d768 0000000000000046 0000000000000000 ffff880082f8b4b8
> [ 1443.148692]  ffff8800300b9fb0 ffff88002fe5dfd8 ffff88002fe5dfd8 ffff88002fe5dfd8
> [ 1443.148712]  ffff88002ed75f10 ffff8800300b9fb0 ffff88002fe5d768 ffff880082a144e0
> [ 1443.148733] Call Trace:
> [ 1443.148764]  [<ffffffff8112d160>] ? __lock_page+0x70/0x70
> [ 1443.148770]  [<ffffffff8163d2e9>] schedule+0x29/0x70
> [ 1443.148773]  [<ffffffff8163d3bf>] io_schedule+0x8f/0xd0
> [ 1443.148777]  [<ffffffff8112d16e>] sleep_on_page+0xe/0x20
> [ 1443.148781]  [<ffffffff8163a3aa>] __wait_on_bit_lock+0x5a/0xc0
> [ 1443.148785]  [<ffffffff8112dd0e>] ? find_get_pages_tag+0x2e/0x1e0
> [ 1443.148790]  [<ffffffff811c25b1>] ? __block_write_full_page+0x211/0x390
> [ 1443.148794]  [<ffffffff8112d157>] __lock_page+0x67/0x70
> [ 1443.148799]  [<ffffffff8106f090>] ? autoremove_wake_function+0x50/0x50
> [ 1443.148809]  [<ffffffffa030d07e>] ext4_num_dirty_pages.isra.53+0x1fe/0x210 [ext4]
> [ 1443.148814]  [<ffffffff8113ae15>] ? pagevec_lookup_tag+0x25/0x40
> [ 1443.148818]  [<ffffffff81138374>] ? write_cache_pages+0x144/0x4e0
> [ 1443.148825]  [<ffffffffa031382d>] ext4_da_writepages+0x63d/0x6a0 [ext4]
> [ 1443.148829]  [<ffffffff81137f40>] ? set_page_dirty_lock+0x70/0x70
> [ 1443.148833]  [<ffffffff811b5863>] ? __writeback_single_inode+0x63/0x310
> [ 1443.148837]  [<ffffffff811b5863>] ? __writeback_single_inode+0x63/0x310
> [ 1443.148841]  [<ffffffff811b6abc>] ? writeback_sb_inodes+0x13c/0x550
> [ 1443.148845]  [<ffffffff8113a123>] do_writepages+0x23/0x40
> [ 1443.148849]  [<ffffffff811b5845>] __writeback_single_inode+0x45/0x310
> [ 1443.148853]  [<ffffffff811b6c48>] writeback_sb_inodes+0x2c8/0x550
> [ 1443.148856]  [<ffffffff811b6f6e>] __writeback_inodes_wb+0x9e/0xd0
> [ 1443.148860]  [<ffffffff811b72eb>] wb_writeback+0x34b/0x370
> [ 1443.148864]  [<ffffffff811a736e>] ? get_nr_inodes+0x5e/0xb0
> [ 1443.148868]  [<ffffffff811b73af>] wb_check_old_data_flush+0x9f/0xb0
> [ 1443.148872]  [<ffffffff811b9059>] wb_do_writeback+0x179/0x200
> [ 1443.148877]  [<ffffffff812cce0a>] ? debug_object_assert_init+0x7a/0xf0
> [ 1443.148881]  [<ffffffff81056f2b>] ? del_timer+0x2b/0x80
> [ 1443.148887]  [<ffffffff811b918c>] bdi_writeback_thread+0xac/0x300
> [ 1443.148894]  [<ffffffff811b90e0>] ? wb_do_writeback+0x200/0x200
> [ 1443.148900]  [<ffffffff8106e84a>] kthread+0xea/0xf0
> [ 1443.148905]  [<ffffffff8106e760>] ? flush_kthread_worker+0x150/0x150
> [ 1443.148919] INFO: task ext4lazyinit:2065 blocked for more than 120 seconds.
> [ 1443.148921] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1443.148925] ext4lazyinit    D ffff88007e93b828     0  2065      2 0x00000000
> [ 1443.148929]  ffff88007ebffbd8 0000000000000046 ffff88007ebffb78 ffffffff810ae74d
> [ 1443.148934]  ffff88002eee5f10 ffff88007ebfffd8 ffff88007ebfffd8 ffff88007ebfffd8
> [ 1443.148939]  ffffffff81c10440 ffff88002eee5f10 ffff88007e93b800 0000000000000001
> [ 1443.148943] Call Trace:
> [ 1443.148948]  [<ffffffff810ae74d>] ? trace_hardirqs_on+0xd/0x10
> [ 1443.148952]  [<ffffffff8163d2e9>] schedule+0x29/0x70
> [ 1443.148960]  [<ffffffffa027e435>] start_this_handle+0x2b5/0x560 [jbd2]
> [ 1443.148964]  [<ffffffff810a924a>] ? static_obj+0x5a/0x70
> [ 1443.148967]  [<ffffffff8106f040>] ? __init_waitqueue_head+0x60/0x60
> [ 1443.148972]  [<ffffffffa027e94d>] jbd2__journal_start+0xed/0x210 [jbd2]
> [ 1443.148980]  [<ffffffffa0324126>] ? ext4_lazyinit_thread+0xb6/0x330 [ext4]
> [ 1443.148987]  [<ffffffffa0324126>] ? ext4_lazyinit_thread+0xb6/0x330 [ext4]
> [ 1443.148994]  [<ffffffffa030b2aa>] ? ext4_init_inode_table+0xaa/0x360 [ext4]
> [ 1443.149002]  [<ffffffffa033a889>] __ext4_journal_start_sb+0x99/0x1a0 [ext4]
> [ 1443.149009]  [<ffffffffa030b2aa>] ext4_init_inode_table+0xaa/0x360 [ext4]
> [ 1443.149016]  [<ffffffffa0324126>] ? ext4_lazyinit_thread+0xb6/0x330 [ext4]
> [ 1443.149023]  [<ffffffffa0324190>] ext4_lazyinit_thread+0x120/0x330 [ext4]
> [ 1443.149029]  [<ffffffffa0324070>] ? init_once+0x70/0x70 [ext4]
> [ 1443.149033]  [<ffffffff8106e84a>] kthread+0xea/0xf0
> [ 1443.149036]  [<ffffffff8106e760>] ? flush_kthread_worker+0x150/0x150
> [ 1443.149039]  [<ffffffff816476dc>] ret_from_fork+0x7c/0xb0
> [ 1443.149043]  [<ffffffff8106e760>] ? flush_kthread_worker+0x150/0x150
> [ 1443.149048] INFO: task jbd2/sdb-8:2411 blocked for more than 120 seconds.
> [ 1443.149051] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1443.149054] jbd2/sdb-8      D ffff88006425bf60     0  2411      2 0x00000000
> [ 1443.149058]  ffff88006d039bf8 0000000000000046 ffff88006d039b98 ffffffff810ae74d
> [ 1443.149063]  ffff88006425bf60 ffff88006d039fd8 ffff88006d039fd8 ffff88006d039fd8
> [ 1443.149067]  ffff88002eee5f10 ffff88006425bf60 ffff88007d8983c0 ffff88006d039d28
> [ 1443.149072] Call Trace:
> [ 1443.149075]  [<ffffffff810ae74d>] ? trace_hardirqs_on+0xd/0x10
> [ 1443.149079]  [<ffffffff8163d2e9>] schedule+0x29/0x70
> [ 1443.149083]  [<ffffffffa0281540>] jbd2_journal_commit_transaction+0x220/0x1d00 [jbd2]
> [ 1443.149088]  [<ffffffff812ccdec>] ? debug_object_assert_init+0x5c/0xf0
> [ 1443.149092]  [<ffffffff810a8e4d>] ? trace_hardirqs_off+0xd/0x10
> [ 1443.149096]  [<ffffffff8163eb37>] ? _raw_spin_unlock_irqrestore+0x67/0x70
> [ 1443.149100]  [<ffffffff8106f040>] ? __init_waitqueue_head+0x60/0x60
> [ 1443.149103]  [<ffffffff81056db5>] ? del_timer_sync+0x5/0xd0
> [ 1443.149108]  [<ffffffffa0286fa1>] kjournald2+0xc1/0x260 [jbd2]
> [ 1443.149112]  [<ffffffff8106f040>] ? __init_waitqueue_head+0x60/0x60
> [ 1443.149116]  [<ffffffffa0286ee0>] ? commit_timeout+0x10/0x10 [jbd2]
> [ 1443.149120]  [<ffffffff8106e84a>] kthread+0xea/0xf0
> [ 1443.149123]  [<ffffffff8106e760>] ? flush_kthread_worker+0x150/0x150
> [ 1443.149127]  [<ffffffff816476dc>] ret_from_fork+0x7c/0xb0
> [ 1443.149130]  [<ffffffff8106e760>] ? flush_kthread_worker+0x150/0x150
> [ 1443.149135] INFO: task doer:2425 blocked for more than 120 seconds.
> [ 1443.149137] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1443.149141] doer            D ffffffff8112d160     0  2425  11234 0x00000000
> [ 1443.149145]  ffff88002f13f9b8 0000000000000046 0000000000000000 ffff880082f8b4b8
> [ 1443.149149]  ffff880030093f60 ffff88002f13ffd8 ffff88002f13ffd8 ffff88002f13ffd8
> [ 1443.149154]  ffffffff81c10440 ffff880030093f60 ffff88002f13f988 ffff880082a144e0
> [ 1443.149158] Call Trace:
> [ 1443.149162]  [<ffffffff8112d160>] ? __lock_page+0x70/0x70
> [ 1443.149165]  [<ffffffff8163d2e9>] schedule+0x29/0x70
> [ 1443.149169]  [<ffffffff8163d3bf>] io_schedule+0x8f/0xd0
> [ 1443.149172]  [<ffffffff8112d16e>] sleep_on_page+0xe/0x20
> [ 1443.149176]  [<ffffffff8163a3aa>] __wait_on_bit_lock+0x5a/0xc0
> [ 1443.149180]  [<ffffffff8112dd0e>] ? find_get_pages_tag+0x2e/0x1e0
> [ 1443.149183]  [<ffffffff8112d157>] __lock_page+0x67/0x70
> [ 1443.149187]  [<ffffffff8106f090>] ? autoremove_wake_function+0x50/0x50
> [ 1443.149193]  [<ffffffffa03131d9>] write_cache_pages_da+0x549/0x560 [ext4]
> [ 1443.149200]  [<ffffffffa0313567>] ? ext4_da_writepages+0x377/0x6a0 [ext4]
> [ 1443.149208]  [<ffffffffa033a889>] ? __ext4_journal_start_sb+0x99/0x1a0 [ext4]
> [ 1443.149214]  [<ffffffffa0313593>] ext4_da_writepages+0x3a3/0x6a0 [ext4]
> [ 1443.149218]  [<ffffffff8115360a>] ? __do_fault+0x14a/0x470
> [ 1443.149222]  [<ffffffff8113a123>] do_writepages+0x23/0x40
> [ 1443.149226]  [<ffffffff8112ed29>] __filemap_fdatawrite_range+0x59/0x60
> [ 1443.149230]  [<ffffffff8112ed6a>] filemap_write_and_wait_range+0x3a/0x80
> [ 1443.149236]  [<ffffffffa0311f65>] ext4_punch_hole+0x1f5/0x5c0 [ext4]
> [ 1443.149240]  [<ffffffff81642b88>] ? __do_page_fault+0x108/0x550
> [ 1443.149244]  [<ffffffff8118a981>] ? do_fallocate+0x101/0x190
> [ 1443.149248]  [<ffffffff8118a981>] ? do_fallocate+0x101/0x190
> [ 1443.149255]  [<ffffffffa0339e3c>] ext4_fallocate+0x30c/0x5d0 [ext4]
> [ 1443.149258]  [<ffffffff8118a981>] ? do_fallocate+0x101/0x190
> [ 1443.149262]  [<ffffffff8118de0d>] ? __fput+0x16d/0x2e0
> [ 1443.149265]  [<ffffffff8118a997>] do_fallocate+0x117/0x190
> [ 1443.149269]  [<ffffffff8118aa67>] SyS_fallocate+0x57/0x90
> [ 1443.149272]  [<ffffffff81647782>] system_call_fastpath+0x16/0x1b
> [ 1563.153036] INFO: task flush-8:16:11233 blocked for more than 120 seconds.
> [ 1563.153045] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1563.153049] flush-8:16      D ffffffff8112d160     0 11233      2 0x00000000
> [ 1563.153055]  ffff88002fe5d768 0000000000000046 0000000000000000 ffff880082f8b4b8
> [ 1563.153061]  ffff8800300b9fb0 ffff88002fe5dfd8 ffff88002fe5dfd8 ffff88002fe5dfd8
> [ 1563.153065]  ffff88002ed75f10 ffff8800300b9fb0 ffff88002fe5d768 ffff880082a144e0
> [ 1563.153071] Call Trace:
> [ 1563.153080]  [<ffffffff8112d160>] ? __lock_page+0x70/0x70
> [ 1563.153086]  [<ffffffff8163d2e9>] schedule+0x29/0x70
> [ 1563.153090]  [<ffffffff8163d3bf>] io_schedule+0x8f/0xd0
> [ 1563.153093]  [<ffffffff8112d16e>] sleep_on_page+0xe/0x20
> [ 1563.153097]  [<ffffffff8163a3aa>] __wait_on_bit_lock+0x5a/0xc0
> [ 1563.153101]  [<ffffffff8112dd0e>] ? find_get_pages_tag+0x2e/0x1e0
> [ 1563.153107]  [<ffffffff811c25b1>] ? __block_write_full_page+0x211/0x390
> [ 1563.153111]  [<ffffffff8112d157>] __lock_page+0x67/0x70
> [ 1563.153116]  [<ffffffff8106f090>] ? autoremove_wake_function+0x50/0x50
> [ 1563.153127]  [<ffffffffa030d07e>] ext4_num_dirty_pages.isra.53+0x1fe/0x210 [ext4]
> [ 1563.153133]  [<ffffffff8113ae15>] ? pagevec_lookup_tag+0x25/0x40
> [ 1563.153137]  [<ffffffff81138374>] ? write_cache_pages+0x144/0x4e0
> [ 1563.153144]  [<ffffffffa031382d>] ext4_da_writepages+0x63d/0x6a0 [ext4]
> [ 1563.153148]  [<ffffffff81137f40>] ? set_page_dirty_lock+0x70/0x70
> [ 1563.153153]  [<ffffffff811b5863>] ? __writeback_single_inode+0x63/0x310
> [ 1563.153157]  [<ffffffff811b5863>] ? __writeback_single_inode+0x63/0x310
> [ 1563.153161]  [<ffffffff811b6abc>] ? writeback_sb_inodes+0x13c/0x550
> [ 1563.153165]  [<ffffffff8113a123>] do_writepages+0x23/0x40
> [ 1563.153169]  [<ffffffff811b5845>] __writeback_single_inode+0x45/0x310
> [ 1563.153173]  [<ffffffff811b6c48>] writeback_sb_inodes+0x2c8/0x550
> [ 1563.153177]  [<ffffffff811b6f6e>] __writeback_inodes_wb+0x9e/0xd0
> [ 1563.153181]  [<ffffffff811b72eb>] wb_writeback+0x34b/0x370
> [ 1563.153185]  [<ffffffff811a736e>] ? get_nr_inodes+0x5e/0xb0
> [ 1563.153189]  [<ffffffff811b73af>] wb_check_old_data_flush+0x9f/0xb0
> [ 1563.153193]  [<ffffffff811b9059>] wb_do_writeback+0x179/0x200
> [ 1563.153199]  [<ffffffff812cce0a>] ? debug_object_assert_init+0x7a/0xf0
> [ 1563.153203]  [<ffffffff81056f2b>] ? del_timer+0x2b/0x80
> [ 1563.153207]  [<ffffffff811b918c>] bdi_writeback_thread+0xac/0x300
> [ 1563.153211]  [<ffffffff811b90e0>] ? wb_do_writeback+0x200/0x200
> [ 1563.153214]  [<ffffffff8106e84a>] kthread+0xea/0xf0
> [ 1563.153218]  [<ffffffff8106e760>] ? flush_kthread_worker+0x150/0x150
> [ 1563.153222]  [<ffffffff816476dc>] ret_from_fork+0x7c/0xb0
> [ 1563.153226]  [<ffffffff8106e760>] ? flush_kthread_worker+0x150/0x150
> [ 1563.153232] INFO: task ext4lazyinit:2065 blocked for more than 120 seconds.
> [ 1563.153235] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1563.153238] ext4lazyinit    D ffff88007e93b828     0  2065      2 0x00000000
> [ 1563.153242]  ffff88007ebffbd8 0000000000000046 ffff88007ebffb78 ffffffff810ae74d
> [ 1563.153247]  ffff88002eee5f10 ffff88007ebfffd8 ffff88007ebfffd8 ffff88007ebfffd8
> [ 1563.153252]  ffffffff81c10440 ffff88002eee5f10 ffff88007e93b800 0000000000000001
> [ 1563.153257] Call Trace:
> [ 1563.153261]  [<ffffffff810ae74d>] ? trace_hardirqs_on+0xd/0x10
> [ 1563.153265]  [<ffffffff8163d2e9>] schedule+0x29/0x70
> [ 1563.153392]  [<ffffffffa027e435>] start_this_handle+0x2b5/0x560 [jbd2]
> [ 1563.153397]  [<ffffffff810a924a>] ? static_obj+0x5a/0x70
> [ 1563.153401]  [<ffffffff8106f040>] ? __init_waitqueue_head+0x60/0x60
> [ 1563.153406]  [<ffffffffa027e94d>] jbd2__journal_start+0xed/0x210 [jbd2]
> [ 1563.153414]  [<ffffffffa0324126>] ? ext4_lazyinit_thread+0xb6/0x330 [ext4]
> [ 1563.153422]  [<ffffffffa0324126>] ? ext4_lazyinit_thread+0xb6/0x330 [ext4]
> [ 1563.153429]  [<ffffffffa030b2aa>] ? ext4_init_inode_table+0xaa/0x360 [ext4]
> [ 1563.153438]  [<ffffffffa033a889>] __ext4_journal_start_sb+0x99/0x1a0 [ext4]
> [ 1563.153445]  [<ffffffffa030b2aa>] ext4_init_inode_table+0xaa/0x360 [ext4]
> [ 1563.153452]  [<ffffffffa0324126>] ? ext4_lazyinit_thread+0xb6/0x330 [ext4]
> [ 1563.153459]  [<ffffffffa0324190>] ext4_lazyinit_thread+0x120/0x330 [ext4]
> [ 1563.153466]  [<ffffffffa0324070>] ? init_once+0x70/0x70 [ext4]
> [ 1563.153470]  [<ffffffff8106e84a>] kthread+0xea/0xf0
> [ 1563.153473]  [<ffffffff8106e760>] ? flush_kthread_worker+0x150/0x150
> [ 1563.153477]  [<ffffffff816476dc>] ret_from_fork+0x7c/0xb0
> [ 1563.153480]  [<ffffffff8106e760>] ? flush_kthread_worker+0x150/0x150
> [ 1563.153486] INFO: task jbd2/sdb-8:2411 blocked for more than 120 seconds.
> [ 1563.153489] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1563.153492] jbd2/sdb-8      D ffff88006425bf60     0  2411      2 0x00000000
> [ 1563.153497]  ffff88006d039bf8 0000000000000046 ffff88006d039b98 ffffffff810ae74d
> [ 1563.153502]  ffff88006425bf60 ffff88006d039fd8 ffff88006d039fd8 ffff88006d039fd8
> [ 1563.153507]  ffff88002eee5f10 ffff88006425bf60 ffff88007d8983c0 ffff88006d039d28
> [ 1563.153512] Call Trace:
> [ 1563.153515]  [<ffffffff810ae74d>] ? trace_hardirqs_on+0xd/0x10
> [ 1563.153519]  [<ffffffff8163d2e9>] schedule+0x29/0x70
> [ 1563.153524]  [<ffffffffa0281540>] jbd2_journal_commit_transaction+0x220/0x1d00 [jbd2]
> [ 1563.153528]  [<ffffffff812ccdec>] ? debug_object_assert_init+0x5c/0xf0
> [ 1563.153532]  [<ffffffff810a8e4d>] ? trace_hardirqs_off+0xd/0x10
> [ 1563.153537]  [<ffffffff8163eb37>] ? _raw_spin_unlock_irqrestore+0x67/0x70
> [ 1563.153541]  [<ffffffff8106f040>] ? __init_waitqueue_head+0x60/0x60
> [ 1563.153545]  [<ffffffff81056db5>] ? del_timer_sync+0x5/0xd0
> [ 1563.153550]  [<ffffffffa0286fa1>] kjournald2+0xc1/0x260 [jbd2]
> [ 1563.153554]  [<ffffffff8106f040>] ? __init_waitqueue_head+0x60/0x60
> [ 1563.153559]  [<ffffffffa0286ee0>] ? commit_timeout+0x10/0x10 [jbd2]
> [ 1563.153562]  [<ffffffff8106e84a>] kthread+0xea/0xf0
> [ 1563.153566]  [<ffffffff8106e760>] ? flush_kthread_worker+0x150/0x150
> [ 1563.153569]  [<ffffffff816476dc>] ret_from_fork+0x7c/0xb0
> [ 1563.153573]  [<ffffffff8106e760>] ? flush_kthread_worker+0x150/0x150
> [ 1563.153579] INFO: task doer:2425 blocked for more than 120 seconds.
> [ 1563.153581] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1563.153585] doer            D ffffffff8112d160     0  2425  11234 0x00000000
> [ 1563.153589]  ffff88002f13f9b8 0000000000000046 0000000000000000 ffff880082f8b4b8
> [ 1563.153594]  ffff880030093f60 ffff88002f13ffd8 ffff88002f13ffd8 ffff88002f13ffd8
> [ 1563.153599]  ffffffff81c10440 ffff880030093f60 ffff88002f13f988 ffff880082a144e0
> [ 1563.153604] Call Trace:
> [ 1563.153607]  [<ffffffff8112d160>] ? __lock_page+0x70/0x70
> [ 1563.153611]  [<ffffffff8163d2e9>] schedule+0x29/0x70
> [ 1563.153615]  [<ffffffff8163d3bf>] io_schedule+0x8f/0xd0
> [ 1563.153618]  [<ffffffff8112d16e>] sleep_on_page+0xe/0x20
> [ 1563.153622]  [<ffffffff8163a3aa>] __wait_on_bit_lock+0x5a/0xc0
> [ 1563.153626]  [<ffffffff8112dd0e>] ? find_get_pages_tag+0x2e/0x1e0
> [ 1563.153630]  [<ffffffff8112d157>] __lock_page+0x67/0x70
> [ 1563.153633]  [<ffffffff8106f090>] ? autoremove_wake_function+0x50/0x50
> [ 1563.153640]  [<ffffffffa03131d9>] write_cache_pages_da+0x549/0x560 [ext4]
> [ 1563.153647]  [<ffffffffa0313567>] ? ext4_da_writepages+0x377/0x6a0 [ext4]
> [ 1563.153655]  [<ffffffffa033a889>] ? __ext4_journal_start_sb+0x99/0x1a0 [ext4]
> [ 1563.153662]  [<ffffffffa0313593>] ext4_da_writepages+0x3a3/0x6a0 [ext4]
> [ 1563.153666]  [<ffffffff8115360a>] ? __do_fault+0x14a/0x470
> [ 1563.153670]  [<ffffffff8113a123>] do_writepages+0x23/0x40
> [ 1563.153674]  [<ffffffff8112ed29>] __filemap_fdatawrite_range+0x59/0x60
> [ 1563.153679]  [<ffffffff8112ed6a>] filemap_write_and_wait_range+0x3a/0x80
> [ 1563.153685]  [<ffffffffa0311f65>] ext4_punch_hole+0x1f5/0x5c0 [ext4]
> [ 1563.153690]  [<ffffffff81642b88>] ? __do_page_fault+0x108/0x550
> [ 1563.153694]  [<ffffffff8118a981>] ? do_fallocate+0x101/0x190
> [ 1563.153698]  [<ffffffff8118a981>] ? do_fallocate+0x101/0x190
> [ 1563.153705]  [<ffffffffa0339e3c>] ext4_fallocate+0x30c/0x5d0 [ext4]
> [ 1563.153720]  [<ffffffff8118aa67>] SyS_fallocate+0x57/0x90
> [ 1563.153723]  [<ffffffff81647782>] system_call_fastpath+0x16/0x1b
> [ 1683.155015] INFO: task flush-8:16:11233 blocked for more than 120 seconds.
> [ 1683.155039] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1683.155056] flush-8:16      D ffffffff8112d160     0 11233      2 0x00000000
> [ 1683.155078]  ffff88002fe5d768 0000000000000046 0000000000000000 ffff880082f8b4b8
> [ 1683.155101]  ffff8800300b9fb0 ffff88002fe5dfd8 ffff88002fe5dfd8 ffff88002fe5dfd8
> [ 1683.155120]  ffff88002ed75f10 ffff8800300b9fb0 ffff88002fe5d768 ffff880082a144e0
> [ 1683.155141] Call Trace:
> [ 1683.155166]  [<ffffffff8112d160>] ? __lock_page+0x70/0x70
> [ 1683.155186]  [<ffffffff8163d2e9>] schedule+0x29/0x70
> [ 1683.155202]  [<ffffffff8163d3bf>] io_schedule+0x8f/0xd0
> [ 1683.155217]  [<ffffffff8112d16e>] sleep_on_page+0xe/0x20
> [ 1683.155233]  [<ffffffff8163a3aa>] __wait_on_bit_lock+0x5a/0xc0
> [ 1683.155250]  [<ffffffff8112dd0e>] ? find_get_pages_tag+0x2e/0x1e0
> [ 1683.155269]  [<ffffffff811c25b1>] ? __block_write_full_page+0x211/0x390
> [ 1683.155286]  [<ffffffff8112d157>] __lock_page+0x67/0x70
> [ 1683.155303]  [<ffffffff8106f090>] ? autoremove_wake_function+0x50/0x50
> [ 1683.155339]  [<ffffffffa030d07e>] ext4_num_dirty_pages.isra.53+0x1fe/0x210 [ext4]
> [ 1683.155361]  [<ffffffff8113ae15>] ? pagevec_lookup_tag+0x25/0x40
> [ 1683.155377]  [<ffffffff81138374>] ? write_cache_pages+0x144/0x4e0
> [ 1683.155407]  [<ffffffffa031382d>] ext4_da_writepages+0x63d/0x6a0 [ext4]
> [ 1683.155424]  [<ffffffff81137f40>] ? set_page_dirty_lock+0x70/0x70
> [ 1683.155443]  [<ffffffff811b5863>] ? __writeback_single_inode+0x63/0x310
> [ 1683.155459]  [<ffffffff811b5863>] ? __writeback_single_inode+0x63/0x310
> [ 1683.155477]  [<ffffffff811b6abc>] ? writeback_sb_inodes+0x13c/0x550
> [ 1683.155493]  [<ffffffff8113a123>] do_writepages+0x23/0x40
> [ 1683.155509]  [<ffffffff811b5845>] __writeback_single_inode+0x45/0x310
> [ 1683.155526]  [<ffffffff811b6c48>] writeback_sb_inodes+0x2c8/0x550
> [ 1683.155543]  [<ffffffff811b6f6e>] __writeback_inodes_wb+0x9e/0xd0
> [ 1683.155560]  [<ffffffff811b72eb>] wb_writeback+0x34b/0x370
> [ 1683.155576]  [<ffffffff811a736e>] ? get_nr_inodes+0x5e/0xb0
> [ 1683.155592]  [<ffffffff811b73af>] wb_check_old_data_flush+0x9f/0xb0
> [ 1683.155610]  [<ffffffff811b9059>] wb_do_writeback+0x179/0x200
> [ 1683.155629]  [<ffffffff812cce0a>] ? debug_object_assert_init+0x7a/0xf0
> [ 1683.155645]  [<ffffffff81056f2b>] ? del_timer+0x2b/0x80
> [ 1683.155661]  [<ffffffff811b918c>] bdi_writeback_thread+0xac/0x300
> [ 1683.155678]  [<ffffffff811b90e0>] ? wb_do_writeback+0x200/0x200
> [ 1683.155693]  [<ffffffff8106e84a>] kthread+0xea/0xf0
> [ 1683.155708]  [<ffffffff8106e760>] ? flush_kthread_worker+0x150/0x150
> [ 1683.155723]  [<ffffffff816476dc>] ret_from_fork+0x7c/0xb0
> [ 1683.155738]  [<ffffffff8106e760>] ? flush_kthread_worker+0x150/0x150
> [ 1683.155761] INFO: task ext4lazyinit:2065 blocked for more than 120 seconds.
> [ 1683.155773] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [ 1683.155787] ext4lazyinit    D ffff88007e93b828     0  2065      2 0x00000000
> [ 1683.155805]  ffff88007ebffbd8 0000000000000046 ffff88007ebffb78 ffffffff810ae74d
> [ 1683.155825]  ffff88002eee5f10 ffff88007ebfffd8 ffff88007ebfffd8 ffff88007ebfffd8
> [ 1683.155844]  ffffffff81c10440 ffff88002eee5f10 ffff88007e93b800 0000000000000001
> [ 1683.155864] Call Trace:
> [ 1683.155879]  [<ffffffff810ae74d>] ? trace_hardirqs_on+0xd/0x10
> [ 1683.155896]  [<ffffffff8163d2e9>] schedule+0x29/0x70
> [ 1683.155921]  [<ffffffffa027e435>] start_this_handle+0x2b5/0x560 [jbd2]
> [ 1683.155938]  [<ffffffff810a924a>] ? static_obj+0x5a/0x70
> [ 1683.155953]  [<ffffffff8106f040>] ? __init_waitqueue_head+0x60/0x60
> [ 1683.155973]  [<ffffffffa027e94d>] jbd2__journal_start+0xed/0x210 [jbd2]
> [ 1683.156007]  [<ffffffffa0324126>] ? ext4_lazyinit_thread+0xb6/0x330 [ext4]
> [ 1683.158547]  [<ffffffffa0324126>] ? ext4_lazyinit_thread+0xb6/0x330 [ext4]
> [ 1683.162391]  [<ffffffffa030b2aa>] ? ext4_init_inode_table+0xaa/0x360 [ext4]
> [ 1683.162400]  [<ffffffffa033a889>] __ext4_journal_start_sb+0x99/0x1a0 [ext4]
> [ 1683.162407]  [<ffffffffa030b2aa>] ext4_init_inode_table+0xaa/0x360 [ext4]
> [ 1683.162414]  [<ffffffffa0324126>] ? ext4_lazyinit_thread+0xb6/0x330 [ext4]
> [ 1683.162420]  [<ffffffffa0324190>] ext4_lazyinit_thread+0x120/0x330 [ext4]
> [ 1683.162427]  [<ffffffffa0324070>] ? init_once+0x70/0x70 [ext4]
> [ 1683.162431]  [<ffffffff8106e84a>] kthread+0xea/0xf0
> [ 1683.162434]  [<ffffffff8106e760>] ? flush_kthread_worker+0x150/0x150
> [ 1683.162438]  [<ffffffff816476dc>] ret_from_fork+0x7c/0xb0
> [ 1683.162441]  [<ffffffff8106e760>] ? flush_kthread_worker+0x150/0x150
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
