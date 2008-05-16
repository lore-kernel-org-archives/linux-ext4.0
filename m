From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 2/4] ext3: call blkdev_issue_flush on fsync
Date: Fri, 16 May 2008 09:37:20 -0500
Message-ID: <1210948642-12171-3-git-send-email-sandeen@redhat.com>
References: <1210948642-12171-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760655AbYEPO4T (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 May 2008 10:56:19 -0400
In-Reply-To: <1210948642-12171-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

To ensure that bits are truly on-disk after an fsync,
ext3 should call blkdev_issue_flush if barriers are supported.

Inspired by an old thread on barriers, by reiserfs & xfs
which do the same, and by a patch SuSE ships with their kernel

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/ext3/fsync.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/ext3/fsync.c b/fs/ext3/fsync.c
index d336341..f6167ec 100644
--- a/fs/ext3/fsync.c
+++ b/fs/ext3/fsync.c
@@ -27,6 +27,7 @@
 #include <linux/sched.h>
 #include <linux/writeback.h>
 #include <linux/jbd.h>
+#include <linux/blkdev.h>
 #include <linux/ext3_fs.h>
 #include <linux/ext3_jbd.h>
 
@@ -45,6 +46,7 @@
 int ext3_sync_file(struct file * file, struct dentry *dentry, int datasync)
 {
 	struct inode *inode = dentry->d_inode;
+	journal_t *journal = EXT3_SB(inode->i_sb)->s_journal;
 	int ret = 0;
 
 	J_ASSERT(ext3_journal_current_handle() == NULL);
@@ -85,6 +87,9 @@ int ext3_sync_file(struct file * file, struct dentry *dentry, int datasync)
 			.nr_to_write = 0, /* sys_fsync did this */
 		};
 		ret = sync_inode(inode, &wbc);
+
+		if (journal && (journal->j_flags & JFS_BARRIER))
+			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 	}
 out:
 	return ret;
-- 
1.5.3.6

