From: Jan Kara <jack@suse.cz>
Subject: [RFC][PATCH] Journal superblock update should send a barrier
Date: Fri, 23 Apr 2010 02:25:55 +0200
Message-ID: <20100423002554.GB25327@quack.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="LQksG6bCIzRHxTLp"
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315Ab0DWAZy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Apr 2010 20:25:54 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hi,

  while reading through the checkpointing code I've realized that we
actually have to send a barrier before each update of journal superblock
after checkpointing. Attached patch does this. Just I'm not sure whether
the performance cost won't be too big. In principle, we could make this
more lightweight by using the fact that transaction commit also sends the
barrier. So we could check before sending a barrier for transaction commit
whether we are slowly running out of journal space and if so whether some
transaction isn't already checkpointed. If yes, we can happily submit
update of journal superblock after the barrier. In case journal is decently
large this should solve the checkpointing problem without introducing
noticeable overhead...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--LQksG6bCIzRHxTLp
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-Send-barrier-before-updating-journal-superblock.patch"

>From e749e83627c35c683114fea32695e581a487e560 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Fri, 23 Apr 2010 02:12:32 +0200
Subject: [PATCH] ext4: Send barrier before updating journal superblock after checkpointing

We have to send a disk barrier after we have finished checkpointing and before
we update the journal superblock and thus effectively remove transactions from
the journal. Otherwise the write of journal superblock can be reordered before
writes of checkpointed journal blocks and thus in case of crash these blocks
needn't be on the platter leading to filesystem corruption.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/checkpoint.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 30beb11..b2de17f 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -519,17 +519,16 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
 	spin_unlock(&journal->j_state_lock);
 
 	/*
-	 * If there is an external journal, we need to make sure that
-	 * any data blocks that were recently written out --- perhaps
-	 * by jbd2_log_do_checkpoint() --- are flushed out before we
-	 * drop the transactions from the external journal.  It's
-	 * unlikely this will be necessary, especially with a
-	 * appropriately sized journal, but we need this to guarantee
-	 * correctness.  Fortunately jbd2_cleanup_journal_tail()
-	 * doesn't get called all that often.
+	 * We need to make sure that any data blocks that were recently written
+	 * out --- perhaps by jbd2_log_do_checkpoint() --- are flushed out
+	 * before we drop the transactions from the journal. Otherwise journal
+	 * superblock write could be reordered before writeout of data and thus
+	 * we could corrupt the filesystem in case of crash. It's unlikely this
+	 * will be necessary, especially with a appropriately sized journal,
+	 * but we need this to guarantee correctness.  Fortunately
+	 * jbd2_cleanup_journal_tail() doesn't get called all that often.
 	 */
-	if ((journal->j_fs_dev != journal->j_dev) &&
-	    (journal->j_flags & JBD2_BARRIER))
+	if (journal->j_flags & JBD2_BARRIER)
 		blkdev_issue_flush(journal->j_fs_dev, NULL);
 	if (!(journal->j_flags & JBD2_ABORT))
 		jbd2_journal_update_superblock(journal, 1);
-- 
1.6.4.2


--LQksG6bCIzRHxTLp--
