From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: ext4 lockdep splat with v4.9-rc1
Date: Thu, 20 Oct 2016 20:06:16 -0600
Message-ID: <20161021020616.GA25426@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In my DAX PMD regression testing I hit the lockdep splat at the end of this
mail.  I've tried to reproduce it multiple times, but haven't been able to.
I'm hoping that the lockdep splat contains enough information by itself to be
useful.

This testing was done with v8 of my DAX PMD series, but I don't think my
series modifies any of the locks in the splat so I think the problem should
exist with v4.9-rc1 as well.

Here's the tree I was testing with, mostly so you can easily match up line
numbers from the lockdep splat:

https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=dax_pmd_v8

Here's the lockdep splat, run through kasan_symbolize.py:

run fstests generic/323 at 2016-10-19 18:03:15

======================================================
[ INFO: possible circular locking dependency detected ]
4.9.0-rc1-00016-g362bae7-dirty #1 Tainted: G            E
-------------------------------------------------------
aio-last-ref-he/17703 is trying to acquire lock:
 ([ 3888.807595] &mm->mmap_sem
){++++++}[ 3888.808540] , at:
[<ffffffff81073d26>] __do_page_fault+0x3b6/0x4c0 arch/x86/mm/fault.c:1343

but task is already holding lock:
 ([ 3888.812678] &sb->s_type->i_mutex_key
#14[ 3888.813750] ){++++++}
, at: [ 3888.814538] [<ffffffff8133ece3>] ext4_direct_IO+0x103/0x810

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #3[ 3888.820884]  (
&sb->s_type->i_mutex_key[ 3888.821933] #14
){++++++}[ 3888.822650] :
[<ffffffff81110828>] lock_acquire+0xe8/0x1d0 kernel/locking/lockdep.c:3746
[<ffffffff81b2ab87>] down_write+0x47/0xb0 kernel/locking/rwsem.c:52
[<     inline     >] inode_lock ./include/linux/fs.h:740
[<ffffffff81301cd8>] vfs_load_quota_inode+0x428/0x570 fs/quota/dquot.c:2305
[<ffffffff8130208f>] dquot_quota_on+0x4f/0x60 fs/quota/dquot.c:2413
[<ffffffff8135ad1f>] ext4_quota_on+0x11f/0x1b0 fs/ext4/super.c:5262
[<     inline     >] quota_quotaon fs/quota/quota.c:91
[<     inline     >] do_quotactl fs/quota/quota.c:724
[<     inline     >] SYSC_quotactl fs/quota/quota.c:873
[<ffffffff813079ec>] SyS_quotactl+0x50c/0x8b0 fs/quota/quota.c:832
[<ffffffff81b2e081>] entry_SYSCALL_64_fastpath+0x1f/0xc2 arch/x86/entry/entry_64.S:209

-> #2[ 3888.838137]  (
&s->s_dquot.dqonoff_mutex[ 3888.839219] ){+.+...}
:
[<ffffffff81110828>] lock_acquire+0xe8/0x1d0 kernel/locking/lockdep.c:3746
[<     inline     >] __mutex_lock_common kernel/locking/mutex.c:521
[<ffffffff81b299cc>] mutex_lock_nested+0x6c/0x3b0 kernel/locking/mutex.c:621
[<ffffffff81302649>] dquot_writeback_dquots+0x39/0x270 fs/quota/dquot.c:620
[<ffffffff81354417>] ext4_sync_fs+0x67/0x2b0 fs/ext4/super.c:4666
[<     inline     >] __sync_filesystem fs/sync.c:38
[<ffffffff812c7d72>] sync_filesystem+0x42/0xa0 fs/sync.c:63
[<ffffffff8128da5a>] freeze_super+0xaa/0x190 fs/super.c:1372
[<     inline     >] ioctl_fsfreeze fs/ioctl.c:555
[<ffffffff812a1365>] do_vfs_ioctl+0x575/0x6e0 fs/ioctl.c:653
[<     inline     >] SYSC_ioctl fs/ioctl.c:694
[<ffffffff812a1549>] SyS_ioctl+0x79/0x90 fs/ioctl.c:685
[<ffffffff81b2e081>] entry_SYSCALL_64_fastpath+0x1f/0xc2 arch/x86/entry/entry_64.S:209

-> #1[ 3888.859411]  (
sb_pagefaults[ 3888.860194] ){++++.+}
:
[<ffffffff81110828>] lock_acquire+0xe8/0x1d0 kernel/locking/lockdep.c:3746
[<     inline     >] percpu_down_read_preempt_disable ./include/linux/percpu-rwsem.h:35
[<     inline     >] percpu_down_read ./include/linux/percpu-rwsem.h:58
[<ffffffff8128e135>] __sb_start_write+0xa5/0x1b0 fs/super.c:1252
[<     inline     >] sb_start_pagefault ./include/linux/fs.h:1577
[<ffffffff81340fa3>] ext4_page_mkwrite+0x63/0x4c0 fs/ext4/inode.c:5666
[<ffffffff81226a14>] do_page_mkwrite+0x74/0x120 mm/memory.c:2054
[<     inline     >] wp_page_shared mm/memory.c:2319
[<ffffffff812283e7>] do_wp_page+0x1f7/0x890 mm/memory.c:2423
[<     inline     >] handle_pte_fault mm/memory.c:3542
[<     inline     >] __handle_mm_fault mm/memory.c:3614
[<ffffffff8122b56d>] handle_mm_fault+0xa7d/0x16c0 mm/memory.c:3651
[<ffffffff81073bdb>] __do_page_fault+0x26b/0x4c0 arch/x86/mm/fault.c:1397
[<ffffffff81073f08>] trace_do_page_fault+0x58/0x270 arch/x86/mm/fault.c:1490
[<ffffffff8106ddfa>] do_async_page_fault+0x1a/0xa0 arch/x86/kernel/kvm.c:265
[<ffffffff81b2f588>] async_page_fault+0x28/0x30 arch/x86/entry/entry_64.S:1015

-> #0[ 3888.882554]  (
&mm->mmap_sem[ 3888.883331] ){++++++}
:
[<     inline     >] check_prev_add kernel/locking/lockdep.c:1829
[<     inline     >] check_prevs_add kernel/locking/lockdep.c:1939
[<     inline     >] validate_chain kernel/locking/lockdep.c:2266
[<ffffffff8111023e>] __lock_acquire+0x10fe/0x1290 kernel/locking/lockdep.c:3335
[<ffffffff81110828>] lock_acquire+0xe8/0x1d0 kernel/locking/lockdep.c:3746
[<ffffffff81b2aade>] down_read+0x3e/0xa0 kernel/locking/rwsem.c:22
[<ffffffff81073d26>] __do_page_fault+0x3b6/0x4c0 arch/x86/mm/fault.c:1343
[<ffffffff81073f08>] trace_do_page_fault+0x58/0x270 arch/x86/mm/fault.c:1490
[<ffffffff8106ddfa>] do_async_page_fault+0x1a/0xa0 arch/x86/kernel/kvm.c:265
[<ffffffff81b2f588>] async_page_fault+0x28/0x30 arch/x86/entry/entry_64.S:1015
[<     inline     >] dax_io fs/dax.c:207
[<ffffffff812e767f>] dax_do_io+0x17f/0x5a0 fs/dax.c:262
[<     inline     >] ext4_direct_IO_read fs/ext4/inode.c:3553
[<ffffffff8133f19c>] ext4_direct_IO+0x5bc/0x810 fs/ext4/inode.c:3595
[<ffffffff811ec096>] generic_file_read_iter+0x286/0x8f0 mm/filemap.c:1942
[<ffffffff812e5361>] aio_run_iocb+0x131/0x2c0 fs/aio.c:1466
[<     inline     >] io_submit_one fs/aio.c:1568
[<ffffffff812e64c6>] do_io_submit+0x336/0x7d0 fs/aio.c:1626
[<     inline     >] SYSC_io_submit fs/aio.c:1651
[<ffffffff812e6970>] SyS_io_submit+0x10/0x20 fs/aio.c:1648
[<ffffffff81b2e081>] entry_SYSCALL_64_fastpath+0x1f/0xc2 arch/x86/entry/entry_64.S:209

other info that might help us debug this:

Chain exists of:
  [ 3888.916374] &mm->mmap_sem
 --> [ 3888.917234] &s->s_dquot.dqonoff_mutex
 --> [ 3888.918375] &sb->s_type->i_mutex_key
#14[ 3888.919448]

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock([ 3888.924882] &sb->s_type->i_mutex_key
#14[ 3888.925954] );
                               lock([ 3888.927657] &s->s_dquot.dqonoff_mutex
);
                               lock([ 3888.930351] &sb->s_type->i_mutex_key
#14[ 3888.931421] );
  lock([ 3888.932425] &mm->mmap_sem
);

 * DEADLOCK *

1 lock held by aio-last-ref-he/17703:
 #0: [ 3888.936982]  (
&sb->s_type->i_mutex_key[ 3888.938028] #14
){++++++}[ 3888.938750] , at:
[<     inline     >] inode_lock_shared ./include/linux/fs.h:750
[<     inline     >] ext4_direct_IO_read fs/ext4/inode.c:3551
[<ffffffff8133ece3>] ext4_direct_IO+0x103/0x810 fs/ext4/inode.c:3595

stack backtrace:
CPU: 1 PID: 17703 Comm: aio-last-ref-he Tainted: G            E   4.9.0-rc1-00016-g362bae7-dirty #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.1-1.fc24 04/01/2014
 ffffc9001471f750 ffffffff815edbe3 ffffffff82f71ac0 ffffffff82ee1540
 ffffc9001471f790 ffffffff8110d8ae 0000000010bf9a40 ffff880510bfa250
 ffff880510bf9a40 ffff880510bfa218 0000000000000001 0000000000000000
Call Trace:
 [<     inline     >] __dump_stack lib/dump_stack.c:15
 [<ffffffff815edbe3>] dump_stack+0x86/0xc3 lib/dump_stack.c:51
 [<ffffffff8110d8ae>] print_circular_bug+0x1be/0x210 kernel/locking/lockdep.c:1202
 [<     inline     >] check_prev_add kernel/locking/lockdep.c:1829
 [<     inline     >] check_prevs_add kernel/locking/lockdep.c:1939
 [<     inline     >] validate_chain kernel/locking/lockdep.c:2266
 [<ffffffff8111023e>] __lock_acquire+0x10fe/0x1290 kernel/locking/lockdep.c:3335
 [<ffffffff81110828>] lock_acquire+0xe8/0x1d0 kernel/locking/lockdep.c:3746
 [<ffffffff81b2aade>] down_read+0x3e/0xa0 kernel/locking/rwsem.c:22
 [<ffffffff81073d26>] __do_page_fault+0x3b6/0x4c0 arch/x86/mm/fault.c:1343
 [<ffffffff81073f08>] trace_do_page_fault+0x58/0x270 arch/x86/mm/fault.c:1490
 [<ffffffff8106ddfa>] do_async_page_fault+0x1a/0xa0 arch/x86/kernel/kvm.c:265
 [<ffffffff81b2f588>] async_page_fault+0x28/0x30 arch/x86/entry/entry_64.S:1015
 [<     inline     >] dax_io fs/dax.c:207
 [<ffffffff812e767f>] dax_do_io+0x17f/0x5a0 fs/dax.c:262
 [<     inline     >] ext4_direct_IO_read fs/ext4/inode.c:3553
 [<ffffffff8133f19c>] ext4_direct_IO+0x5bc/0x810 fs/ext4/inode.c:3595
 [<ffffffff811ec096>] generic_file_read_iter+0x286/0x8f0 mm/filemap.c:1942
 [<ffffffff812e5361>] aio_run_iocb+0x131/0x2c0 fs/aio.c:1466
 [<     inline     >] io_submit_one fs/aio.c:1568
 [<ffffffff812e64c6>] do_io_submit+0x336/0x7d0 fs/aio.c:1626
 [<     inline     >] SYSC_io_submit fs/aio.c:1651
 [<ffffffff812e6970>] SyS_io_submit+0x10/0x20 fs/aio.c:1648
 [<ffffffff81b2e081>] entry_SYSCALL_64_fastpath+0x1f/0xc2 arch/x86/entry/entry_64.S:209
