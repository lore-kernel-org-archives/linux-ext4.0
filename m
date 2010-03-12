From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] ext4/jbd2: fix io-barrier logic in case of external journal
Date: Fri, 12 Mar 2010 20:26:49 +0300
Message-ID: <1268414810-17289-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:49965 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933363Ab0CLR05 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Mar 2010 12:26:57 -0500
Received: by bwz1 with SMTP id 1so1247685bwz.21
        for <linux-ext4@vger.kernel.org>; Fri, 12 Mar 2010 09:26:55 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently journalled mode is still broken if fs use external
journal. This is because all data handled as metadata.
We must to issue io-barrier to fs_device even if transaction
has only metadata blocks.

Also add missed return value check.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/fsync.c  |    2 +-
 fs/jbd2/commit.c |    3 +++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 98bd140..eb52837 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -101,7 +101,7 @@ int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
 		    (journal->j_fs_dev != journal->j_dev) &&
 		    (journal->j_flags & JBD2_BARRIER))
 			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
-		jbd2_log_wait_commit(journal, commit_tid);
+		ret = jbd2_log_wait_commit(journal, commit_tid);
 	} else if (journal->j_flags & JBD2_BARRIER)
 		blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 	return ret;
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 1bc74b6..2f62f1b 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -682,6 +682,9 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 			tag->t_flags |= cpu_to_be32(JBD2_FLAG_LAST_TAG);
 
 start_journal_io:
+			if (bufs)
+				commit_transaction->t_flushed_data_blocks = 1;
+
 			for (i = 0; i < bufs; i++) {
 				struct buffer_head *bh = wbuf[i];
 				/*
-- 
1.6.6

