Return-Path: <SRS0=65gx=NY=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:60163 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbeKNJZg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 14 Nov 2018 04:25:36 -0500
From: Chengguang Xu <cgxu519@gmx.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Cc: linux-ext4@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH] ext4: remove redundant condition check
Date: Wed, 14 Nov 2018 07:24:48 +0800
Message-Id: <20181113232448.11071-1-cgxu519@gmx.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_xattr_destroy_cache() can handle NULL pointer correctly,
so there is no need to check NULL pointer before calling
ext4_xattr_destroy_cache().

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/ext4/super.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 53ff6c2a26ed..30d4a4e69de8 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1000,14 +1000,13 @@ static void ext4_put_super(struct super_block *sb)
 		invalidate_bdev(sbi->journal_bdev);
 		ext4_blkdev_remove(sbi);
 	}
-	if (sbi->s_ea_inode_cache) {
-		ext4_xattr_destroy_cache(sbi->s_ea_inode_cache);
-		sbi->s_ea_inode_cache = NULL;
-	}
-	if (sbi->s_ea_block_cache) {
-		ext4_xattr_destroy_cache(sbi->s_ea_block_cache);
-		sbi->s_ea_block_cache = NULL;
-	}
+
+	ext4_xattr_destroy_cache(sbi->s_ea_inode_cache);
+	sbi->s_ea_inode_cache = NULL;
+
+	ext4_xattr_destroy_cache(sbi->s_ea_block_cache);
+	sbi->s_ea_block_cache = NULL;
+
 	if (sbi->s_mmp_tsk)
 		kthread_stop(sbi->s_mmp_tsk);
 	brelse(sbi->s_sbh);
@@ -4522,14 +4521,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (EXT4_SB(sb)->rsv_conversion_wq)
 		destroy_workqueue(EXT4_SB(sb)->rsv_conversion_wq);
 failed_mount_wq:
-	if (sbi->s_ea_inode_cache) {
-		ext4_xattr_destroy_cache(sbi->s_ea_inode_cache);
-		sbi->s_ea_inode_cache = NULL;
-	}
-	if (sbi->s_ea_block_cache) {
-		ext4_xattr_destroy_cache(sbi->s_ea_block_cache);
-		sbi->s_ea_block_cache = NULL;
-	}
+	ext4_xattr_destroy_cache(sbi->s_ea_inode_cache);
+	sbi->s_ea_inode_cache = NULL;
+
+	ext4_xattr_destroy_cache(sbi->s_ea_block_cache);
+	sbi->s_ea_block_cache = NULL;
+
 	if (sbi->s_journal) {
 		jbd2_journal_destroy(sbi->s_journal);
 		sbi->s_journal = NULL;
-- 
2.17.2
