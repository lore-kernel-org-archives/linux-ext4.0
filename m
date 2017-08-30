From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 2/2] ext2fs: improve expand_dir performance
Date: Wed, 30 Aug 2017 01:47:25 -0600
Message-ID: <1504079245-49002-2-git-send-email-adilger@dilger.ca>
References: <1504079245-49002-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-so.shaw.ca ([64.59.136.139]:60430 "EHLO
        smtp-out-so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751295AbdH3Hr1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 30 Aug 2017 03:47:27 -0400
In-Reply-To: <1504079245-49002-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Previously, ext2fs_expand_dir() in mke2fs and debugfs could
only add one block at a time after scanning the whole directory,
which was very slow if a large number of directory leaf blocks
are being added at once (in particular for the f_large_dir test).

Add a new ext2fs_expand_dir2() function that takes the number
of blocks to add to the directory and add them all at once, and
call that from mke2fs (to create lost+found) and debugfs (with
an optional 3rd argument to the "expand_dir" command).

Fix expand_dir_proc() to expand inline directories before trying
to add more blocks, to distinguish between adding blocks and
clusters, and not count added indirect/index blocks as leaves.

Have create_lost_and_found() round up to a full bigalloc chunk,
as there is little benefit if unused blocks in the same chunk
are left "free" since they can't be used for anything else.

This speeds up f_large_dir with 65000 files from 4232s to 4141s.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 debugfs/debugfs.8.in     |  9 ++++++--
 debugfs/debugfs.c        | 23 +++++++++++++++++----
 lib/ext2fs/expanddir.c   | 53 ++++++++++++++++++++++++++++++++----------------
 lib/ext2fs/ext2fs.h      |  2 ++
 misc/mke2fs.c            | 27 +++++++++++++-----------
 tests/f_large_dir/script |  4 +---
 6 files changed, 79 insertions(+), 39 deletions(-)

diff --git a/debugfs/debugfs.8.in b/debugfs/debugfs.8.in
index 87d487e..e3f54c1 100644
--- a/debugfs/debugfs.8.in
+++ b/debugfs/debugfs.8.in
@@ -316,9 +316,14 @@ Remove the extended attribute
 .I attr_name
 from the file \fIfilespec\fR.
 .TP
-.BI expand_dir " filespec"
+.B expand_dir
+.I filespec
+.RI [ blocks_to_add ]
 Expand the directory
-.IR filespec .
+.I filespec
+by
+.I blocks_to_add
+blocks, or 1 block if unspecified.
 .TP
 .BI fallocate " filespec start_block [end_block]
 Allocate and map uninitialized blocks into \fIfilespec\fR between
diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 0a4b536..868cbbd 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -1965,15 +1965,30 @@ void do_show_debugfs_params(int argc EXT2FS_ATTR((unused)),
 #ifndef READ_ONLY
 void do_expand_dir(int argc, char *argv[])
 {
-	ext2_ino_t inode;
+	ext2_ino_t ino;
+	int add_blocks;
 	int retval;
 
-	if (common_inode_args_process(argc, argv, &inode, CHECK_FS_RW))
+	if (common_args_process(argc, argv, 2, 3, argv[0],
+				"<file> [blocks_to_add]",
+				CHECK_FS_RW | CHECK_FS_BITMAPS))
+		return;
+
+	ino = string_to_inode(argv[1]);
+	if (!ino)
 		return;
 
-	retval = ext2fs_expand_dir(current_fs, inode);
+	if (argc == 3) {
+		add_blocks = parse_ulong(argv[2], argv[1], "blocks_to_add",
+					 &retval);
+		if (retval)
+			return;
+	} else {
+		add_blocks = 1;
+	}
+	retval = ext2fs_expand_dir2(current_fs, ino, add_blocks);
 	if (retval)
-		com_err("ext2fs_expand_dir", retval, 0);
+		com_err("ext2fs_expand_dir2", retval, 0);
 	return;
 }
 
diff --git a/lib/ext2fs/expanddir.c b/lib/ext2fs/expanddir.c
index 9f02312..d88861e 100644
--- a/lib/ext2fs/expanddir.c
+++ b/lib/ext2fs/expanddir.c
@@ -21,11 +21,13 @@
 #include "ext2fsP.h"
 
 struct expand_dir_struct {
-	int		done;
-	int		newblocks;
+	unsigned	done:1;
+	unsigned	clusters_added;
 	blk64_t		goal;
 	errcode_t	err;
 	ext2_ino_t	dir;
+	unsigned	blocks_to_add;
+	unsigned	blocks_added;
 };
 
 static int expand_dir_proc(ext2_filsys	fs,
@@ -35,7 +37,7 @@ static int expand_dir_proc(ext2_filsys	fs,
 			   int		ref_offset EXT2FS_ATTR((unused)),
 			   void		*priv_data)
 {
-	struct expand_dir_struct *es = (struct expand_dir_struct *) priv_data;
+	struct expand_dir_struct *es = priv_data;
 	blk64_t	new_blk;
 	char		*block;
 	errcode_t	retval;
@@ -46,30 +48,33 @@ static int expand_dir_proc(ext2_filsys	fs,
 		return 0;
 	}
 	if (blockcnt &&
-	    (EXT2FS_B2C(fs, es->goal) == EXT2FS_B2C(fs, es->goal+1)))
-		new_blk = es->goal+1;
-	else {
+	    (EXT2FS_B2C(fs, es->goal) == EXT2FS_B2C(fs, es->goal + 1))) {
+		new_blk = es->goal + 1;
+	} else {
 		es->goal &= ~EXT2FS_CLUSTER_MASK(fs);
 		retval = ext2fs_new_block2(fs, es->goal, 0, &new_blk);
 		if (retval) {
 			es->err = retval;
 			return BLOCK_ABORT;
 		}
-		es->newblocks++;
+		es->clusters_added++;
 		ext2fs_block_alloc_stats2(fs, new_blk, +1);
 	}
 	if (blockcnt > 0) {
+		es->blocks_added++;
 		retval = ext2fs_new_dir_block(fs, 0, 0, &block);
 		if (retval) {
 			es->err = retval;
 			return BLOCK_ABORT;
 		}
-		es->done = 1;
+		es->done = (es->blocks_added >= es->blocks_to_add);
 		retval = ext2fs_write_dir_block4(fs, new_blk, block, 0,
 						 es->dir);
 		ext2fs_free_mem(&block);
-	} else
+	} else {
+		/* indirect or index block */
 		retval = ext2fs_zero_blocks2(fs, new_blk, 1, NULL, NULL);
+	}
 	if (blockcnt >= 0)
 		es->goal = new_blk;
 	if (retval) {
@@ -84,10 +89,11 @@ static int expand_dir_proc(ext2_filsys	fs,
 		return BLOCK_CHANGED;
 }
 
-errcode_t ext2fs_expand_dir(ext2_filsys fs, ext2_ino_t dir)
+errcode_t ext2fs_expand_dir2(ext2_filsys fs, ext2_ino_t dir,
+			     unsigned blocks_to_add)
 {
 	errcode_t	retval;
-	struct expand_dir_struct es;
+	struct expand_dir_struct es = { 0 };
 	struct ext2_inode	inode;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
@@ -98,6 +104,9 @@ errcode_t ext2fs_expand_dir(ext2_filsys fs, ext2_ino_t dir)
 	if (!fs->block_map)
 		return EXT2_ET_NO_BLOCK_BITMAP;
 
+	if (blocks_to_add > fs->super->s_free_blocks_count)
+		return EXT2_ET_DIR_NO_SPACE;
+
 	retval = ext2fs_check_directory(fs, dir);
 	if (retval)
 		return retval;
@@ -106,16 +115,19 @@ errcode_t ext2fs_expand_dir(ext2_filsys fs, ext2_ino_t dir)
 	if (retval)
 		return retval;
 
-	es.done = 0;
-	es.err = 0;
+	/* expand inode inline data before starting iteration */
+	if (inode.i_flags & EXT4_INLINE_DATA_FL) {
+		retval = ext2fs_inline_data_expand(fs, dir);
+		if (retval)
+			return retval;
+		blocks_to_add--;
+	}
 	es.goal = ext2fs_find_inode_goal(fs, dir, &inode, 0);
-	es.newblocks = 0;
 	es.dir = dir;
+	es.blocks_to_add = blocks_to_add;
 
 	retval = ext2fs_block_iterate3(fs, dir, BLOCK_FLAG_APPEND,
 				       0, expand_dir_proc, &es);
-	if (retval == EXT2_ET_INLINE_DATA_CANT_ITERATE)
-		return ext2fs_inline_data_expand(fs, dir);
 
 	if (es.err)
 		return es.err;
@@ -129,8 +141,8 @@ errcode_t ext2fs_expand_dir(ext2_filsys fs, ext2_ino_t dir)
 	if (retval)
 		return retval;
 
-	inode.i_size += fs->blocksize;
-	ext2fs_iblk_add_blocks(fs, &inode, es.newblocks);
+	inode.i_size += fs->blocksize * es.blocks_added;
+	ext2fs_iblk_add_blocks(fs, &inode, es.clusters_added);
 
 	retval = ext2fs_write_inode(fs, dir, &inode);
 	if (retval)
@@ -138,3 +150,8 @@ errcode_t ext2fs_expand_dir(ext2_filsys fs, ext2_ino_t dir)
 
 	return 0;
 }
+
+errcode_t ext2fs_expand_dir(ext2_filsys fs, ext2_ino_t dir)
+{
+	return ext2fs_expand_dir2(fs, dir, 1);
+}
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index b734f1a..0267660 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1194,6 +1194,8 @@ extern errcode_t ext2fs_dup_handle(ext2_filsys src, ext2_filsys *dest);
 
 /* expanddir.c */
 extern errcode_t ext2fs_expand_dir(ext2_filsys fs, ext2_ino_t dir);
+extern errcode_t ext2fs_expand_dir2(ext2_filsys fs, ext2_ino_t dir,
+				    unsigned blocks_to_add);
 
 /* ext_attr.c */
 extern __u32 ext2fs_ext_attr_hash_entry(struct ext2_ext_attr_entry *entry,
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 85d88ed..2a83040 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -507,18 +507,21 @@ static void create_lost_and_found(ext2_filsys fs)
 		exit(1);
 	}
 
-	for (i=1; i < EXT2_NDIR_BLOCKS; i++) {
-		/* Ensure that lost+found is at least 2 blocks, so we always
-		 * test large empty blocks for big-block filesystems.  */
-		if ((lpf_size += fs->blocksize) >= 16*1024 &&
-		    lpf_size >= 2 * fs->blocksize)
-			break;
-		retval = ext2fs_expand_dir(fs, ino);
-		if (retval) {
-			com_err("ext2fs_expand_dir", retval, "%s",
-				_("while expanding /lost+found"));
-			exit(1);
-		}
+	/* Ensure that lost+found is at least 2 blocks, so we always
+	 * test large empty blocks for big-block filesystems.  */
+	lpf_size = EXT2_NDIR_BLOCKS;
+	if (lpf_size * fs->blocksize > 16 * 1024)
+		lpf_size = 16 * 1024 / fs->blocksize;
+	if (lpf_size < 2)
+		lpf_size = 2;
+
+	/* round up size to full cluster, no point in making it smaller */
+	lpf_size = EXT2FS_C2B(fs, EXT2FS_B2C(fs, lpf_size - 1) + 1);
+	retval = ext2fs_expand_dir2(fs, ino, lpf_size - 1 /* initial block */);
+	if (retval) {
+		com_err("ext2fs_expand_dir", retval, "%s",
+			_("while expanding /lost+found"));
+		exit(1);
 	}
 }
 
diff --git a/tests/f_large_dir/script b/tests/f_large_dir/script
index b25e106..1824778 100644
--- a/tests/f_large_dir/script
+++ b/tests/f_large_dir/script
@@ -32,11 +32,9 @@ if [ $RC -eq 0 ]; then
 	echo "cd /foo"
 	touch $TMPFILE.tmp
 	echo "write $TMPFILE.tmp foofile"
+	echo "expand ./ $((DIRBLK))"
 	i=0
 	while test $i -lt $ENTRIES ; do
-	    if test $((i % DIRENT_PER_LEAF)) -eq 0; then
-	    	echo "expand ./"
-	    fi
 	    if test $((i % 5000)) -eq 0 -a $SECONDS -ne $START; then
 		ELAPSED=$((SECONDS - START))
 		RATE=$((i / ELAPSED))
-- 
1.8.0
