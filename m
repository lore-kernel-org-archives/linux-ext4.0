From: Surbhi Palande <surbhi.palande@canonical.com>
Subject: [PATCH] ext4: Ensure writecache to disk in no journal mode
Date: Fri, 26 Mar 2010 18:21:02 +0200
Message-ID: <1269620462-25906-1-git-send-email-surbhi.palande@canonical.com>
Cc: Theodore Tso <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:47471 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab0CZQVN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Mar 2010 12:21:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ensure that in the no journal mode the write cache is flushed to the disk by
calling a blkdev_issue_flush() which issues a WRITE_BARRIER if necessary.

Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
---
 fs/ext4/fsync.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index d6049e4..1d73a50 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -67,8 +67,12 @@ int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
 	if (ret < 0)
 		return ret;
 
-	if (!journal)
-		return simple_fsync(file, dentry, datasync);
+	if (!journal) {
+		ret = simple_fsync(file, dentry, datasync);
+		if (test_opt(inode->i_sb, BARRIER))
+			blkdev_issue_flush(inode->i_sb->s_bdev, NULL);
+		return ret;
+	}
 
 	/*
 	 * data=writeback,ordered:
-- 
1.6.3.3

