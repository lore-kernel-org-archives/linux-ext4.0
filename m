From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 11/47] libext2fs: find inode goal when allocating blocks
Date: Fri, 07 Nov 2014 13:51:59 -0800
Message-ID: <20141107215159.883.90273.stgit@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35618 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbaKGVwD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2014 16:52:03 -0500
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Try to be a little smarter about where we go to allocate blocks for a
inode.  For a given inode and logical offset, set the goal as if the
file were physically continuous.  If it's bmapped, just start looking
at wherever lblk 0 is.  If that's not possible (the file has no
lblk>pblk mappings, inline data, etc.) then start looking in the
inode's block group.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass2.c                 |    3 ++-
 lib/ext2fs/alloc.c             |   43 ++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/bmap.c              |    5 +++--
 lib/ext2fs/expanddir.c         |    6 +++++-
 lib/ext2fs/ext2fs.h            |    2 ++
 lib/ext2fs/ext_attr.c          |    4 +---
 lib/ext2fs/extent.c            |   11 +++-------
 lib/ext2fs/mkdir.c             |    7 +++++--
 lib/ext2fs/symlink.c           |    7 +++++--
 tests/f_extent_oobounds/script |    6 +++---
 tests/f_extents2/expect.1      |    2 +-
 11 files changed, 73 insertions(+), 23 deletions(-)


diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index c354e4a..cd0762a 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1772,7 +1772,8 @@ static int allocate_dir_block(e2fsck_t ctx,
 	pctx->errcode = ext2fs_map_cluster_block(fs, db->ino, &inode,
 						 db->blockcnt, &blk);
 	if (pctx->errcode || blk == 0) {
-		pctx->errcode = ext2fs_new_block2(fs, 0,
+		blk = ext2fs_find_inode_goal(fs, db->ino, &inode, db->blockcnt);
+		pctx->errcode = ext2fs_new_block2(fs, blk,
 						  ctx->block_found_map, &blk);
 		if (pctx->errcode) {
 			pctx->str = "ext2fs_new_block";
diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index cb778f7..fda45f9 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -288,3 +288,46 @@ void ext2fs_set_alloc_block_callback(ext2_filsys fs,
 
 	fs->get_alloc_block = func;
 }
+
+blk64_t ext2fs_find_inode_goal(ext2_filsys fs, ext2_ino_t ino,
+			       struct ext2_inode *inode, blk64_t lblk)
+{
+	dgrp_t			group;
+	__u8			log_flex;
+	struct ext2fs_extent	extent;
+	ext2_extent_handle_t	handle;
+	errcode_t		err;
+
+	if (inode == NULL || ext2fs_inode_data_blocks2(fs, inode) == 0)
+		goto no_blocks;
+
+	if (inode->i_flags & EXT4_INLINE_DATA_FL)
+		goto no_blocks;
+
+	if (inode->i_flags & EXT4_EXTENTS_FL) {
+		err = ext2fs_extent_open2(fs, ino, inode, &handle);
+		if (err)
+			goto no_blocks;
+		err = ext2fs_extent_goto2(handle, 0, lblk);
+		if (err)
+			goto extent_err;
+		err = ext2fs_extent_get(handle, EXT2_EXTENT_CURRENT, &extent);
+		if (err)
+			goto extent_err;
+		return extent.e_pblk + (lblk - extent.e_lblk);
+extent_err:
+		ext2fs_extent_free(handle);
+		goto no_blocks;
+	}
+
+	/* block mapped file; see if block zero is mapped? */
+	if (inode->i_block[0])
+		return inode->i_block[0];
+
+no_blocks:
+	log_flex = fs->super->s_log_groups_per_flex;
+	group = ext2fs_group_of_ino(fs, ino);
+	if (log_flex)
+		group = group & ~((1 << (log_flex)) - 1);
+	return ext2fs_group_first_block2(fs, group);
+}
diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
index f819e9c..cb3f5a1 100644
--- a/lib/ext2fs/bmap.c
+++ b/lib/ext2fs/bmap.c
@@ -244,7 +244,7 @@ got_block:
 		retval = extent_bmap(fs, ino, inode, handle, block_buf,
 				     0, block-1, 0, blocks_alloc, &blk64);
 		if (retval)
-			blk64 = 0;
+			blk64 = ext2fs_find_inode_goal(fs, ino, inode, block);
 		retval = ext2fs_alloc_block2(fs, blk64, block_buf,
 					     &blk64);
 		if (retval)
@@ -354,7 +354,8 @@ errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
 		}
 
 		*phys_blk = inode_bmap(inode, block);
-		b = block ? inode_bmap(inode, block-1) : 0;
+		b = block ? inode_bmap(inode, block - 1) :
+			    ext2fs_find_inode_goal(fs, ino, inode, block);
 
 		if ((*phys_blk == 0) && (bmap_flags & BMAP_ALLOC)) {
 			retval = ext2fs_alloc_block(fs, b, block_buf, &b);
diff --git a/lib/ext2fs/expanddir.c b/lib/ext2fs/expanddir.c
index ecc13ae..9f02312 100644
--- a/lib/ext2fs/expanddir.c
+++ b/lib/ext2fs/expanddir.c
@@ -102,9 +102,13 @@ errcode_t ext2fs_expand_dir(ext2_filsys fs, ext2_ino_t dir)
 	if (retval)
 		return retval;
 
+	retval = ext2fs_read_inode(fs, dir, &inode);
+	if (retval)
+		return retval;
+
 	es.done = 0;
 	es.err = 0;
-	es.goal = 0;
+	es.goal = ext2fs_find_inode_goal(fs, dir, &inode, 0);
 	es.newblocks = 0;
 	es.dir = dir;
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index f9599a3..afe4fd5 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -689,6 +689,8 @@ extern void ext2fs_set_alloc_block_callback(ext2_filsys fs,
 					    errcode_t (**old)(ext2_filsys fs,
 							      blk64_t goal,
 							      blk64_t *ret));
+blk64_t ext2fs_find_inode_goal(ext2_filsys fs, ext2_ino_t ino,
+			       struct ext2_inode *inode, blk64_t lblk);
 
 /* alloc_sb.c */
 extern int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index c397e00..70bc3f9 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -374,7 +374,6 @@ static errcode_t prep_ea_block_for_write(ext2_filsys fs, ext2_ino_t ino,
 {
 	struct ext2_ext_attr_header *header;
 	void *block_buf = NULL;
-	dgrp_t grp;
 	blk64_t blk, goal;
 	errcode_t err;
 
@@ -420,8 +419,7 @@ static errcode_t prep_ea_block_for_write(ext2_filsys fs, ext2_ino_t ino,
 	}
 
 	/* Allocate a block */
-	grp = ext2fs_group_of_ino(fs, ino);
-	goal = ext2fs_inode_table_loc(fs, grp);
+	goal = ext2fs_find_inode_goal(fs, ino, (struct ext2_inode *)inode, 0);
 	err = ext2fs_alloc_block2(fs, goal, NULL, &blk);
 	if (err)
 		goto out2;
diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index ca5b78b..b6e4fbd 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -1012,14 +1012,9 @@ static errcode_t extent_node_split(ext2_extent_handle_t handle,
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
+		goal_blk = ext2fs_find_inode_goal(handle->fs, handle->ino,
+						  handle->inode, 0);
 	retval = ext2fs_alloc_block2(handle->fs, goal_blk, block_buf,
 				    &new_node_pblk);
 	if (retval)
diff --git a/lib/ext2fs/mkdir.c b/lib/ext2fs/mkdir.c
index c4c7967..433f3b4 100644
--- a/lib/ext2fs/mkdir.c
+++ b/lib/ext2fs/mkdir.c
@@ -68,8 +68,12 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	/*
 	 * Allocate a data block for the directory
 	 */
+	memset(&inode, 0, sizeof(struct ext2_inode));
 	if (!inline_data) {
-		retval = ext2fs_new_block2(fs, 0, 0, &blk);
+		retval = ext2fs_new_block2(fs, ext2fs_find_inode_goal(fs, ino,
+								      &inode,
+								      0),
+					   NULL, &blk);
 		if (retval)
 			goto cleanup;
 	}
@@ -77,7 +81,6 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	/*
 	 * Create a scratch template for the directory
 	 */
-	memset(&inode, 0, sizeof(struct ext2_inode));
 	if (inline_data)
 		retval = ext2fs_new_dir_inline_data(fs, ino, parent,
 						    inode.i_block);
diff --git a/lib/ext2fs/symlink.c b/lib/ext2fs/symlink.c
index f6eb6b6..0732afe 100644
--- a/lib/ext2fs/symlink.c
+++ b/lib/ext2fs/symlink.c
@@ -51,9 +51,13 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	/*
 	 * Allocate a data block for slow links
 	 */
+	memset(&inode, 0, sizeof(struct ext2_inode));
 	fastlink = (target_len < sizeof(inode.i_block));
 	if (!fastlink) {
-		retval = ext2fs_new_block2(fs, 0, 0, &blk);
+		retval = ext2fs_new_block2(fs, ext2fs_find_inode_goal(fs, ino,
+								      &inode,
+								      0),
+					   NULL, &blk);
 		if (retval)
 			goto cleanup;
 		retval = ext2fs_get_mem(fs->blocksize, &block_buf);
@@ -74,7 +78,6 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	/*
 	 * Create the inode structure....
 	 */
-	memset(&inode, 0, sizeof(struct ext2_inode));
 	inode.i_mode = LINUX_S_IFLNK | 0777;
 	inode.i_uid = inode.i_gid = 0;
 	inode.i_links_count = 1;
diff --git a/tests/f_extent_oobounds/script b/tests/f_extent_oobounds/script
index b00b031..54674ca 100644
--- a/tests/f_extent_oobounds/script
+++ b/tests/f_extent_oobounds/script
@@ -7,6 +7,9 @@ dd if=/dev/zero of=$TMPFILE bs=1k count=256 > /dev/null 2>&1
 $MKE2FS -Ft ext4 $TMPFILE > /dev/null 2>&1
 $DEBUGFS -w $TMPFILE << EOF  > /dev/null 2>&1
 write /dev/null testfile
+setb 100 15
+setb 130 30
+setb 200 30
 extent_open testfile
   insert_node 0 15 100
   insert_node --after 15 15 115
@@ -22,9 +25,6 @@ extent_open testfile
   extent_close
 set_inode_field testfile i_size 61400
 set_inode_field testfile i_blocks 154
-setb 100 15
-setb 130 30
-setb 200 30
 set_bg 0 free_blocks_count 156
 set_bg 0 bg_checksum calc
 set_super_value free_blocks_count 156
diff --git a/tests/f_extents2/expect.1 b/tests/f_extents2/expect.1
index fa7f6eb..51e36ff 100644
--- a/tests/f_extents2/expect.1
+++ b/tests/f_extents2/expect.1
@@ -55,7 +55,7 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-Block bitmap differences:  -(26--34) -(154--199)
+Block bitmap differences:  -(25--34) -(155--199)
 Fix? yes
 
 Free blocks count wrong for group #0 (65535, counted=55).

