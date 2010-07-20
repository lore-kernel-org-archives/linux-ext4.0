From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 10/12] e2fsprogs: Map maximum filesystem size with a single snapshot file
Date: Tue, 20 Jul 2010 18:16:11 +0300
Message-ID: <1279638973-14561-11-git-send-email-amir73il@users.sf.net>
References: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
Cc: linux-ext4@vger.kernel.org, Amir Goldstein <amir73il@users.sf.net>
To: tytso@mit.edu, andreas.dilger@oracle.com, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42770 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339Ab0GTPRy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Jul 2010 11:17:54 -0400
Received: by mail-ww0-f44.google.com with SMTP id 40so968910wwj.1
        for <linux-ext4@vger.kernel.org>; Tue, 20 Jul 2010 08:17:54 -0700 (PDT)
In-Reply-To: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

To map 2^32 logical blocks, 4 triple indirect blocks are used instead
of just one.  The extra 3 triple indirect blocks are stored in-place
of direct blocks, which are not in use by snapshot files.
Snapshots cannot be enabled on filesytem with block size < 4K.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 e2fsck/pass1.c       |   14 ++++++++++----
 lib/ext2fs/block.c   |   15 +++++++++++++++
 lib/ext2fs/bmap.c    |   19 +++++++++++++++++--
 lib/ext2fs/ext2_fs.h |   11 +++++++++++
 lib/ext2fs/i_block.c |   12 +++++++++---
 misc/e2image.c       |    1 +
 6 files changed, 63 insertions(+), 9 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index daecce6..cd4432b 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1081,6 +1081,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 		    (inode->i_block[EXT2_IND_BLOCK] ||
 		     inode->i_block[EXT2_DIND_BLOCK] ||
 		     inode->i_block[EXT2_TIND_BLOCK] ||
+		     (inode->i_flags & EXT4_SNAPFILE_FL) ||
 		     ext2fs_file_acl_block(inode))) {
 			inodes_to_process[process_inode_count].ino = ino;
 			inodes_to_process[process_inode_count].inode = *inode;
@@ -2007,8 +2008,10 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		}
 	}
 
-	if (!(fs->super->s_feature_ro_compat &
-	      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ||
+	if ((!(fs->super->s_feature_ro_compat &
+	       EXT4_FEATURE_RO_COMPAT_HUGE_FILE) &&
+	     /* snapshot file always supports the 'huge_file' flag */
+	     !(inode->i_flags & EXT4_SNAPFILE_FL)) ||
 	    !(inode->i_flags & EXT4_HUGE_FILE_FL))
 		pb.num_blocks *= (fs->blocksize / 512);
 #if 0
@@ -2039,6 +2042,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		    !(inode->i_flags & EXT4_EOFBLOCKS_FL))
 			bad_size = 3;
 		else if (!(extent_fs && (inode->i_flags & EXT4_EXTENTS_FL)) &&
+			 !(pb.is_reg && (inode->i_flags & EXT4_SNAPFILE_FL)) &&
 			 size > ext2_max_sizes[fs->super->s_log_block_size])
 			/* too big for a direct/indirect-mapped file */
 			bad_size = 4;
@@ -2077,8 +2081,10 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	    (inode->i_size_high || inode->i_size & 0x80000000UL))
 		ctx->large_files++;
 	if ((pb.num_blocks != ext2fs_inode_i_blocks(fs, inode)) ||
-	    ((fs->super->s_feature_ro_compat &
-	      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) &&
+	    (((fs->super->s_feature_ro_compat &
+	       EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ||
+	      /* snapshot file always supports the 'huge_file' flag */
+	      (inode->i_flags & EXT4_SNAPFILE_FL)) &&
 	     (inode->i_flags & EXT4_HUGE_FILE_FL) &&
 	     (inode->osd2.linux2.l_i_blocks_hi != 0))) {
 		pctx->num = pb.num_blocks;
diff --git a/lib/ext2fs/block.c b/lib/ext2fs/block.c
index ff0d8bd..dfc0791 100644
--- a/lib/ext2fs/block.c
+++ b/lib/ext2fs/block.c
@@ -484,6 +484,12 @@ errcode_t ext2fs_block_iterate3(ext2_filsys fs,
 	 * Iterate over normal data blocks
 	 */
 	for (i = 0; i < EXT2_NDIR_BLOCKS ; i++, ctx.bcount++) {
+		if ((inode.i_flags & EXT4_SNAPFILE_FL) &&
+				LINUX_S_ISREG(inode.i_mode) &&
+				i < NEXT3_EXTRA_TIND_BLOCKS)
+			/* snapshot file extra triple indirect blocks */
+			continue;
+
 		if (inode.i_block[i] || (flags & BLOCK_FLAG_APPEND)) {
 			blk64 = inode.i_block[i];
 			ret |= (*ctx.func)(fs, &blk64, ctx.bcount, 0, i, 
@@ -514,6 +520,15 @@ errcode_t ext2fs_block_iterate3(ext2_filsys fs,
 		if (ret & BLOCK_ABORT)
 			goto abort_exit;
 	}
+	if ((inode.i_flags & EXT4_SNAPFILE_FL) && LINUX_S_ISREG(inode.i_mode)) {
+		/* iterate snapshot file extra triple indirect blocks */
+		for (i = 0; i < NEXT3_EXTRA_TIND_BLOCKS; i++) {
+			ret |= block_iterate_tind(&inode.i_block[i],
+						  0, EXT2_N_BLOCKS+i, &ctx);
+			if (ret & BLOCK_ABORT)
+				goto abort_exit;
+		}
+	}
 
 abort_exit:
 	if (ret & BLOCK_CHANGED) {
diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
index fbcb375..d92e981 100644
--- a/lib/ext2fs/bmap.c
+++ b/lib/ext2fs/bmap.c
@@ -136,6 +136,8 @@ errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
 	struct ext2_inode inode_buf;
 	ext2_extent_handle_t handle = 0;
 	blk_t addr_per_block;
+	blk64_t addr_per_tind_block;
+	int	tind;
 	blk_t	b, blk32;
 	char	*buf = 0;
 	errcode_t	retval = 0;
@@ -286,7 +288,20 @@ errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
 
 	/* Triply indirect block */
 	block -= addr_per_block * addr_per_block;
-	b = inode_bmap(inode, EXT2_TIND_BLOCK);
+	tind = EXT2_TIND_BLOCK;
+	addr_per_tind_block = addr_per_block * addr_per_block * addr_per_block;
+	if (block > addr_per_tind_block) {
+		/* use direct blocks as extra triple indirect blocks? */
+		tind = block / addr_per_tind_block;
+		block -= tind * addr_per_tind_block;
+		if (!(inode->i_flags & EXT4_SNAPFILE_FL) ||
+				!LINUX_S_ISREG(inode->i_mode) ||
+				tind >= NEXT3_EXTRA_TIND_BLOCKS) {
+			retval = EXT2_ET_BAD_BLOCK_NUM;
+			goto done;
+		}
+	}
+	b = inode_bmap(inode, tind);
 	if (!b) {
 		if (!(bmap_flags & BMAP_ALLOC)) {
 			if (bmap_flags & BMAP_SET)
@@ -298,7 +313,7 @@ errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino, struct ext2_inode *inode,
 		retval = ext2fs_alloc_block(fs, b, block_buf, &b);
 		if (retval)
 			goto done;
-		inode_bmap(inode, EXT2_TIND_BLOCK) = b;
+		inode_bmap(inode, tind) = b;
 		blocks_alloc++;
 	}
 	retval = block_tind_bmap(fs, bmap_flags, b, block_buf,
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 8e850eb..3a48486 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -250,6 +250,17 @@ struct ext2_dx_countlimit {
 #define EXT2_DIND_BLOCK			(EXT2_IND_BLOCK + 1)
 #define EXT2_TIND_BLOCK			(EXT2_DIND_BLOCK + 1)
 #define EXT2_N_BLOCKS			(EXT2_TIND_BLOCK + 1)
+/*
+ * Snapshot files have different indirection mapping that can map up to 2^32
+ * logical blocks, so they can cover the mapped filesystem block address space.
+ * Next3 must use either 4K or 8K blocks (depending on PAGE_SIZE).
+ * With 8K blocks, 1 triple indirect block maps 2^33 logical blocks.
+ * With 4K blocks (the system default), each triple indirect block maps 2^30
+ * logical blocks, so 4 triple indirect blocks map 2^32 logical blocks.
+ * Snapshot files in small filesystems (<= 4G), use only 1 double indirect
+ * block to map the entire filesystem.
+ */
+#define	NEXT3_EXTRA_TIND_BLOCKS		3
 
 /*
  * Inode flags
diff --git a/lib/ext2fs/i_block.c b/lib/ext2fs/i_block.c
index 822776d..8079d8e 100644
--- a/lib/ext2fs/i_block.c
+++ b/lib/ext2fs/i_block.c
@@ -31,8 +31,10 @@ errcode_t ext2fs_iblk_add_blocks(ext2_filsys fs, struct ext2_inode *inode,
 {
 	unsigned long long b = inode->i_blocks;
 
-	if (!(fs->super->s_feature_ro_compat &
+	if (!((fs->super->s_feature_ro_compat &
 	      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ||
+	     /* snapshot file always supports the 'huge_file' flag */
+	     (inode->i_flags & EXT4_SNAPFILE_FL)) ||
 	    !(inode->i_flags & EXT4_HUGE_FILE_FL))
 	    num_blocks *= fs->blocksize / 512;
 
@@ -53,8 +55,10 @@ errcode_t ext2fs_iblk_sub_blocks(ext2_filsys fs, struct ext2_inode *inode,
 {
 	unsigned long long b = inode->i_blocks;
 
-	if (!(fs->super->s_feature_ro_compat &
+	if (!((fs->super->s_feature_ro_compat &
 	      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ||
+	     /* snapshot file always supports the 'huge_file' flag */
+	     (inode->i_flags & EXT4_SNAPFILE_FL)) ||
 	    !(inode->i_flags & EXT4_HUGE_FILE_FL))
 	    num_blocks *= fs->blocksize / 512;
 
@@ -74,8 +78,10 @@ errcode_t ext2fs_iblk_sub_blocks(ext2_filsys fs, struct ext2_inode *inode,
 
 errcode_t ext2fs_iblk_set(ext2_filsys fs, struct ext2_inode *inode, blk64_t b)
 {
-	if (!(fs->super->s_feature_ro_compat &
+	if (!((fs->super->s_feature_ro_compat &
 	      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ||
+	     /* snapshot file always supports the 'huge_file' flag */
+	     (inode->i_flags & EXT4_SNAPFILE_FL)) ||
 	    !(inode->i_flags & EXT4_HUGE_FILE_FL))
 		b *= fs->blocksize / 512;
 
diff --git a/misc/e2image.c b/misc/e2image.c
index 003ac5a..d9e0681 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -536,6 +536,7 @@ static void write_raw_image_file(ext2_filsys fs, int fd, int scramble_flag)
 			}
 		} else {
 			if ((inode.i_flags & EXT4_EXTENTS_FL) ||
+			    (inode.i_flags & EXT4_SNAPFILE_FL) ||
 			    inode.i_block[EXT2_IND_BLOCK] ||
 			    inode.i_block[EXT2_DIND_BLOCK] ||
 			    inode.i_block[EXT2_TIND_BLOCK]) {
-- 
1.6.6

