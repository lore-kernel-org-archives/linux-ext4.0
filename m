From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 03/15][e2fsprogs] Add new blk64_t handling functions
Date: Wed, 20 Aug 2008 12:32:54 -0500
Message-ID: <20080820173254.23412.69243.stgit@gara>
References: <20080820173210.23412.46020.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:34445 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbYHTRcF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Aug 2008 13:32:05 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e32.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7KHPGYc031007
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 13:25:16 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7KHVpdI077034
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 11:31:58 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7KHVoHU025778
	for <linux-ext4@vger.kernel.org>; Wed, 20 Aug 2008 11:31:50 -0600
In-Reply-To: <20080820173210.23412.46020.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Add new blk64_t handling functions

Add new blknum.c file which contains funtions to handle blk64_t and
low/high values in super blocks and inodes.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/ext2fs/Makefile.in |    1
 lib/ext2fs/blknum.c    |  214 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2fs.h    |   33 +++++--
 3 files changed, 237 insertions(+), 11 deletions(-)
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
--

 lib/ext2fs/Makefile.in |    1 
 lib/ext2fs/blknum.c    |  244 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2fs.h    |   45 +++++++--
 3 files changed, 279 insertions(+), 11 deletions(-)

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index 6f0ae62..3e7cbb9 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -26,6 +26,7 @@ OBJS= $(DEBUGFS_LIB_OBJS) $(RESIZE_LIB_OBJS) $(E2IMAGE_LIB_OBJS) \
 	bb_inode.o \
 	bitmaps.o \
 	bitops.o \
+	blknum.o \
 	block.o \
 	bmap.o \
 	check_desc.o \
diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
new file mode 100644
index 0000000..8c8057d
--- /dev/null
+++ b/lib/ext2fs/blknum.c
@@ -0,0 +1,244 @@
+/*
+ * blknum.c --- Functions to handle blk64_t and high/low 64-bit block
+ * number.
+ *
+ * Copyright IBM Corporation, 2007
+ * Author Jose R. Santos <jrs@us.ibm.com>
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Public
+ * License.
+ * %End-Header%
+ */
+
+#include "ext2fs.h"
+
+/*
+ * Return the group # of a block
+ */
+dgrp_t ext2fs_group_of_blk2(ext2_filsys fs, blk64_t blk)
+{
+	return (blk - fs->super->s_first_data_block) /
+		fs->super->s_blocks_per_group;
+}
+
+/*
+ * Return the first block (inclusive) in a group
+ */
+blk64_t ext2fs_group_first_block2(ext2_filsys fs, dgrp_t group)
+{
+	return fs->super->s_first_data_block +
+		(group * fs->super->s_blocks_per_group);
+}
+
+/*
+ * Return the last block (inclusive) in a group
+ */
+blk64_t ext2fs_group_last_block2(ext2_filsys fs, dgrp_t group)
+{
+	return (group == fs->group_desc_count - 1 ?
+		ext2fs_blocks_count(fs->super) - 1 :
+		ext2fs_group_first_block2(fs, group) +
+			(fs->super->s_blocks_per_group - 1));
+}
+
+/*
+ * Return the inode data block count
+ */
+blk64_t ext2fs_inode_data_blocks2(ext2_filsys fs,
+					struct ext2_inode *inode)
+{
+	return (inode->i_blocks |
+		(fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(__u64)inode->osd2.linux2.l_i_blocks_hi << 32 : 0)) -
+		(inode->i_file_acl ? fs->blocksize >> 9 : 0);
+}
+
+/*
+ * Return the fs block count
+ */
+blk64_t ext2fs_blocks_count(struct ext2_super_block *super)
+{
+	return super->s_blocks_count |
+		(super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(__u64) super->s_blocks_count_hi << 32 : 0);
+}
+
+/*
+ * Set the fs block count
+ */
+void ext2fs_blocks_count_set(struct ext2_super_block *super, blk64_t blk)
+{
+	super->s_blocks_count = blk;
+	if (super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+		super->s_blocks_count_hi = (__u64) blk >> 32;
+}
+
+/*
+ * Add to the current fs block count
+ */
+void ext2fs_blocks_count_add(struct ext2_super_block *super, blk64_t blk)
+{
+	blk64_t tmp;
+	tmp = ext2fs_blocks_count(super) + blk;
+	ext2fs_blocks_count_set(super, tmp);
+}
+
+/*
+ * Return the fs reserved block count
+ */
+blk64_t ext2fs_r_blocks_count(struct ext2_super_block *super)
+{
+	return super->s_r_blocks_count |
+		(super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(__u64) super->s_r_blocks_count_hi << 32 : 0);
+}
+
+/*
+ * Set the fs reserved block count
+ */
+void ext2fs_r_blocks_count_set(struct ext2_super_block *super, blk64_t blk)
+{
+	super->s_r_blocks_count = blk;
+	if (super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+		super->s_r_blocks_count_hi = (__u64) blk >> 32;
+}
+
+/*
+ * Add to the current reserved fs block count
+ */
+void ext2fs_r_blocks_count_add(struct ext2_super_block *super, blk64_t blk)
+{
+	blk64_t tmp;
+	tmp = ext2fs_r_blocks_count(super) + blk;
+	ext2fs_r_blocks_count_set(super, tmp);
+}
+
+/*
+ * Return the fs free block count
+ */
+blk64_t ext2fs_free_blocks_count(struct ext2_super_block *super)
+{
+	return super->s_free_blocks_count |
+		(super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(__u64) super->s_free_blocks_hi << 32 : 0);
+}
+
+/*
+ * Set the fs free block count
+ */
+void ext2fs_free_blocks_count_set(struct ext2_super_block *super, blk64_t blk)
+{
+	super->s_free_blocks_count = blk;
+	if (super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+		super->s_free_blocks_hi = (__u64) blk >> 32;
+}
+
+/*
+ * Add to the current free fs block count
+ */
+void ext2fs_free_blocks_count_add(struct ext2_super_block *super, blk64_t blk)
+{
+	blk64_t tmp;
+	tmp = ext2fs_free_blocks_count(super) + blk;
+	ext2fs_free_blocks_count_set(super, tmp);
+}
+
+/*
+ * Return the block bitmap block of a group
+ */
+blk64_t ext2fs_block_bitmap_loc(ext2_filsys fs, dgrp_t group)
+{
+	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
+		struct ext4_group_desc *gdp;
+		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
+
+		return gdp->bg_block_bitmap |
+			(fs->super->s_feature_incompat
+			 & EXT4_FEATURE_INCOMPAT_64BIT ?
+			 (__u64) gdp->bg_block_bitmap_hi << 32 : 0);
+	}
+
+	return fs->group_desc[group].bg_block_bitmap;
+}
+
+/*
+ * Set the block bitmap block of a group
+ */
+void ext2fs_block_bitmap_loc_set(ext2_filsys fs, dgrp_t group, blk64_t blk)
+{
+	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
+		struct ext4_group_desc *gdp;
+		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
+		gdp->bg_block_bitmap = blk;
+		if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+			gdp->bg_block_bitmap_hi = (__u64) blk >> 32;
+	} else
+		fs->group_desc[group].bg_block_bitmap = blk;
+}
+
+/*
+ * Return the inode bitmap block of a group
+ */
+blk64_t ext2fs_inode_bitmap_loc(ext2_filsys fs, dgrp_t group)
+{
+	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
+		struct ext4_group_desc *gdp;
+		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
+
+		return gdp->bg_inode_bitmap |
+			(fs->super->s_feature_incompat
+			 & EXT4_FEATURE_INCOMPAT_64BIT ?
+			 (__u64) gdp->bg_inode_bitmap_hi << 32 : 0);
+	}
+
+	return fs->group_desc[group].bg_inode_bitmap;
+}
+
+/*
+ * Set the inode bitmap block of a group
+ */
+void ext2fs_inode_bitmap_loc_set(ext2_filsys fs, dgrp_t group, blk64_t blk)
+{
+	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
+		struct ext4_group_desc *gdp;
+		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
+		gdp->bg_inode_bitmap = blk;
+		if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+			gdp->bg_inode_bitmap_hi = (__u64) blk >> 32;
+	} else
+		fs->group_desc[group].bg_inode_bitmap = blk;
+}
+
+/*
+ * Return the inode table block of a group
+ */
+blk64_t ext2fs_inode_table_loc(ext2_filsys fs, dgrp_t group)
+{
+	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
+		struct ext4_group_desc *gdp;
+		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
+
+		return gdp->bg_inode_table |
+			(fs->super->s_feature_incompat
+			 & EXT4_FEATURE_INCOMPAT_64BIT ?
+			 (__u64) gdp->bg_inode_table_hi << 32 : 0);
+	}
+
+	return fs->group_desc[group].bg_inode_table;
+}
+
+/*
+ * Set the inode table block of a group
+ */
+void ext2fs_inode_table_loc_set(ext2_filsys fs, dgrp_t group, blk64_t blk)
+{
+	if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
+		struct ext4_group_desc *gdp;
+		gdp = (struct ext4_group_desc *) (fs->group_desc) + group;
+		gdp->bg_inode_table = blk;
+		if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+			gdp->bg_inode_table_hi = (__u64) blk >> 32;
+	} else
+		fs->group_desc[group].bg_inode_table = blk;
+}
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index d9337aa..208be32 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -682,6 +682,36 @@ extern errcode_t ext2fs_get_block_bitmap_range(ext2fs_block_bitmap bmap,
 					blk_t start, unsigned int num,
 					void *out);
 
+/* blknum.c */
+extern dgrp_t ext2fs_group_of_blk2(ext2_filsys fs, blk64_t);
+extern blk64_t ext2fs_group_first_block2(ext2_filsys fs, dgrp_t group);
+extern blk64_t ext2fs_group_last_block2(ext2_filsys fs, dgrp_t group);
+extern blk64_t ext2fs_inode_data_blocks2(ext2_filsys fs,
+					 struct ext2_inode *inode);
+extern blk64_t ext2fs_blocks_count(struct ext2_super_block *super);
+extern void ext2fs_blocks_count_set(struct ext2_super_block *super,
+				    blk64_t blk);
+extern void ext2fs_blocks_count_add(struct ext2_super_block *super,
+				    blk64_t blk);
+extern blk64_t ext2fs_r_blocks_count(struct ext2_super_block *super);
+extern void ext2fs_r_blocks_count_set(struct ext2_super_block *super,
+				      blk64_t blk);
+extern void ext2fs_r_blocks_count_add(struct ext2_super_block *super,
+				      blk64_t blk);
+extern blk64_t ext2fs_free_blocks_count(struct ext2_super_block *super);
+extern void ext2fs_free_blocks_count_set(struct ext2_super_block *super,
+					 blk64_t blk);
+extern void ext2fs_free_blocks_count_add(struct ext2_super_block *super,
+					 blk64_t blk);
+extern blk64_t ext2fs_block_bitmap_loc(ext2_filsys fs, dgrp_t group);
+extern void ext2fs_block_bitmap_loc_set(ext2_filsys fs, dgrp_t group,
+					blk64_t blk);
+extern blk64_t ext2fs_inode_bitmap_loc(ext2_filsys fs, dgrp_t group);
+extern void ext2fs_inode_bitmap_loc_set(ext2_filsys fs, dgrp_t group,
+					blk64_t blk);
+extern blk64_t ext2fs_inode_table_loc(ext2_filsys fs, dgrp_t group);
+extern void ext2fs_inode_table_loc_set(ext2_filsys fs, dgrp_t group,
+				       blk64_t blk);
 
 /* block.c */
 extern errcode_t ext2fs_block_iterate(ext2_filsys fs,
@@ -1316,10 +1346,8 @@ _INLINE_ int ext2fs_test_bb_dirty(ext2_filsys fs)
  */
 _INLINE_ int ext2fs_group_of_blk(ext2_filsys fs, blk_t blk)
 {
-	return (blk - fs->super->s_first_data_block) /
-		fs->super->s_blocks_per_group;
+	return ext2fs_group_of_blk2(fs, blk);
 }
-
 /*
  * Return the group # of an inode number
  */
@@ -1333,8 +1361,7 @@ _INLINE_ int ext2fs_group_of_ino(ext2_filsys fs, ext2_ino_t ino)
  */
 _INLINE_ blk_t ext2fs_group_first_block(ext2_filsys fs, dgrp_t group)
 {
-	return fs->super->s_first_data_block +
-		(group * fs->super->s_blocks_per_group);
+	return ext2fs_group_first_block2(fs, group);
 }
 
 /*
@@ -1342,17 +1369,13 @@ _INLINE_ blk_t ext2fs_group_first_block(ext2_filsys fs, dgrp_t group)
  */
 _INLINE_ blk_t ext2fs_group_last_block(ext2_filsys fs, dgrp_t group)
 {
-	return (group == fs->group_desc_count - 1 ?
-		fs->super->s_blocks_count - 1 :
-		ext2fs_group_first_block(fs, group) +
-			(fs->super->s_blocks_per_group - 1));
+	return ext2fs_group_last_block2(fs, group);
 }
 
 _INLINE_ blk_t ext2fs_inode_data_blocks(ext2_filsys fs,
 					struct ext2_inode *inode)
 {
-       return inode->i_blocks -
-              (inode->i_file_acl ? fs->blocksize >> 9 : 0);
+	return ext2fs_inode_data_blocks2(fs, inode);
 }
 
 /*

