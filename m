From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Fix a double free of sbi->s_group_info in ext4_mb_init_backend
Date: Mon, 11 Jul 2011 23:26:56 +0800
Message-ID: <1310398016-8104-2-git-send-email-tm@tao.ma>
References: <1310398016-8104-1-git-send-email-tm@tao.ma>
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:45398 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757782Ab1GKP1Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Jul 2011 11:27:16 -0400
In-Reply-To: <1310398016-8104-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

If we meet with an error in ext4_mb_add_groupinfo, we kfree
sbi->s_group_info[group >> EXT4_DESC_PER_BLOCK_BITS(sb)], but fail to
reset it to NULL. So the caller ext4_mb_init_backend will try to kfree
it again and causes a double free. So fix it by resetting it to NULL.

Some typo in comments of mballoc.c are also changed.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/mballoc.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c680641..4e7d055 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -75,8 +75,8 @@
  *
  * The inode preallocation space is used looking at the _logical_ start
  * block. If only the logical file block falls within the range of prealloc
- * space we will consume the particular prealloc space. This make sure that
- * that the we have contiguous physical blocks representing the file blocks
+ * space we will consume the particular prealloc space. This makes sure that
+ * we have contiguous physical blocks representing the file blocks
  *
  * The important thing to be noted in case of inode prealloc space is that
  * we don't modify the values associated to inode prealloc space except
@@ -84,7 +84,7 @@
  *
  * If we are not able to find blocks in the inode prealloc space and if we
  * have the group allocation flag set then we look at the locality group
- * prealloc space. These are per CPU prealloc list repreasented as
+ * prealloc space. These are per CPU prealloc list represented as
  *
  * ext4_sb_info.s_locality_groups[smp_processor_id()]
  *
@@ -152,7 +152,7 @@
  * best extent in the found extents. Searching for the blocks starts with
  * the group specified as the goal value in allocation context via
  * ac_g_ex. Each group is first checked based on the criteria whether it
- * can used for allocation. ext4_mb_good_group explains how the groups are
+ * can be used for allocation. ext4_mb_good_group explains how the groups are
  * checked.
  *
  * Both the prealloc space are getting populated as above. So for the first
@@ -2279,8 +2279,10 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 
 exit_group_info:
 	/* If a meta_group_info table has been allocated, release it now */
-	if (group % EXT4_DESC_PER_BLOCK(sb) == 0)
+	if (group % EXT4_DESC_PER_BLOCK(sb) == 0) {
 		kfree(sbi->s_group_info[group >> EXT4_DESC_PER_BLOCK_BITS(sb)]);
+		sbi->s_group_info[group >> EXT4_DESC_PER_BLOCK_BITS(sb)] = NULL;
+	}
 exit_meta_group_info:
 	return -ENOMEM;
 } /* ext4_mb_add_groupinfo */
-- 
1.7.4

