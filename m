From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] Jbd2: delay discarding buffers in journal_unmap_buffer
Date: Tue, 16 Feb 2010 20:39:57 +0100
Message-ID: <20100216193957.GG3153@quack.suse.cz>
References: <1265432063-5806-1-git-send-email-dingdinghua@nrchpc.ac.cn>
 <20100208160332.GF4321@quack.suse.cz>
 <20100216014521.GR5337@thunk.org>
 <20100216193304.GF3153@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, dingdinghua <dingdinghua@nrchpc.ac.cn>,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43557 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933228Ab0BPTju (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 16 Feb 2010 14:39:50 -0500
Content-Disposition: inline
In-Reply-To: <20100216193304.GF3153@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 16-02-10 20:33:05, Jan Kara wrote:
> On Mon 15-02-10 20:45:21, tytso@mit.edu wrote:
> > On Mon, Feb 08, 2010 at 05:03:33PM +0100, Jan Kara wrote:
> > > On Sat 06-02-10 12:54:23, dingdinghua wrote:
> > > > Delay discarding buffers in journal_unmap_buffer until
> > > > we know that "add to orphan" operation has definitely been
> > > > committed, otherwise the log space of committing transation
> > > > may be freed and reused before truncate get committed, updates
> > > > may get lost if crash happens.
> > > > 
> > > > Signed-off-by: dingdinghua <dingdinghua@nrchpc.ac.cn>
> > >   Thanks for the patch. Just two remarks to the comments below...
> > 
> > Here's the version I've applied to the ext4 patch queue, which
> > includes Jan's suggested changes to the comments.
>   Thanks for summing it up. The patch looks good.
> Acked-by: Jan Kara <jack@suse.cz>
> 
>   I'm going to backport the patch to JBD now.
  OK, the backport is below. I've added it to my tree.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

>From 63b4e55561560adf8a9c735f9feffbbf7d3978e2 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 16 Feb 2010 20:37:12 +0100
Subject: [PATCH] jbd: Delay discarding buffers in journal_unmap_buffer

Delay discarding buffers in journal_unmap_buffer until
we know that "add to orphan" operation has definitely been
committed, otherwise the log space of committing transation
may be freed and reused before truncate get committed, updates
may get lost if crash happens.

This patch is a backport of JBD2 fix by dingdinghua <dingdinghua@nrchpc.ac.cn>.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd/commit.c      |   10 +++++-----
 fs/jbd/transaction.c |   43 +++++++++++++++++++++++++++++++------------
 2 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 4bd8825..2c90e3e 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -862,12 +862,12 @@ restart_loop:
 		/* A buffer which has been freed while still being
 		 * journaled by a previous transaction may end up still
 		 * being dirty here, but we want to avoid writing back
-		 * that buffer in the future now that the last use has
-		 * been committed.  That's not only a performance gain,
-		 * it also stops aliasing problems if the buffer is left
-		 * behind for writeback and gets reallocated for another
+		 * that buffer in the future after the "add to orphan"
+		 * operation been committed,  That's not only a performance
+		 * gain, it also stops aliasing problems if the buffer is
+		 * left behind for writeback and gets reallocated for another
 		 * use in a different page. */
-		if (buffer_freed(bh)) {
+		if (buffer_freed(bh) && !jh->b_next_transaction) {
 			clear_buffer_freed(bh);
 			clear_buffer_jbddirty(bh);
 		}
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 006f9ad..99e9fea 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -1864,6 +1864,21 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh)
 	if (!jh)
 		goto zap_buffer_no_jh;
 
+	/*
+	 * We cannot remove the buffer from checkpoint lists until the
+	 * transaction adding inode to orphan list (let's call it T)
+	 * is committed.  Otherwise if the transaction changing the
+	 * buffer would be cleaned from the journal before T is
+	 * committed, a crash will cause that the correct contents of
+	 * the buffer will be lost.  On the other hand we have to
+	 * clear the buffer dirty bit at latest at the moment when the
+	 * transaction marking the buffer as freed in the filesystem
+	 * structures is committed because from that moment on the
+	 * buffer can be reallocated and used by a different page.
+	 * Since the block hasn't been freed yet but the inode has
+	 * already been added to orphan list, it is safe for us to add
+	 * the buffer to BJ_Forget list of the newest transaction.
+	 */
 	transaction = jh->b_transaction;
 	if (transaction == NULL) {
 		/* First case: not on any transaction.  If it
@@ -1929,16 +1944,15 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh)
 			goto zap_buffer;
 		}
 		/*
-		 * If it is committing, we simply cannot touch it.  We
-		 * can remove it's next_transaction pointer from the
-		 * running transaction if that is set, but nothing
-		 * else. */
+		 * The buffer is committing, we simply cannot touch
+		 * it. So we just set j_next_transaction to the
+		 * running transaction (if there is one) and mark
+		 * buffer as freed so that commit code knows it should
+		 * clear dirty bits when it is done with the buffer.
+		 */
 		set_buffer_freed(bh);
-		if (jh->b_next_transaction) {
-			J_ASSERT(jh->b_next_transaction ==
-					journal->j_running_transaction);
-			jh->b_next_transaction = NULL;
-		}
+		if (journal->j_running_transaction && buffer_jbddirty(bh))
+			jh->b_next_transaction = journal->j_running_transaction;
 		journal_put_journal_head(jh);
 		spin_unlock(&journal->j_list_lock);
 		jbd_unlock_bh_state(bh);
@@ -2120,7 +2134,7 @@ void journal_file_buffer(struct journal_head *jh,
  */
 void __journal_refile_buffer(struct journal_head *jh)
 {
-	int was_dirty;
+	int was_dirty, jlist;
 	struct buffer_head *bh = jh2bh(jh);
 
 	J_ASSERT_JH(jh, jbd_is_locked_bh_state(bh));
@@ -2142,8 +2156,13 @@ void __journal_refile_buffer(struct journal_head *jh)
 	__journal_temp_unlink_buffer(jh);
 	jh->b_transaction = jh->b_next_transaction;
 	jh->b_next_transaction = NULL;
-	__journal_file_buffer(jh, jh->b_transaction,
-				jh->b_modified ? BJ_Metadata : BJ_Reserved);
+	if (buffer_freed(bh))
+		jlist = BJ_Forget;
+	else if (jh->b_modified)
+		jlist = BJ_Metadata;
+	else
+		jlist = BJ_Reserved;
+	__journal_file_buffer(jh, jh->b_transaction, jlist);
 	J_ASSERT_JH(jh, jh->b_transaction->t_state == T_RUNNING);
 
 	if (was_dirty)
-- 
1.6.4.2

