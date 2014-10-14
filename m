From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/4] ext4: cleanup data integrity sync fo nonjournal mode
Date: Tue, 14 Oct 2014 14:03:54 +0400
Message-ID: <1413281035-6483-4-git-send-email-dmonakhov@openvz.org>
References: <1413281035-6483-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:13228 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754900AbaJNKEJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 14 Oct 2014 06:04:09 -0400
In-Reply-To: <1413281035-6483-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There are several rules we must follows during data integrity
1) barrier MUST being sent if barrier_opt is enabled (and must not otherwise)
2) If we can guarantee that barrier will be sent for us,
   we can skip explicit barrier.

Change log:
 - Fix needs_barrier var initialization according to rule (1)
 - Avoid barriers if barrier_opt was not enabled for non-journal mode
   according to rule (1)
 - Style cleanup flush optimization according to rule (2)

CC: linux-ext4@vger.kernel.org
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/fsync.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index a8bc47f..2b0fd69 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -92,7 +92,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
 	int ret = 0, err;
 	tid_t commit_tid;
-	bool needs_barrier = false;
+	bool needs_barrier = test_opt(inode->i_sb, BARRIER);
 
 	J_ASSERT(ext4_journal_current_handle() == NULL);
 
@@ -107,10 +107,10 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	}
 
 	if (!journal) {
-		ret = generic_file_fsync(file, start, end, datasync);
+		ret = __generic_file_fsync(file, start, end, datasync);
 		if (!ret && !hlist_empty(&inode->i_dentry))
 			ret = ext4_sync_parent(inode);
-		goto out;
+		goto out_flush;
 	}
 
 	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
@@ -136,10 +136,11 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	}
 
 	commit_tid = datasync ? ei->i_datasync_tid : ei->i_sync_tid;
-	if (journal->j_flags & JBD2_BARRIER &&
-	    !jbd2_trans_will_send_data_barrier(journal, commit_tid))
-		needs_barrier = true;
+	if (needs_barrier &&
+	    jbd2_trans_will_send_data_barrier(journal, commit_tid))
+		needs_barrier = false;
 	ret = jbd2_complete_transaction(journal, commit_tid);
+out_flush:
 	if (needs_barrier) {
 		err = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
 		if (!ret)
-- 
1.7.1

