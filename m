From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: Fix a race between checkpointing code and
	journal_get_write_access()
Date: Fri, 10 Jul 2009 12:07:13 +0200
Message-ID: <20090710100713.GB17524@duck.suse.cz>
References: <1245859360-5261-1-git-send-email-jack@suse.cz> <1245859360-5261-2-git-send-email-jack@suse.cz> <20090706025319.GG6706@mit.edu> <20090708223150.GB14005@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="NzB8fVQJ5HfG6fxh"
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37443 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbZGJKHY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Jul 2009 06:07:24 -0400
Content-Disposition: inline
In-Reply-To: <20090708223150.GB14005@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 08-07-09 18:31:50, Theodore Tso wrote:
> On Sun, Jul 05, 2009 at 10:53:19PM -0400, Theodore Tso wrote:
> > On Wed, Jun 24, 2009 at 06:02:40PM +0200, Jan Kara wrote:
> > > The following race can happen:
> > > 
> > >   CPU1                          CPU2
> > >                                 checkpointing code checks the buffer, adds
> > >                                   it to an array for writeback
> > > do_get_write_access()
> > >   ...
> > >   lock_buffer()
> > >   unlock_buffer()
> > >                                   flush_batch() submits the buffer for IO
> > >   __jbd2_journal_file_buffer()
> > > 
> > >   So a buffer under writeout is returned from do_get_write_access(). Since
> > > the filesystem code relies on the fact that journaled buffers cannot be
> > > written out, it does not take the buffer lock and so it can modify buffer
> > > while it is under writeout. That can lead to a filesystem corruption
> > > if we crash at the right moment.
> > >   We fix the problem by clearing the buffer dirty bit under buffer_lock
> > > even if the buffer is on BJ_None list. Actually, we clear the dirty bit
> > > regardless the list the buffer is in and warn about the fact if
> > > the buffer is already journalled.
> 
> When running fsstress, we get the "Spotted dirty metadata buffer;
> there's a risk of filesystem corruption in csae of a system crash" at
> least half a dozen times or so.  That sounds like we have a problem.
> Were you expecting that this was a "this should never happen"
> situation, or is there a known bug that we need to fix here?
  Yes, it should be "this should never happen", unless you run something
like tune2fs while the filesystem is mounted. But looking at the code, I
have missed that buffer could be dirty also in
jbd2_journal_get_create_access() because jbd2_journal_forget() does not
clear the dirty bit in case the buffer is just being committed. Attached
patch should fix it. Thanks for report.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--NzB8fVQJ5HfG6fxh
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-jbd2-Clear-dirty-bit-in-jbd2_journal_get_create_acc.patch"

>From 0ab2ad057f96f49ba443f317df8e6368dd76def7 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Fri, 10 Jul 2009 11:56:37 +0200
Subject: [PATCH] jbd2: Clear dirty bit in jbd2_journal_get_create_access()

In case we reallocate previously freed buffer, it can happen that the buffer we
reallocate is dirty (jbd2_journal_forget() got called while the previous
transaction was still committing). At the time we reallocate the buffer, the
transaction freeing the buffer must be already committed so we can just remove
the dirty bit. This silences the warning in jbd2_journal_file_buffer() about
metadata buffer being dirty.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/transaction.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 86144aa..0fb7c88 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -826,6 +826,15 @@ int jbd2_journal_get_create_access(handle_t *handle, struct buffer_head *bh)
 	J_ASSERT_JH(jh, buffer_locked(jh2bh(jh)));
 
 	if (jh->b_transaction == NULL) {
+		/*
+		 * Previous jbd2_journal_forget() could have left the buffer
+		 * with jbddirty bit set because it was being committed. When
+		 * the commit finished, we've filed the buffer for
+		 * checkpointing and marked it dirty. Now we are reallocating
+		 * the buffer so the transaction freeing it must have
+		 * committed and so it's safe to clear the dirty bit.
+		 */
+		clear_buffer_dirty(jh2bh(jh));
 		jh->b_transaction = transaction;
 
 		/* first access by this transaction */
-- 
1.6.0.2


--NzB8fVQJ5HfG6fxh--
