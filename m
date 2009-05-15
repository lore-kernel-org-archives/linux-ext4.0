From: Vincent Minet <vincent@vincent-minet.net>
Subject: [PATCH] ext4: Fix spinlock assertions on UP systems
Date: Fri, 15 May 2009 11:55:25 +0200
Message-ID: <1242381325-10307-1-git-send-email-vincent@vincent-minet.net>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from serveur.didaction.com ([91.121.180.38]:42878 "EHLO
	serveur.didaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbZEOKFM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 15 May 2009 06:05:12 -0400
Received: from portablevm.vincent-minet.net (unknown [IPv6:2a01:e35:2e22:1bb0::2])
	by serveur.didaction.com (Postfix) with ESMTPSA id 160C624042
	for <linux-ext4@vger.kernel.org>; Fri, 15 May 2009 11:55:43 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On UP systems without DEBUG_SPINLOCK, ext4_is_group_locked always fails
which triggers a BUG_ON() call.
This patch fixes it by using assert_spin_locked instead.

Signed-off-by: Vincent Minet <vincent@vincent-minet.net>
---
 fs/ext4/ext4.h    |    6 ------
 fs/ext4/mballoc.c |   10 +++++-----
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 7386b80..fec8acb 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1598,12 +1598,6 @@ static inline void ext4_unlock_group(struct super_block *sb,
 	spin_unlock(ext4_group_lock_ptr(sb, group));
 }
 
-static inline int ext4_is_group_locked(struct super_block *sb,
-					ext4_group_t group)
-{
-	return spin_is_locked(ext4_group_lock_ptr(sb, group));
-}
-
 /*
  * Inodes and files operations
  */
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 14a3b77..fe7db8b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -449,7 +449,7 @@ static void mb_free_blocks_double(struct inode *inode, struct ext4_buddy *e4b,
 
 	if (unlikely(e4b->bd_info->bb_bitmap == NULL))
 		return;
-	BUG_ON(!ext4_is_group_locked(sb, e4b->bd_group));
+	assert_spin_locked(ext4_group_lock_ptr(sb, e4b->bd_group));
 	for (i = 0; i < count; i++) {
 		if (!mb_test_bit(first + i, e4b->bd_info->bb_bitmap)) {
 			ext4_fsblk_t blocknr;
@@ -473,7 +473,7 @@ static void mb_mark_used_double(struct ext4_buddy *e4b, int first, int count)
 
 	if (unlikely(e4b->bd_info->bb_bitmap == NULL))
 		return;
-	BUG_ON(!ext4_is_group_locked(e4b->bd_sb, e4b->bd_group));
+	assert_spin_locked(ext4_group_lock_ptr(e4b->bd_sb, e4b->bd_group));
 	for (i = 0; i < count; i++) {
 		BUG_ON(mb_test_bit(first + i, e4b->bd_info->bb_bitmap));
 		mb_set_bit(first + i, e4b->bd_info->bb_bitmap);
@@ -1128,7 +1128,7 @@ static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 	struct super_block *sb = e4b->bd_sb;
 
 	BUG_ON(first + count > (sb->s_blocksize << 3));
-	BUG_ON(!ext4_is_group_locked(sb, e4b->bd_group));
+	assert_spin_locked(ext4_group_lock_ptr(sb, e4b->bd_group));
 	mb_check_buddy(e4b);
 	mb_free_blocks_double(inode, e4b, first, count);
 
@@ -1209,7 +1209,7 @@ static int mb_find_extent(struct ext4_buddy *e4b, int order, int block,
 	int ord;
 	void *buddy;
 
-	BUG_ON(!ext4_is_group_locked(e4b->bd_sb, e4b->bd_group));
+	assert_spin_locked(ext4_group_lock_ptr(e4b->bd_sb, e4b->bd_group));
 	BUG_ON(ex == NULL);
 
 	buddy = mb_find_buddy(e4b, order, &max);
@@ -1273,7 +1273,7 @@ static int mb_mark_used(struct ext4_buddy *e4b, struct ext4_free_extent *ex)
 
 	BUG_ON(start + len > (e4b->bd_sb->s_blocksize << 3));
 	BUG_ON(e4b->bd_group != ex->fe_group);
-	BUG_ON(!ext4_is_group_locked(e4b->bd_sb, e4b->bd_group));
+	assert_spin_locked(ext4_group_lock_ptr(e4b->bd_sb, e4b->bd_group));
 	mb_check_buddy(e4b);
 	mb_mark_used_double(e4b, start, len);
 
-- 
1.6.3

