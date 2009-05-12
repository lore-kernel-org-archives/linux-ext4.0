From: Jan Kara <jack@suse.cz>
Subject: Re: [Bugme-new] [Bug 13232] New: ext3/4 with synchronous writes gets wedged by Postfix
Date: Tue, 12 May 2009 18:56:01 +0200
Message-ID: <20090512165601.GC27092@atrey.karlin.mff.cuni.cz>
References: <bug-13232-10286@http.bugzilla.kernel.org/> <20090505145525.92e9551a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, kernel-nospam@dbwatson.ukfsn.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37709 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757302AbZELQ4B (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 May 2009 12:56:01 -0400
Content-Disposition: inline
In-Reply-To: <20090505145525.92e9551a.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).

> > SysRq : Show Blocked State
> >   task                PC stack   pid father
> > kjournald     D c01384df     0  2525      2
> >  cfcb5f0c 00000082 de27d500 c01384df cfcb5ef4 c02cb5c0 00000001 de32ca00
> >  de324814 dd037ebc de324814 de324934 dd037ebc cfcb5f5c cfcb5f90 c01bd4bb
> >  00000046 c0424110 de324a0c de324814 de324800 00000000 00000002 dd037e80
> > Call Trace:
> >  [<c01384df>] ? trace_hardirqs_on+0xb/0xd
> >  [<c01bd4bb>] journal_commit_transaction+0xea/0xeaf
> >  [<c02c534a>] ? _spin_unlock_irqrestore+0x38/0x3f
> >  [<c0138489>] ? trace_hardirqs_on_caller+0x145/0x190
> >  [<c012b6ee>] ? autoremove_wake_function+0x0/0x38
> >  [<c0122a25>] ? del_timer+0x50/0x59
> >  [<c01c0c75>] kjournald+0xad/0x1bb
> >  [<c012b6ee>] ? autoremove_wake_function+0x0/0x38
> >  [<c01c0bc8>] ? kjournald+0x0/0x1bb
> >  [<c012b442>] kthread+0x37/0x59
> >  [<c012b40b>] ? kthread+0x0/0x59
> >  [<c0103667>] kernel_thread_helper+0x7/0x10
> 
> I assume this is
> 
> 	while (commit_transaction->t_updates) {
> 		DEFINE_WAIT(wait);
> 
> 		prepare_to_wait(&journal->j_wait_updates, &wait,
> 					TASK_UNINTERRUPTIBLE);
> 		if (commit_transaction->t_updates) {
> 			spin_unlock(&commit_transaction->t_handle_lock);
> 			spin_unlock(&journal->j_state_lock);
> 			schedule();
  Yes.

> I'm wondering about
> 
> : commit e219cca082f52e7dfea41f3be264b7b5eb204227
> : Author:     Theodore Ts'o <tytso@mit.edu>
> : AuthorDate: Thu Nov 6 22:37:59 2008 -0500
> : Commit:     Theodore Ts'o <tytso@mit.edu>
> : CommitDate: Thu Nov 6 22:37:59 2008 -0500
> :
> :    jbd: don't give up looking for space so easily in __log_wait_for_space
> 
> but that patch was present in 2.6.28.
  Hmm, I don't see what made this deadlock happening - as far as I can
see it's there for quite some time. See below...

> > pickup        D c01384df     0  2597   2594
> >  cfaa9e5c 00000086 df9faa80 c01384df cfaa9e44 00000282 cfaa9e74 de32ca00
> >  cfaa9e5c c012b8b7 00000002 de324800 0000014f cfaa9e74 cfaa9e94 c01c0539
> >  00000000 de3248c8 de324910 de324814 00000000 df9faa80 c012b6ee de3248e4
> > Call Trace:
> >  [<c01384df>] ? trace_hardirqs_on+0xb/0xd
> >  [<c012b8b7>] ? prepare_to_wait+0x42/0x4a
> >  [<c01c0539>] log_wait_commit+0x90/0xf7
> >  [<c012b6ee>] ? autoremove_wake_function+0x0/0x38
> >  [<c01bba9d>] journal_stop+0x1c8/0x288
> >  [<c01b4236>] __ext3_journal_stop+0x1c/0x38
> >  [<c01aeb96>] ext3_delete_inode+0x90/0xc2
> >  [<c01aeb06>] ? ext3_delete_inode+0x0/0xc2
> >  [<c017ab82>] generic_delete_inode+0x72/0x100
> >  [<c02c4ee1>] ? _spin_lock+0x3a/0x40
> >  [<c017ad4c>] generic_drop_inode+0x13c/0x1da
> >  [<c01d4068>] ? _atomic_dec_and_lock+0x10/0x38
> >  [<c017a4e7>] iput+0x47/0x4e
> >  [<c0173db0>] do_unlinkat+0xc1/0x137
> >  [<c0102f87>] ? sysenter_exit+0xf/0x18
> >  [<c0138489>] ? trace_hardirqs_on_caller+0x145/0x190
> >  [<c0173e36>] sys_unlink+0x10/0x12
> >  [<c0102f55>] sysenter_do_call+0x12/0x35
  In generic_delete_inode() we mark inode as I_FREEING. Then
ext3_delete_inode() is called and because of O_SYNC it starts a
transaction commit and waits for it.

> > postdrop      D c01384df     0  2664   2663
> >  cfcbfd6c 00000086 dd13f700 c01384df cfcbfd54 c02cb5c0 00000001 deedc780
> >  c03a1690 c1402348 c03a1690 cfcbfd7c c1402348 cfcbfd90 cfcbfd9c c017a55b
> >  dd758c48 00000007 00000000 dd13f700 c012b726 c1402364 c1402364 00152b13
> > Call Trace:
> >  [<c01384df>] ? trace_hardirqs_on+0xb/0xd
> >  [<c017a55b>] __wait_on_freeing_inode+0x6d/0x88
> >  [<c012b726>] ? wake_bit_function+0x0/0x47
> >  [<c017a5b5>] find_inode_fast+0x3f/0x4a
> >  [<c017ba05>] insert_inode_locked+0x50/0xeb
> >  [<c01ab90b>] ext3_new_inode+0x738/0x88f
> >  [<c01bc550>] ? journal_start+0xab/0x100
> >  [<c01b259a>] ext3_create+0x59/0xbf
> >  [<c01722c4>] vfs_create+0x75/0xb0
> >  [<c02c4dda>] ? _spin_unlock+0x1d/0x20
> >  [<c01b2541>] ? ext3_create+0x0/0xbf
> >  [<c0174bc3>] do_filp_open+0x644/0x713
> >  [<c02c4dda>] ? _spin_unlock+0x1d/0x20
> >  [<c01692ce>] do_sys_open+0x45/0xce
> >  [<c0102f87>] ? sysenter_exit+0xf/0x18
> >  [<c0138489>] ? trace_hardirqs_on_caller+0x145/0x190
> >  [<c01693a3>] sys_open+0x23/0x2b
> >  [<c0102f55>] sysenter_do_call+0x12/0x35
  Here, we have started a transaction in ext3_create() and then wait in
find_inode_fast() for I_FREEING to be cleared (obviously we have
reallocated the inode and squeezed the allocation before journal_stop()
from the delete was called).
  Nasty deadlock and I don't see how to fix it now - have to go home for
today... Tomorrow I'll have a look what we can do about it.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
