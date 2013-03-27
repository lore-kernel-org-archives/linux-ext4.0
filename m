From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/2 v2] ext4: Make ext4_block_in_group() much more efficient
Date: Wed, 27 Mar 2013 12:04:04 +0100
Message-ID: <1364382245-32510-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab3C0LEM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Mar 2013 07:04:12 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently in when getting the block group number for a particular block
in ext4_block_in_group() we're using ext4_get_group_no_and_offset()
which uses do_div() to get the block group and the remainer which is
offset within the group.

We don't need all of that in ext4_block_in_group() as we only need to
figure out the group number.

This commit changes ext4_block_in_group() to calculate group number
directly. This shows as a big improvement with regards to cpu
utilization. Measuring fallocate -l 15T on fresh file system with perf
showed that 23% of cpu time was spend in the
ext4_get_group_no_and_offset(). With this change it completely
disappears from the list only bumping the occurrence of
ext4_init_block_bitmap() which is the biggest user of
ext4_block_in_group() by 4%. As the result of this change on my system
the fallocate call was approx. 10% faster.

However since there is '-g' option in mkfs which allow us setting
different groups size (mostly for developers) I've introduced new per
file system flag whether we have a standard block group size or not. The
flag is used to determine whether we can use the bit shift optimization
or not.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
v2: Add sbi flag if there is standard group size

 fs/ext4/balloc.c |   22 ++++++++++++++++------
 fs/ext4/ext4.h   |    3 +++
 fs/ext4/super.c  |    4 ++++
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 92e68b3..a4d2e73 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -49,14 +49,24 @@ void ext4_get_group_no_and_offset(struct super_block *sb, ext4_fsblk_t blocknr,
 
 }
 
-static int ext4_block_in_group(struct super_block *sb, ext4_fsblk_t block,
-			ext4_group_t block_group)
+/*
+ * Check whether the 'block' lives within the 'block_group'. Returns 1 if so
+ * and 0 otherwise.
+ */
+static inline int ext4_block_in_group(struct super_block *sb,
+				      ext4_fsblk_t block,
+				      ext4_group_t block_group)
 {
 	ext4_group_t actual_group;
-	ext4_get_group_no_and_offset(sb, block, &actual_group, NULL);
-	if (actual_group == block_group)
-		return 1;
-	return 0;
+
+	if (test_opt(sb, STD_GROUP_SIZE))
+		actual_group =
+			(le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block) +
+			block) >>
+			(EXT4_BLOCK_SIZE_BITS(sb) + EXT4_CLUSTER_BITS(sb) + 3);
+	else
+		ext4_get_group_no_and_offset(sb, block, &actual_group, NULL);
+	return (actual_group == block_group) ? 1 : 0;
 }
 
 /* Return the number of clusters used for file system metadata; this
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 167ff56..2ee8d76 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -983,6 +983,9 @@ struct ext4_inode_info {
 
 #define EXT4_MOUNT2_EXPLICIT_DELALLOC	0x00000001 /* User explicitly
 						      specified delalloc */
+#define EXT4_MOUNT_STD_GROUP_SIZE	0x00000002 /* We have standard group
+						      size of blocksize * 8
+						      blocks */
 
 #define clear_opt(sb, opt)		EXT4_SB(sb)->s_mount_opt &= \
 						~EXT4_MOUNT_##opt
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d1ee6a8..28ea887 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3522,6 +3522,10 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_addr_per_block_bits = ilog2(EXT4_ADDR_PER_BLOCK(sb));
 	sbi->s_desc_per_block_bits = ilog2(EXT4_DESC_PER_BLOCK(sb));
 
+	/* Do we have standard group size of blocksize * 8 blocks ? */
+	if (sbi->s_blocks_per_group == blocksize << 8)
+		set_opt(sb, STD_GROUP_SIZE);
+
 	for (i = 0; i < 4; i++)
 		sbi->s_hash_seed[i] = le32_to_cpu(es->s_hash_seed[i]);
 	sbi->s_def_hash_version = es->s_def_hash_version;
-- 
1.7.7.6

