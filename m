From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/5] ext4: Correctly handle EOFBLOCKS flag in
 ext4_ext_punch_hole
Date: Thu, 22 Mar 2012 09:47:45 -0400
Message-ID: <20120322134745.GB25897@thunk.org>
References: <1332314639-22875-1-git-send-email-lczerner@redhat.com>
 <1332314639-22875-2-git-send-email-lczerner@redhat.com>
 <20120322021305.GE11157@thunk.org>
 <alpine.LFD.2.00.1203220826020.4904@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, achender@linux.vnet.ibm.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49509 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851Ab2CVNru (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Mar 2012 09:47:50 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1203220826020.4904@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 22, 2012 at 09:25:15AM +0100, Lukas Czerner wrote:
> 
> The worse what can happen is that after a write spanning several block
> we'll have first part of the write punched out, but second part written
> correctly since in this case it might hit already punched block
> and need to wait for punch_hole to finish, after that the rest of the
> range is written. However the write should remain consistent on block
> granularity which is all we guarantee anyway, right ?

I need to look more closely at this, but thing that was worrying me
was the part of truncate/punch where we have to invalidate the parts
of the page cache where we've unmapped the blocks.  i.e., the call to
truncate_inode_pages_range() racing with the write.  I think we're ok,
since truncate_inode_pages_range() grabs the page spinlock and then
checks for PageWriteback, which ought to be sufficient, but truncate
does take that codepath with i_mutex down, and so my spidey sense is
tingling.  I may just being too paranoid, though.

Still, that's not a criticism of your patch.

More serious is the following lockdep warning that I got.  Grabbing
i_mutex after the transaction handle is started can lead to a circular
locking deadlock...

						- Ted

BEGIN TEST: Ext4 4k block Wed Mar 21 22:47:17 EDT 2012
Device: /dev/vdb
mke2fs options: -q
mount options: -o block_validity
000 - unknown test, ignored
FSTYP         -- ext4
PLATFORM      -- Linux/i686 candygram 3.3.0-rc2-00592-gc56a0b2
MKFS_OPTIONS  -- -q /dev/vdc
MOUNT_OPTIONS -- -o acl,user_xattr -o block_validity /dev/vdc /vdc
075	[  808.872903] 
[  808.873567] ======================================================
[  808.875933] [ INFO: possible circular locking dependency detected ]
[  808.875933] 3.3.0-rc2-00592-gc56a0b2 #32 Not tainted
[  808.875933] -------------------------------------------------------
[  808.875933] fsx/13769 is trying to acquire lock:
[  808.875933]  (&sb->s_type->i_mutex_key#3){+.+.+.}, at: [<c028d900>] ext4_ext_punch_hole+0x2b8/0x382
[  808.875933] 
[  808.875933] but task is already holding lock:
[  808.875933]  (jbd2_handle){+.+...}, at: [<c02a5995>] start_this_handle+0x4e4/0x51a
[  808.875933] 
[  808.875933] which lock already depends on the new lock.
[  808.875933] 
[  808.875933] 
[  808.875933] the existing dependency chain (in reverse order) is:
[  808.875933] 
[  808.875933] -> #1 (jbd2_handle){+.+...}:
[  808.875933]        [<c019789d>] lock_acquire+0x99/0xbd
[  808.875933]        [<c02a59b7>] start_this_handle+0x506/0x51a
[  808.875933]        [<c02a5ba6>] jbd2__journal_start+0xae/0xda
[  808.875933]        [<c02a5be4>] jbd2_journal_start+0x12/0x14
[  808.875933]        [<c0284fb8>] ext4_journal_start_sb+0x11e/0x126
[  808.875933]        [<c0277661>] ext4_unlink+0x82/0x1e5
[  808.875933]        [<c02127e1>] vfs_unlink+0x61/0xaf
[  808.875933]        [<c02147b5>] do_unlinkat+0xa0/0x112
[  808.875933]        [<c0214946>] sys_unlinkat+0x30/0x37
[  808.875933]        [<c06d8c5d>] syscall_call+0x7/0xb
[  808.875933] 
[  808.875933] -> #0 (&sb->s_type->i_mutex_key#3){+.+.+.}:
[  808.875933]        [<c0197598>] __lock_acquire+0x989/0xbf5
[  808.875933]        [<c019789d>] lock_acquire+0x99/0xbd
[  808.875933]        [<c06d65f4>] __mutex_lock_common+0x30/0x316
[  808.875933]        [<c06d6988>] mutex_lock_nested+0x26/0x2f
[  808.875933]        [<c028d900>] ext4_ext_punch_hole+0x2b8/0x382
[  808.875933]        [<c026e316>] ext4_punch_hole+0x5f/0x70
[  808.875933]        [<c028fbce>] ext4_fallocate+0x63/0x469
[  808.875933]        [<c0208974>] do_fallocate+0xe7/0x105
[  808.875933]        [<c02089c3>] sys_fallocate+0x31/0x46
[  808.875933]        [<c06d8c5d>] syscall_call+0x7/0xb
[  808.875933] 
[  808.875933] other info that might help us debug this:
[  808.875933] 
[  808.875933]  Possible unsafe locking scenario:
[  808.875933] 
[  808.875933]        CPU0                    CPU1
[  808.875933]        ----                    ----
[  808.875933]   lock(jbd2_handle);
[  808.875933]                                lock(&sb->s_type->i_mutex_key#3);
[  808.875933]                                lock(jbd2_handle);
[  808.875933]   lock(&sb->s_type->i_mutex_key#3);
[  808.875933] 
[  808.875933]  *** DEADLOCK ***
[  808.875933] 
[  808.875933] 1 lock held by fsx/13769:
[  808.875933]  #0:  (jbd2_handle){+.+...}, at: [<c02a5995>] start_this_handle+0x4e4/0x51a
[  808.875933] 
[  808.875933] stack backtrace:
[  808.875933] Pid: 13769, comm: fsx Not tainted 3.3.0-rc2-00592-gc56a0b2 #32
[  808.875933] Call Trace:
[  808.875933]  [<c01954fb>] print_circular_bug+0x194/0x1a1
[  808.875933]  [<c0197598>] __lock_acquire+0x989/0xbf5
[  808.875933]  [<c019789d>] lock_acquire+0x99/0xbd
[  808.875933]  [<c028d900>] ? ext4_ext_punch_hole+0x2b8/0x382
[  808.875933]  [<c06d65f4>] __mutex_lock_common+0x30/0x316
[  808.875933]  [<c028d900>] ? ext4_ext_punch_hole+0x2b8/0x382
[  808.875933]  [<c017d53a>] ? local_clock+0x3d/0x55
[  808.875933]  [<c01942de>] ? lock_release_holdtime+0x2b/0xcd
[  808.875933]  [<c028d8d9>] ? ext4_ext_punch_hole+0x291/0x382
[  808.875933]  [<c06d6988>] mutex_lock_nested+0x26/0x2f
[  808.875933]  [<c028d900>] ? ext4_ext_punch_hole+0x2b8/0x382
[  808.875933]  [<c028d900>] ext4_ext_punch_hole+0x2b8/0x382
[  808.875933]  [<c026e316>] ext4_punch_hole+0x5f/0x70
[  808.875933]  [<c028fbce>] ext4_fallocate+0x63/0x469
[  808.875933]  [<c017d4ed>] ? sched_clock_cpu+0x134/0x144
[  808.875933]  [<c023473e>] ? fsnotify+0x1e8/0x202
[  808.875933]  [<c01940d5>] ? trace_hardirqs_off+0xb/0xd
[  808.875933]  [<c017d53a>] ? local_clock+0x3d/0x55
[  808.875933]  [<c020a873>] ? fget+0x57/0x71
[  808.875933]  [<c0208974>] do_fallocate+0xe7/0x105
[  808.875933]  [<c02089c3>] sys_fallocate+0x31/0x46
[  808.875933]  [<c06d8c5d>] syscall_call+0x7/0xb
[  808.875933]  [<c06d0000>] ? init_intel+0x1aa/0x370
