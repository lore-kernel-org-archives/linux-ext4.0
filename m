From: Davide Italiano <dccitaliano@gmail.com>
Subject: [PATCH] ext4: Remove redundant check under lock scope
Date: Mon,  6 Apr 2015 22:35:01 -0700
Message-ID: <1428384901-2304-2-git-send-email-dccitaliano@gmail.com>
References: <1428384901-2304-1-git-send-email-dccitaliano@gmail.com>
Cc: Davide Italiano <dccitaliano@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:36580 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbbDGFvH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Apr 2015 01:51:07 -0400
Received: by pabsx10 with SMTP id sx10so67548341pab.3
        for <linux-ext4@vger.kernel.org>; Mon, 06 Apr 2015 22:51:06 -0700 (PDT)
In-Reply-To: <1428384901-2304-1-git-send-email-dccitaliano@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_zero_range() and ext4_collapse_range() duplicate
the check in ext4_fallocate(). The checks are made with
inode lock held when there's no need for that. Remove them,
reducing the scope of the lock.

Signed-off-by: Davide Italiano <dccitaliano@gmail.com>
---
 fs/ext4/extents.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index bed4308..9e6fa09 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4810,15 +4810,6 @@ static long ext4_zero_range(struct file *file, loff_t offset,
 		flags |= EXT4_GET_BLOCKS_KEEP_SIZE;
 
 	mutex_lock(&inode->i_mutex);
-
-	/*
-	 * Indirect files do not support unwritten extnets
-	 */
-	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))) {
-		ret = -EOPNOTSUPP;
-		goto out_mutex;
-	}
-
 	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
 	     offset + len > i_size_read(inode)) {
 		new_size = offset + len;
@@ -5445,13 +5436,6 @@ int ext4_collapse_range(struct inode *inode, loff_t offset, loff_t len)
 		ret = -EINVAL;
 		goto out_mutex;
 	}
-
-	/* Currently just for extent based files */
-	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
-		ret = -EOPNOTSUPP;
-		goto out_mutex;
-	}
