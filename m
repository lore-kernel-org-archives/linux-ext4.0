From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: lockdep splat with v4.11 and generic/386
Date: Fri, 5 May 2017 09:50:35 -0700
Message-ID: <20170505165035.GA5963@birch.djwong.org>
References: <20170504193838.GA808@linux.intel.com>
 <20170505075923.GB25424@quack2.suse.cz>
 <20170505084950.GC25424@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20871 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbdEEQvP (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 5 May 2017 12:51:15 -0400
Content-Disposition: inline
In-Reply-To: <20170505084950.GC25424@quack2.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 05, 2017 at 10:49:50AM +0200, Jan Kara wrote:
> On Fri 05-05-17 09:59:23, Jan Kara wrote:
> > On Thu 04-05-17 13:38:38, Ross Zwisler wrote:
> > > I hit the following lockdep splat during some regression testing today, and
> > > was able to reproduce it on vanilla v4.11 without DAX.  My test setup is big
> > > memmap PMEM device in a QEMU virtual machine, but I don't think that the block
> > > device is important.  I was able to reproduce this easily by running
> > > generic/386 in a loop.  Here's the failure:
> > 
> > Thanks for report! This is false positive caused by a bug in our lockdep
> > annotation - locks on quota files (i_data_sem in this case) rank
> > differently than locks on normal files - specifically the lock ordering is
> > i_data_sem (normal file, directory, ...) -> dqio_mutex -> i_data_sem (quota
> > file). Now we do take care to tell lockdep about this by calling
> > lockdep_set_quota_inode() in fs/ext4/super.c for quota files. However we
> > don't return i_data_sem back to the normal locking class on freeing inode
> > and when quota file inode gets reused for something else, it has a wrong
> > locking class set which confuses lockdep. I'll send a fix.
> 
> Hum, I have the fix implemented but how did you make that test work for
> ext4? For me it is not run because:
> 
> xfs_quota binary does not support foreign filesystems
> 
> and looking at xfs_quota source in the latest git, -f still is not
> supported...

What git repo are you using?  xfs_quota has had -f since xfsprogs 4.8.

xfsprogs upstream lives at:
git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

(XFS moved off SGI infrastructure last October.)

--D

> 
> 								Honza
> 
> > >   FSTYP         -- ext4
> > >   PLATFORM      -- Linux/x86_64 lorwyn 4.11.0
> > >   MKFS_OPTIONS  -- /dev/pmem0p2
> > >   MOUNT_OPTIONS -- -o acl,user_xattr -o context=system_u:object_r:root_t:s0 /dev/pmem0p2 /mnt/xfstests_scratch
> > >   
> > >   generic/386 1s ... 1s
> > >   _check_dmesg: something found in dmesg (see /root/xfstests/results//generic/386.dmesg)
> > >   Ran: generic/386
> > >   Failures: generic/386
> > >   Failed 1 of 1 tests
> > > 
> > > Here's the lockdep splat, passed through kasan_symbolize.py:
> > > 
> > >   run fstests generic/386 at 2017-05-04 13:36:35
> > >   EXT4-fs (pmem0p2): mounted filesystem with ordered data mode. Opts: acl,user_xattr,quota
> > >   
> > >   ======================================================
> > >   [ INFO: possible circular locking dependency detected ]
> > >   4.11.0 #1 Not tainted
> > >   -------------------------------------------------------
> > >   mkdir/8458 is trying to acquire lock:
> > >    (&s->s_dquot.dqio_mutex){+.+...}, at: [<ffffffff8133a8bb>] dquot_commit+0x2b/0xd0 fs/quota/dquot.c:453
> > >   
> > >   but task is already holding lock:
> > >    (&ei->i_data_sem/2){++++..}, at: [<ffffffff81371ba1>] ext4_map_blocks+0x151/0x5e0 fs/ext4/inode.c:612
> > >   
> > >   which lock already depends on the new lock.
> > >   
> > >   
> > >   the existing dependency chain (in reverse order) is:
> > >   
> > >   -> #1 (&ei->i_data_sem/2){++++..}:
> > >         [<      none      >] lock_acquire+0xea/0x1f0 kernel/locking/lockdep.c:3762
> > >         [<      none      >] down_read+0x43/0xa0 kernel/locking/rwsem.c:23
> > >         [<      none      >] ext4_map_blocks+0x2b4/0x5e0 fs/ext4/inode.c:540
> > >         [<      none      >] ext4_getblk+0x51/0x1a0 fs/ext4/inode.c:949
> > >         [<      none      >] ext4_bread+0x22/0xc0 fs/ext4/inode.c:999
> > >         [<      none      >] ext4_quota_read+0xce/0x110 fs/ext4/super.c:5470
> > >         [<      none      >] read_blk+0x4c/0x60 fs/quota/quota_tree.c:63
> > >         [<      none      >] find_tree_dqentry+0x44/0x230 fs/quota/quota_tree.c:579
> > >         [<      none      >] find_tree_dqentry+0x1ad/0x230 fs/quota/quota_tree.c:590
> > >         [<      none      >] find_tree_dqentry+0x1ad/0x230 fs/quota/quota_tree.c:590
> > >         [<      none      >] find_tree_dqentry+0x1ad/0x230 fs/quota/quota_tree.c:590
> > >         [<     inline     >] find_dqentry fs/quota/quota_tree.c:602
> > >         [<      none      >] qtree_read_dquot+0x12e/0x260 fs/quota/quota_tree.c:622
> > >         [<      none      >] v2_read_dquot+0x2e/0x30 fs/quota/quota_v2.c:288
> > >         [<      none      >] dquot_acquire+0xe3/0x120 fs/quota/dquot.c:411
> > >         [<      none      >] ext4_acquire_dquot+0x68/0xa0 fs/ext4/super.c:5227
> > >         [<      none      >] dqget+0x305/0x470 fs/quota/dquot.c:891
> > >         [<      none      >] __dquot_initialize+0x151/0x290 fs/quota/dquot.c:1460
> > >         [<      none      >] dquot_initialize+0x13/0x20 fs/quota/dquot.c:1511
> > >         [<      none      >] ext4_mkdir+0x66/0x470 fs/ext4/namei.c:2645
> > >         [<      none      >] vfs_mkdir+0x119/0x1c0 fs/namei.c:3769
> > >         [<     inline     >] SYSC_mkdirat fs/namei.c:3792
> > >         [<     inline     >] SyS_mkdirat fs/namei.c:3776
> > >         [<     inline     >] SYSC_mkdir fs/namei.c:3803
> > >         [<      none      >] SyS_mkdir+0x7a/0xf0 fs/namei.c:3801
> > >         [<      none      >] entry_SYSCALL_64_fastpath+0x1f/0xc2 arch/x86/entry/entry_64.S:204
> > >   
> > >   -> #0 (&s->s_dquot.dqio_mutex){+.+...}:
> > >         [<     inline     >] check_prev_add kernel/locking/lockdep.c:1830
> > >         [<     inline     >] check_prevs_add kernel/locking/lockdep.c:1940
> > >         [<     inline     >] validate_chain kernel/locking/lockdep.c:2267
> > >         [<      none      >] __lock_acquire+0x12c2/0x1450 kernel/locking/lockdep.c:3347
> > >         [<      none      >] lock_acquire+0xea/0x1f0 kernel/locking/lockdep.c:3762
> > >         [<     inline     >] __mutex_lock_common kernel/locking/mutex.c:756
> > >         [<      none      >] __mutex_lock+0x8d/0xa80 kernel/locking/mutex.c:893
> > >         [<      none      >] mutex_lock_nested+0x1b/0x20 kernel/locking/mutex.c:908
> > >         [<      none      >] dquot_commit+0x2b/0xd0 fs/quota/dquot.c:453
> > >         [<      none      >] ext4_write_dquot+0x6f/0xa0 fs/ext4/super.c:5211
> > >         [<      none      >] ext4_mark_dquot_dirty+0x3f/0x60 fs/ext4/super.c:5262
> > >         [<     inline     >] mark_dquot_dirty fs/quota/dquot.c:337
> > >         [<     inline     >] mark_all_dquot_dirty fs/quota/dquot.c:369
> > >         [<      none      >] __dquot_alloc_space+0x275/0x2b0 fs/quota/dquot.c:1693
> > >         [<     inline     >] dquot_alloc_space_nodirty ./include/linux/quotaops.h:284
> > >         [<     inline     >] dquot_alloc_space ./include/linux/quotaops.h:297
> > >         [<     inline     >] dquot_alloc_block ./include/linux/quotaops.h:321
> > >         [<      none      >] ext4_mb_new_blocks+0x113/0x1110 fs/ext4/mballoc.c:4487
> > >         [<      none      >] ext4_ext_map_blocks+0xe2f/0x20d0 fs/ext4/extents.c:4478
> > >         [<      none      >] ext4_map_blocks+0x175/0x5e0 fs/ext4/inode.c:619
> > >         [<      none      >] ext4_getblk+0x51/0x1a0 fs/ext4/inode.c:949
> > >         [<      none      >] ext4_bread+0x22/0xc0 fs/ext4/inode.c:999
> > >         [<      none      >] ext4_append+0x4d/0xe0 fs/ext4/namei.c:64
> > >         [<     inline     >] ext4_init_new_dir fs/ext4/namei.c:2615
> > >         [<      none      >] ext4_mkdir+0x266/0x470 fs/ext4/namei.c:2662
> > >         [<      none      >] vfs_mkdir+0x119/0x1c0 fs/namei.c:3769
> > >         [<     inline     >] SYSC_mkdirat fs/namei.c:3792
> > >         [<     inline     >] SyS_mkdirat fs/namei.c:3776
> > >         [<     inline     >] SYSC_mkdir fs/namei.c:3803
> > >         [<      none      >] SyS_mkdir+0x7a/0xf0 fs/namei.c:3801
> > >         [<      none      >] entry_SYSCALL_64_fastpath+0x1f/0xc2 arch/x86/entry/entry_64.S:204
> > >   
> > >   other info that might help us debug this:
> > >   
> > >    Possible unsafe locking scenario:
> > >   
> > >          CPU0                    CPU1
> > >          ----                    ----
> > >     lock(&ei->i_data_sem/2);
> > >                                  lock(&s->s_dquot.dqio_mutex);
> > >                                  lock(&ei->i_data_sem/2);
> > >     lock(&s->s_dquot.dqio_mutex);
> > >   
> > >    *** DEADLOCK ***
> > >   
> > >   5 locks held by mkdir/8458:
> > >    #0:  (sb_writers#14){.+.+.+}, at: [<     inline     >] sb_start_write ./include/linux/fs.h:1504
> > >    #0:  (sb_writers#14){.+.+.+}, at: [<ffffffff812e1e24>] mnt_want_write+0x24/0x50 fs/namespace.c:388
> > >    #1:  (&type->i_mutex_dir_key#5/1){+.+.+.}, at: [<     inline     >] inode_lock_nested ./include/linux/fs.h:731
> > >    #1:  (&type->i_mutex_dir_key#5/1){+.+.+.}, at: [<ffffffff812cb5e3>] filename_create+0x83/0x160 fs/namei.c:3594
> > >    #2:  (jbd2_handle){++++..}, at: [<ffffffff813d31b2>] start_this_handle+0x112/0x450 fs/jbd2/transaction.c:361
> > >    #3:  (&ei->i_data_sem/2){++++..}, at: [<ffffffff81371ba1>] ext4_map_blocks+0x151/0x5e0 fs/ext4/inode.c:612
> > >    #4:  (dquot_srcu){......}, at: [<     inline     >] srcu_read_lock ./include/linux/srcu.h:237
> > >    #4:  (dquot_srcu){......}, at: [<ffffffff8133c44b>] __dquot_alloc_space+0xbb/0x2b0 fs/quota/dquot.c:1668
> > >   
> > >   stack backtrace:
> > >   CPU: 3 PID: 8458 Comm: mkdir Not tainted 4.11.0 #1
> > >   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.3-1.fc25 04/01/2014
> > >   Call Trace:
> > >   [<     inline     >] __dump_stack lib/dump_stack.c:16
> > >   [<      none      >] dump_stack+0x86/0xc3 lib/dump_stack.c:52
> > >   [<      none      >] print_circular_bug+0x1be/0x210 kernel/locking/lockdep.c:1204
> > >   [<     inline     >] check_prev_add kernel/locking/lockdep.c:1830
> > >   [<     inline     >] check_prevs_add kernel/locking/lockdep.c:1940
> > >   [<     inline     >] validate_chain kernel/locking/lockdep.c:2267
> > >   [<      none      >] __lock_acquire+0x12c2/0x1450 kernel/locking/lockdep.c:3347
> > >   [<      none      >] lock_acquire+0xea/0x1f0 kernel/locking/lockdep.c:3762
> > >    ?[<      none      >] lock_acquire+0xea/0x1f0 kernel/locking/lockdep.c:3762
> > >    ?[<      none      >] dquot_commit+0x2b/0xd0 fs/quota/dquot.c:453
> > >    ?[<      none      >] dquot_commit+0x2b/0xd0 fs/quota/dquot.c:453
> > >   [<     inline     >] __mutex_lock_common kernel/locking/mutex.c:756
> > >   [<      none      >] __mutex_lock+0x8d/0xa80 kernel/locking/mutex.c:893
> > >    ?[<      none      >] dquot_commit+0x2b/0xd0 fs/quota/dquot.c:453
> > >    ?[<     inline     >] spin_unlock ./include/linux/spinlock.h:339
> > >    ?[<      none      >] dquot_mark_dquot_dirty+0x57/0xc0 fs/quota/dquot.c:355
> > >    ?[<     inline     >] __ext4_journal_start fs/ext4/ext4_jbd2.h:318
> > >    ?[<      none      >] ext4_write_dquot+0x5c/0xa0 fs/ext4/super.c:5207
> > >    ?[<     inline     >] __ext4_journal_start fs/ext4/ext4_jbd2.h:318
> > >    ?[<      none      >] ext4_write_dquot+0x5c/0xa0 fs/ext4/super.c:5207
> > >   [<      none      >] mutex_lock_nested+0x1b/0x20 kernel/locking/mutex.c:908
> > >    ?[<      none      >] mutex_lock_nested+0x1b/0x20 kernel/locking/mutex.c:908
> > >   [<      none      >] dquot_commit+0x2b/0xd0 fs/quota/dquot.c:453
> > >   [<      none      >] ext4_write_dquot+0x6f/0xa0 fs/ext4/super.c:5211
> > >   [<      none      >] ext4_mark_dquot_dirty+0x3f/0x60 fs/ext4/super.c:5262
> > >   [<     inline     >] mark_dquot_dirty fs/quota/dquot.c:337
> > >   [<     inline     >] mark_all_dquot_dirty fs/quota/dquot.c:369
> > >   [<      none      >] __dquot_alloc_space+0x275/0x2b0 fs/quota/dquot.c:1693
> > >    ?[<      none      >] __this_cpu_preempt_check+0x13/0x20 lib/smp_processor_id.c:62
> > >    ?[<      none      >] __percpu_counter_add+0x85/0xb0 lib/percpu_counter.c:90
> > >   [<     inline     >] dquot_alloc_space_nodirty ./include/linux/quotaops.h:284
> > >   [<     inline     >] dquot_alloc_space ./include/linux/quotaops.h:297
> > >   [<     inline     >] dquot_alloc_block ./include/linux/quotaops.h:321
> > >   [<      none      >] ext4_mb_new_blocks+0x113/0x1110 fs/ext4/mballoc.c:4487
> > >    ?[<     inline     >] lock_is_held ./include/linux/lockdep.h:348
> > >    ?[<      none      >] rcu_read_lock_sched_held+0x4a/0x80 kernel/rcu/update.c:114
> > >    ?[<     inline     >] trace_kmalloc ./include/trace/events/kmem.h:45
> > >    ?[<      none      >] __kmalloc+0x2ce/0x300 mm/slub.c:3743
> > >    ?[<     inline     >] kmalloc ./include/linux/slab.h:495
> > >    ?[<     inline     >] kzalloc ./include/linux/slab.h:663
> > >    ?[<      none      >] ext4_find_extent+0x295/0x2d0 fs/ext4/extents.c:894
> > >    ?[<     inline     >] kmalloc ./include/linux/slab.h:495
> > >    ?[<     inline     >] kzalloc ./include/linux/slab.h:663
> > >    ?[<      none      >] ext4_find_extent+0x295/0x2d0 fs/ext4/extents.c:894
> > >   [<      none      >] ext4_ext_map_blocks+0xe2f/0x20d0 fs/ext4/extents.c:4478
> > >    ?[<      none      >] ext4_map_blocks+0x331/0x5e0 fs/ext4/inode.c:571
> > >    ?[<      none      >] ext4_map_blocks+0x331/0x5e0 fs/ext4/inode.c:571
> > >   [<      none      >] ext4_map_blocks+0x175/0x5e0 fs/ext4/inode.c:619
> > >   [<      none      >] ext4_getblk+0x51/0x1a0 fs/ext4/inode.c:949
> > >   [<      none      >] ext4_bread+0x22/0xc0 fs/ext4/inode.c:999
> > >   [<      none      >] ext4_append+0x4d/0xe0 fs/ext4/namei.c:64
> > >   [<     inline     >] ext4_init_new_dir fs/ext4/namei.c:2615
> > >   [<      none      >] ext4_mkdir+0x266/0x470 fs/ext4/namei.c:2662
> > >   [<      none      >] vfs_mkdir+0x119/0x1c0 fs/namei.c:3769
> > >   [<     inline     >] SYSC_mkdirat fs/namei.c:3792
> > >   [<     inline     >] SyS_mkdirat fs/namei.c:3776
> > >   [<     inline     >] SYSC_mkdir fs/namei.c:3803
> > >   [<      none      >] SyS_mkdir+0x7a/0xf0 fs/namei.c:3801
> > >   [<      none      >] entry_SYSCALL_64_fastpath+0x1f/0xc2 arch/x86/entry/entry_64.S:204
> > >   RIP: 0033:0x7fb614c15947
> > >   RSP: 002b:00007fff31be4938 EFLAGS: 00000216 ORIG_RAX: 0000000000000053
> > >   RAX: ffffffffffffffda RBX: 00007fff31be4c48 RCX: 00007fb614c15947
> > >   RDX: 0000000000000000 RSI: 00000000000001ff RDI: 00007fff31be6aa5
> > >   RBP: 0000000000000003 R08: 00000000000001ff R09: 0000564258eadac0
> > >   R10: 000056425b0a4060 R11: 0000000000000216 R12: 0000000000000000
> > >   R13: 0000564258eadb00 R14: 0000000000000000 R15: 0000000000000000
> > -- 
> > Jan Kara <jack@suse.com>
> > SUSE Labs, CR
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
