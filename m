From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC v1 1/4] resize2fs: allocate ext2_resize_t outside of
 resize_fs
Date: Thu, 12 Mar 2015 19:20:12 +0300
Message-ID: <20150312162012.17173.29592.stgit@buzz>
References: <20150312161341.17173.96760.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Li Xi <pkuelelixi@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from forward-corp1m.cmail.yandex.net ([5.255.216.100]:46012 "EHLO
	forward-corp1m.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932203AbbCLQUR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Mar 2015 12:20:17 -0400
In-Reply-To: <20150312161341.17173.96760.stgit@buzz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This structure will be used for passing more parameters into resize_fs().

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 resize/main.c      |   22 +++++++++++++++++++---
 resize/resize2fs.c |   42 ++++++++++++++----------------------------
 resize/resize2fs.h |    7 +++----
 3 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/resize/main.c b/resize/main.c
index c25de61947f3..16f48d438cb0 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -187,6 +187,7 @@ int main (int argc, char ** argv)
 	long		sysval;
 	int		len, mount_flags;
 	char		*mtpt;
+	ext2_resize_t	rfs;
 
 #ifdef ENABLE_NLS
 	setlocale(LC_MESSAGES, "");
@@ -203,6 +204,15 @@ int main (int argc, char ** argv)
 	if (argc && *argv)
 		program_name = *argv;
 
+	/*
+	 * Create the data structure
+	 */
+	retval = ext2fs_get_memzero(sizeof(struct ext2_resize_struct), &rfs);
+	if (retval) {
+		com_err("resize2fs", retval, "can't allocate data structure\n");
+		exit(1);
+	}
+
 	while ((c = getopt(argc, argv, "d:fFhMPpS:bs")) != EOF) {
 		switch (c) {
 		case 'h':
@@ -526,9 +536,14 @@ int main (int argc, char ** argv)
 			printf(_("Resizing the filesystem on "
 				 "%s to %llu (%dk) blocks.\n"),
 			       device_name, new_size, blocksize / 1024);
-		retval = resize_fs(fs, &new_size, flags,
-				   ((flags & RESIZE_PERCENT_COMPLETE) ?
-				    resize_progress_func : 0));
+
+		rfs->flags = flags;
+		rfs->new_size = new_size;
+		if (flags & RESIZE_PERCENT_COMPLETE)
+			rfs->progress = resize_progress_func;
+
+		retval = resize_fs(fs, rfs);
+		new_size = rfs->new_size;
 	}
 	free(mtpt);
 	if (retval) {
@@ -562,5 +577,6 @@ int main (int argc, char ** argv)
 	if (fd > 0)
 		close(fd);
 	remove_error_table(&et_ext2_error_table);
+	ext2fs_free_mem(&rfs);
 	return (0);
 }
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 041ff75029b2..dead364bf4bf 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -42,7 +42,7 @@
 #endif
 
 static void fix_uninit_block_bitmaps(ext2_filsys fs);
-static errcode_t adjust_superblock(ext2_resize_t rfs, blk64_t new_size);
+static errcode_t adjust_superblock(ext2_resize_t rfs);
 static errcode_t blocks_to_move(ext2_resize_t rfs);
 static errcode_t block_mover(ext2_resize_t rfs);
 static errcode_t inode_scan_and_fix(ext2_resize_t rfs);
@@ -56,7 +56,7 @@ static errcode_t mark_table_blocks(ext2_filsys fs,
 static errcode_t clear_sparse_super2_last_group(ext2_resize_t rfs);
 static errcode_t reserve_sparse_super2_last_group(ext2_resize_t rfs,
 						 ext2fs_block_bitmap meta_bmap);
-static errcode_t resize_group_descriptors(ext2_resize_t rfs, blk64_t new_size);
+static errcode_t resize_group_descriptors(ext2_resize_t rfs);
 static errcode_t move_bg_metadata(ext2_resize_t rfs);
 static errcode_t zero_high_bits_in_inodes(ext2_resize_t rfs);
 
@@ -84,28 +84,15 @@ static int lazy_itable_init;
 /*
  * This is the top-level routine which does the dirty deed....
  */
-errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
-	    errcode_t (*progress)(ext2_resize_t rfs, int pass,
-					  unsigned long cur,
-					  unsigned long max_val))
+errcode_t resize_fs(ext2_filsys fs, ext2_resize_t rfs)
 {
-	ext2_resize_t	rfs;
 	errcode_t	retval;
 	struct resource_track	rtrack, overall_track;
+	int flags = rfs->flags;
 
-	/*
-	 * Create the data structure
-	 */
-	retval = ext2fs_get_mem(sizeof(struct ext2_resize_struct), &rfs);
-	if (retval)
-		return retval;
-
-	memset(rfs, 0, sizeof(struct ext2_resize_struct));
-	fs->priv_data = rfs;
 	rfs->old_fs = fs;
-	rfs->flags = flags;
-	rfs->itable_buf	 = 0;
-	rfs->progress = progress;
+	fs->priv_data = rfs;
+	rfs->itable_buf = 0;
 
 	init_resource_track(&overall_track, "overall resize2fs", fs->io);
 	init_resource_track(&rtrack, "read_bitmaps", fs->io);
@@ -126,7 +113,7 @@ errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
 		goto errout;
 
 	init_resource_track(&rtrack, "resize_group_descriptors", fs->io);
-	retval = resize_group_descriptors(rfs, *new_size);
+	retval = resize_group_descriptors(rfs);
 	if (retval)
 		goto errout;
 	print_resource_track(rfs, &rtrack, fs->io);
@@ -144,7 +131,7 @@ errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
 	print_resource_track(rfs, &rtrack, fs->io);
 
 	init_resource_track(&rtrack, "adjust_superblock", fs->io);
-	retval = adjust_superblock(rfs, *new_size);
+	retval = adjust_superblock(rfs);
 	if (retval)
 		goto errout;
 	print_resource_track(rfs, &rtrack, fs->io);
@@ -156,7 +143,7 @@ errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
 	ext2fs_bg_flags_clear(rfs->new_fs, rfs->new_fs->group_desc_count - 1,
 			     EXT2_BG_BLOCK_UNINIT);
 
-	*new_size = ext2fs_blocks_count(rfs->new_fs->super);
+	rfs->new_size = ext2fs_blocks_count(rfs->new_fs->super);
 
 	init_resource_track(&rtrack, "blocks_to_move", fs->io);
 	retval = blocks_to_move(rfs);
@@ -240,7 +227,6 @@ errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
 		ext2fs_free_block_bitmap(rfs->reserve_blocks);
 	if (rfs->move_blocks)
 		ext2fs_free_block_bitmap(rfs->move_blocks);
-	ext2fs_free_mem(&rfs);
 
 	return 0;
 
@@ -251,7 +237,6 @@ errout:
 	}
 	if (rfs->itable_buf)
 		ext2fs_free_mem(&rfs->itable_buf);
-	ext2fs_free_mem(&rfs);
 	return retval;
 }
 
@@ -274,7 +259,7 @@ static void adjust_reserved_gdt_blocks(ext2_filsys old_fs, ext2_filsys fs)
 }
 
 /* Toggle 64bit mode */
-static errcode_t resize_group_descriptors(ext2_resize_t rfs, blk64_t new_size)
+static errcode_t resize_group_descriptors(ext2_resize_t rfs)
 {
 	void *o, *n, *new_group_desc;
 	dgrp_t i;
@@ -284,7 +269,7 @@ static errcode_t resize_group_descriptors(ext2_resize_t rfs, blk64_t new_size)
 	if (!(rfs->flags & (RESIZE_DISABLE_64BIT | RESIZE_ENABLE_64BIT)))
 		return 0;
 
-	if (new_size != ext2fs_blocks_count(rfs->new_fs->super) ||
+	if (rfs->new_size != ext2fs_blocks_count(rfs->new_fs->super) ||
 	    ext2fs_blocks_count(rfs->new_fs->super) >= (1ULL << 32) ||
 	    (rfs->flags & RESIZE_DISABLE_64BIT &&
 	     rfs->flags & RESIZE_ENABLE_64BIT))
@@ -1006,7 +991,7 @@ errout:
  * This routine adjusts the superblock and other data structures, both
  * in disk as well as in memory...
  */
-static errcode_t adjust_superblock(ext2_resize_t rfs, blk64_t new_size)
+static errcode_t adjust_superblock(ext2_resize_t rfs)
 {
 	ext2_filsys	fs = rfs->new_fs;
 	int		adj = 0;
@@ -1024,7 +1009,8 @@ static errcode_t adjust_superblock(ext2_resize_t rfs, blk64_t new_size)
 	if (retval)
 		return retval;
 
-	retval = adjust_fs_info(fs, rfs->old_fs, rfs->reserve_blocks, new_size);
+	retval = adjust_fs_info(fs, rfs->old_fs,
+				rfs->reserve_blocks, rfs->new_size);
 	if (retval)
 		goto errout;
 
diff --git a/resize/resize2fs.h b/resize/resize2fs.h
index 829fcd8ea8e1..c5377e2b06c3 100644
--- a/resize/resize2fs.h
+++ b/resize/resize2fs.h
@@ -128,6 +128,8 @@ struct ext2_resize_struct {
 				    unsigned long cur,
 				    unsigned long max);
 	void		*prog_data;
+
+	blk64_t		new_size;
 };
 
 /*
@@ -141,10 +143,7 @@ struct ext2_resize_struct {
 
 
 /* prototypes */
-extern errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
-			   errcode_t	(*progress)(ext2_resize_t rfs,
-					    int pass, unsigned long cur,
-					    unsigned long max));
+extern errcode_t resize_fs(ext2_filsys fs, ext2_resize_t rfs);
 
 extern errcode_t adjust_fs_info(ext2_filsys fs, ext2_filsys old_fs,
 				ext2fs_block_bitmap reserve_blocks,

