Return-Path: <SRS0=BVhb=PR=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:23882 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732319AbfAIPdq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jan 2019 10:33:46 -0500
From: Kanchan Joshi <joshi.k@samsung.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-nvme@lists.infradead.org, jack@suse.com, david@fromorbit.com,
        tytso@mit.edu, prakash.v@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH 4/4] fs/ext4,jbd2: add support for passing write-hint with
 journal.
Date: Wed, 09 Jan 2019 21:01:01 +0530
Message-id: <1547047861-7271-5-git-send-email-joshi.k@samsung.com>
In-reply-to: <1547047861-7271-1-git-send-email-joshi.k@samsung.com>
References: <1547047861-7271-1-git-send-email-joshi.k@samsung.com>
        <CGME20190109153342epcas2p3208f62a4dd876f8e1765b48f8aec2432@epcas2p3.samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For NAND based SSDs, mixing of data with different life-time reduces
efficiency of internal garbage-collection. During FS operations, series
of journal updates will follow/precede series of data/meta updates, causing
intermixing inside SSD. By passing a write-hint with journal, its write
can be isolated from other data/meta writes, leading to endurance/performance
benefit on SSD.

This patch introduces "j_writehint" member in JBD2 journal, using which
Ext4 specifies write-hint (as SHORT) for journal.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 fs/ext4/super.c      |  2 ++
 fs/jbd2/commit.c     | 11 +++++++----
 fs/jbd2/journal.c    |  3 ++-
 fs/jbd2/revoke.c     |  3 ++-
 include/linux/jbd2.h |  8 ++++++++
 5 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d6c142d..3af4049 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4289,6 +4289,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	set_task_ioprio(sbi->s_journal->j_task, journal_ioprio);
 
+	sbi->s_journal->j_writehint = KERN_WRITE_LIFE_SHORT;
+
 	sbi->s_journal->j_commit_callback = ext4_journal_commit_callback;
 
 no_journal:
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 2eb55c3..6da4c28 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -153,10 +153,12 @@ static int journal_submit_commit_record(journal_t *journal,
 
 	if (journal->j_flags & JBD2_BARRIER &&
 	    !jbd2_has_feature_async_commit(journal))
-		ret = submit_bh(REQ_OP_WRITE,
-			REQ_SYNC | REQ_PREFLUSH | REQ_FUA, bh);
+		ret = submit_bh_write_hint(REQ_OP_WRITE,
+			REQ_SYNC | REQ_PREFLUSH | REQ_FUA, bh,
+			journal->j_writehint);
 	else
-		ret = submit_bh(REQ_OP_WRITE, REQ_SYNC, bh);
+		ret = submit_bh_write_hint(REQ_OP_WRITE, REQ_SYNC, bh,
+			journal->j_writehint);
 
 	*cbh = bh;
 	return ret;
@@ -711,7 +713,8 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 				clear_buffer_dirty(bh);
 				set_buffer_uptodate(bh);
 				bh->b_end_io = journal_end_buffer_io_sync;
-				submit_bh(REQ_OP_WRITE, REQ_SYNC, bh);
+				submit_bh_write_hint(REQ_OP_WRITE, REQ_SYNC,
+						bh, journal->j_writehint);
 			}
 			cond_resched();
 			stats.run.rs_blocks_logged += bufs;
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 8ef6b6d..804dc2c 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1384,7 +1384,8 @@ static int jbd2_write_superblock(journal_t *journal, int write_flags)
 	jbd2_superblock_csum_set(journal, sb);
 	get_bh(bh);
 	bh->b_end_io = end_buffer_write_sync;
-	ret = submit_bh(REQ_OP_WRITE, write_flags, bh);
+	ret = submit_bh_write_hint(REQ_OP_WRITE, write_flags, bh,
+				journal->j_writehint);
 	wait_on_buffer(bh);
 	if (buffer_write_io_error(bh)) {
 		clear_buffer_write_io_error(bh);
diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index a1143e5..376b1d8 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -642,7 +642,8 @@ static void flush_descriptor(journal_t *journal,
 	set_buffer_jwrite(descriptor);
 	BUFFER_TRACE(descriptor, "write");
 	set_buffer_dirty(descriptor);
-	write_dirty_buffer(descriptor, REQ_SYNC);
+	write_dirty_buffer_with_hint(descriptor, REQ_SYNC,
+				journal->j_writehint);
 }
 #endif
 
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 0f919d5..918f21e 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1139,6 +1139,14 @@ struct journal_s
 	 */
 	__u32 j_csum_seed;
 
+	/**
+	 * @j_writehint:
+	 *
+	 * write-hint for journal (set by FS).
+	 */
+	enum rw_hint	j_writehint;
+
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	/**
 	 * @j_trans_commit_map:
-- 
2.7.4
