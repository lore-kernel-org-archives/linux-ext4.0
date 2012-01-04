From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 3/3] e2fsprogs: add a function computing old desc blocks without reserved ones
Date: Wed,  4 Jan 2012 19:02:12 +0800
Message-ID: <1325674932-26069-3-git-send-email-xiaoqiangnk@gmail.com>
References: <1325674932-26069-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63482 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab2ADOw6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Jan 2012 09:52:58 -0500
Received: by mail-iy0-f174.google.com with SMTP id h11so32657015iae.19
        for <linux-ext4@vger.kernel.org>; Wed, 04 Jan 2012 06:52:58 -0800 (PST)
In-Reply-To: <1325674932-26069-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If first_meta_bg > desc_blocks, ext2fs_open reads more decs_blocks,
however desc buffer in memory is allocated based on desc_blocks.
Maybe there are similar problems in other places, so this patch adds a
function which computes right old_desc_blocks.

The problem can be reproduced by setting first_meta_bg.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 lib/ext2fs/blknum.c  |   15 +++++++++++++++
 lib/ext2fs/closefs.c |    5 +----
 lib/ext2fs/ext2fs.h  |    1 +
 lib/ext2fs/openfs.c  |   18 ++++++++----------
 misc/dumpe2fs.c      |   10 ++--------
 5 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
index f1d5156..6d057ed 100644
--- a/lib/ext2fs/blknum.c
+++ b/lib/ext2fs/blknum.c
@@ -112,6 +112,21 @@ blk64_t ext2fs_old_desc_blocks_count(ext2_filsys fs)
 }
 
 /*
+ * Return the old desc blocks count without reserved ones.
+ */
+blk64_t ext2fs_old_desc_blocks_count_without_rsved(ext2_filsys fs)
+{
+	blk64_t old_desc_blocks;
+
+	old_desc_blocks = fs->desc_blocks;
+	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG &&
+	    old_desc_blocks > fs->super->s_first_meta_bg)
+		old_desc_blocks = fs->super->s_first_meta_bg;
+
+	return old_desc_blocks;
+}
+
+/*
  * Set the fs block count
  */
 void ext2fs_blocks_count_set(struct ext2_super_block *super, blk64_t blk)
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 0a97b69..75210c2 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -328,10 +328,7 @@ errcode_t ext2fs_flush2(ext2_filsys fs, int flags)
 	 * superblocks and group descriptors.
 	 */
 	group_ptr = (char *) group_shadow;
-	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
-		old_desc_blocks = fs->super->s_first_meta_bg;
-	else
-		old_desc_blocks = fs->desc_blocks;
+	old_desc_blocks = ext2fs_old_desc_blocks_count_without_rsved(fs);
 
 	ext2fs_numeric_progress_init(fs, &progress, NULL,
 				     fs->group_desc_count);
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 78f0f94..aae57e3 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -806,6 +806,7 @@ extern blk64_t ext2fs_inode_i_blocks(ext2_filsys fs,
 					 struct ext2_inode *inode);
 extern blk64_t ext2fs_blocks_count(struct ext2_super_block *super);
 extern blk64_t ext2fs_old_desc_blocks_count(ext2_filsys fs);
+extern blk64_t ext2fs_old_desc_blocks_count_without_rsved(ext2_filsys fs);
 extern void ext2fs_blocks_count_set(struct ext2_super_block *super,
 				    blk64_t blk);
 extern void ext2fs_blocks_count_add(struct ext2_super_block *super,
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 40a52c5..1077321 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -95,7 +95,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 {
 	ext2_filsys	fs;
 	errcode_t	retval;
-	unsigned long	i, first_meta_bg;
+	unsigned long	i, old_desc_blocks;
 	__u32		features;
 	unsigned int	groups_per_block, blocks_per_group, io_flags;
 	blk64_t		group_block, blk;
@@ -331,25 +331,23 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 		group_block = 1; /* Deal with 1024 blocksize && bigalloc */
 	dest = (char *) fs->group_desc;
 	groups_per_block = EXT2_DESC_PER_BLOCK(fs->super);
-	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
-		first_meta_bg = fs->super->s_first_meta_bg;
-	else
-		first_meta_bg = fs->desc_blocks;
-	if (first_meta_bg) {
+
+	old_desc_blocks = ext2fs_old_desc_blocks_count_without_rsved(fs);
+	if (old_desc_blocks) {
 		retval = io_channel_read_blk(fs->io, group_block+1,
-					     first_meta_bg, dest);
+					     old_desc_blocks, dest);
 		if (retval)
 			goto cleanup;
 #ifdef WORDS_BIGENDIAN
 		gdp = (struct ext2_group_desc *) dest;
-		for (j=0; j < groups_per_block*first_meta_bg; j++) {
+		for (j=0; j < groups_per_block * old_desc_blocks; j++) {
 			gdp = ext2fs_group_desc(fs, fs->group_desc, j);
 			ext2fs_swap_group_desc2(fs, gdp);
 		}
 #endif
-		dest += fs->blocksize*first_meta_bg;
+		dest += fs->blocksize * old_desc_blocks;
 	}
-	for (i=first_meta_bg ; i < fs->desc_blocks; i++) {
+	for (i = old_desc_blocks; i < fs->desc_blocks; i++) {
 		blk = ext2fs_descriptor_block_loc2(fs, group_block, i);
 		retval = io_channel_read_blk64(fs->io, blk, 1, dest);
 		if (retval)
diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 2f9e87b..61c32f2 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -175,10 +175,7 @@ static void list_desc (ext2_filsys fs)
 	reserved_gdt = fs->super->s_reserved_gdt_blocks;
 	fputc('\n', stdout);
 	first_block = fs->super->s_first_data_block;
-	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
-		old_desc_blocks = fs->super->s_first_meta_bg;
-	else
-		old_desc_blocks = fs->desc_blocks;
+	old_desc_blocks = ext2fs_old_desc_blocks_count_without_rsved(fs);
 	for (i = 0; i < fs->group_desc_count; i++) {
 		first_block = ext2fs_group_first_block2(fs, i);
 		last_block = ext2fs_group_last_block2(fs, i);
@@ -495,10 +492,7 @@ void print_super_gdt_blocks_count (ext2_filsys fs) {
 	blk64_t old_desc_blocks;
 	unsigned int grp;
 
-	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
-		old_desc_blocks = fs->super->s_first_meta_bg;
-	else
-		old_desc_blocks = fs->desc_blocks;
+	old_desc_blocks = ext2fs_old_desc_blocks_count_without_rsved(fs);
 
 	for (grp = 0; grp < fs->group_desc_count; grp++) {
 		ext2fs_super_and_bgd_loc2(fs, grp, &super_blk,
-- 
1.7.5.1

