From: Jan Kara <jack@suse.cz>
Subject: Re: 3.3.7 lockdep report from jbd.
Date: Fri, 1 Jun 2012 20:36:03 +0200
Message-ID: <20120601183603.GA1646@quack.suse.cz>
References: <20120530023747.GA1845@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50537 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932760Ab2FASgI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 1 Jun 2012 14:36:08 -0400
Content-Disposition: inline
In-Reply-To: <20120530023747.GA1845@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 29-05-12 22:37:47, Dave Jones wrote:
> Just saw this on my backup server during an rsync.
> I'll see if I can reproduce it in 3.4 later.
> 
> 	Dave
> 
> 
> =========================================================
> [ INFO: possible irq lock inversion dependency detected ]
> 3.3.7-1.fc16.x86_64.debug #1 Not tainted
> ---------------------------------------------------------
> kswapd0/37 just changed the state of lock:
>  (jbd2_handle){+.+.-.}, at: [<ffffffff8128b457>] start_this_handle+0x507/0x700
> but this lock took another, RECLAIM_FS-unsafe lock in the past:
>  (&isec->lock){+.+.+.}
> 
> and interrupts could create inverse lock ordering between them.
> 
> 
> other info that might help us debug this:
>  Possible interrupt unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&isec->lock);
>                                local_irq_disable();
>                                lock(jbd2_handle);
>                                lock(&isec->lock);
>   <Interrupt>
>     lock(jbd2_handle);

Frankly, this looks like a false positive and I have a hard time
understanding how lockdep even came to the above conclusion.

Certainly we never take jbd2_handle in an interrupt. Lockdep is correct
jbd2_handle is taken in reclaim, although I'm reasonably sure we never end
up taking isec->lock under jbd2_handle in reclaim.

I'm not sure how to silence this warning though...

								Honza
> 
>  *** DEADLOCK ***
> 
> 2 locks held by kswapd0/37:
>  #0:  (shrinker_rwsem){++++..}, at: [<ffffffff8116304c>] shrink_slab+0x3c/0x4b0
>  #1:  (&type->s_umount_key#20){++++..}, at: [<ffffffff811bf654>] grab_super_passive+0x44/0x90
> 
> the shortest dependencies between 2nd lock and 1st lock:
>  -> (&isec->lock){+.+.+.} ops: 582449 {
>     HARDIRQ-ON-W at:
>                                          [<ffffffff810cbf69>] __lock_acquire+0x619/0x1c20
>                                          [<ffffffff810cdc5d>] lock_acquire+0x9d/0x200
>                                          [<ffffffff8169ef94>] mutex_lock_nested+0x74/0x3a0
>                                          [<ffffffff812c68e2>] inode_doinit_with_dentry+0xc2/0x650
>                                          [<ffffffff812c6e8c>] selinux_d_instantiate+0x1c/0x20
>                                          [<ffffffff812bd75b>] security_d_instantiate+0x1b/0x30
>                                          [<ffffffff811d4081>] d_instantiate+0x61/0x80
>                                          [<ffffffff811d69d3>] d_alloc_root+0x43/0x50
>                                          [<ffffffff81237f62>] sysfs_mount+0x182/0x220
>                                          [<ffffffff811bffe3>] mount_fs+0x43/0x1b0
>                                          [<ffffffff811dd7f2>] vfs_kern_mount+0x72/0x100
>                                          [<ffffffff811dd899>] kern_mount_data+0x19/0x30
>                                          [<ffffffff81ef30b2>] sysfs_init+0x5a/0xb5
>                                          [<ffffffff81ef1862>] mnt_init+0xa1/0x181
>                                          [<ffffffff81ef14fc>] vfs_caches_init+0xfb/0x10c
>                                          [<ffffffff81ecebf3>] start_kernel+0x3b5/0x3fc
>                                          [<ffffffff81ece346>] x86_64_start_reservations+0x131/0x135
>                                          [<ffffffff81ece44c>] x86_64_start_kernel+0x102/0x111
>     SOFTIRQ-ON-W at:
>                                          [<ffffffff810cbf98>] __lock_acquire+0x648/0x1c20
>                                          [<ffffffff810cdc5d>] lock_acquire+0x9d/0x200
>                                          [<ffffffff8169ef94>] mutex_lock_nested+0x74/0x3a0
>                                          [<ffffffff812c68e2>] inode_doinit_with_dentry+0xc2/0x650
>                                          [<ffffffff812c6e8c>] selinux_d_instantiate+0x1c/0x20
>                                          [<ffffffff812bd75b>] security_d_instantiate+0x1b/0x30
>                                          [<ffffffff811d4081>] d_instantiate+0x61/0x80
>                                          [<ffffffff811d69d3>] d_alloc_root+0x43/0x50
>                                          [<ffffffff81237f62>] sysfs_mount+0x182/0x220
>                                          [<ffffffff811bffe3>] mount_fs+0x43/0x1b0
>                                          [<ffffffff811dd7f2>] vfs_kern_mount+0x72/0x100
>                                          [<ffffffff811dd899>] kern_mount_data+0x19/0x30
>                                          [<ffffffff81ef30b2>] sysfs_init+0x5a/0xb5
>                                          [<ffffffff81ef1862>] mnt_init+0xa1/0x181
>                                          [<ffffffff81ef14fc>] vfs_caches_init+0xfb/0x10c
>                                          [<ffffffff81ecebf3>] start_kernel+0x3b5/0x3fc
>                                          [<ffffffff81ece346>] x86_64_start_reservations+0x131/0x135
>                                          [<ffffffff81ece44c>] x86_64_start_kernel+0x102/0x111
>     RECLAIM_FS-ON-W at:
>                                             [<ffffffff810ce626>] mark_held_locks+0x86/0x150
>                                             [<ffffffff810cedb1>] lockdep_trace_alloc+0x71/0xd0
>                                             [<ffffffff811591d6>] __alloc_pages_nodemask+0x86/0xa90
>                                             [<ffffffff81194063>] alloc_pages_current+0xa3/0x110
>                                             [<ffffffff81154b94>] __get_free_pages+0x14/0x50
>                                             [<ffffffff812c6b4b>] inode_doinit_with_dentry+0x32b/0x650
>                                             [<ffffffff812c6f56>] sb_finish_set_opts+0xc6/0x260
>                                             [<ffffffff812c753c>] selinux_set_mnt_opts+0x32c/0x540
>                                             [<ffffffff812c77b0>] superblock_doinit+0x60/0xc0
>                                             [<ffffffff812c78f0>] delayed_superblock_init+0x10/0x20
>                                             [<ffffffff811bfa41>] iterate_supers+0xf1/0x100
>                                             [<ffffffff812cae13>] selinux_complete_init+0x33/0x40
>                                             [<ffffffff812da95b>] security_load_policy+0x35b/0x4e0
>                                             [<ffffffff812ccb6f>] sel_write_load+0x9f/0x790
>                                             [<ffffffff811bb506>] vfs_write+0xb6/0x180
>                                             [<ffffffff811bb82d>] sys_write+0x4d/0x90
>                                             [<ffffffff816abc29>] system_call_fastpath+0x16/0x1b
>     INITIAL USE at:
>                                         [<ffffffff810cbc70>] __lock_acquire+0x320/0x1c20
>                                         [<ffffffff810cdc5d>] lock_acquire+0x9d/0x200
>                                         [<ffffffff8169ef94>] mutex_lock_nested+0x74/0x3a0
>                                         [<ffffffff812c68e2>] inode_doinit_with_dentry+0xc2/0x650
>                                         [<ffffffff812c6e8c>] selinux_d_instantiate+0x1c/0x20
>                                         [<ffffffff812bd75b>] security_d_instantiate+0x1b/0x30
>                                         [<ffffffff811d4081>] d_instantiate+0x61/0x80
>                                         [<ffffffff811d69d3>] d_alloc_root+0x43/0x50
>                                         [<ffffffff81237f62>] sysfs_mount+0x182/0x220
>                                         [<ffffffff811bffe3>] mount_fs+0x43/0x1b0
>                                         [<ffffffff811dd7f2>] vfs_kern_mount+0x72/0x100
>                                         [<ffffffff811dd899>] kern_mount_data+0x19/0x30
>                                         [<ffffffff81ef30b2>] sysfs_init+0x5a/0xb5
>                                         [<ffffffff81ef1862>] mnt_init+0xa1/0x181
>                                         [<ffffffff81ef14fc>] vfs_caches_init+0xfb/0x10c
>                                         [<ffffffff81ecebf3>] start_kernel+0x3b5/0x3fc
>                                         [<ffffffff81ece346>] x86_64_start_reservations+0x131/0x135
>                                         [<ffffffff81ece44c>] x86_64_start_kernel+0x102/0x111
>   }
>   ... key      at: [<ffffffff829db510>] __key.51824+0x0/0x8
>   ... acquired at:
>    [<ffffffff810cdc5d>] lock_acquire+0x9d/0x200
>    [<ffffffff8169ef94>] mutex_lock_nested+0x74/0x3a0
>    [<ffffffff812c68e2>] inode_doinit_with_dentry+0xc2/0x650
>    [<ffffffff812c6e8c>] selinux_d_instantiate+0x1c/0x20
>    [<ffffffff812bd75b>] security_d_instantiate+0x1b/0x30
>    [<ffffffff811d4081>] d_instantiate+0x61/0x80
>    [<ffffffff812510b6>] ext4_add_nondir+0x76/0x80
>    [<ffffffff812531b6>] ext4_symlink+0x1a6/0x330
>    [<ffffffff811ca2d9>] vfs_symlink+0x99/0x100
>    [<ffffffff811cdb73>] sys_symlinkat+0xb3/0xd0
>    [<ffffffff811cdba6>] sys_symlink+0x16/0x20
>    [<ffffffff816abc29>] system_call_fastpath+0x16/0x1b
> 
> -> (jbd2_handle){+.+.-.} ops: 20071115 {
>    HARDIRQ-ON-W at:
>                                        [<ffffffff810cbf69>] __lock_acquire+0x619/0x1c20
>                                        [<ffffffff810cdc5d>] lock_acquire+0x9d/0x200
>                                        [<ffffffff8128b486>] start_this_handle+0x536/0x700
>                                        [<ffffffff8128b77a>] jbd2__journal_start+0x12a/0x1a0
>                                        [<ffffffff8128b803>] jbd2_journal_start+0x13/0x20
>                                        [<ffffffff81266cde>] ext4_journal_start_sb+0x7e/0x2a0
>                                        [<ffffffff81252907>] ext4_unlink+0x67/0x4b0
>                                        [<ffffffff811c9bdf>] vfs_unlink+0x9f/0x110
>                                        [<ffffffff811ccf43>] do_unlinkat+0x183/0x1c0
>                                        [<ffffffff811cda82>] sys_unlinkat+0x22/0x40
>                                        [<ffffffff816abc29>] system_call_fastpath+0x16/0x1b
>    SOFTIRQ-ON-W at:
>                                        [<ffffffff810cbf98>] __lock_acquire+0x648/0x1c20
>                                        [<ffffffff810cdc5d>] lock_acquire+0x9d/0x200
>                                        [<ffffffff8128b486>] start_this_handle+0x536/0x700
>                                        [<ffffffff8128b77a>] jbd2__journal_start+0x12a/0x1a0
>                                        [<ffffffff8128b803>] jbd2_journal_start+0x13/0x20
>                                        [<ffffffff81266cde>] ext4_journal_start_sb+0x7e/0x2a0
>                                        [<ffffffff81252907>] ext4_unlink+0x67/0x4b0
>                                        [<ffffffff811c9bdf>] vfs_unlink+0x9f/0x110
>                                        [<ffffffff811ccf43>] do_unlinkat+0x183/0x1c0
>                                        [<ffffffff811cda82>] sys_unlinkat+0x22/0x40
>                                        [<ffffffff816abc29>] system_call_fastpath+0x16/0x1b
>    IN-RECLAIM_FS-W at:
>                                           [<ffffffff810cbee0>] __lock_acquire+0x590/0x1c20
>                                           [<ffffffff810cdc5d>] lock_acquire+0x9d/0x200
>                                           [<ffffffff8128b486>] start_this_handle+0x536/0x700
>                                           [<ffffffff8128b77a>] jbd2__journal_start+0x12a/0x1a0
>                                           [<ffffffff8128b803>] jbd2_journal_start+0x13/0x20
>                                           [<ffffffff81266cde>] ext4_journal_start_sb+0x7e/0x2a0
>                                           [<ffffffff8124bfb9>] ext4_evict_inode+0x1a9/0x620
>                                           [<ffffffff811d91d3>] evict+0xa3/0x1b0
>                                           [<ffffffff811d93e5>] iput+0x105/0x200
>                                           [<ffffffff811d3bb8>] dentry_iput+0xa8/0x100
>                                           [<ffffffff811d53a0>] shrink_dentry_list+0x280/0x4c0
>                                           [<ffffffff811d64eb>] prune_dcache_sb+0x15b/0x190
>                                           [<ffffffff811bf7d0>] prune_super+0x130/0x1a0
>                                           [<ffffffff81163185>] shrink_slab+0x175/0x4b0
>                                           [<ffffffff8116762a>] balance_pgdat+0x52a/0x720
>                                           [<ffffffff811679c1>] kswapd+0x1a1/0x5b0
>                                           [<ffffffff8108b927>] kthread+0xb7/0xc0
>                                           [<ffffffff816ad074>] kernel_thread_helper+0x4/0x10
>    INITIAL USE at:
>                                       [<ffffffff810cbc70>] __lock_acquire+0x320/0x1c20
>                                       [<ffffffff810cdc5d>] lock_acquire+0x9d/0x200
>                                       [<ffffffff8128b486>] start_this_handle+0x536/0x700
>                                       [<ffffffff8128b77a>] jbd2__journal_start+0x12a/0x1a0
>                                       [<ffffffff8128b803>] jbd2_journal_start+0x13/0x20
>                                       [<ffffffff81266cde>] ext4_journal_start_sb+0x7e/0x2a0
>                                       [<ffffffff81252907>] ext4_unlink+0x67/0x4b0
>                                       [<ffffffff811c9bdf>] vfs_unlink+0x9f/0x110
>                                       [<ffffffff811ccf43>] do_unlinkat+0x183/0x1c0
>                                       [<ffffffff811cda82>] sys_unlinkat+0x22/0x40
>                                       [<ffffffff816abc29>] system_call_fastpath+0x16/0x1b
>  }
>  ... key      at: [<ffffffff829cff00>] jbd2_handle_key+0x0/0x8
>  ... acquired at:
>    [<ffffffff810cae1b>] check_usage_forwards+0x11b/0x150
>    [<ffffffff810cb7f8>] mark_lock+0x198/0x2f0
>    [<ffffffff810cbee0>] __lock_acquire+0x590/0x1c20
>    [<ffffffff810cdc5d>] lock_acquire+0x9d/0x200
>    [<ffffffff8128b486>] start_this_handle+0x536/0x700
>    [<ffffffff8128b77a>] jbd2__journal_start+0x12a/0x1a0
>    [<ffffffff8128b803>] jbd2_journal_start+0x13/0x20
>    [<ffffffff81266cde>] ext4_journal_start_sb+0x7e/0x2a0
>    [<ffffffff8124bfb9>] ext4_evict_inode+0x1a9/0x620
>    [<ffffffff811d91d3>] evict+0xa3/0x1b0
>    [<ffffffff811d93e5>] iput+0x105/0x200
>    [<ffffffff811d3bb8>] dentry_iput+0xa8/0x100
>    [<ffffffff811d53a0>] shrink_dentry_list+0x280/0x4c0
>    [<ffffffff811d64eb>] prune_dcache_sb+0x15b/0x190
>    [<ffffffff811bf7d0>] prune_super+0x130/0x1a0
>    [<ffffffff81163185>] shrink_slab+0x175/0x4b0
>    [<ffffffff8116762a>] balance_pgdat+0x52a/0x720
>    [<ffffffff811679c1>] kswapd+0x1a1/0x5b0
>    [<ffffffff8108b927>] kthread+0xb7/0xc0
>    [<ffffffff816ad074>] kernel_thread_helper+0x4/0x10
> 
> 
> stack backtrace:
> Pid: 37, comm: kswapd0 Not tainted 3.3.7-1.fc16.x86_64.debug #1
> Call Trace:
>  [<ffffffff810cacf8>] print_irq_inversion_bug.part.19+0x1e8/0x1f0
>  [<ffffffff810cae1b>] check_usage_forwards+0x11b/0x150
>  [<ffffffff810cb7f8>] mark_lock+0x198/0x2f0
>  [<ffffffff810cad00>] ? print_irq_inversion_bug.part.19+0x1f0/0x1f0
>  [<ffffffff810cbee0>] __lock_acquire+0x590/0x1c20
>  [<ffffffff8128b6d9>] ? jbd2__journal_start+0x89/0x1a0
>  [<ffffffff81022023>] ? native_sched_clock+0x13/0x80
>  [<ffffffff810a3dc5>] ? sched_clock_local+0x25/0x90
>  [<ffffffff810a3f58>] ? sched_clock_cpu+0xa8/0x110
>  [<ffffffff810c815d>] ? trace_hardirqs_off+0xd/0x10
>  [<ffffffff810cdc5d>] lock_acquire+0x9d/0x200
>  [<ffffffff8128b457>] ? start_this_handle+0x507/0x700
>  [<ffffffff8128b486>] start_this_handle+0x536/0x700
>  [<ffffffff8128b457>] ? start_this_handle+0x507/0x700
>  [<ffffffff811a1c2b>] ? kmem_cache_alloc+0x19b/0x280
>  [<ffffffff8128b6d9>] ? jbd2__journal_start+0x89/0x1a0
>  [<ffffffff8128b77a>] jbd2__journal_start+0x12a/0x1a0
>  [<ffffffff8124bfb9>] ? ext4_evict_inode+0x1a9/0x620
>  [<ffffffff8128b803>] jbd2_journal_start+0x13/0x20
>  [<ffffffff81266cde>] ext4_journal_start_sb+0x7e/0x2a0
>  [<ffffffff8121ec90>] ? __dquot_initialize+0x30/0x180
>  [<ffffffff811d91c1>] ? evict+0x91/0x1b0
>  [<ffffffff8124bfb9>] ext4_evict_inode+0x1a9/0x620
>  [<ffffffff811d91d3>] evict+0xa3/0x1b0
>  [<ffffffff811d93e5>] iput+0x105/0x200
>  [<ffffffff811d3bb8>] dentry_iput+0xa8/0x100
>  [<ffffffff811d53a0>] shrink_dentry_list+0x280/0x4c0
>  [<ffffffff811d53d0>] ? shrink_dentry_list+0x2b0/0x4c0
>  [<ffffffff811d64eb>] prune_dcache_sb+0x15b/0x190
>  [<ffffffff811bf7d0>] prune_super+0x130/0x1a0
>  [<ffffffff81163185>] shrink_slab+0x175/0x4b0
>  [<ffffffff811ae776>] ? mem_cgroup_iter+0xf6/0x340
>  [<ffffffff8116762a>] balance_pgdat+0x52a/0x720
>  [<ffffffff811679c1>] kswapd+0x1a1/0x5b0
>  [<ffffffff8108c580>] ? __init_waitqueue_head+0x60/0x60
>  [<ffffffff81167820>] ? balance_pgdat+0x720/0x720
>  [<ffffffff8108b927>] kthread+0xb7/0xc0
>  [<ffffffff816ad074>] kernel_thread_helper+0x4/0x10
>  [<ffffffff816a3374>] ? retint_restore_args+0x13/0x13
>  [<ffffffff8108b870>] ? __init_kthread_worker+0x70/0x70
>  [<ffffffff816ad070>] ? gs_change+0x13/0x13
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
