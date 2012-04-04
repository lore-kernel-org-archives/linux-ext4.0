From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd: clear b_modified before moving the jh to a
 different transaction
Date: Wed, 4 Apr 2012 09:55:20 +0200
Message-ID: <20120404075520.GA5725@quack.suse.cz>
References: <1326219175-4529-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="YZ5djTAD1cGYuMQK"
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jack@suse.cz
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49718 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753088Ab2DDHzY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Apr 2012 03:55:24 -0400
Content-Disposition: inline
In-Reply-To: <1326219175-4529-1-git-send-email-josef@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 10-01-12 13:12:55, Josef Bacik wrote:
> If we are journalling data (ie journal=data or big symlinks) we can discard
> buffers and move them to different transactions to make sure they get cleaned up
> properly.  The problem is b_modified could still be set from the last
> transaction that touched it, so putting it on the currently running transaction
> or setting it up to be put on the next transaction will run into problems if the
> buffer gets reused in that transaction as the space accounting logic won't be
> done, which will result in panics at commit time because t_nr_buffers will end
> up being more than t_outstanding_credits.  Thanks to Jan Kara for pointing out
> the other part of this problem a few months ago.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
  So I think I've nailed this down. Your feeling that the problem is with
refiling buffer to BJ_Forget list of the running transaction was right. The
missing piece to the puzzle was that journal_invalidatepage() can get
called not only when underlying block is freed but also when someone
flushes page cache. The traces I have suggest that someone has flushed page
cache (likely of the block device), that moved buffer from the checkpoint
list to BJ_Forget list of the running transaction and then the same running
transaction tried to modify the buffer which triggered the accounting
problem you spotted.

I have updated the changelog and pushed the patch to my tree (for JBD
only). I'll duplicate the patch for JBD2 tomorrow.

								Honza


-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--YZ5djTAD1cGYuMQK
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-jbd-clear-b_modified-before-moving-the-jh-to-a-diffe.patch"

>From d433e0479c9cde46b29b30a5c5996c1dbe57005f Mon Sep 17 00:00:00 2001
From: Josef Bacik <josef@redhat.com>
Date: Tue, 10 Jan 2012 13:12:55 -0500
Subject: [PATCH] jbd: clear b_modified before moving the jh to a different transaction

journal_forget() and journal_invalidatepage() functions move buffer to
BJ_Forget list of a running transaction so that the buffer gets cleaned up when
the transaction is committed. This usually happens when underlying block is
freed but journal_invalidatepage() can also move the buffer when page cache of
the corresponding inode (may be a block device) gets flushed.  When the buffer
had b_modfied set from the previous transaction and we happen to modify it
again in the current transaction, we won't properly account for the modified
buffer by subtracting the number of reserved credits of the running transaction
because do_get_write_access() won't clear b_modified (buffer already is on
running transaction so do_get_write_access() things it has nothing to do).
This then results in assertion failure in commit code because the transaction
has more buffers than reserved credits (t_nr_buffers > t_outstanding_credits).

We fix the issue by clearing b_modified before moving buffer to a BJ_Forget list
of another transaction because logically, it's not changed for that transaction
anymore.

CC: stable@kernel.org
Signed-off-by: Josef Bacik <josef@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd/transaction.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index febc10d..fb48e44 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -1788,6 +1788,7 @@ static int __dispose_buffer(struct journal_head *jh, transaction_t *transaction)
 		 */
 		clear_buffer_dirty(bh);
 		__journal_file_buffer(jh, transaction, BJ_Forget);
+		jh->b_modified = 0;
 		may_free = 0;
 	} else {
 		JBUFFER_TRACE(jh, "on running transaction");
@@ -1956,8 +1957,10 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh)
 		 * clear dirty bits when it is done with the buffer.
 		 */
 		set_buffer_freed(bh);
-		if (journal->j_running_transaction && buffer_jbddirty(bh))
+		if (journal->j_running_transaction && buffer_jbddirty(bh)) {
+			jh->b_modified = 0;
 			jh->b_next_transaction = journal->j_running_transaction;
+		}
 		journal_put_journal_head(jh);
 		spin_unlock(&journal->j_list_lock);
 		jbd_unlock_bh_state(bh);
-- 
1.7.1


--YZ5djTAD1cGYuMQK--
