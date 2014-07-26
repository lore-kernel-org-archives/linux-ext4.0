From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/18] e2fsck: reserve blocks for root/lost+found directory
 repair
Date: Fri, 25 Jul 2014 17:33:45 -0700
Message-ID: <20140726003345.28334.14376.stgit@birch.djwong.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31733 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaGZAdz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jul 2014 20:33:55 -0400
In-Reply-To: <20140726003339.28334.54447.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we think we're going to need to repair either the root directory or
the lost+found directory, reserve a block at the end of pass 1 to
reduce the likelihood of an e2fsck abort while reconstructing
root/lost+found during pass 3.

If / and/or /lost+found are corrupt and duplicate processing in pass
1b allocates all the free blocks in the FS, fsck aborts with an
unusable FS since pass 3 can't recreate / or /lost+found.  If either
of those directories are missing, an admin can't easily mount the FS
and access the directory tree to move files off the injured FS and
free up space; this in turn prevents subsequent runs of e2fsck from
being able to continue repairs of the FS.

(One could migrate files manually with debugfs without the help of
path names, but it seems easier if users can simply mount the FS and
use regular FS management tools.)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/e2fsck.h          |    3 +++
 e2fsck/pass1.c           |   39 +++++++++++++++++++++++++++++++++++++++
 e2fsck/pass3.c           |   23 +++++++++++++++++++++++
 tests/f_holedir/expect.1 |    2 +-
 tests/f_holedir/expect.2 |    2 +-
 5 files changed, 67 insertions(+), 2 deletions(-)


diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index d6d0ba9..76d15c4 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -375,6 +375,9 @@ struct e2fsck_struct {
 	 */
 	void *priv_data;
 	ext2fs_block_bitmap block_metadata_map; /* Metadata blocks */
+
+	/* Reserve blocks for root and l+f re-creation */
+	blk64_t root_repair_block, lnf_repair_block;
 };
 
 /* Used by the region allocation code */
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 10ffe39..c116e1c 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -601,6 +601,42 @@ static errcode_t recheck_bad_inode_checksum(ext2_filsys fs, ext2_ino_t ino,
 	return 0;
 }
 
+static void reserve_block_for_root_repair(e2fsck_t ctx)
+{
+	blk64_t		blk = 0;
+	errcode_t	err;
+	ext2_filsys	fs = ctx->fs;
+
+	ctx->root_repair_block = 0;
+	if (ext2fs_test_inode_bitmap2(ctx->inode_used_map, EXT2_ROOT_INO))
+		return;
+
+	err = ext2fs_new_block2(fs, 0, ctx->block_found_map, &blk);
+	if (err)
+		return;
+	ext2fs_mark_block_bitmap2(ctx->block_found_map, blk);
+	ctx->root_repair_block = blk;
+}
+
+static void reserve_block_for_lnf_repair(e2fsck_t ctx)
+{
+	blk64_t		blk = 0;
+	errcode_t	err;
+	ext2_filsys	fs = ctx->fs;
+	const char	*name = "lost+found";
+	ext2_ino_t	ino;
+
+	ctx->lnf_repair_block = 0;
+	if (!ext2fs_lookup(fs, EXT2_ROOT_INO, name, sizeof(name)-1, 0, &ino))
+		return;
+
+	err = ext2fs_new_block2(fs, 0, ctx->block_found_map, &blk);
+	if (err)
+		return;
+	ext2fs_mark_block_bitmap2(ctx->block_found_map, blk);
+	ctx->lnf_repair_block = blk;
+}
+
 void e2fsck_pass1(e2fsck_t ctx)
 {
 	int	i;
@@ -1357,6 +1393,9 @@ endit:
 	if (inode)
 		ext2fs_free_mem(&inode);
 
+	reserve_block_for_root_repair(ctx);
+	reserve_block_for_lnf_repair(ctx);
+
 	/*
 	 * The l+f inode may have been cleared, so zap it now and
 	 * later passes will recalculate it if necessary
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index 4fc390a..92e71e7 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -134,6 +134,17 @@ abort_exit:
 		inode_done_map = 0;
 	}
 
+	if (ctx->lnf_repair_block) {
+		ext2fs_unmark_block_bitmap2(ctx->block_found_map,
+					    ctx->lnf_repair_block);
+		ctx->lnf_repair_block = 0;
+	}
+	if (ctx->root_repair_block) {
+		ext2fs_unmark_block_bitmap2(ctx->block_found_map,
+					    ctx->root_repair_block);
+		ctx->root_repair_block = 0;
+	}
+
 	print_resource_track(ctx, _("Pass 3"), &rtrack, ctx->fs->io);
 }
 
@@ -176,6 +187,11 @@ static void check_root(e2fsck_t ctx)
 	/*
 	 * First, find a free block
 	 */
+	if (ctx->root_repair_block) {
+		blk = ctx->root_repair_block;
+		ctx->root_repair_block = 0;
+		goto skip_new_block;
+	}
 	pctx.errcode = ext2fs_new_block2(fs, 0, ctx->block_found_map, &blk);
 	if (pctx.errcode) {
 		pctx.str = "ext2fs_new_block";
@@ -184,6 +200,7 @@ static void check_root(e2fsck_t ctx)
 		return;
 	}
 	ext2fs_mark_block_bitmap2(ctx->block_found_map, blk);
+skip_new_block:
 	ext2fs_mark_block_bitmap2(fs->block_map, blk);
 	ext2fs_mark_bb_dirty(fs);
 
@@ -425,6 +442,11 @@ unlink:
 	/*
 	 * First, find a free block
 	 */
+	if (ctx->lnf_repair_block) {
+		blk = ctx->lnf_repair_block;
+		ctx->lnf_repair_block = 0;
+		goto skip_new_block;
+	}
 	retval = ext2fs_new_block2(fs, 0, ctx->block_found_map, &blk);
 	if (retval) {
 		pctx.errcode = retval;
@@ -432,6 +454,7 @@ unlink:
 		return 0;
 	}
 	ext2fs_mark_block_bitmap2(ctx->block_found_map, blk);
+skip_new_block:
 	ext2fs_block_alloc_stats2(fs, blk, +1);
 
 	/*
diff --git a/tests/f_holedir/expect.1 b/tests/f_holedir/expect.1
index ad74fa6..e9cf590 100644
--- a/tests/f_holedir/expect.1
+++ b/tests/f_holedir/expect.1
@@ -18,7 +18,7 @@ Directory inode 11 has an unallocated block #6.  Allocate? yes
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-Block bitmap differences:  -21
+Block bitmap differences:  -10
 Fix? yes
 
 Free blocks count wrong for group #0 (78, counted=79).
diff --git a/tests/f_holedir/expect.2 b/tests/f_holedir/expect.2
index 4c0b4f2..6ab6209 100644
--- a/tests/f_holedir/expect.2
+++ b/tests/f_holedir/expect.2
@@ -3,5 +3,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 11/32 files (0.0% non-contiguous), 21/100 blocks
+test_filesys: 11/32 files (9.1% non-contiguous), 21/100 blocks
 Exit status is 0

