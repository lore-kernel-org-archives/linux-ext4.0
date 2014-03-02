From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 22/32] libext2fs: find inode goal when allocating blocks
Date: Sat, 01 Mar 2014 23:18:59 -0800
Message-ID: <20140302071859.28217.79516.stgit@birch.djwong.org>
References: <20140302071639.28217.57302.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44374 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbaCBHTD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Mar 2014 02:19:03 -0500
In-Reply-To: <20140302071639.28217.57302.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Try to be a little smarter about where we go to allocate blocks for a
inode.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass2.c         |    3 ++-
 e2fsck/pass3.c         |    2 +-
 lib/ext2fs/alloc.c     |   10 ++++++++++
 lib/ext2fs/bmap.c      |    5 +++--
 lib/ext2fs/expanddir.c |    2 +-
 lib/ext2fs/ext2fs.h    |    1 +
 lib/ext2fs/ext_attr.c  |    3 +--
 lib/ext2fs/extent.c    |   10 ++--------
 lib/ext2fs/mkdir.c     |    3 ++-
 lib/ext2fs/symlink.c   |    3 ++-
 10 files changed, 25 insertions(+), 17 deletions(-)


diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 3e22a18..e2974eb 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1619,7 +1619,8 @@ static int allocate_dir_block(e2fsck_t ctx,
 	/*
 	 * First, find a free block
 	 */
-	pctx->errcode = ext2fs_new_block2(fs, 0, ctx->block_found_map, &blk);
+	blk = ext2fs_find_inode_goal(fs, db->ino);
+	pctx->errcode = ext2fs_new_block2(fs, blk, ctx->block_found_map, &blk);
 	if (pctx->errcode) {
 		pctx->str = "ext2fs_new_block";
 		fix_problem(ctx, PR_2_ALLOC_DIRBOCK, pctx);
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index aaf177c..6769b05 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -812,7 +812,7 @@ errcode_t e2fsck_expand_directory(e2fsck_t ctx, ext2_ino_t dir,
 
 	es.num = num;
 	es.guaranteed_size = guaranteed_size;
-	es.last_block = 0;
+	es.last_block = ext2fs_find_inode_goal(fs, dir);
 	es.err = 0;
 	es.newblocks = 0;
 	es.ctx = ctx;
diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 1be4ecc..aa084ac 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -293,3 +293,13 @@ void ext2fs_set_alloc_block_callback(ext2_filsys fs,
 
 	fs->get_alloc_block = func;
 }
+
+blk64_t ext2fs_find_inode_goal(ext2_filsys fs, ext2_ino_t ino)
+{
+	dgrp_t	group = ext2fs_group_of_ino(fs, ino);
+	__u8	log_flex = fs->super->s_log_groups_per_flex;
+
+	if (log_flex)
+		group = group & ~((1 << (log_flex)) - 1);
+	return ext2fs_group_first_block2(fs, group);
+}
diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
index 07455f8..837d745 100644
--- a/lib/ext2fs/bmap.c
+++ b/lib/ext2fs/bmap.c
@@ -252,7 +252,7 @@ got_block:
 		retval = extent_bmap(fs, ino, inode, handle, block_buf,
 				     0, block-1, 0, blocks_alloc, &blk64);
 		if (retval)
-			blk64 = 0;
+			blk64 = ext2fs_find_inode_goal(fs, ino);
 		retval = ext2fs_alloc_block2(fs, blk64, block_buf,
 					     &blk64);
 		if (retval)
@@ -361,7 +361,8 @@ errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
 		}
 
 		*phys_blk = inode_bmap(inode, block);
-		b = block ? inode_bmap(inode, block-1) : 0;
+		b = block ? inode_bmap(inode, block-1) :
+			    ext2fs_find_inode_goal(fs, ino);
 
 		if ((*phys_blk == 0) && (bmap_flags & BMAP_ALLOC)) {
 			retval = ext2fs_alloc_block(fs, b, block_buf, &b);
diff --git a/lib/ext2fs/expanddir.c b/lib/ext2fs/expanddir.c
index 09a15fa..0463462 100644
--- a/lib/ext2fs/expanddir.c
+++ b/lib/ext2fs/expanddir.c
@@ -110,7 +110,7 @@ errcode_t ext2fs_expand_dir(ext2_filsys fs, ext2_ino_t dir)
 
 	es.done = 0;
 	es.err = 0;
-	es.goal = 0;
+	es.goal = ext2fs_find_inode_goal(fs, dir);
 	es.newblocks = 0;
 	es.dir = dir;
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 8aa0ac9..edbb92b 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -687,6 +687,7 @@ extern void ext2fs_set_alloc_block_callback(ext2_filsys fs,
 					    errcode_t (**old)(ext2_filsys fs,
 							      blk64_t goal,
 							      blk64_t *ret));
+blk64_t ext2fs_find_inode_goal(ext2_filsys fs, ext2_ino_t ino);
 
 /* alloc_sb.c */
 extern int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index 44d7615..9302fdf 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -404,8 +404,7 @@ static errcode_t prep_ea_block_for_write(ext2_filsys fs, ext2_ino_t ino,
 	}
 
 	/* Allocate a block */
-	grp = ext2fs_group_of_ino(fs, ino);
-	goal = ext2fs_inode_table_loc(fs, grp);
+	goal = ext2fs_find_inode_goal(fs, ino);
 	err = ext2fs_alloc_block2(fs, goal, NULL, &blk);
 	if (err)
 		goto out2;
diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index cf75a0b..5a6c5b5 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -1010,14 +1010,8 @@ static errcode_t extent_node_split(ext2_extent_handle_t handle,
 		goto done;
 	}
 
-	if (!goal_blk) {
-		dgrp_t	group = ext2fs_group_of_ino(handle->fs, handle->ino);
-		__u8	log_flex = handle->fs->super->s_log_groups_per_flex;
-
-		if (log_flex)
-			group = group & ~((1 << (log_flex)) - 1);
-		goal_blk = ext2fs_group_first_block2(handle->fs, group);
-	}
+	if (!goal_blk)
+		goal_blk = ext2fs_find_inode_goal(handle->fs, handle->ino);
 	retval = ext2fs_alloc_block2(handle->fs, goal_blk, block_buf,
 				    &new_node_pblk);
 	if (retval)
diff --git a/lib/ext2fs/mkdir.c b/lib/ext2fs/mkdir.c
index 4a85439..9864645 100644
--- a/lib/ext2fs/mkdir.c
+++ b/lib/ext2fs/mkdir.c
@@ -57,7 +57,8 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	/*
 	 * Allocate a data block for the directory
 	 */
-	retval = ext2fs_new_block2(fs, 0, 0, &blk);
+	retval = ext2fs_new_block2(fs, ext2fs_find_inode_goal(fs, ino), 0,
+				   &blk);
 	if (retval)
 		goto cleanup;
 
diff --git a/lib/ext2fs/symlink.c b/lib/ext2fs/symlink.c
index b2ef66c..cb3a2e7 100644
--- a/lib/ext2fs/symlink.c
+++ b/lib/ext2fs/symlink.c
@@ -53,7 +53,8 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	 */
 	fastlink = (target_len < sizeof(inode.i_block));
 	if (!fastlink) {
-		retval = ext2fs_new_block2(fs, 0, 0, &blk);
+		retval = ext2fs_new_block2(fs, ext2fs_find_inode_goal(fs, ino),
+					   0, &blk);
 		if (retval)
 			goto cleanup;
 		retval = ext2fs_get_mem(fs->blocksize, &block_buf);

