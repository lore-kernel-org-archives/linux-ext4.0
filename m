From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH 1/3] ext2fs: Handle internal journal over 2^32 bytes
Date: Fri, 10 Jun 2011 04:00:17 -0600
Message-ID: <1307700019-4551-1-git-send-email-adilger@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:12460 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab1FJKAW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jun 2011 06:00:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The write_journal_inode() code is only setting the low 32-bit i_size
for the journal size, even though it is possible to specify a journal
up to 10M blocks in size.  Trying to create a journal larger than 2GB
will succeed, but an immediate e2fsck would fail.  Store i_size_high
for the journal inode when creating it, and load it upon access.

Use s_jnl_blocks[15] to store the journal i_size_high backup.  This
field is currently unused, as EXT2_N_BLOCKS is 15, so it is using
s_jnl_blocks[0..14], and i_size is in s_jnl_blocks[16].

Rename the "size" argument "num_blocks" for the journal creation functions
to clarify this parameter is in units of filesystem blocks and not bytes.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 debugfs/logdump.c      |    1 +
 e2fsck/journal.c       |   11 ++++++---
 e2fsck/unix.c          |    3 +-
 lib/ext2fs/ext2fs.h    |    8 +++---
 lib/ext2fs/mkjournal.c |   49 ++++++++++++++++++++++++++++-------------------
 lib/ext2fs/swapfs.c    |   18 ++++++++--------
 resize/resize2fs.c     |    1 +
 7 files changed, 53 insertions(+), 38 deletions(-)

diff --git a/debugfs/logdump.c b/debugfs/logdump.c
index 1f6b7c9..d1e64fd 100644
--- a/debugfs/logdump.c
+++ b/debugfs/logdump.c
@@ -209,6 +209,7 @@ void do_logdump(int argc, char **argv)
 			memset(&journal_inode, 0, sizeof(struct ext2_inode));
 			memcpy(&journal_inode.i_block[0], es->s_jnl_blocks,
 			       EXT2_N_BLOCKS*4);
+			journal_inode.i_size_high = es->s_jnl_blocks[15];
 			journal_inode.i_size = es->s_jnl_blocks[16];
 			journal_inode.i_links_count = 1;
 			journal_inode.i_mode = LINUX_S_IFREG | 0600;
diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 93f685c..6d350ee 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -288,6 +288,7 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 			memset(&j_inode->i_ext2, 0, sizeof(struct ext2_inode));
 			memcpy(&j_inode->i_ext2.i_block[0], sb->s_jnl_blocks,
 			       EXT2_N_BLOCKS*4);
+			j_inode->i_ext2.i_size_high = sb->s_jnl_blocks[15];
 			j_inode->i_ext2.i_size = sb->s_jnl_blocks[16];
 			j_inode->i_ext2.i_links_count = 1;
 			j_inode->i_ext2.i_mode = LINUX_S_IFREG | 0600;
@@ -301,7 +302,7 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 			retval = EXT2_ET_NO_JOURNAL;
 			goto try_backup_journal;
 		}
-		if (j_inode->i_ext2.i_size / journal->j_blocksize <
+		if (EXT2_I_SIZE(&j_inode->i_ext2) / journal->j_blocksize <
 		    JFS_MIN_JOURNAL_BLOCKS) {
 			retval = EXT2_ET_JOURNAL_TOO_SMALL;
 			goto try_backup_journal;
@@ -310,8 +311,8 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 		retval = ext2fs_block_iterate3(ctx->fs, j_inode->i_ino,
 					       BLOCK_FLAG_HOLE, 0,
 					       process_journal_block, &pb);
-		if ((pb.last_block+1) * ctx->fs->blocksize <
-		    j_inode->i_ext2.i_size) {
+		if ((pb.last_block + 1) * ctx->fs->blocksize <
+		    EXT2_I_SIZE(&j_inode->i_ext2)) {
 			retval = EXT2_ET_JOURNAL_TOO_SMALL;
 			goto try_backup_journal;
 		}
@@ -322,7 +323,8 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 				goto errout;
 		}
 
-		journal->j_maxlen = j_inode->i_ext2.i_size / journal->j_blocksize;
+		journal->j_maxlen = EXT2_I_SIZE(&j_inode->i_ext2) /
+			journal->j_blocksize;
 
 #ifdef USE_INODE_IO
 		retval = ext2fs_inode_io_intern2(ctx->fs, sb->s_journal_inum,
@@ -943,6 +945,7 @@ void e2fsck_move_ext3_journal(e2fsck_t ctx)
 		if (fix_problem(ctx, PR_0_BACKUP_JNL, &pctx)) {
 			memcpy(sb->s_jnl_blocks, inode.i_block,
 			       EXT2_N_BLOCKS*4);
+			sb->s_jnl_blocks[15] = inode.i_size_high;
 			sb->s_jnl_blocks[16] = inode.i_size;
 			sb->s_jnl_backup_type = EXT3_JNL_BACKUP_BLOCKS;
 			ext2fs_mark_super_dirty(fs);
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 998aa07..a43f0c9 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1374,7 +1374,8 @@ print_unsupp_features:
 	 * find the default journal size.
 	 */
 	if (sb->s_jnl_backup_type == EXT3_JNL_BACKUP_BLOCKS)
-		journal_size = sb->s_jnl_blocks[16] >> 20;
+		journal_size = (sb->s_jnl_blocks[15] << (32 - 20)) |
+			       (sb->s_jnl_blocks[16] >> 20);
 	else
 		journal_size = -1;
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 975ab9d..44447bf 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1255,15 +1255,15 @@ extern errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum
 extern errcode_t ext2fs_zero_blocks(ext2_filsys fs, blk_t blk, int num,
 				    blk_t *ret_blk, int *ret_count);
 extern errcode_t ext2fs_zero_blocks2(ext2_filsys fs, blk64_t blk, int num,
-				     blk64_t *ret_blk, int *ret_count); 
+				     blk64_t *ret_blk, int *ret_count);
 extern errcode_t ext2fs_create_journal_superblock(ext2_filsys fs,
-						  __u32 size, int flags,
+						  __u32 num_blocks, int flags,
 						  char  **ret_jsb);
 extern errcode_t ext2fs_add_journal_device(ext2_filsys fs,
 					   ext2_filsys journal_dev);
-extern errcode_t ext2fs_add_journal_inode(ext2_filsys fs, blk_t size,
+extern errcode_t ext2fs_add_journal_inode(ext2_filsys fs, blk_t num_blocks,
 					  int flags);
-extern int ext2fs_default_journal_size(__u64 blocks);
+extern int ext2fs_default_journal_size(__u64 num_blocks);
 
 /* openfs.c */
 extern errcode_t ext2fs_open(const char *name, int flags, int superblock,
diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index 242c537..36b75be 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -42,13 +42,13 @@
  * returns it as an allocated block.
  */
 errcode_t ext2fs_create_journal_superblock(ext2_filsys fs,
-					   __u32 size, int flags,
+					   __u32 num_blocks, int flags,
 					   char  **ret_jsb)
 {
 	errcode_t		retval;
 	journal_superblock_t	*jsb;
 
-	if (size < 1024)
+	if (num_blocks < 1024)
 		return EXT2_ET_JOURNAL_TOO_SMALL;
 
 	if ((retval = ext2fs_get_mem(fs->blocksize, &jsb)))
@@ -62,7 +62,7 @@ errcode_t ext2fs_create_journal_superblock(ext2_filsys fs,
 	else
 		jsb->s_header.h_blocktype = htonl(JFS_SUPERBLOCK_V2);
 	jsb->s_blocksize = htonl(fs->blocksize);
-	jsb->s_maxlen = htonl(size);
+	jsb->s_maxlen = htonl(num_blocks);
 	jsb->s_nr_users = htonl(1);
 	jsb->s_first = htonl(1);
 	jsb->s_sequence = htonl(1);
@@ -90,14 +90,15 @@ errcode_t ext2fs_create_journal_superblock(ext2_filsys fs,
  * filesystems.
  */
 static errcode_t write_journal_file(ext2_filsys fs, char *filename,
-				    blk_t size, int flags)
+				    blk_t num_blocks, int flags)
 {
 	errcode_t	retval;
 	char		*buf = 0;
 	int		fd, ret_size;
 	blk_t		i;
 
-	if ((retval = ext2fs_create_journal_superblock(fs, size, flags, &buf)))
+	if ((retval = ext2fs_create_journal_superblock(fs, num_blocks, flags,
+						       &buf)))
 		return retval;
 
 	/* Open the device or journal file */
@@ -117,7 +118,7 @@ static errcode_t write_journal_file(ext2_filsys fs, char *filename,
 		goto errout;
 	memset(buf, 0, fs->blocksize);
 
-	for (i = 1; i < size; i++) {
+	for (i = 1; i < num_blocks; i++) {
 		ret_size = write(fd, buf, fs->blocksize);
 		if (ret_size < 0) {
 			retval = errno;
@@ -284,15 +285,17 @@ static int mkjournal_proc(ext2_filsys	fs,
  * This function creates a journal using direct I/O routines.
  */
 static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
-				     blk64_t size, int flags)
+				     blk_t num_blocks, int flags)
 {
 	char			*buf;
 	dgrp_t			group, start, end, i, log_flex;
 	errcode_t		retval;
 	struct ext2_inode	inode;
+	unsigned long long	inode_size;
 	struct mkjournal_struct	es;
 
-	if ((retval = ext2fs_create_journal_superblock(fs, size, flags, &buf)))
+	if ((retval = ext2fs_create_journal_superblock(fs, num_blocks, flags,
+						       &buf)))
 		return retval;
 
 	if ((retval = ext2fs_read_bitmaps(fs)))
@@ -304,7 +307,7 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 	if (inode.i_blocks > 0)
 		return EEXIST;
 
-	es.num_blocks = size;
+	es.num_blocks = num_blocks;
 	es.newblocks = 0;
 	es.buf = buf;
 	es.err = 0;
@@ -360,7 +363,12 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 	if ((retval = ext2fs_read_inode(fs, journal_ino, &inode)))
 		goto errout;
 
- 	inode.i_size += fs->blocksize * size;
+	inode_size = (unsigned long long)fs->blocksize * num_blocks;
+	inode.i_size = inode_size & 0xFFFFFFFF;
+	inode.i_size_high = (inode_size >> 32) & 0xFFFFFFFF;
+	if (inode.i_size_high)
+		fs->super->s_feature_ro_compat |=
+			EXT2_FEATURE_RO_COMPAT_LARGE_FILE;
 	ext2fs_iblk_add_blocks(fs, &inode, es.newblocks);
 	inode.i_mtime = inode.i_ctime = fs->now ? fs->now : time(0);
 	inode.i_links_count = 1;
@@ -371,6 +379,7 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 	retval = 0;
 
 	memcpy(fs->super->s_jnl_blocks, inode.i_block, EXT2_N_BLOCKS*4);
+	fs->super->s_jnl_blocks[15] = inode.i_size_high;
 	fs->super->s_jnl_blocks[16] = inode.i_size;
 	fs->super->s_jnl_backup_type = EXT3_JNL_BACKUP_BLOCKS;
 	ext2fs_mark_super_dirty(fs);
@@ -386,17 +395,17 @@ errout:
  * in the filesystem.  For very small filesystems, it is not reasonable to
  * have a journal that fills more than half of the filesystem.
  */
-int ext2fs_default_journal_size(__u64 blocks)
+int ext2fs_default_journal_size(__u64 num_blocks)
 {
-	if (blocks < 2048)
+	if (num_blocks < 2048)
 		return -1;
-	if (blocks < 32768)
+	if (num_blocks < 32768)
 		return (1024);
-	if (blocks < 256*1024)
+	if (num_blocks < 256*1024)
 		return (4096);
-	if (blocks < 512*1024)
+	if (num_blocks < 512*1024)
 		return (8192);
-	if (blocks < 1024*1024)
+	if (num_blocks < 1024*1024)
 		return (16384);
 	return 32768;
 }
@@ -467,7 +476,7 @@ errcode_t ext2fs_add_journal_device(ext2_filsys fs, ext2_filsys journal_dev)
  * POSIX routines if the filesystem is mounted, or using direct I/O
  * functions if it is not.
  */
-errcode_t ext2fs_add_journal_inode(ext2_filsys fs, blk_t size, int flags)
+errcode_t ext2fs_add_journal_inode(ext2_filsys fs, blk_t num_blocks, int flags)
 {
 	errcode_t		retval;
 	ext2_ino_t		journal_ino;
@@ -504,7 +513,7 @@ errcode_t ext2fs_add_journal_inode(ext2_filsys fs, blk_t size, int flags)
 		if ((fd = open(jfile, O_CREAT|O_WRONLY, 0600)) < 0)
 			return errno;
 
-		if ((retval = write_journal_file(fs, jfile, size, flags)))
+		if ((retval = write_journal_file(fs, jfile, num_blocks, flags)))
 			goto errout;
 
 		/* Get inode number of the journal file */
@@ -544,7 +553,7 @@ errcode_t ext2fs_add_journal_inode(ext2_filsys fs, blk_t size, int flags)
 		}
 		journal_ino = EXT2_JOURNAL_INO;
 		if ((retval = write_journal_inode(fs, journal_ino,
-						  size, flags)))
+						  num_blocks, flags)))
 			return retval;
 	}
 
@@ -567,7 +576,7 @@ main(int argc, char **argv)
 {
 	errcode_t	retval;
 	char		*device_name;
-	ext2_filsys 	fs;
+	ext2_filsys	fs;
 
 	if (argc < 2) {
 		fprintf(stderr, "Usage: %s filesystem\n", argv[0]);
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 3a43c6c..87b1a2e 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -83,16 +83,16 @@ void ext2fs_swap_super(struct ext2_super_block * sb)
 		sb->s_hash_seed[i] = ext2fs_swab32(sb->s_hash_seed[i]);
 
 	/* if journal backup is for a valid extent-based journal... */
-	if (!ext2fs_extent_header_verify(sb->s_jnl_blocks,
-					 sizeof(sb->s_jnl_blocks))) {
-		/* ... swap only the journal i_size */
-		sb->s_jnl_blocks[16] = ext2fs_swab32(sb->s_jnl_blocks[16]);
-		/* and the extent data is not swapped on read */
-		return;
+	if (ext2fs_extent_header_verify(sb->s_jnl_blocks,
+					sizeof(sb->s_jnl_blocks)) == 0) {
+		/* ... swap only the journal i_size and i_size_high,
+		 * and the extent data is not swapped on read */
+		i = 15;
+	} else {
+		/* direct/indirect journal: swap it all */
+		i = 0;
 	}
