From: Eric Whitney <enwlinux@gmail.com>
Subject: generic/095 triggers lockdep warning in 4.9-rc1
Date: Thu, 20 Oct 2016 14:04:00 -0400
Message-ID: <20161020180400.GA2172@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.cz, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:36392 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754817AbcJTR7R (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Oct 2016 13:59:17 -0400
Received: by mail-qk0-f175.google.com with SMTP id o68so109038056qkf.3
        for <linux-ext4@vger.kernel.org>; Thu, 20 Oct 2016 10:59:17 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As reported in today's concall, generic/095 triggered a lockdep warning
during my regression run on a 4.9-rc1 kernel in the 4k test case using the
latest xfstests-bld test appliance.  The warning is attached below, and
involves both ext4's direct I/O path and the quota code.

This failure is difficult to reproduce - 120 out of 120 subsequent trials in
the 4k test case completed successfully.  No generic/095 failures occurred in
any other test appliance test case during regression.  Also, I've not seen
this particular failure in regression runs prior to 4.9-rc1.

Eric


generic/095		[16:41:05][  542.526101] run fstests generic/095 at 2016-10-17 16:41:05
[  543.567531] 
[  543.567659] ======================================================
[  543.568053] [ INFO: possible circular locking dependency detected ]
[  543.568457] 4.9.0-rc1 #1 Not tainted
[  543.568687] -------------------------------------------------------
[  543.569095] fio/3576 is trying to acquire lock:
[  543.569372]  ([  543.569466] &mm->mmap_sem
){++++++}[  543.569934] , at: 
[  543.570191] [<ffffffff8120938f>] get_user_pages_unlocked+0x5f/0x1e0
[  543.570549] 
[  543.570549] but task is already holding lock:
[  543.570737]  ([  543.570737] &sb->s_type->i_mutex_key
#11[  543.570737] ){++++++}
, at: [  543.570737] [<ffffffff812f6be0>] ext4_direct_IO+0x140/0x740
[  543.570737] 
[  543.570737] which lock already depends on the new lock.
[  543.570737] 
[  543.570737] 
[  543.570737] the existing dependency chain (in reverse order) is:
[  543.570737] 
-> #3[  543.570737]  (
&sb->s_type->i_mutex_key[  543.570737] #11
){++++++}[  543.570737] :
[  543.570737]        [  543.570737] [<ffffffff811192b9>] lock_acquire+0xf9/0x1e0
[  543.570737]        [  543.570737] [<ffffffff817a9a26>] down_write+0x36/0x70
[  543.570737]        [  543.570737] [<ffffffff812c2d75>] vfs_load_quota_inode+0x475/0x580
[  543.570737]        [  543.570737] [<ffffffff812c3308>] dquot_quota_on+0x58/0x60
[  543.570737]        [  543.570737] [<ffffffff813119f2>] ext4_quota_on+0x122/0x1c0
[  543.570737]        [  543.570737] [<ffffffff812c79c5>] SyS_quotactl+0x6a5/0x890
[  543.570737]        [  543.570737] [<ffffffff81002e50>] do_syscall_64+0x70/0x3d0
[  543.570737]        [  543.570737] [<ffffffff817acdc9>] return_from_SYSCALL_64+0x0/0x7a
[  543.570737] 
-> #2[  543.570737]  (
&s->s_dquot.dqonoff_mutex[  543.570737] ){+.+...}
[  543.570737] :
[  543.570737]        [  543.570737] [<ffffffff811192b9>] lock_acquire+0xf9/0x1e0
[  543.570737]        [  543.570737] [<ffffffff817a771f>] mutex_lock_nested+0x4f/0x390
[  543.570737]        [  543.578945] [<ffffffff812c11c8>] dquot_writeback_dquots+0x38/0x290
[  543.578945]        [  543.578945] [<ffffffff8130b8bd>] ext4_sync_fs+0x5d/0x270
[  543.578945]        [  543.578945] [<ffffffff8128c1b2>] sync_filesystem+0x42/0xa0
[  543.578945]        [  543.578945] [<ffffffff81255aba>] freeze_super+0xaa/0x190
[  543.578945]        [  543.578945] [<ffffffff812691e3>] do_vfs_ioctl+0x533/0x6a0
[  543.578945]        [  543.578945] [<ffffffff812693c9>] SyS_ioctl+0x79/0x90
[  543.578945]        [  543.578945] [<ffffffff81002e50>] do_syscall_64+0x70/0x3d0
[  543.578945]        [  543.578945] [<ffffffff817acdc9>] return_from_SYSCALL_64+0x0/0x7a
[  543.578945] 
-> #1[  543.578945]  (
sb_pagefaults[  543.582788] ){++++..}
[  543.582788] :
[  543.582788]        [  543.582788] [<ffffffff811192b9>] lock_acquire+0xf9/0x1e0
[  543.582788]        [  543.582788] [<ffffffff81256199>] __sb_start_write+0x119/0x1d0
[  543.582788]        [  543.582788] [<ffffffff812f8bb1>] ext4_page_mkwrite+0x51/0x450
[  543.582788]        [  543.582788] [<ffffffff81209f65>] do_page_mkwrite+0x65/0xc0
[  543.582788]        [  543.582788] [<ffffffff8120f15e>] handle_mm_fault+0x5ce/0xf50
[  543.582788]        [  543.582788] [<ffffffff810a9e82>] __do_page_fault+0x222/0x4f0
[  543.582788]        [  543.582788] [<ffffffff810aa22d>] trace_do_page_fault+0x5d/0x290
[  543.582788]        [  543.582788] [<ffffffff810a505a>] do_async_page_fault+0x1a/0xa0
[  543.582788]        [  543.582788] [<ffffffff817ade88>] async_page_fault+0x28/0x30
[  543.582788] 
-> #0[  543.582788]  (
&mm->mmap_sem[  543.582788] ){++++++}
[  543.582788] :
[  543.582788]        [  543.582788] [<ffffffff81118ba6>] __lock_acquire+0x1406/0x1680
[  543.582788]        [  543.582788] [<ffffffff811192b9>] lock_acquire+0xf9/0x1e0
[  543.582788]        [  543.582788] [<ffffffff817a99c9>] down_read+0x39/0x60
[  543.582788]        [  543.582788] [<ffffffff8120938f>] get_user_pages_unlocked+0x5f/0x1e0
[  543.582788]        [  543.582788] [<ffffffff810b0969>] get_user_pages_fast+0x79/0x160
[  543.582788]        [  543.582788] [<ffffffff813ea665>] iov_iter_get_pages+0xb5/0x2b0
[  543.582788]        [  543.582788] [<ffffffff81298f4e>] do_blockdev_direct_IO+0x1e1e/0x26f0
[  543.582788]        [  543.582788] [<ffffffff8129985a>] __blockdev_direct_IO+0x3a/0x40
[  543.582788]        [  543.582788] [<ffffffff812f6c33>] ext4_direct_IO+0x193/0x740
[  543.582788]        [  543.582788] [<ffffffff811d985b>] generic_file_read_iter+0x3cb/0x730
[  543.582788]        [  543.582788] [<ffffffff8125264d>] __vfs_read+0xbd/0x110
[  543.582788]        [  543.582788] [<ffffffff81252d43>] vfs_read+0x93/0x130
[  543.582788]        [  543.582788] [<ffffffff81254169>] SyS_read+0x49/0xa0
[  543.582788]        [  543.582788] [<ffffffff81002e50>] do_syscall_64+0x70/0x3d0
[  543.582788]        [  543.582788] [<ffffffff817acdc9>] return_from_SYSCALL_64+0x0/0x7a
[  543.582788] 
[  543.582788] other info that might help us debug this:
[  543.582788] 
[  543.582788] Chain exists of:
  [  543.582788] &mm->mmap_sem
 --> [  543.582788] &s->s_dquot.dqonoff_mutex
 --> [  543.582788] &sb->s_type->i_mutex_key
#11[  543.582788] 
[  543.582788] 
[  543.582788]  Possible unsafe locking scenario:
[  543.582788] 
[  543.582788]        CPU0                    CPU1
[  543.582788]        ----                    ----
[  543.582788]   lock([  543.582788] &sb->s_type->i_mutex_key
#11[  543.582788] );
[  543.582788]                                lock([  543.582788] &s->s_dquot.dqonoff_mutex
[  543.582788] );
[  543.582788]                                lock([  543.582788] &sb->s_type->i_mutex_key
#11[  543.582788] );
[  543.582788]   lock([  543.582788] &mm->mmap_sem
[  543.582788] );
[  543.582788] 
[  543.582788]  *** DEADLOCK ***
[  543.582788] 
[  543.582788] 1 lock held by fio/3576:
[  543.582788]  #0: [  543.582788]  (
&sb->s_type->i_mutex_key[  543.582788] #11
){++++++}[  543.582788] , at: 
[  543.582788] [<ffffffff812f6be0>] ext4_direct_IO+0x140/0x740
[  543.582788] 
[  543.582788] stack backtrace:
[  543.582788] CPU: 1 PID: 3576 Comm: fio Not tainted 4.9.0-rc1 #1
[  543.582788] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[  543.582788]  ffffc900037db800 ffffffff813d7a13 ffffffff825d38c0 ffffffff825e8da0
[  543.582788]  ffffc900037db840 ffffffff81115fcf ffffc900037db8b0 ffff88007a2ea480
[  543.582788]  ffff88007a2ead00 ffff88007a2eacd8 0000000000000001 0000000000000001
[  543.582788] Call Trace:
[  543.582788]  [<ffffffff813d7a13>] dump_stack+0x85/0xc2
[  543.582788]  [<ffffffff81115fcf>] print_circular_bug+0x1cf/0x230
[  543.582788]  [<ffffffff81118ba6>] __lock_acquire+0x1406/0x1680
[  543.582788]  [<ffffffff811192b9>] lock_acquire+0xf9/0x1e0
[  543.582788]  [<ffffffff8120938f>] ? get_user_pages_unlocked+0x5f/0x1e0
[  543.582788]  [<ffffffff817a99c9>] down_read+0x39/0x60
[  543.582788]  [<ffffffff8120938f>] ? get_user_pages_unlocked+0x5f/0x1e0
[  543.582788]  [<ffffffff8120938f>] get_user_pages_unlocked+0x5f/0x1e0
[  543.582788]  [<ffffffff8111723d>] ? mark_held_locks+0x6d/0x90
[  543.582788]  [<ffffffff810b0969>] get_user_pages_fast+0x79/0x160
[  543.582788]  [<ffffffff813ea665>] iov_iter_get_pages+0xb5/0x2b0
[  543.582788]  [<ffffffff81298f4e>] do_blockdev_direct_IO+0x1e1e/0x26f0
[  543.582788]  [<ffffffff8118d38d>] ? delayacct_end+0x5d/0x70
[  543.582788]  [<ffffffff817a55bd>] ? io_schedule_timeout+0xfd/0x140
[  543.582788]  [<ffffffff812f1780>] ? ext4_dio_get_block_unwritten_sync+0x90/0x90
[  543.582788]  [<ffffffff812f1780>] ? ext4_dio_get_block_unwritten_sync+0x90/0x90
[  543.582788]  [<ffffffff8129985a>] __blockdev_direct_IO+0x3a/0x40
[  543.582788]  [<ffffffff812f6c33>] ext4_direct_IO+0x193/0x740
[  543.582788]  [<ffffffff81274944>] ? __atime_needs_update+0x74/0x180
[  543.582788]  [<ffffffff811d985b>] generic_file_read_iter+0x3cb/0x730
[  543.582788]  [<ffffffff8125264d>] __vfs_read+0xbd/0x110
[  543.582788]  [<ffffffff81252d43>] vfs_read+0x93/0x130
[  543.582788]  [<ffffffff81254169>] SyS_read+0x49/0xa0
[  543.582788]  [<ffffffff81002e50>] do_syscall_64+0x70/0x3d0
[  543.582788]  [<ffffffff817acdc9>] entry_SYSCALL64_slow_path+0x25/0x25
 [16:41:13] [failed, exit status 1] - output mismatch (see /results/ext4/results-4k/generic/095.out.bad)
    --- tests/generic/095.out	2016-09-05 18:22:48.000000000 +0000
    +++ /results/ext4/results-4k/generic/095.out.bad	2016-10-17 16:41:13.311594618 +0000
    @@ -1,2 +1,3 @@
     QA output created by 095
     Silence is golden
    +_check_dmesg: something found in dmesg (see /results/ext4/results-4k/generic/095.dmesg)
    ...
    (Run 'diff -u tests/generic/095.out /results/ext4/results-4k/generic/095.out.bad'  to see the entire diff)
