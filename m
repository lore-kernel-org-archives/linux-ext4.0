From: Wang shilong <wangshilong1991@gmail.com>
Subject: [PATCH 1/2] Ext2: return ENOMEM rather than EIO if sb_getblk fails
Date: Thu, 13 Jan 2011 18:46:25 +0800
Message-ID: <1294915585-3377-1-git-send-email-wangshilong1991@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, tytso@mit.edu,
	linux-ext4@vger.kernel.org,
	Wang shilong <wangshilong1991@gmail.com>,
	Wang Shilong <wangsl-fnst@cn.fujitsu.com>
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:57923 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab3AMCoe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Jan 2013 21:44:34 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>

As the only reason that sb_getblk fails is that allocation fails.
It will be better to use ENOMEM rather than EIO.

Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
---
 fs/ext2/super.c | 2 +-
 fs/ext2/xattr.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 663fdcd..3308a55 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1457,7 +1457,7 @@ static ssize_t ext2_quota_write(struct super_block *sb, int type,
 		else
 			bh = sb_getblk(sb, tmp_bh.b_blocknr);
 		if (unlikely(!bh)) {
-			err = -EIO;
+			err = -ENOMEM;
 			goto out;
 		}
 		lock_buffer(bh);
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 06209ec..2d7557d 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -665,7 +665,7 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 			if (unlikely(!new_bh)) {
 				ext2_free_blocks(inode, block, 1);
 				mark_inode_dirty(inode);
-				error = -EIO;
+				error = -ENOMEM;
 				goto cleanup;
 			}
 			lock_buffer(new_bh);
-- 
1.7.11.7

