From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/2] e2fsck: remove EXT4_EOFBLOCKS_FL flag handling
Date: Wed, 21 Mar 2012 13:34:52 +0100
Message-ID: <1332333293-25028-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755914Ab2CUMe7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Mar 2012 08:34:59 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We've decided to remove EOFBLOCKS_FL from the ext4 file system entirely,
because it is not actually very useful and it is causing more problems
than it solves. We're going to remove it from e2fsprogs first and then
after the new e2fsprogs version is common enough we can remove the
kernel part as well.

This commit changes e2fsck to not check for EOFBLOCKS_FL. Instead we
simply search for initialized extents past the i_size as this should not
happen. Uninitialized extents can be past the i_size as we can do
fallocate with KEEP_SIZE flag.

Also remove the EXT4_EOFBLOCKS_FL from lib/ext2fs/ext2_fs.h since it is
no longer needed.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 e2fsck/pass1.c       |   36 +++++++++++++++++-------------------
 e2fsck/problem.c     |    5 -----
 e2fsck/problem.h     |    3 +--
 lib/ext2fs/ext2_fs.h |    2 +-
 4 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 9f4142b..c7645d1 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -84,6 +84,7 @@ struct process_block_struct {
 	blk64_t		num_blocks;
 	blk64_t		max_blocks;
 	e2_blkcnt_t	last_block;
+	e2_blkcnt_t	last_init_lblock;
 	e2_blkcnt_t	last_db_block;
 	int		num_illegal_blocks;
 	blk64_t		previous_block;
@@ -1898,6 +1899,9 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			pb->last_db_block = blockcnt - 1;
 		pb->previous_block = extent.e_pblk + extent.e_len - 1;
 		start_block = pb->last_block = extent.e_lblk + extent.e_len - 1;
+		if (is_leaf && !is_dir &&
+		    !(extent.e_flags & EXT2_EXTENT_FLAGS_UNINIT))
+			pb->last_init_lblock = extent.e_lblk + extent.e_len - 1;
 	next:
 		pctx->errcode = ext2fs_extent_get(ehandle,
 						  EXT2_EXTENT_NEXT_SIB,
@@ -1964,6 +1968,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	pb.ino = ino;
 	pb.num_blocks = 0;
 	pb.last_block = -1;
+	pb.last_init_lblock = -1;
 	pb.last_db_block = -1;
 	pb.num_illegal_blocks = 0;
 	pb.suppress = 0; pb.clear = 0;
@@ -2004,10 +2009,16 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	if (ext2fs_inode_has_valid_blocks2(fs, inode)) {
 		if (extent_fs && (inode->i_flags & EXT4_EXTENTS_FL))
 			check_blocks_extents(ctx, pctx, &pb);
-		else
+		else {
 			pctx->errcode = ext2fs_block_iterate3(fs, ino,
 						pb.is_dir ? BLOCK_FLAG_HOLE : 0,
 						block_buf, process_block, &pb);
+			/*
+			 * We do not have uninitialized extents in non extent
+			 * files.
+			 */
+			pb.last_init_lblock = pb.last_block;
+		}
 	}
 	end_problem_latch(ctx, PR_LATCH_BLOCK);
 	end_problem_latch(ctx, PR_LATCH_TOOBIG);
@@ -2079,12 +2090,12 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		e2_blkcnt_t blkpg = ctx->blocks_per_page;
 
 		size = EXT2_I_SIZE(inode);
-		if ((pb.last_block >= 0) &&
+		if ((pb.last_init_lblock >= 0) &&
 		    /* allow allocated blocks to end of PAGE_SIZE */
-		    (size < (__u64)pb.last_block * fs->blocksize) &&
-		    (pb.last_block / blkpg * blkpg != pb.last_block ||
-		     size < (__u64)(pb.last_block & ~(blkpg-1)) *fs->blocksize) &&
-		    !(inode->i_flags & EXT4_EOFBLOCKS_FL))
+		    (size < (__u64)pb.last_init_lblock * fs->blocksize) &&
+		    (pb.last_init_lblock / blkpg * blkpg != pb.last_init_lblock ||
+		     size < (__u64)(pb.last_init_lblock & ~(blkpg-1)) *
+		     fs->blocksize))
 			bad_size = 3;
 		else if (!(extent_fs && (inode->i_flags & EXT4_EXTENTS_FL)) &&
 			 size > ext2_max_sizes[fs->super->s_log_block_size])
@@ -2095,19 +2106,6 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 			 ((1ULL << (32 + EXT2_BLOCK_SIZE_BITS(fs->super))) - 1))
 			/* too big for an extent-based file - 32bit ee_block */
 			bad_size = 6;
-
-		/*
-		 * Check to see if the EOFBLOCKS flag is set where it
-		 * doesn't need to be.
-		 */
-		if ((inode->i_flags & EXT4_EOFBLOCKS_FL) &&
-		    (size >= (((__u64)pb.last_block + 1) * fs->blocksize))) {
-			pctx->blkcount = pb.last_block;
-			if (fix_problem(ctx, PR_1_EOFBLOCKS_FL_SET, pctx)) {
-				inode->i_flags &= ~EXT4_EOFBLOCKS_FL;
-				dirty_inode++;
-			}
-		}
 	}
 	/* i_size for symlinks is checked elsewhere */
 	if (bad_size && !LINUX_S_ISLNK(inode->i_mode)) {
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index c66c6be..a156e40 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -906,11 +906,6 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i has an invalid extent node (blk %b, lblk %c)\n"),
 	  PROMPT_CLEAR, 0 },
 
-	{ PR_1_EOFBLOCKS_FL_SET,
-	  N_("@i %i should not have EOFBLOCKS_FL set "
-	     "(size %Is, lblk %r)\n"),
-	  PROMPT_CLEAR, PR_PREEN_OK },
-
 	/* Failed to convert subcluster bitmap */
 	{ PR_1_CONVERT_SUBCLUSTER,
 	  N_("Error converting subcluster @b @B: %m\n"),
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index f2bd414..7427c9f 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -532,8 +532,7 @@ struct problem_context {
 /* Extent node header invalid */
 #define PR_1_EXTENT_HEADER_INVALID	0x01005F
 
-/* EOFBLOCKS flag set when not necessary */
-#define PR_1_EOFBLOCKS_FL_SET		0x010060
+/* PR_1_EOFBLOCKS_FL_SET 0x010060 was here */
 
 /* Failed to convert subcluster bitmap */
 #define PR_1_CONVERT_SUBCLUSTER		0x010061
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 3b01285..20decff 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -300,7 +300,7 @@ struct ext2_dx_countlimit {
 #define EXT4_HUGE_FILE_FL               0x00040000 /* Set to each huge file */
 #define EXT4_EXTENTS_FL 		0x00080000 /* Inode uses extents */
 #define EXT4_EA_INODE_FL	        0x00200000 /* Inode used for large EA */
-#define EXT4_EOFBLOCKS_FL		0x00400000 /* Blocks allocated beyond EOF */
+/* EXT4_EOFBLOCKS_FL 0x00400000 was here */
 #define EXT4_SNAPFILE_FL		0x01000000  /* Inode is a snapshot */
 #define EXT4_SNAPFILE_DELETED_FL	0x04000000  /* Snapshot is being deleted */
 #define EXT4_SNAPFILE_SHRUNK_FL		0x08000000  /* Snapshot shrink has completed */
-- 
1.7.4.4

