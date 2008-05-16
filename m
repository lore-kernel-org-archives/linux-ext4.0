From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 4/4] ext4: call blkdev_issue_flush on fsync
Date: Fri, 16 May 2008 09:37:22 -0500
Message-ID: <1210948642-12171-5-git-send-email-sandeen@redhat.com>
References: <1210948642-12171-1-git-send-email-sandeen@redhat.com>
Cc: Eric Sandeen <sandeen@redhat.com>
To: sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:38516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763369AbYEPO4X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 May 2008 10:56:23 -0400
In-Reply-To: <1210948642-12171-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

To ensure that bits are truly on-disk after an fsync,
we should call blkdev_issue_flush if barriers are supported.

Inspired by an old thread on barriers, by reiserfs & xfs
which do the same, and by a patch SuSE ships with their kernel

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/ext4/fsync.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 1c8ba48..a45c373 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -27,6 +27,7 @@
 #include <linux/sched.h>
 #include <linux/writeback.h>
 #include <linux/jbd2.h>
+#include <linux/blkdev.h>
 #include "ext4.h"
 #include "ext4_jbd2.h"
 
@@ -45,6 +46,7 @@
 int ext4_sync_file(struct file * file, struct dentry *dentry, int datasync)
 {
 	struct inode *inode = dentry->d_inode;
+	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
 	int ret = 0;
 
 	J_ASSERT(ext4_journal_current_handle() == NULL);
@@ -85,6 +87,8 @@ int ext4_sync_file(struct file * file, struct dentry *dentry, int datasync)
 			.nr_to_write = 0, /* sys_fsync did this */
 		};
 		ret = sync_inode(inode, &wbc);
+		if (journal && (journal->j_flags & JBD2_BARRIER))
+			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
 	}
 out:
 	return ret;
-- 
1.5.3.6

