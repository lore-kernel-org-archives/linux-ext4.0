From: Andreas Dilger <andreas.dilger@oracle.com>
Subject: [PATCH] allow internal journal size 2GB or larger
Date: Thu, 5 Aug 2010 13:26:19 -0600
Message-ID: <BDFF27EB-4448-4042-B8BD-7DD104AE9021@oracle.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: multipart/mixed; boundary=Apple-Mail-79--66014412
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:58249 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175Ab0HET0y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Aug 2010 15:26:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail-79--66014412
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

The current libext2fs and e2fsck code does not handle an internal =
journal inode size larger than 2GB because of 32-bit overflow.  The high =
bits of the journal are not stored on disk correctly, nor are they =
backed up into the superblock.  This is not a problem with a large =
external journal device.

Fix the code to correctly process the high bits of the journal size.  It =
turns out there is also space in the superblock journal backup to hold =
the high bits of the journal size (in s_jnl_blocks[15]), because there =
are 17 words reserved for this field, but the i_blocks field only uses =
EXT2_N_BLOCKS =3D 15 blocks [0-14], and the journal size is stored in =
[16], so no change to the on-disk format is needed.

Signed-off-by: Andreas Dilger <andreas.dilger@oracle.com>

Cheers, Andreas
--
Andreas Dilger
Lustre Technical Lead
Oracle Corporation Canada Inc.

--Apple-Mail-79--66014412
Content-Disposition: attachment;
	filename=e2fsprogs-bigjournal.diff
Content-Type: application/octet-stream;
	name="e2fsprogs-bigjournal.diff"
Content-Transfer-Encoding: 7bit

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
index 75dafa6..5351442 100644
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
@@ -942,6 +944,7 @@ void e2fsck_move_ext3_journal(e2fsck_t ctx)
 		if (fix_problem(ctx, PR_0_BACKUP_JNL, &pctx)) {
 			memcpy(sb->s_jnl_blocks, inode.i_block,
 			       EXT2_N_BLOCKS*4);
+			sb->s_jnl_blocks[15] = inode.i_size_high;
 			sb->s_jnl_blocks[16] = inode.i_size;
 			sb->s_jnl_backup_type = EXT3_JNL_BACKUP_BLOCKS;
 			ext2fs_mark_super_dirty(fs);
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 6cb2214..7c41964 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1346,7 +1346,8 @@ print_unsupp_features:
 	 * find the default journal size.
 	 */
 	if (sb->s_jnl_backup_type == EXT3_JNL_BACKUP_BLOCKS)
-		journal_size = sb->s_jnl_blocks[16] >> 20;
+		journal_size = (sb->s_jnl_blocks[15] << (32 - 20)) |
+			       (sb->s_jnl_blocks[16] >> 20);
 	else
 		journal_size = -1;
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index f2f9ac8..3e92ce2 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1244,11 +1244,11 @@ extern errcode_t ext2fs_zero_blocks(ext2_filsys fs, blk_t blk, int num,
 extern errcode_t ext2fs_zero_blocks2(ext2_filsys fs, blk64_t blk, int num,
 				     blk64_t *ret_blk, int *ret_count); 
 extern errcode_t ext2fs_create_journal_superblock(ext2_filsys fs,
-						  __u32 size, int flags,
+						  __u32 blocks, int flags,
 						  char  **ret_jsb);
 extern errcode_t ext2fs_add_journal_device(ext2_filsys fs,
 					   ext2_filsys journal_dev);
-extern errcode_t ext2fs_add_journal_inode(ext2_filsys fs, blk_t size,
+extern errcode_t ext2fs_add_journal_inode(ext2_filsys fs, blk_t blocks,
 					  int flags);
 extern int ext2fs_default_journal_size(__u64 blocks);
 
diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index 9466e78..fe52809 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -42,13 +42,13 @@
  * returns it as an allocated block.
  */
 errcode_t ext2fs_create_journal_superblock(ext2_filsys fs,
-					   __u32 size, int flags,
+					   __u32 blocks, int flags,
 					   char  **ret_jsb)
 {
 	errcode_t		retval;
 	journal_superblock_t	*jsb;
 
-	if (size < 1024)
+	if (blocks < 1024)
 		return EXT2_ET_JOURNAL_TOO_SMALL;
 
 	if ((retval = ext2fs_get_mem(fs->blocksize, &jsb)))
@@ -62,7 +62,7 @@ errcode_t ext2fs_create_journal_superblock(ext2_filsys fs,
 	else
 		jsb->s_header.h_blocktype = htonl(JFS_SUPERBLOCK_V2);
 	jsb->s_blocksize = htonl(fs->blocksize);
-	jsb->s_maxlen = htonl(size);
+	jsb->s_maxlen = htonl(blocks);
 	jsb->s_nr_users = htonl(1);
 	jsb->s_first = htonl(1);
 	jsb->s_sequence = htonl(1);
@@ -90,14 +90,14 @@ errcode_t ext2fs_create_journal_superblock(ext2_filsys fs,
  * filesystems.
  */
 static errcode_t write_journal_file(ext2_filsys fs, char *filename,
-				    blk_t size, int flags)
+				    blk_t blocks, int flags)
 {
 	errcode_t	retval;
 	char		*buf = 0;
 	int		fd, ret_size;
 	blk_t		i;
 
-	if ((retval = ext2fs_create_journal_superblock(fs, size, flags, &buf)))
+	if ((retval = ext2fs_create_journal_superblock(fs, blocks, flags,&buf)))
 		return retval;
 
 	/* Open the device or journal file */
@@ -117,7 +117,7 @@ static errcode_t write_journal_file(ext2_filsys fs, char *filename,
 		goto errout;
 	memset(buf, 0, fs->blocksize);
 
-	for (i = 1; i < size; i++) {
+	for (i = 1; i < blocks; i++) {
 		ret_size = write(fd, buf, fs->blocksize);
 		if (ret_size < 0) {
 			retval = errno;
@@ -284,15 +284,16 @@ static int mkjournal_proc(ext2_filsys	fs,
  * This function creates a journal using direct I/O routines.
  */
 static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
-				     blk64_t size, int flags)
+				     blk64_t blocks, int flags)
 {
 	char			*buf;
 	dgrp_t			group, start, end, i, log_flex;
 	errcode_t		retval;
 	struct ext2_inode	inode;
+	unsigned long long	inode_size;
 	struct mkjournal_struct	es;
 
-	if ((retval = ext2fs_create_journal_superblock(fs, size, flags, &buf)))
+	if ((retval = ext2fs_create_journal_superblock(fs, blocks, flags,&buf)))
 		return retval;
 
 	if ((retval = ext2fs_read_bitmaps(fs)))
@@ -304,7 +305,7 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 	if (inode.i_blocks > 0)
 		return EEXIST;
 
-	es.num_blocks = size;
+	es.num_blocks = blocks;
 	es.newblocks = 0;
 	es.buf = buf;
 	es.err = 0;
@@ -360,7 +361,12 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 	if ((retval = ext2fs_read_inode(fs, journal_ino, &inode)))
 		goto errout;
 
- 	inode.i_size += fs->blocksize * size;
+	inode_size = (unsigned long long)fs->blocksize * blocks;
+	inode.i_size = inode_size & 0xFFFFFFFF;
+	inode.i_size_high = (inode_size >> 32) & 0xFFFFFFFF;
+	if (inode.i_size_high)
+		fs->super->s_feature_ro_compat |=
+			EXT2_FEATURE_RO_COMPAT_LARGE_FILE;
 	ext2fs_iblk_add_blocks(fs, &inode, es.newblocks);
 	inode.i_mtime = inode.i_ctime = fs->now ? fs->now : time(0);
 	inode.i_links_count = 1;
@@ -371,6 +377,7 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 	retval = 0;
 
 	memcpy(fs->super->s_jnl_blocks, inode.i_block, EXT2_N_BLOCKS*4);
+	fs->super->s_jnl_blocks[15] = inode.i_size_high;
 	fs->super->s_jnl_blocks[16] = inode.i_size;
 	fs->super->s_jnl_backup_type = EXT3_JNL_BACKUP_BLOCKS;
 	ext2fs_mark_super_dirty(fs);
@@ -466,7 +473,7 @@ errcode_t ext2fs_add_journal_device(ext2_filsys fs, ext2_filsys journal_dev)
  * POSIX routines if the filesystem is mounted, or using direct I/O
  * functions if it is not.
  */
-errcode_t ext2fs_add_journal_inode(ext2_filsys fs, blk_t size, int flags)
+errcode_t ext2fs_add_journal_inode(ext2_filsys fs, blk_t blocks, int flags)
 {
 	errcode_t		retval;
 	ext2_ino_t		journal_ino;
@@ -503,7 +510,7 @@ errcode_t ext2fs_add_journal_inode(ext2_filsys fs, blk_t size, int flags)
 		if ((fd = open(jfile, O_CREAT|O_WRONLY, 0600)) < 0)
 			return errno;
 
-		if ((retval = write_journal_file(fs, jfile, size, flags)))
+		if ((retval = write_journal_file(fs, jfile, blocks, flags)))
 			goto errout;
 
 		/* Get inode number of the journal file */
@@ -543,7 +550,7 @@ errcode_t ext2fs_add_journal_inode(ext2_filsys fs, blk_t size, int flags)
 		}
 		journal_ino = EXT2_JOURNAL_INO;
 		if ((retval = write_journal_inode(fs, journal_ino,
-						  size, flags)))
+						  blocks, flags)))
 			return retval;
 	}
 
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index de7585c..24635f8 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -81,16 +81,16 @@ void ext2fs_swap_super(struct ext2_super_block * sb)
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
--Apple-Mail-79--66014412--
