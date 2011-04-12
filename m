From: Jan Kara <jack@suse.cz>
Subject: Re: quota lockdep while running ext4 xfstests #219
Date: Tue, 12 Apr 2011 22:42:05 +0200
Message-ID: <20110412204205.GH5246@quack.suse.cz>
References: <E1Q96g3-0004W8-Vj@tytso-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:33376 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757136Ab1DLUmI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Apr 2011 16:42:08 -0400
Content-Disposition: inline
In-Reply-To: <E1Q96g3-0004W8-Vj@tytso-glaptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Ted,

On Sun 10-04-11 22:16:31, Ted Ts'o wrote:
> FYI, I manage to trigger the following lockdep warning while running
> v2.6.39-rc1 plus the ext4 patch queue.  None of the patches except for
> your "ext4: remove unnecessary [cm]time update of quota file" patch
> should affect the quota operations, and I don't think this patch should
> have caused this, either.
  Thanks for the trace. Yeah, the described patch shouldn't cause it.

> I'm going to ignore this now, since it was triggered by repquota, and
> I'm guessing it should occur rarely, but I thought I should let you know
> in case I'm misjudging things.
> 
> [ 3315.676493] =======================================================
> [ 3315.679704] [ INFO: possible circular locking dependency detected ]
> [ 3315.679704] 2.6.39-rc1-00009-g19e2b53 #1508
> [ 3315.679704] -------------------------------------------------------
> [ 3315.679704] repquota/10186 is trying to acquire lock:
> [ 3315.679704]  (&mm->mmap_sem){++++++}, at: [<c01e3cce>] might_fault+0x4c/0x8a
> [ 3315.679704] 
> [ 3315.679704] but task is already holding lock:
> [ 3315.679704]  (&type->s_umount_key#21){+++++.}, at: [<c01fd7b2>] get_super+0x55/0x98
> [ 3315.679704] 
> [ 3315.679704] which lock already depends on the new lock.
  Interesting. So I see two problems here. One problem seems to be an
ordering of mmap_sem and i_alloc_sem. Generally, truncate code establishes
i_alloc_sem (notify_change) -> mmap_sem (unmap_mapping_range). OTOH ext4
gets i_alloc_sem in ext4_page_mkwrite() which is called with mmap_sem held.
So I wonder why we don't see a warning even earlier.

Another problem is caused by adding s_umount to the mix. Quota code
gets reference to the superblock and then copies further data from
userspace so we get s_umount -> mmap_sem ordering. The other ordering of
the lock happens when ext4_page_mkwrite() holds mmap_sem and ext4_da_write_begin()
tries to call writeback code to free up some reservations and
writeback_inodes_sb_if_idle() gets s_umount.

In the first case, I guess we have no other possibility than to avoid using
i_alloc_sem. Page lock ought to be enough but we have to make sure some
unexpected races with truncate code do not happen.

In the second case it's questionable what is the right lock ordering. Both
code paths look fixable but neither is trivial so I'm undecided which way
to go.

									Honza

> [ 3315.679704] -> #2 (&type->s_umount_key#21){+++++.}:
> [ 3315.679704]        [<c0189957>] lock_acquire+0x99/0xbd
> [ 3315.679704]        [<c0688727>] down_read+0x39/0x76
> [ 3315.679704]        [<c0216db5>] writeback_inodes_sb_if_idle+0x26/0x3d
> [ 3315.679704]        [<c026392b>] ext4_da_write_begin+0xfe/0x27d
> [ 3315.679704]        [<c025e04c>] ext4_page_mkwrite+0x14b/0x198
> [ 3315.679704]        [<c01e6220>] __do_fault+0xfd/0x346
> [ 3315.679704]        [<c01e70a5>] handle_pte_fault+0x318/0x73c
> [ 3315.679704]        [<c01e7589>] handle_mm_fault+0xc0/0xd2
> [ 3315.679704]        [<c068c3c8>] do_page_fault+0x362/0x37e
> [ 3315.679704]        [<c0689fab>] error_code+0x5f/0x64
> [ 3315.679704] 
> [ 3315.679704] -> #1 (&sb->s_type->i_alloc_sem_key#3){++++..}:
> [ 3315.679704]        [<c0189957>] lock_acquire+0x99/0xbd
> [ 3315.679704]        [<c0688727>] down_read+0x39/0x76
> [ 3315.679704]        [<c025df32>] ext4_page_mkwrite+0x31/0x198
> [ 3315.679704]        [<c01e6220>] __do_fault+0xfd/0x346
> [ 3315.679704]        [<c01e70a5>] handle_pte_fault+0x318/0x73c
> [ 3315.679704]        [<c01e7589>] handle_mm_fault+0xc0/0xd2
> [ 3315.679704]        [<c068c3c8>] do_page_fault+0x362/0x37e
> [ 3315.679704]        [<c0689fab>] error_code+0x5f/0x64
> [ 3315.679704] 
> [ 3315.679704] -> #0 (&mm->mmap_sem){++++++}:
> [ 3315.679704]        [<c018964d>] __lock_acquire+0x926/0xb97
> [ 3315.679704]        [<c0189957>] lock_acquire+0x99/0xbd
> [ 3315.679704]        [<c01e3ced>] might_fault+0x6b/0x8a
> [ 3315.679704]        [<c036e6f0>] copy_to_user+0x34/0x10c
> [ 3315.679704]        [<c02365d1>] do_quotactl+0x247/0x39c
> [ 3315.679704]        [<c0236830>] sys_quotactl+0x10a/0x136
> [ 3315.679704]        [<c06898dd>] syscall_call+0x7/0xb
> [ 3315.679704] 
> [ 3315.679704] other info that might help us debug this:
> [ 3315.679704] 
> [ 3315.679704] 1 lock held by repquota/10186:
> [ 3315.679704]  #0:  (&type->s_umount_key#21){+++++.}, at: [<c01fd7b2>] get_super+0x55/0x98
> [ 3315.679704] 
> [ 3315.679704] stack backtrace:
> [ 3315.679704] Pid: 10186, comm: repquota Not tainted 2.6.39-rc1-00009-g19e2b53 #1508
> [ 3315.679704] Call Trace:
> [ 3315.679704]  [<c0188099>] print_circular_bug+0x90/0x9c
> [ 3315.679704]  [<c018964d>] __lock_acquire+0x926/0xb97
> [ 3315.679704]  [<c01876d3>] ? mark_lock+0x1e/0x1df
> [ 3315.679704]  [<c0189957>] lock_acquire+0x99/0xbd
> [ 3315.679704]  [<c01e3cce>] ? might_fault+0x4c/0x8a
> [ 3315.679704]  [<c01e3ced>] might_fault+0x6b/0x8a
> [ 3315.679704]  [<c01e3cce>] ? might_fault+0x4c/0x8a
> [ 3315.679704]  [<c036e6f0>] copy_to_user+0x34/0x10c
> [ 3315.679704]  [<c02365d1>] do_quotactl+0x247/0x39c
> [ 3315.679704]  [<c01fd7b2>] ? get_super+0x55/0x98
> [ 3315.679704]  [<c01fd7b2>] ? get_super+0x55/0x98
> [ 3315.679704]  [<c0236830>] sys_quotactl+0x10a/0x136
> [ 3315.679704]  [<c06898dd>] syscall_call+0x7/0xb
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
