From: Jan Kara <jack@suse.cz>
Subject: [PATCH] jbd: Issue cache flush after checkpointing
Date: Mon,  9 Jan 2012 15:04:44 +0100
Message-ID: <1326117884-19928-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51050 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820Ab2AIOEu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jan 2012 09:04:50 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 1A8AC9141C
	for <linux-ext4@vger.kernel.org>; Mon,  9 Jan 2012 15:04:49 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we reach cleanup_journal_tail(), there is no guarantee that
checkpointed buffers are on a stable storage - especially if buffers were
written out by log_do_checkpoint(), they are likely to be only in disk's
caches. Thus when we update journal superblock, effectively removing old
transaction from journal, this write of superblock can get to stable storage
before those checkpointed buffers which can result in filesystem corruption
after a crash.

Thus we must unconditionally issue a cache flush before we update journal
superblock.

I managed to reproduce the corruption using somewhat tweaked Chris Mason's
barrier-test scheduler. Also this should fix occasional reports of 'Bit already
freed' filesystem errors which are totally unreproducible but inspection of
several fs images I've gathered over time points to a problem like this.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd/checkpoint.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

 I've added this patch to my tree and plan to push it to Linus soon.

diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
index f94fc48..3396c0f 100644
--- a/fs/jbd/checkpoint.c
+++ b/fs/jbd/checkpoint.c
@@ -522,6 +522,16 @@ int cleanup_journal_tail(journal_t *journal)
 	journal->j_tail_sequence = first_tid;
 	journal->j_tail = blocknr;
 	spin_unlock(&journal->j_state_lock);
+	/*
+	 * We need to make sure that any blocks that were recently written out
+	 * --- perhaps by log_do_checkpoint() --- are flushed out before we
+	 * drop the transactions from the journal. It's unlikely this will be
+	 * necessary, especially with an appropriately sized journal, but we
+	 * need this to guarantee correctness.  Fortunately
+	 * cleanup_journal_tail() doesn't get called all that often.
+	 */
+	if (journal->j_flags & JFS_BARRIER)
+		blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL, NULL);
 	if (!(journal->j_flags & JFS_ABORT))
 		journal_update_superblock(journal, 1);
 	return 0;
-- 
1.7.1

