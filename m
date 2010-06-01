From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.34.y 01/28] ext4: check missed return value in ext4_sync_file()
Date: Tue,  1 Jun 2010 12:12:48 -0400
Message-ID: <1275408795-17487-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:56888 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757108Ab0FAQNW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Jun 2010 12:13:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit 0671e704658b9f26f85e78d51176daa861f955c7 upstream (as of v2.6.34-git13)

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/fsync.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 0d0c323..42bd94a 100644
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
-- 
1.6.6.1.1.g974db.dirty

