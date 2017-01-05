From: Eric Whitney <enwlinux@gmail.com>
Subject: generic/383 triggers lockdep warning in 4.10-rc2
Date: Thu, 5 Jan 2017 11:53:33 -0500
Message-ID: <20170105165333.GA24939@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:34772 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759029AbdAEQyC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jan 2017 11:54:02 -0500
Received: by mail-qt0-f193.google.com with SMTP id a29so2968503qtb.1
        for <linux-ext4@vger.kernel.org>; Thu, 05 Jan 2017 08:54:02 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

During my 4.10-rc1 and 4.10-rc2 regression runs with the latest xfstests-bld
test appliance, generic/383 triggered a lockdep warning in the 4k test case,
resulting in a test failure.  The warning is attached below.  I've not seen
this particular failure in regression runs prior to 4.10-rc1. No generic/383
failures occurred in any other test appliance test case during regression.

This failure is difficult to reproduce when the test is run alone rather than
as part of the full sequence of tests run for the 4k test case.  When run
in isolation, it failed in 1 out of 100 trials.  However, it's occurred each
time I've run the entire 4k test case - 5 out of 5 trials.

Eric

generic/383 2s ...	[05:04:54][ 2418.684358] run fstests generic/383 at 2017-01-03 05:04:54
[ 2419.159985] 
[ 2419.160130] ======================================================
[ 2419.160659] [ INFO: possible circular locking dependency detected ]
[ 2419.161245] 4.10.0-rc2 #1 Not tainted
[ 2419.161593] -------------------------------------------------------
[ 2419.162124] mkdir/14939 is trying to acquire lock:
[ 2419.162531]  (&s->s_dquot.dqio_mutex){+.+...}, at: [<ffffffff812c3659>] dquot_commit+0x29/0xb0
[ 2419.163226] 
[ 2419.163226] but task is already holding lock:
[ 2419.163226]  (&ei->i_data_sem){++++..}, at: [<ffffffff812f38dd>] ext4_map_blocks+0xed/0x640
[ 2419.163226] 
[ 2419.163226] which lock already depends on the new lock.
[ 2419.163226] 
[ 2419.163226] 
[ 2419.163226] the existing dependency chain (in reverse order) is:
[ 2419.163226] 
[ 2419.163226] -> #1 (&ei->i_data_sem){++++..}:
[ 2419.163226]        
[ 2419.163226] [<ffffffff81118a09>] lock_acquire+0xf9/0x1e0
[ 2419.163226]        
[ 2419.163226] [<ffffffff817bde66>] down_write+0x36/0x70
[ 2419.163226]        
[ 2419.163226] [<ffffffff812f38dd>] ext4_map_blocks+0xed/0x640
[ 2419.163226]        
[ 2419.163226] [<ffffffff812f4888>] ext4_getblk+0x48/0x180
[ 2419.163226]        
[ 2419.163226] [<ffffffff812f49d3>] ext4_bread+0x13/0x90
[ 2419.163226]        
[ 2419.163226] [<ffffffff81314cdb>] ext4_quota_write+0x9b/0x200
[ 2419.163226]        
[ 2419.163226] [<ffffffff812c7b83>] write_blk+0x33/0x70
[ 2419.163226]        
[ 2419.163226] [<ffffffff812c7e27>] get_free_dqblk+0x47/0xb0
[ 2419.163226]        
[ 2419.163226] [<ffffffff812c8708>] do_insert_tree+0x208/0x460
[ 2419.163226]        
[ 2419.163226] [<ffffffff812c8742>] do_insert_tree+0x242/0x460
[ 2419.163226]        
[ 2419.163226] [<ffffffff812c89ce>] qtree_write_dquot+0x6e/0x180
[ 2419.163226]        
[ 2419.163226] [<ffffffff812c72fe>] v2_write_dquot+0x2e/0x30
[ 2419.163226]        
[ 2419.163226] [<ffffffff812c28c4>] dquot_acquire+0xa4/0x120
[ 2419.163226]        
[ 2419.163226] [<ffffffff8130e2eb>] ext4_acquire_dquot+0x6b/0xa0
[ 2419.163226]        
[ 2419.163226] [<ffffffff812c488a>] dqget+0x30a/0x460
[ 2419.163226]        
[ 2419.163226] [<ffffffff812c57b4>] dquot_get_dqblk+0x14/0x40
[ 2419.163226]        
[ 2419.163226] [<ffffffff812c9804>] quota_getquota+0xa4/0x1b0
[ 2419.163226]        
[ 2419.163226] [<ffffffff812ca976>] SyS_quotactl+0x616/0x890
[ 2419.163226]        
[ 2419.163226] [<ffffffff81002e50>] do_syscall_64+0x70/0x3d0
[ 2419.163226]        
[ 2419.163226] [<ffffffff817c1209>] return_from_SYSCALL_64+0x0/0x7a
[ 2419.163226] 
[ 2419.163226] -> #0 (&s->s_dquot.dqio_mutex){+.+...}:
[ 2419.163226]        
[ 2419.163226] [<ffffffff811182d9>] __lock_acquire+0x1449/0x16d0
[ 2419.163226]        
[ 2419.163226] [<ffffffff81118a09>] lock_acquire+0xf9/0x1e0
[ 2419.163226]        
[ 2419.163226] [<ffffffff817bc7cf>] mutex_lock_nested+0x4f/0x620
[ 2419.163226]        
[ 2419.163226] [<ffffffff812c3659>] dquot_commit+0x29/0xb0
[ 2419.163226]        
[ 2419.163226] [<ffffffff8130e38f>] ext4_write_dquot+0x6f/0xa0
[ 2419.163226]        
[ 2419.163226] [<ffffffff8130e3ff>] ext4_mark_dquot_dirty+0x3f/0x60
[ 2419.163226]        
[ 2419.163226] [<ffffffff812c6b12>] __dquot_alloc_space+0x192/0x220
[ 2419.163226]        
[ 2419.163226] [<ffffffff8133140c>] ext4_mb_new_blocks+0xfc/0xea0
[ 2419.163226]        
[ 2419.163226] [<ffffffff813251dd>] ext4_ext_map_blocks+0xa7d/0x21b0
[ 2419.163226]        
[ 2419.163226] [<ffffffff812f3901>] ext4_map_blocks+0x111/0x640
[ 2419.163226]        
[ 2419.163226] [<ffffffff812f4888>] ext4_getblk+0x48/0x180
[ 2419.163226]        
[ 2419.163226] [<ffffffff812f49d3>] ext4_bread+0x13/0x90
[ 2419.163226]        
[ 2419.163226] [<ffffffff812fee79>] ext4_append+0x49/0xe0
[ 2419.163226]        
[ 2419.163226] [<ffffffff81304154>] ext4_mkdir+0x254/0x430
[ 2419.163226]        
[ 2419.163226] [<ffffffff81261adc>] vfs_mkdir+0x11c/0x1c0
[ 2419.163226]        
[ 2419.163226] [<ffffffff81268232>] SyS_mkdir+0xb2/0xe0
[ 2419.163226]        
[ 2419.163226] [<ffffffff81002e50>] do_syscall_64+0x70/0x3d0
[ 2419.163226]        
[ 2419.163226] [<ffffffff817c1209>] return_from_SYSCALL_64+0x0/0x7a
[ 2419.163226] 
[ 2419.163226] other info that might help us debug this:
[ 2419.163226] 
[ 2419.163226]  Possible unsafe locking scenario:
[ 2419.163226] 
[ 2419.163226]        CPU0                    CPU1
[ 2419.163226]        ----                    ----
[ 2419.163226]   lock(&ei->i_data_sem);
[ 2419.163226]                                lock(&s->s_dquot.dqio_mutex);
[ 2419.163226]                                lock(&ei->i_data_sem);
[ 2419.163226]   lock(&s->s_dquot.dqio_mutex);
[ 2419.163226] 
[ 2419.163226]  *** DEADLOCK ***
[ 2419.163226] 
[ 2419.163226] 5 locks held by mkdir/14939:
[ 2419.163226]  #0:  (sb_writers#3){++++.+}, at: [<ffffffff8127c664>] mnt_want_write+0x24/0x50
[ 2419.163226]  #1:  (&type->i_mutex_dir_key/1){+.+.+.}, at: [<ffffffff81267270>] filename_create+0x70/0x150
[ 2419.163226]  #2:  (jbd2_handle){++++..}, at: [<ffffffff81343271>] start_this_handle+0x101/0x420
[ 2419.163226]  #3:  (&ei->i_data_sem){++++..}, at: [<ffffffff812f38dd>] ext4_map_blocks+0xed/0x640
[ 2419.163226]  #4:  (dquot_srcu){......}, at: [<ffffffff812c69ea>] __dquot_alloc_space+0x6a/0x220
[ 2419.163226] 
[ 2419.163226] stack backtrace:
[ 2419.163226] CPU: 0 PID: 14939 Comm: mkdir Not tainted 4.10.0-rc2 #1
[ 2419.163226] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[ 2419.163226] Call Trace:
[ 2419.163226]  dump_stack+0x85/0xc2
[ 2419.163226]  print_circular_bug+0x1cf/0x230
[ 2419.163226]  __lock_acquire+0x1449/0x16d0
[ 2419.163226]  lock_acquire+0xf9/0x1e0
[ 2419.163226]  ? dquot_commit+0x29/0xb0
[ 2419.163226]  mutex_lock_nested+0x4f/0x620
[ 2419.163226]  ? dquot_commit+0x29/0xb0
[ 2419.163226]  dquot_commit+0x29/0xb0
[ 2419.163226]  ext4_write_dquot+0x6f/0xa0
[ 2419.163226]  ext4_mark_dquot_dirty+0x3f/0x60
[ 2419.163226]  __dquot_alloc_space+0x192/0x220
[ 2419.163226]  ? __dquot_alloc_space+0x6a/0x220
[ 2419.163226]  ? ext4_es_insert_extent+0x105/0x260
[ 2419.163226]  ext4_mb_new_blocks+0xfc/0xea0
[ 2419.163226]  ? __kmalloc+0x209/0x270
[ 2419.163226]  ? ext4_find_extent+0x1ef/0x2f0
[ 2419.163226]  ? ext4_find_extent+0x1ef/0x2f0
[ 2419.163226]  ext4_ext_map_blocks+0xa7d/0x21b0
[ 2419.163226]  ? crypto_shash_update+0x36/0x100
[ 2419.163226]  ext4_map_blocks+0x111/0x640
[ 2419.163226]  ? __ext4_new_inode+0x11eb/0x1590
[ 2419.163226]  ext4_getblk+0x48/0x180
[ 2419.163226]  ext4_bread+0x13/0x90
[ 2419.163226]  ext4_append+0x49/0xe0
[ 2419.163226]  ext4_mkdir+0x254/0x430
[ 2419.163226]  vfs_mkdir+0x11c/0x1c0
[ 2419.163226]  SyS_mkdir+0xb2/0xe0
[ 2419.163226]  do_syscall_64+0x70/0x3d0
[ 2419.163226]  entry_SYSCALL64_slow_path+0x25/0x25
[ 2419.163226] RIP: 0033:0x7f44c096fb97
[ 2419.163226] RSP: 002b:00007fff8e7aa878 EFLAGS: 00000206 ORIG_RAX: 0000000000000053
[ 2419.163226] RAX: ffffffffffffffda RBX: 00007fff8e7ab27f RCX: 00007f44c096fb97
[ 2419.163226] RDX: 00000000000001ff RSI: 00000000000001ff RDI: 00007fff8e7ab27f
[ 2419.163226] RBP: 00007fff8e7aaa80 R08: 00000000000001ff R09: 0000000000402a00
[ 2419.163226] R10: 00007fff8e7aa640 R11: 0000000000000206 R12: 0000000000000000
[ 2419.163226] R13: 0000000000000001 R14: 00007fff8e7aaad0 R15: 00000000000001ff
 [05:04:54] 0s
[ 2419.306353] EXT4-fs (vdc): mounted filesystem with ordered data mode. Opts: acl,user_xattr,block_validity
_check_dmesg: something found in dmesg (see /results/ext4/results-4k/generic/383.dmesg)

