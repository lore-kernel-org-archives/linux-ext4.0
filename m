From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [Take2 PATCH 09/10][e2fsprogs] Use new ext2fs_super_and_bgd_loc2 call
	in libext2fs.
Date: Wed, 21 May 2008 12:54:22 -0500
Message-ID: <20080521175422.18810.88416.stgit@gara>
References: <20080521175325.18810.25160.stgit@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Jose R. Santos" <jrs@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60049 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934846AbYEURyp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 May 2008 13:54:45 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4LHsXwm006963
	for <linux-ext4@vger.kernel.org>; Wed, 21 May 2008 13:54:33 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4LHsNm9137392
	for <linux-ext4@vger.kernel.org>; Wed, 21 May 2008 13:54:23 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4LHsNLA007123
	for <linux-ext4@vger.kernel.org>; Wed, 21 May 2008 13:54:23 -0400
In-Reply-To: <20080521175325.18810.25160.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Use new ext2fs_super_and_bgd_loc2 call in libext2fs.

The new ext2fs_super_and_bgd_loc2() function has some changes aside
from just blk64_t support.  Lets make sure that the interfaces are
sane by adding libext2fs support early to get the new API tested here.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 e2fsck/pass5.c        |    7 ++++---
 lib/ext2fs/alloc_sb.c |   23 +++++++++++++++++++----
 lib/ext2fs/closefs.c  |    9 +++++----
 3 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index cc17820..a729308 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -111,7 +111,8 @@ static void print_bitmap_problem(e2fsck_t ctx, int problem,
 static void check_block_bitmaps(e2fsck_t ctx)
 {
 	ext2_filsys fs = ctx->fs;
-	blk_t	i, super;
+	blk64_t	i;
+	blk_t   super;
 	int	*free_array;
 	int	group = 0;
 	blk_t	blocks = 0;
@@ -174,10 +175,10 @@ redo_counts:
 		actual = ext2fs_fast_test_block_bitmap(ctx->block_found_map, i);
 
 		if (skip_group) {
-			blk_t	super_blk, old_desc_blk, new_desc_blk;
+			blk64_t	super_blk, old_desc_blk, new_desc_blk;
 			int	old_desc_blocks;
 
-			ext2fs_super_and_bgd_loc(fs, group, &super_blk,
+			ext2fs_super_and_bgd_loc2(fs, group, &super_blk,
 					 &old_desc_blk, &new_desc_blk, 0);
 
 			if (fs->super->s_feature_incompat &
diff --git a/lib/ext2fs/alloc_sb.c b/lib/ext2fs/alloc_sb.c
index 200ce5c..00cc5b0 100644
--- a/lib/ext2fs/alloc_sb.c
+++ b/lib/ext2fs/alloc_sb.c
@@ -44,11 +44,12 @@ int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
 				 dgrp_t group,
 				 ext2fs_block_bitmap bmap)
 {
-	blk_t	super_blk, old_desc_blk, new_desc_blk;
+	blk64_t	super_blk, old_desc_blk, new_desc_blk;
+	blk_t	used_blks;
 	int	j, old_desc_blocks, num_blocks;
 
-	num_blocks = ext2fs_super_and_bgd_loc(fs, group, &super_blk, 
-					      &old_desc_blk, &new_desc_blk, 0);
+	ext2fs_super_and_bgd_loc2(fs, group, &super_blk,
+				  &old_desc_blk, &new_desc_blk, &used_blks);
 
 	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
 		old_desc_blocks = fs->super->s_first_meta_bg;
@@ -57,16 +58,30 @@ int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
 			fs->desc_blocks + fs->super->s_reserved_gdt_blocks;
 
 	if (super_blk || (group == 0))
+		/* FIXME-64 */
 		ext2fs_mark_block_bitmap(bmap, super_blk);
 
 	if (old_desc_blk) {
 		if (fs->super->s_reserved_gdt_blocks && fs->block_map == bmap)
 			fs->group_desc[group].bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
 		for (j=0; j < old_desc_blocks; j++)
+			/* FIXME-64 */
 			ext2fs_mark_block_bitmap(bmap, old_desc_blk + j);
 	}
 	if (new_desc_blk)
+		/* FIXME-64 */
 		ext2fs_mark_block_bitmap(bmap, new_desc_blk);
 
-	return num_blocks;
+	if (group == fs->group_desc_count-1) {
+		num_blocks = (fs->super->s_blocks_count -
+			     fs->super->s_first_data_block) %
+			fs->super->s_blocks_per_group;
+		if (!num_blocks)
+			num_blocks = fs->super->s_blocks_per_group;
+	} else
+		num_blocks = fs->super->s_blocks_per_group;
+
+	num_blocks -= 2 + fs->inode_blocks_per_group + used_blks;
+
+	return num_blocks  ;
 }
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 8231ca6..b61556e 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -338,11 +338,10 @@ errcode_t ext2fs_flush(ext2_filsys fs)
 		old_desc_blocks = fs->desc_blocks;
 
 	for (i = 0; i < fs->group_desc_count; i++) {
-		blk_t	super_blk, old_desc_blk, new_desc_blk;
-		int	meta_bg;
+		blk64_t	super_blk, old_desc_blk, new_desc_blk;
 
-		ext2fs_super_and_bgd_loc(fs, i, &super_blk, &old_desc_blk, 
-					 &new_desc_blk, &meta_bg);
+		ext2fs_super_and_bgd_loc2(fs, i, &super_blk, &old_desc_blk,
+					 &new_desc_blk, 0);
 
 		if (!(fs->flags & EXT2_FLAG_MASTER_SB_ONLY) &&i && super_blk) {
 			retval = write_backup_super(fs, i, super_blk,
@@ -360,6 +359,8 @@ errcode_t ext2fs_flush(ext2_filsys fs)
 				goto errout;
 		}
 		if (new_desc_blk) {
+			int meta_bg = i / EXT2_DESC_PER_BLOCK(fs->super);
+
 			retval = io_channel_write_blk(fs->io, new_desc_blk,
 				1, group_ptr + (meta_bg*fs->blocksize));
 			if (retval)

