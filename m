From: akpm@osdl.org
Subject: [patch 033/100] ext4 uninline ext4_get_group_no_and_offset()
Date: Wed, 11 Oct 2006 01:21:18 -0700
Message-ID: <200610110821.k9B8LIOe012034@shell0.pdx.osdl.net>
Cc: akpm@osdl.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:27781 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965183AbWJKIuo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Oct 2006 04:50:44 -0400
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id k9B8oPav024846
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 11 Oct 2006 01:50:43 -0700
To: torvalds@osdl.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Andrew Morton <akpm@osdl.org>

Way too big to inline.

Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext4/balloc.c        |   18 ++++++++++++++++++
 include/linux/ext4_fs.h |   22 ++--------------------
 2 files changed, 20 insertions(+), 20 deletions(-)

diff -puN fs/ext4/balloc.c~ext4-uninline-ext4_get_group_no_and_offset fs/ext4/balloc.c
--- a/fs/ext4/balloc.c~ext4-uninline-ext4_get_group_no_and_offset
+++ a/fs/ext4/balloc.c
@@ -25,6 +25,24 @@
  */
 
 /*
+ * Calculate the block group number and offset, given a block number
+ */
+void ext4_get_group_no_and_offset(struct super_block *sb, ext4_fsblk_t blocknr,
+		unsigned long *blockgrpp, ext4_grpblk_t *offsetp)
+{
+        struct ext4_super_block *es = EXT4_SB(sb)->s_es;
+	ext4_grpblk_t offset;
+
+        blocknr = blocknr - le32_to_cpu(es->s_first_data_block);
+        offset = sector_div(blocknr, EXT4_BLOCKS_PER_GROUP(sb));
+	if (offsetp)
+		*offsetp = offset;
+	if (blockgrpp)
+	        *blockgrpp = blocknr;
+
+}
+
+/*
  * The free blocks are managed by bitmaps.  A file system contains several
  * blocks groups.  Each group contains 1 bitmap block for blocks, 1 bitmap
  * block for inodes, N blocks for the inode table and data blocks.
diff -puN include/linux/ext4_fs.h~ext4-uninline-ext4_get_group_no_and_offset include/linux/ext4_fs.h
--- a/include/linux/ext4_fs.h~ext4-uninline-ext4_get_group_no_and_offset
+++ a/include/linux/ext4_fs.h
@@ -769,26 +769,8 @@ ext4_group_first_block_no(struct super_b
  */
 #define ERR_BAD_DX_DIR	-75000
 
-/*
- * This function calculate the block group number and offset,
- * given a block number
- */
-
-static inline void ext4_get_group_no_and_offset(struct super_block * sb,
-                                ext4_fsblk_t blocknr, unsigned long* blockgrpp,
-                                ext4_grpblk_t *offsetp)
-{
-        struct ext4_super_block *es = EXT4_SB(sb)->s_es;
-	ext4_grpblk_t offset;
-
-        blocknr = blocknr - le32_to_cpu(es->s_first_data_block);
-        offset = sector_div(blocknr, EXT4_BLOCKS_PER_GROUP(sb));
-	if (offsetp)
-		*offsetp = offset;
-	if (blockgrpp)
-	        *blockgrpp = blocknr;
-
-}
+void ext4_get_group_no_and_offset(struct super_block *sb, ext4_fsblk_t blocknr,
+			unsigned long *blockgrpp, ext4_grpblk_t *offsetp);
 
 /*
  * Function prototypes
_
