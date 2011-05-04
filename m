From: <Martin_Zielinski@McAfee.com>
Subject: RE: [PATCH 2/2] jbd: fix fsync() tid wraparound bug
Date: Wed, 4 May 2011 09:21:04 -0500
Message-ID: <BCB84D936723884B91E4CC5CA0A7C54AA4F95A9F32@EMEADALEXMB1.corp.nai.org>
References: <20110425231454.GB9486@thunk.org>
 <1303777411-1316-2-git-send-email-tytso@mit.edu>
 <20110430171711.GA2819@thunk.org> <20110502150758.GH4556@quack.suse.cz>
 <20110502182945.GG2819@thunk.org> <20110502190441.GK4556@quack.suse.cz>
 <20110502213113.GI2819@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: <linux-ext4@vger.kernel.org>
To: <tytso@mit.edu>, <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dalsmrelay2.nai.com ([205.227.136.216]:43869 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab1EDOWQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 May 2011 10:22:16 -0400
In-Reply-To: <20110502213113.GI2819@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Here's an update.
In my first post I was not aware of the implementation of tid_gt.
I agree that 2 and a half billion commits on an SD card are - hmph - unlikely

The kernels with the patch is not yet installed because we recently provided a kernel with a panic() instead of J_ASSERT and a crashkernel. 
We now have 5 cores all showing the same behavior in j_commit_sequence vs. j_commit_request.

What the cores show (snipped):
(gdb) bt
#0  crash_setup_regs (regs=0x0) at /usr/src/debug/linux-2.6.32/arch/x86/include/asm/kexec.h:127
#1  crash_kexec (regs=0x0) at kernel/kexec.c:1076
#2  0xffffffff81048872 in panic (fmt=0xffffffff818bdb95 "running transaction is NULL")
    at kernel/panic.c:82
#3  0xffffffff81159b79 in journal_commit_transaction (journal=0xffff88031e6c4600)
    at fs/jbd/commit.c:347
#4  0xffffffff8115de49 in kjournald (arg=<value optimized out>) at fs/jbd/journal.c:150
#5  0xffffffff8105fccf in kthread (_create=<value optimized out>) at kernel/kthread.c:78
#6  0xffffffff8100c9da in ?? ()
#7  0x0000000000000000 in ?? ()

gdb) p *journal
$4 = {j_flags = 16, j_errno = 0, j_sb_buffer = 0xffff88031f156dc8, 
  j_superblock = 0xffff88031f876000, j_format_version = 2, j_state_lock = {raw_lock = {
      slock = 2874125135}}, j_barrier_count = 0, j_barrier = {count = {counter = 1}, wait_lock = {
      raw_lock = {slock = 0}}, wait_list = {next = 0xffff88031e6c4638, 
      prev = 0xffff88031e6c4638}, owner = 0x0}, j_running_transaction = 0x0, 
  j_committing_transaction = 0x0, j_checkpoint_transactions = 0xffff88031bd16b40,
...
j_tail_sequence = 2288011385, j_transaction_sequence = 2288014068, 
  j_commit_sequence = 2288014067, j_commit_request = 140530417,
...
  j_wbuf = 0xffff88031de98000, j_wbufsize = 512, j_last_sync_writer = 4568, 
  j_average_commit_time = 69247, j_private = 0xffff88031fd49400}

Means that j_commit_request would be considered to be greater than j_commit_sequence and trigger a commit.

The j_last_sync_writer has a promising backtrace:

crash> bt 4568
PID: 4568   TASK: ffff8802c38ce300  CPU: 8   COMMAND: "core"
 #0 [ffff8802c38d1da8] schedule at ffffffff8159f5e8
 #1 [ffff8802c38d1e50] log_wait_commit at ffffffff8115d4a1
 #2 [ffff8802c38d1ec0] ext3_sync_file at ffffffff8113c589
 #3 [ffff8802c38d1ef0] vfs_fsync_range at ffffffff81105588
 #4 [ffff8802c38d1f30] vfs_fsync at ffffffff81105612
 #5 [ffff8802c38d1f40] do_fsync at ffffffff81105646
 #6 [ffff8802c38d1f70] sys_fdatasync at ffffffff8110566a
 #7 [ffff8802c38d1f80] system_call_fastpath at ffffffff8100ba2b
    RIP: 00007f5be9bd6587  RSP: 0000000047386f38  RFLAGS: 00010202
    RAX: 000000000000004b  RBX: ffffffff8100ba2b  RCX: 0000000000000000
    RDX: 0000000000000000  RSI: 0000000000000000  RDI: 00000000000000f7
    RBP: 00007f5aecf23cc8   R8: 00007f5bc54e56a0   R9: 00000000000011d8
    R10: 0000000001c01800  R11: 0000000000000202  R12: ffffffff8110566a
    R13: ffff8802c38d1f78  R14: 00007f5aecf23b98  R15: 0000000000000000
    ORIG_RAX: 000000000000004b  CS: 0033  SS: 002b

To make a long story short: The inode did not carry the j_commit_request tid.

But:
crash> foreach files
...
247 ffff88031e65bb00 ffff88026c3ea540 ffff88031f0c0758 REG  /opt/data/users/user.db
...
(this is an sqlite database)

And:
(gdb) p ((struct ext3_inode_info*)(0xffff88031f0c0758-0xd0))->i_sync_tid
$5 = {counter = -2006954411}
(gdb) p ((struct ext3_inode_info*)(0xffff88031f0c0758-0xd0))->i_datasync_tid
$3 = {counter = 140530417}

> j_commit_request = 140530417

So it *is* a datasync from sqlite. And your fix will catch it. 
I still don't understand, where this number comes from. 

Unfortunately I cannot provide the core files as they are coming from customers. 
But if there is anything I can do to provide further information, please let me know.

Cheers,
Martin

-----Original Message-----
From: Ted Ts'o [mailto:tytso@mit.edu] 
Sent: Montag, 2. Mai 2011 23:31
To: Jan Kara
Cc: Ext4 Developers List; Zielinski, Martin
Subject: Re: [PATCH 2/2] jbd: fix fsync() tid wraparound bug

On Mon, May 02, 2011 at 09:04:41PM +0200, Jan Kara wrote:
>   Ah, OK. I didn't know it's so many reports. Indeed it looks like there's
> another bug. But then the WARN you have added should tell us more about
> who's causing the problem, right?

That's the hope.  I'm not sure WARNs get logged in Android's reporting
system.  I need to work the Android folks to figure this out.  Worst
case I may have to turn the WARN into a BUG for them (although it may
be tough to convince them to make such a change).  I'm hoping though
that the debugging information from Martin's machines will also come
through with some useful information that will allow us to root cause
whatever is causing this to happen.

							- Ted
