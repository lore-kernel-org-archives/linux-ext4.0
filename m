From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: ext4/jbd2 hangs in __jbd2_log_wait_for_space on 3.4-RT/3.6-RT
Date: Fri, 31 May 2013 14:34:12 -0400
Message-ID: <20130531183411.GA30169@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
To: <linux-rt-users@vger.kernel.org>, <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:54142 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845Ab3EaSdu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 May 2013 14:33:50 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This problem is seen on vanilla 3.4-RT and 3.6-RT kernels. It is
not clear to me whether this is an RT issue, or whether (as usual)
RT has managed to shake out an issue in mainline code.  So I've
looped in the ext4 list as well as the RT list, since at the
moment it appears this can impact anyone using RT and ext4...

What happens is that under reasonable load, the jbd2/sda1-8 thread
goes D state, and then lots of regular processes follow suit, after
calling __jbd2_log_wait_for_space.  As can be seen at the bottom
of the sysrq-t output, j_checkpoint_mutex is implicated.  All
future processes trying to do I/O to/from that filesystem go D.

More testing details:
Even though debug_rt_mutex_print_deadlock shows up in each stalled
process backtrace, no output is seen from debug_rt_mutex_print_deadlock.
There are no messages in dmesg at all, until I trigger a SysRQ-t.

I've reproduced this on v3.4.42-rt57, v3.4.47-rt62, and v3.6.11.3-rt35.

The two separate versions of v3.4.x are because I noticed the 3.4.47
pulled in some jbd2 commits via stable, like 794446c6 "jbd2: fix race
between jbd2_journal_remove_checkpoint and ->j_commit_callback". It
looked promising, but having that present didn't change things.

I'm using a yocto build, configured for six parallel package builds,
each pkg in turn with "make -j6" to create I/O.  I've found that also
running an "rm -rf" of an old build (several gigs of data) at the
same time increases the probability of it.  Typically it will fail
within about 15m or so.  The test box is a dell optiplex 990 with
a single disk as ext4.  The box stays alive for basic sysrq operations
and anything else that doesn't touch the locked filesystem.  The build
halts with a static load average equal to the number of blocked D procs.

I've deleted the sysrq-t output from the irrelevant sleeping processes
in order to reduce the noise.  I'll keep looking at this but I'm hoping
more experienced eyes on the problem will help, since it seems common
to all RT users and hence of interest to everyone (I've not yet tried
3.8.x-RT, mind you.)

Paul.
--

[From v3.4.47-rt62]

 SysRq : Show State
   task                        PC stack   pid father
 jbd2/sda1-8     D ffff88021fc8fb28     0   251      2 0x00000000
  ffff88021fc8fa70 0000000000000046 ffff88021fc8fa50 ffff88021fc8ffd8
  ffff88021fc8ffd8 0000000000004000 ffff88018f77a000 ffff88021f47b000
  ffff88021fc8fa10 0000000000000246 0000000000000000 ffffffff816cd488
 Call Trace:
  [<ffffffff816cd488>] ? rt_spin_lock_slowunlock+0x18/0x7a
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff8109caa5>] ? sub_preempt_count+0x65/0xc0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff8109caa5>] ? sub_preempt_count+0x65/0xc0
  [<ffffffff810ed570>] ? __lock_page+0x70/0x70
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff810ed570>] ? __lock_page+0x70/0x70
  [<ffffffff816cc3dd>] io_schedule+0x8d/0xd0
  [<ffffffff810ed579>] sleep_on_page+0x9/0x10
  [<ffffffff816cb328>] __wait_on_bit+0x58/0x90
  [<ffffffff810ed7c8>] wait_on_page_bit+0x78/0x80
  [<ffffffff81090e40>] ? autoremove_wake_function+0x40/0x40
  [<ffffffff810ede13>] filemap_fdatawait_range+0x113/0x1c0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff8109caa5>] ? sub_preempt_count+0x65/0xc0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff8109caa5>] ? sub_preempt_count+0x65/0xc0
  [<ffffffff810edee7>] filemap_fdatawait+0x27/0x30
  [<ffffffff81207384>] jbd2_journal_commit_transaction+0x8c4/0x1620
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff8120accb>] kjournald2+0xcb/0x290
  [<ffffffff81090e00>] ? __init_waitqueue_head+0x90/0x90
  [<ffffffff8120ac00>] ? commit_timeout+0x10/0x10
  [<ffffffff81090483>] kthread+0xa3/0xb0
  [<ffffffff816ce1d6>] ? _raw_spin_unlock_irq+0x36/0x60
  [<ffffffff8109a400>] ? finish_task_switch+0x80/0x120
  [<ffffffff8109a3c3>] ? finish_task_switch+0x43/0x120
  [<ffffffff816d01d4>] kernel_thread_helper+0x4/0x10
  [<ffffffff8109a400>] ? finish_task_switch+0x80/0x120
  [<ffffffff816ce55d>] ? retint_restore_args+0xe/0xe
  [<ffffffff810903e0>] ? __init_kthread_worker+0xa0/0xa0
  [<ffffffff816d01d0>] ? gs_change+0xb/0xb
 ext4-dio-unwrit S 0000000000000040     0   252      2 0x00000000
  ffff88021f4c9d90 0000000000000046 ffff88021f4c9d00 ffff88021f4c9fd8
  ffff88021f4c9fd8 0000000000004000 ffff880224f29000 ffff88021ff7e000
  ffff88021f4c9d00 0000000000000000 ffff88021f4c9cf0 ffffffff810a13e0
 Call Trace:
  [<ffffffff810a13e0>] ? update_curr+0x50/0xc0
  [<ffffffff816ce185>] ? _raw_spin_unlock_irqrestore+0x65/0x80
  [<ffffffff816cc2a2>] ? preempt_schedule+0x42/0x60
  [<ffffffff816ce195>] ? _raw_spin_unlock_irqrestore+0x75/0x80
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff8108ab37>] rescuer_thread+0x1d7/0x200
  [<ffffffff8108a960>] ? process_scheduled_works+0x40/0x40
  [<ffffffff8108a960>] ? process_scheduled_works+0x40/0x40
  [<ffffffff81090483>] kthread+0xa3/0xb0
  [<ffffffff816ce1d6>] ? _raw_spin_unlock_irq+0x36/0x60
  [<ffffffff8109a400>] ? finish_task_switch+0x80/0x120
  [<ffffffff8109a3c3>] ? finish_task_switch+0x43/0x120
  [<ffffffff816d01d4>] kernel_thread_helper+0x4/0x10
  [<ffffffff8109a400>] ? finish_task_switch+0x80/0x120
  [<ffffffff816ce55d>] ? retint_restore_args+0xe/0xe
  [<ffffffff810903e0>] ? __init_kthread_worker+0xa0/0xa0
  [<ffffffff816d01d0>] ? gs_change+0xb/0xb
 rs:main Q:Reg   D ffff88021fd77000     0   604      1 0x00000000
  ffff88022088b7e8 0000000000000046 0000000000000000 ffff88022088bfd8
  ffff88022088bfd8 0000000000004000 ffffffff81933020 ffff88021fd77000
  ffff88022088b808 0000000000000246 ffff88021fd77000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff810c1d06>] ? futex_wake+0x116/0x140
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff810963bb>] ? __srcu_read_unlock+0x3b/0x60
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 flush-8:0       D ffff88021a8cf7d0     0  1144      2 0x00000000
  ffff88021a8cf770 0000000000000046 ffff88021a8cf680 ffff88021a8cffd8
  ffff88021a8cffd8 0000000000004000 ffff88018f629000 ffff88022028b000
  ffff88022017b038 ffff88021a8cf720 ffff88021a8cf6c0 ffffffff81088e64
 Call Trace:
  [<ffffffff81088e64>] ? queue_work+0x34/0x40
  [<ffffffff8108b1f5>] ? queue_delayed_work+0x25/0x30
  [<ffffffff8132a51c>] ? blk_run_queue_async+0x3c/0x60
  [<ffffffff8132a8c1>] ? queue_unplugged.isra.41+0x61/0x70
  [<ffffffff8132ccfd>] ? blk_flush_plug_list+0x19d/0x210
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff8120ab6d>] jbd2_log_wait_commit+0xbd/0x140
  [<ffffffff81090e00>] ? __init_waitqueue_head+0x90/0x90
  [<ffffffff8120927e>] jbd2_log_do_checkpoint+0xee/0x4a0
  [<ffffffff812096d9>] __jbd2_log_wait_for_space+0xa9/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff81090e00>] ? __init_waitqueue_head+0x90/0x90
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff811cb723>] ? ext4_meta_trans_blocks+0x43/0xa0
  [<ffffffff811d1782>] ext4_da_writepages+0x2c2/0x4e0
  [<ffffffff810f884d>] do_writepages+0x1d/0x40
  [<ffffffff8115dded>] writeback_single_inode+0x17d/0x380
  [<ffffffff8115e415>] writeback_sb_inodes+0x1d5/0x2e0
  [<ffffffff8115e8c7>] __writeback_inodes_wb+0x97/0xd0
  [<ffffffff8115ecab>] wb_writeback+0x1fb/0x210
  [<ffffffff8115f5bf>] wb_do_writeback+0x1cf/0x1e0
  [<ffffffff8115f64b>] bdi_writeback_thread+0x7b/0x150
  [<ffffffff8115f5d0>] ? wb_do_writeback+0x1e0/0x1e0
  [<ffffffff81090483>] kthread+0xa3/0xb0
  [<ffffffff816ce1d6>] ? _raw_spin_unlock_irq+0x36/0x60
  [<ffffffff8109a400>] ? finish_task_switch+0x80/0x120
  [<ffffffff8109a3c3>] ? finish_task_switch+0x43/0x120
  [<ffffffff816d01d4>] kernel_thread_helper+0x4/0x10
  [<ffffffff8109a400>] ? finish_task_switch+0x80/0x120
  [<ffffffff816ce55d>] ? retint_restore_args+0xe/0xe
  [<ffffffff810903e0>] ? __init_kthread_worker+0xa0/0xa0
  [<ffffffff816d01d0>] ? gs_change+0xb/0xb
 pseudo          D ffff8801b5788000     0  9577      1 0x00000000
  ffff88004d1cf7e8 0000000000000046 0000000000000000 ffff88004d1cffd8
  ffff88004d1cffd8 0000000000004000 ffffffff81933020 ffff8801b5788000
  ffff88004d1cf728 0000000000000246 ffff8801b5788000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8110cbcb>] ? handle_pte_fault+0x8b/0x7d0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff88021aaf4000     0  9652      1 0x00000000
  ffff8800b39d97e8 0000000000000046 0000000000000000 ffff8800b39d9fd8
  ffff8800b39d9fd8 0000000000004000 ffff880224f60000 ffff88021aaf4000
  ffff8800b39d9728 0000000000000246 ffff88021aaf4000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8110d0d0>] ? handle_pte_fault+0x590/0x7d0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff88019b831000     0  9673      1 0x00000000
  ffff88018f7097e8 0000000000000046 0000000000000000 ffff88018f709fd8
  ffff88018f709fd8 0000000000004000 ffff880224f29000 ffff88019b831000
  ffff88018f709728 0000000000000246 ffff88019b831000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8110d0d0>] ? handle_pte_fault+0x590/0x7d0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff88018f77a000     0  9741      1 0x00000000
  ffff8802111d77e8 0000000000000046 0000000000000000 ffff8802111d7fd8
  ffff8802111d7fd8 0000000000004000 ffff880224f60000 ffff88018f77a000
  ffff8802111d7728 0000000000000246 ffff88018f77a000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8110cbcb>] ? handle_pte_fault+0x8b/0x7d0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff88004e236000     0  9821      1 0x00000000
  ffff88018367d7e8 0000000000000046 0000000000000000 ffff88018367dfd8
  ffff88018367dfd8 0000000000004000 ffff880224f60000 ffff88004e236000
  ffff88018367d728 0000000000000246 ffff88004e236000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8110cbcb>] ? handle_pte_fault+0x8b/0x7d0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff880209899000     0  9856      1 0x00000000
  ffff88018370b7e8 0000000000000046 0000000000000000 ffff88018370bfd8
  ffff88018370bfd8 0000000000004000 ffff880224efb000 ffff880209899000
  ffff88018370b728 0000000000000246 ffff880209899000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8110cbcb>] ? handle_pte_fault+0x8b/0x7d0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff8800b3943000     0  9905      1 0x00000000
  ffff8800ca5837e8 0000000000000046 0000000000000000 ffff8800ca583fd8
  ffff8800ca583fd8 0000000000004000 ffff880224efb000 ffff8800b3943000
  ffff8800ca583728 0000000000000246 ffff8800b3943000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8110cbcb>] ? handle_pte_fault+0x8b/0x7d0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff88019baf8000     0  9923      1 0x00000000
  ffff88018f7f17e8 0000000000000046 0000000000000000 ffff88018f7f1fd8
  ffff88018f7f1fd8 0000000000004000 ffff880224f29000 ffff88019baf8000
  ffff88018f7f1728 0000000000000246 ffff88019baf8000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8110d0d0>] ? handle_pte_fault+0x590/0x7d0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff880211049000     0  9960      1 0x00000000
  ffff8802111b57e8 0000000000000046 0000000000000000 ffff8802111b5fd8
  ffff8802111b5fd8 0000000000004000 ffffffff81933020 ffff880211049000
  ffff8802111b5728 0000000000000246 ffff880211049000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8110cbcb>] ? handle_pte_fault+0x8b/0x7d0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff8800b3b35000     0 10011      1 0x00000000
  ffff88017a14b7e8 0000000000000046 0000000000000000 ffff88017a14bfd8
  ffff88017a14bfd8 0000000000004000 ffffffff81933020 ffff8800b3b35000
  ffff88017a14b728 0000000000000246 ffff8800b3b35000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8110d0d0>] ? handle_pte_fault+0x590/0x7d0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff88021fe29000     0 10136      1 0x00000000
  ffff8801783f37e8 0000000000000046 0000000000000000 ffff8801783f3fd8
  ffff8801783f3fd8 0000000000004000 ffff880224f60000 ffff88021fe29000
  ffff8801783f3728 0000000000000246 ffff88021fe29000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8110d0d0>] ? handle_pte_fault+0x590/0x7d0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff8800a0e95000     0 10175      1 0x00000000
  ffff88016ec6b7e8 0000000000000046 0000000000000000 ffff88016ec6bfd8
  ffff88016ec6bfd8 0000000000004000 ffff880224f29000 ffff8800a0e95000
  ffff88016ec6b728 0000000000000246 ffff8800a0e95000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8110d0d0>] ? handle_pte_fault+0x590/0x7d0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff8800cc1e9000     0 10196      1 0x00000000
  ffff88017a10b7e8 0000000000000046 0000000000000000 ffff88017a10bfd8
  ffff88017a10bfd8 0000000000004000 ffff880224f29000 ffff8800cc1e9000
  ffff88017a10b728 0000000000000246 ffff8800cc1e9000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8114a9c3>] ? core_sys_select+0x33/0x500
  [<ffffffff810becd0>] ? lock_release_non_nested+0xa0/0x2e0
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff88014904b000     0 10243      1 0x00000000
  ffff8800cc0477e8 0000000000000046 0000000000000000 ffff8800cc047fd8
  ffff8800cc047fd8 0000000000004000 ffff880224efb000 ffff88014904b000
  ffff8800cc047728 0000000000000246 ffff88014904b000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8110d0d0>] ? handle_pte_fault+0x590/0x7d0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff8802214a7000     0 10295      1 0x00000000
  ffff8800cc0f17e8 0000000000000046 0000000000000000 ffff8800cc0f1fd8
  ffff8800cc0f1fd8 0000000000004000 ffff880224f29000 ffff8802214a7000
  ffff8800cc0f1728 0000000000000246 ffff8802214a7000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8110d0d0>] ? handle_pte_fault+0x590/0x7d0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff88022120f000     0 10296      1 0x00000000
  ffff88008a5ab7e8 0000000000000046 0000000000000000 ffff88008a5abfd8
  ffff88008a5abfd8 0000000000004000 ffff880224f60000 ffff88022120f000
  ffff88008a5ab728 0000000000000246 ffff88022120f000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8110d0d0>] ? handle_pte_fault+0x590/0x7d0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff880211030000     0 10345      1 0x00000000
  ffff8801782977e8 0000000000000046 0000000000000000 ffff880178297fd8
  ffff880178297fd8 0000000000004000 ffffffff81933020 ffff880211030000
  ffff880178297728 0000000000000246 ffff880211030000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8110d0d0>] ? handle_pte_fault+0x590/0x7d0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff8800a0ea6000     0 10389      1 0x00000000
  ffff88018f6e97e8 0000000000000046 0000000000000000 ffff88018f6e9fd8
  ffff88018f6e9fd8 0000000000004000 ffff880224f60000 ffff8800a0ea6000
  ffff88018f6e9728 0000000000000246 ffff8800a0ea6000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8110d0d0>] ? handle_pte_fault+0x590/0x7d0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff88021ab12000     0 10395      1 0x00000000
  ffff88017a09f7e8 0000000000000046 0000000000000000 ffff88017a09ffd8
  ffff88017a09ffd8 0000000000004000 ffffffff81933020 ffff88021ab12000
  ffff88017a09f728 0000000000000246 ffff88021ab12000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8110d0d0>] ? handle_pte_fault+0x590/0x7d0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff88019b886000     0 10431      1 0x00000000
  ffff8802213db7e8 0000000000000046 0000000000000000 ffff8802213dbfd8
  ffff8802213dbfd8 0000000000004000 ffff880224f60000 ffff88019b886000
  ffff8802213db728 0000000000000246 ffff88019b886000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8110d0d0>] ? handle_pte_fault+0x590/0x7d0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff88004d11c000     0 10468      1 0x00000000
  ffff8802111b37e8 0000000000000046 0000000000000000 ffff8802111b3fd8
  ffff8802111b3fd8 0000000000004000 ffff880224f60000 ffff88004d11c000
  ffff8802111b3728 0000000000000246 ffff88004d11c000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8110d0d0>] ? handle_pte_fault+0x590/0x7d0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff880209b11000     0 10495      1 0x00000000
  ffff88018f6d57e8 0000000000000046 0000000000000000 ffff88018f6d5fd8
  ffff88018f6d5fd8 0000000000004000 ffffffff81933020 ffff880209b11000
  ffff88018f6d5728 0000000000000246 ffff880209b11000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8114a9c3>] ? core_sys_select+0x33/0x500
  [<ffffffff810becd0>] ? lock_release_non_nested+0xa0/0x2e0
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff8800a0e28000     0 10526      1 0x00000000
  ffff8800b39037e8 0000000000000046 0000000000000000 ffff8800b3903fd8
  ffff8800b3903fd8 0000000000004000 ffffffff81933020 ffff8800a0e28000
  ffff8800b3903728 0000000000000246 ffff8800a0e28000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8114a9c3>] ? core_sys_select+0x33/0x500
  [<ffffffff810becd0>] ? lock_release_non_nested+0xa0/0x2e0
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff88013a5f4000     0 10562      1 0x00000000
  ffff88018f7b77e8 0000000000000046 0000000000000000 ffff88018f7b7fd8
  ffff88018f7b7fd8 0000000000004000 ffff880224f29000 ffff88013a5f4000
  ffff88018f7b7728 0000000000000246 ffff88013a5f4000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8110d0d0>] ? handle_pte_fault+0x590/0x7d0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff88021fcf6000     0 10578      1 0x00000000
  ffff8801836d37e8 0000000000000046 0000000000000000 ffff8801836d3fd8
  ffff8801836d3fd8 0000000000004000 ffff880224efb000 ffff88021fcf6000
  ffff8801836d3728 0000000000000246 ffff88021fcf6000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8110d0d0>] ? handle_pte_fault+0x590/0x7d0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff88004bcbd000     0 10642      1 0x00000000
  ffff8801783617e8 0000000000000046 0000000000000000 ffff880178361fd8
  ffff880178361fd8 0000000000004000 ffff880224efb000 ffff88004bcbd000
  ffff880178361728 0000000000000246 ffff88004bcbd000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8110d0d0>] ? handle_pte_fault+0x590/0x7d0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff8801837a6000     0 10673      1 0x00000000
  ffff8801783f97e8 0000000000000046 0000000000000000 ffff8801783f9fd8
  ffff8801783f9fd8 0000000000004000 ffff880224efb000 ffff8801837a6000
  ffff8801783f9728 0000000000000246 ffff8801837a6000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8110d0d0>] ? handle_pte_fault+0x590/0x7d0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff88004fcf6000     0 10705      1 0x00000000
  ffff88018f6c17e8 0000000000000046 0000000000000000 ffff88018f6c1fd8
  ffff88018f6c1fd8 0000000000004000 ffff880224efb000 ffff88004fcf6000
  ffff88018f6c1728 0000000000000246 ffff88004fcf6000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8114a9c3>] ? core_sys_select+0x33/0x500
  [<ffffffff810becd0>] ? lock_release_non_nested+0xa0/0x2e0
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff88018f66e000     0 10714      1 0x00000000
  ffff88017a04d7e8 0000000000000046 ffff880200000000 ffff88017a04dfd8
  ffff88017a04dfd8 0000000000004000 ffff880224efb000 ffff88018f66e000
  ffff88017a04d728 0000000000000246 ffff88018f66e000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8110d0d0>] ? handle_pte_fault+0x590/0x7d0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 python          D ffff8801b55e5000     0 10763   1868 0x00000000
  ffff8801782c3838 0000000000000046 0000000000000000 ffff8801782c3fd8
  ffff8801782c3fd8 0000000000004000 ffff88019bb99000 ffff8801b55e5000
  ffff8801782c3778 0000000000000246 ffff8801b55e5000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816ce15d>] ? _raw_spin_unlock_irqrestore+0x3d/0x80
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff81090e00>] ? __init_waitqueue_head+0x90/0x90
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff811cb723>] ? ext4_meta_trans_blocks+0x43/0xa0
  [<ffffffff811e819b>] ext4_ext_truncate+0x3b/0x1d0
  [<ffffffff811cd535>] ext4_truncate+0x65/0x70
  [<ffffffff811cfe68>] ext4_setattr+0x138/0x3e0
  [<ffffffff81153c1b>] notify_change+0x1cb/0x370
  [<ffffffff8113311d>] do_truncate+0x5d/0xa0
  [<ffffffff811455e8>] do_last.isra.35+0x578/0x820
  [<ffffffff81145a9a>] path_openat+0xca/0x3c0
  [<ffffffff816cd488>] ? rt_spin_lock_slowunlock+0x18/0x7a
  [<ffffffff81145eac>] do_filp_open+0x3c/0x90
  [<ffffffff811550b6>] ? alloc_fd+0x176/0x230
  [<ffffffff81133e71>] do_sys_open+0xf1/0x1e0
  [<ffffffff81133f7c>] sys_open+0x1c/0x20
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 python          D ffff88019ba09000     0 10777   1868 0x00000000
  ffff880178271838 0000000000000046 0000000000000000 ffff880178271fd8
  ffff880178271fd8 0000000000004000 ffff8801b55e5000 ffff88019ba09000
  ffff880178271778 0000000000000246 ffff88019ba09000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816ce15d>] ? _raw_spin_unlock_irqrestore+0x3d/0x80
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff81090e00>] ? __init_waitqueue_head+0x90/0x90
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff811cb723>] ? ext4_meta_trans_blocks+0x43/0xa0
  [<ffffffff811e819b>] ext4_ext_truncate+0x3b/0x1d0
  [<ffffffff811cd535>] ext4_truncate+0x65/0x70
  [<ffffffff811cfe68>] ext4_setattr+0x138/0x3e0
  [<ffffffff81153c1b>] notify_change+0x1cb/0x370
  [<ffffffff8113311d>] do_truncate+0x5d/0xa0
  [<ffffffff811455e8>] do_last.isra.35+0x578/0x820
  [<ffffffff81145a9a>] path_openat+0xca/0x3c0
  [<ffffffff816cd488>] ? rt_spin_lock_slowunlock+0x18/0x7a
  [<ffffffff81145eac>] do_filp_open+0x3c/0x90
  [<ffffffff811550b6>] ? alloc_fd+0x176/0x230
  [<ffffffff81133e71>] do_sys_open+0xf1/0x1e0
  [<ffffffff81133f7c>] sys_open+0x1c/0x20
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 python          D ffff880221173000     0 10778   1868 0x00000000
  ffff8801836d5768 0000000000000046 0000000000000000 ffff8801836d5fd8
  ffff8801836d5fd8 0000000000004000 ffff880224f60000 ffff880221173000
  ffff8801836d56a8 0000000000000246 ffff880221173000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816ce15d>] ? _raw_spin_unlock_irqrestore+0x3d/0x80
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff81090e00>] ? __init_waitqueue_head+0x90/0x90
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff811ce3d7>] ext4_da_write_begin+0x77/0x1a0
  [<ffffffff810ec77a>] generic_file_buffered_write+0x10a/0x270
  [<ffffffff8109caa5>] ? sub_preempt_count+0x65/0xc0
  [<ffffffff810ee7dd>] __generic_file_aio_write+0x22d/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff8110a667>] ? might_fault+0x97/0xa0
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 python          D ffff88008a678000     0 10805   1868 0x00000000
  ffff880178207838 0000000000000046 0000000000000000 ffff880178207fd8
  ffff880178207fd8 0000000000004000 ffff88019ba09000 ffff88008a678000
  ffff880178207858 0000000000000246 ffff88008a678000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816ce15d>] ? _raw_spin_unlock_irqrestore+0x3d/0x80
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff81090e00>] ? __init_waitqueue_head+0x90/0x90
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff811cb723>] ? ext4_meta_trans_blocks+0x43/0xa0
  [<ffffffff811e819b>] ext4_ext_truncate+0x3b/0x1d0
  [<ffffffff811cd535>] ext4_truncate+0x65/0x70
  [<ffffffff811cfe68>] ext4_setattr+0x138/0x3e0
  [<ffffffff81153c1b>] notify_change+0x1cb/0x370
  [<ffffffff8113311d>] do_truncate+0x5d/0xa0
  [<ffffffff811455e8>] do_last.isra.35+0x578/0x820
  [<ffffffff81145a9a>] path_openat+0xca/0x3c0
  [<ffffffff816cd488>] ? rt_spin_lock_slowunlock+0x18/0x7a
  [<ffffffff81145eac>] do_filp_open+0x3c/0x90
  [<ffffffff811550b6>] ? alloc_fd+0x176/0x230
  [<ffffffff81133e71>] do_sys_open+0xf1/0x1e0
  [<ffffffff81133f7c>] sys_open+0x1c/0x20
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 tar             D ffff88019bb99000     0 10814  10812 0x00000000
  ffff88017a02fb08 0000000000000046 ffff880100000000 ffff88017a02ffd8
  ffff88017a02ffd8 0000000000004000 ffffffff81933020 ffff88019bb99000
  ffff88017a02fa48 0000000000000246 ffff88019bb99000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff81090e00>] ? __init_waitqueue_head+0x90/0x90
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff8109caa5>] ? sub_preempt_count+0x65/0xc0
  [<ffffffff811d6696>] ext4_mkdir+0x96/0x340
  [<ffffffff811431cc>] vfs_mkdir+0xbc/0x100
  [<ffffffff811462a2>] sys_mkdirat+0xc2/0xd0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff88019b9ad000     0 10817  10816 0x00000000
  ffff88017a013998 0000000000000046 0000000000000000 ffff88017a013fd8
  ffff88017a013fd8 0000000000004000 ffff880224f60000 ffff88019b9ad000
  ffff88017a0138d8 0000000000000246 ffff88019b9ad000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff811cb723>] ? ext4_meta_trans_blocks+0x43/0xa0
  [<ffffffff811d1782>] ext4_da_writepages+0x2c2/0x4e0
  [<ffffffff810f884d>] do_writepages+0x1d/0x40
  [<ffffffff810ee2eb>] __filemap_fdatawrite_range+0x5b/0x60
  [<ffffffff810ee387>] filemap_flush+0x17/0x20
  [<ffffffff811cd347>] ext4_alloc_da_blocks+0x27/0x30
  [<ffffffff811c81f9>] ext4_release_file+0x79/0xd0
  [<ffffffff811372d0>] fput+0xf0/0x270
  [<ffffffff811325e7>] filp_close+0x67/0xa0
  [<ffffffff811326d2>] sys_close+0xb2/0x1b0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 pseudo          D ffff8801783f0000     0 10818  10817 0x00000000
  ffff88017a15f7e8 0000000000000046 0000000000000000 ffff88017a15ffd8
  ffff88017a15ffd8 0000000000004000 ffff880224f60000 ffff8801783f0000
  ffff88017a15f728 0000000000000246 ffff8801783f0000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff816ccdeb>] ? rt_mutex_slowlock+0x4b/0x1d0
  [<ffffffff810bd3ec>] ? __lock_acquire+0x3bc/0x1c00
  [<ffffffff811d1da1>] ext4_dirty_inode+0x21/0x60
  [<ffffffff8115e59e>] __mark_inode_dirty+0x3e/0x250
  [<ffffffff811512ea>] file_update_time+0xca/0x150
  [<ffffffff810ee7a8>] __generic_file_aio_write+0x1f8/0x440
  [<ffffffff816cd040>] ? rt_mutex_lock+0x30/0x40
  [<ffffffff810eea5c>] generic_file_aio_write+0x6c/0xe0
  [<ffffffff811c8502>] ext4_file_write+0xb2/0x270
  [<ffffffff8110cbcb>] ? handle_pte_fault+0x8b/0x7d0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff811341ee>] do_sync_write+0xde/0x120
  [<ffffffff81314b87>] ? security_file_permission+0x27/0xb0
  [<ffffffff811347dc>] ? rw_verify_area+0x5c/0xf0
  [<ffffffff81134ad6>] vfs_write+0xa6/0x160
  [<ffffffff81134dd8>] sys_write+0x48/0xa0
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 run.do_populate S ffff8800ca568ff0     0 10819  10799 0x00000000
  ffff880162465e58 0000000000000046 ffff8800ca569000 ffff880162465fd8
  ffff880162465fd8 0000000000004000 ffff880224f29000 ffff8800ca569000
  ffff880162465df8 0000000000000246 0000000000000000 ffffffff816cd488
 Call Trace:
  [<ffffffff816cd488>] ? rt_spin_lock_slowunlock+0x18/0x7a
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff8109caa5>] ? sub_preempt_count+0x65/0xc0
  [<ffffffff8109ca01>] ? get_parent_ip+0x11/0x50
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff8107259e>] do_wait+0x1ee/0x260
  [<ffffffff81073c60>] sys_wait4+0x70/0xf0
  [<ffffffff81070f60>] ? task_stopped_code+0x60/0x60
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 ln              D ffff8801b56d0000     0 10820  10819 0x00000000
  ffff88017a0e3b08 0000000000000046 0000000000000000 ffff88017a0e3fd8
  ffff88017a0e3fd8 0000000000004000 ffff880224f29000 ffff8801b56d0000
  ffff88017a0e3a48 0000000000000246 ffff8801b56d0000 0000000000000000
 Call Trace:
  [<ffffffff810c5be0>] ? debug_rt_mutex_print_deadlock+0x50/0x350
  [<ffffffff816cc2e9>] schedule+0x29/0x90
  [<ffffffff816cccf5>] __rt_mutex_slowlock+0x45/0xf0
  [<ffffffff816cce80>] rt_mutex_slowlock+0xe0/0x1d0
  [<ffffffff816cd040>] rt_mutex_lock+0x30/0x40
  [<ffffffff816cd9a4>] _mutex_lock+0x34/0x40
  [<ffffffff8120971d>] ? __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
  [<ffffffff81204530>] start_this_handle+0x2e0/0x580
  [<ffffffff810bcb3c>] ? lockdep_init_map+0xac/0x5a0
  [<ffffffff8112ea4d>] ? kmem_cache_alloc+0x1cd/0x2a0
  [<ffffffff81204a4a>] jbd2__journal_start+0x11a/0x1c0
  [<ffffffff81204afe>] jbd2_journal_start+0xe/0x10
  [<ffffffff811db8a0>] ext4_journal_start_sb+0x60/0x160
  [<ffffffff8109caa5>] ? sub_preempt_count+0x65/0xc0
  [<ffffffff811d83f3>] ext4_symlink+0x193/0x2b0
  [<ffffffff811430cd>] vfs_symlink+0x8d/0xd0
  [<ffffffff81146403>] sys_symlinkat+0xb3/0xd0
  [<ffffffff81146431>] sys_symlink+0x11/0x20
  [<ffffffff816cece6>] system_call_fastpath+0x1a/0x1f
 
 Showing all locks held in the system:
 2 locks held by rs:main Q:Reg/604:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 1 lock held by getty/898:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff813b4f2e>] n_tty_read+0x58e/0x870
 1 lock held by getty/899:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff813b4f2e>] n_tty_read+0x58e/0x870
 1 lock held by getty/901:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff813b4f2e>] n_tty_read+0x58e/0x870
 1 lock held by getty/902:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff813b4f2e>] n_tty_read+0x58e/0x870
 1 lock held by getty/905:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff813b4f2e>] n_tty_read+0x58e/0x870
 2 locks held by flush-8:0/1144:
  #0:  (&type->s_umount_key#17){+.+.+.}, at: [<ffffffff81138b49>] grab_super_passive+0x49/0xa0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 1 lock held by getty/1152:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff813b4f2e>] n_tty_read+0x58e/0x870
 2 locks held by bash/1153:
  #0:  (sysrq_key_table_lock){+.+...}, at: [<ffffffff813bb60f>] __handle_sysrq+0x2f/0x180
  #1:  (tasklist_lock){+.+...}, at: [<ffffffff810bc825>] debug_show_all_locks+0x45/0x2b0
 1 lock held by bash/1256:
  #0:  (&tty->atomic_read_lock){+.+...}, at: [<ffffffff813b4f2e>] n_tty_read+0x58e/0x870
 2 locks held by pseudo/9577:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/9652:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/9673:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/9741:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/9821:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/9856:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/9905:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/9923:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/9960:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/10011:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/10136:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/10175:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/10196:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/10243:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/10295:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/10296:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/10345:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/10389:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/10395:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/10431:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/10468:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/10495:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/10526:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/10562:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/10578:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/10642:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/10673:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/10705:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/10714:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by python/10763:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff81133111>] do_truncate+0x51/0xa0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by python/10777:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff81133111>] do_truncate+0x51/0xa0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by python/10778:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by python/10805:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff81133111>] do_truncate+0x51/0xa0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by tar/10814:
  #0:  (&type->i_mutex_dir_key#3/1){+.+.+.}, at: [<ffffffff8114431b>] kern_path_create+0x7b/0x140
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 1 lock held by pseudo/10817:
  #0:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by pseudo/10818:
  #0:  (&sb->s_type->i_mutex_key#11){+.+...}, at: [<ffffffff810eea40>] generic_file_aio_write+0x50/0xe0
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 2 locks held by ln/10820:
  #0:  (&type->i_mutex_dir_key#3/1){+.+.+.}, at: [<ffffffff8114431b>] kern_path_create+0x7b/0x140
  #1:  (&journal->j_checkpoint_mutex){+.+...}, at: [<ffffffff8120971d>] __jbd2_log_wait_for_space+0xed/0x1f0
 
 =============================================
 
