From: Valerie Clement <valerie.clement@bull.net>
Subject: [PATCH 5/8][e2fsprogs] add new inline functions to get blocks
	counters
Date: Thu, 30 Aug 2007 17:39:30 +0200
Message-ID: <1188488370.15770.52.camel@ext1.frec.bull.fr>
References: <1188487715.15770.35.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43824 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586AbXH3N0t (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Aug 2007 09:26:49 -0400
In-Reply-To: <1188487715.15770.35.camel@ext1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


From: Valerie Clement <valerie.clement@bull.net>

In preparation for 64-bit support, this patch introduces new inline functions
to get block counts in the on-disk superblock.

If the EXT4_FEATURE_INCOMPAT_64BIT flag is not set, the functions return the
low 32 bits of block counters.

Changes from the previous version:
Replace macros definition by inline functions because some previous macros
evaluate their argument more than once.

Signed-off-by: Valerie Clement <valerie.clement@bull.net>
---

 lib/ext2fs/ext2fs.h |   72 +++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 61 insertions(+), 11 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 3aa9c8f..b60318c 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1011,6 +1011,13 @@ extern blk_t ext2fs_group_last_block(ext2_filsys fs, dgrp_t group);
 extern blk_t ext2fs_inode_data_blocks(ext2_filsys fs,
 				      struct ext2_inode *inode);
 extern unsigned int ext2fs_div_ceil(unsigned int a, unsigned int b);
+extern blk_t ext2_blocks_count(struct ext2_super_block *super);
+extern blk_t ext2_r_blocks_count(struct ext2_super_block *super);
+extern blk_t ext2_free_blocks_count(struct ext2_super_block *super);
+extern void ext2_blocks_count_set(struct ext2_super_block *super, blk_t blk);
+extern void ext2_r_blocks_count_set(struct ext2_super_block *super, blk_t blk);
+extern void ext2_free_blocks_count_set(struct ext2_super_block *super,
+					blk_t blk);
 
 /*
  * The actual inlined functions definitions themselves...
@@ -1184,17 +1191,6 @@ _INLINE_ blk_t ext2fs_group_first_block(ext2_filsys fs, dgrp_t group)
 		(group * fs->super->s_blocks_per_group);
 }
 
-/*
- * Return the last block (inclusive) in a group
- */
-_INLINE_ blk_t ext2fs_group_last_block(ext2_filsys fs, dgrp_t group)
-{
-	return (group == fs->group_desc_count - 1 ?
-		fs->super->s_blocks_count - 1 :
-		ext2fs_group_first_block(fs, group) +
-			(fs->super->s_blocks_per_group - 1));
-}
-
 _INLINE_ blk_t ext2fs_inode_data_blocks(ext2_filsys fs,
 					struct ext2_inode *inode)
 {
@@ -1211,6 +1207,60 @@ _INLINE_ unsigned int ext2fs_div_ceil(unsigned int a, unsigned int b)
 		return 0;
 	return ((a - 1) / b) + 1;
 }
+
+_INLINE_ blk_t ext2_blocks_count(struct ext2_super_block *super)
+{
+	return super->s_blocks_count +
+		(super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(__u64)super->s_blocks_count_hi << 32 : 0);
+}
+
+_INLINE_ blk_t ext2_r_blocks_count(struct ext2_super_block *super)
+{
+	return super->s_r_blocks_count +
+		(super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(__u64)super->s_r_blocks_count_hi << 32 : 0);
+}
+
+_INLINE_ blk_t ext2_free_blocks_count(struct ext2_super_block *super)
+{
+	return super->s_free_blocks_count +
+		(super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(__u64)super->s_free_blocks_hi << 32 : 0);
+}
+
+_INLINE_ void ext2_blocks_count_set(struct ext2_super_block *super, blk_t blk)
+{
+	super->s_blocks_count = blk;
+	if (super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+		super->s_blocks_count_hi = (__u64) blk >> 32;
+}
+
+_INLINE_ void ext2_r_blocks_count_set(struct ext2_super_block *super, blk_t blk)
+{
+	super->s_r_blocks_count = blk;
+	if (super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+		super->s_r_blocks_count_hi = (__u64) blk >> 32;
+}
+
+_INLINE_ void ext2_free_blocks_count_set(struct ext2_super_block *super,
+					 blk_t blk)
+{
+	super->s_free_blocks_count = blk;
+	if (super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+		super->s_free_blocks_hi = (__u64) blk >> 32;
+}
+
+/*
+ * Return the last block (inclusive) in a group
+ */
+_INLINE_ blk_t ext2fs_group_last_block(ext2_filsys fs, dgrp_t group)
+{
+	return (group == fs->group_desc_count - 1 ?
+		fs->super->s_blocks_count - 1 :
+		ext2fs_group_first_block(fs, group) +
+			(fs->super->s_blocks_per_group - 1));
+}
 #undef _INLINE_
 #endif
 
