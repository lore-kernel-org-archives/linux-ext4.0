From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: [PATCH 1/4 v3] journal: use consts instead of 1024 and add helper for journal with 1k blocksize
Date: Mon, 28 Jul 2014 11:43:22 +0400
Message-ID: <1406533405-6899-2-git-send-email-a3at.mail@gmail.com>
References: <1406533405-6899-1-git-send-email-a3at.mail@gmail.com>
Cc: tytso@mit.edu, darrick.wong@oracle.com, adilger@dilger.ca,
	Azat Khuzhin <a3at.mail@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:54695 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbaG1Hn4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jul 2014 03:43:56 -0400
Received: by mail-la0-f52.google.com with SMTP id e16so5086935lan.39
        for <linux-ext4@vger.kernel.org>; Mon, 28 Jul 2014 00:43:54 -0700 (PDT)
In-Reply-To: <1406533405-6899-1-git-send-email-a3at.mail@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use
EXT2_MIN_BLOCK_SIZE/JFS_MIN_JOURNAL_BLOCKS/SUPERBLOCK_SIZE/SUPERBLOCK_OFFSET
instead of hardcoded 1024 when it is okay, and also add a helper
ext2fs_journal_sb_start() that will return start of journal sb with
special case for fs with 1k block size.

Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 e2fsck/journal.c       |  5 ++---
 lib/ext2fs/ext2fs.h    |  1 +
 lib/ext2fs/mkjournal.c | 28 ++++++++++++++++------------
 misc/tune2fs.c         |  6 +++---
 4 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 9be52cd..3b40e00 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -393,8 +393,7 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 	if (ext_journal) {
 		blk64_t maxlen;
 
-		if (ctx->fs->blocksize == 1024)
-			start = 1;
+		start = ext2fs_journal_sb_start(ctx->fs->blocksize) - 1;
 		bh = getblk(dev_journal, start, ctx->fs->blocksize);
 		if (!bh) {
 			retval = EXT2_ET_NO_MEMORY;
@@ -405,7 +404,7 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 			brelse(bh);
 			goto errout;
 		}
-		memcpy(&jsuper, start ? bh->b_data :  bh->b_data + 1024,
+		memcpy(&jsuper, start ? bh->b_data :  bh->b_data + SUPERBLOCK_OFFSET,
 		       sizeof(jsuper));
 		brelse(bh);
 #ifdef WORDS_BIGENDIAN
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 33b2519..ab57534 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1377,6 +1377,7 @@ extern errcode_t ext2fs_add_journal_inode(ext2_filsys fs, blk_t num_blocks,
 extern errcode_t ext2fs_add_journal_inode2(ext2_filsys fs, blk_t num_blocks,
 					   blk64_t goal, int flags);
 extern int ext2fs_default_journal_size(__u64 num_blocks);
+extern int ext2fs_journal_sb_start(int blocksize);
 
 /* openfs.c */
 extern errcode_t ext2fs_open(const char *name, int flags, int superblock,
diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index e8316a7..96b6d36 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -49,7 +49,7 @@ errcode_t ext2fs_create_journal_superblock(ext2_filsys fs,
 	errcode_t		retval;
 	journal_superblock_t	*jsb;
 
-	if (num_blocks < 1024)
+	if (num_blocks < JFS_MIN_JOURNAL_BLOCKS)
 		return EXT2_ET_JOURNAL_TOO_SMALL;
 
 	if ((retval = ext2fs_get_mem(fs->blocksize, &jsb)))
@@ -75,10 +75,7 @@ errcode_t ext2fs_create_journal_superblock(ext2_filsys fs,
 	if (fs->super->s_feature_incompat &
 	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV) {
 		jsb->s_nr_users = 0;
-		if (fs->blocksize == 1024)
-			jsb->s_first = htonl(3);
-		else
-			jsb->s_first = htonl(2);
+		jsb->s_first = htonl(ext2fs_journal_sb_start(fs->blocksize) + 1);
 	}
 
 	*ret_jsb = (char *) jsb;
@@ -428,6 +425,13 @@ int ext2fs_default_journal_size(__u64 num_blocks)
 	return 32768;
 }
 
+int ext2fs_journal_sb_start(int blocksize)
+{
+	if (blocksize == EXT2_MIN_BLOCK_SIZE)
+		return 2;
+	return 1;
+}
+
 /*
  * This function adds a journal device to a filesystem
  */
@@ -435,7 +439,7 @@ errcode_t ext2fs_add_journal_device(ext2_filsys fs, ext2_filsys journal_dev)
 {
 	struct stat	st;
 	errcode_t	retval;
-	char		buf[1024];
+	char		buf[SUPERBLOCK_SIZE];
 	journal_superblock_t	*jsb;
 	int		start;
 	__u32		i, nr_users;
@@ -448,10 +452,9 @@ errcode_t ext2fs_add_journal_device(ext2_filsys fs, ext2_filsys journal_dev)
 		return EXT2_ET_JOURNAL_NOT_BLOCK; /* Must be a block device */
 
 	/* Get the journal superblock */
-	start = 1;
-	if (journal_dev->blocksize == 1024)
-		start++;
-	if ((retval = io_channel_read_blk64(journal_dev->io, start, -1024,
+	start = ext2fs_journal_sb_start(journal_dev->blocksize);
+	if ((retval = io_channel_read_blk64(journal_dev->io, start,
+					    -SUPERBLOCK_SIZE,
 					    buf)))
 		return retval;
 
@@ -477,7 +480,8 @@ errcode_t ext2fs_add_journal_device(ext2_filsys fs, ext2_filsys journal_dev)
 	}
 
 	/* Writeback the journal superblock */
-	if ((retval = io_channel_write_blk64(journal_dev->io, start, -1024, buf)))
+	if ((retval = io_channel_write_blk64(journal_dev->io, start,
+					    -SUPERBLOCK_SIZE, buf)))
 		return retval;
 
 	fs->super->s_journal_inum = 0;
@@ -630,7 +634,7 @@ main(int argc, char **argv)
 		exit(1);
 	}
 
-	retval = ext2fs_add_journal_inode(fs, 1024, 0);
+	retval = ext2fs_add_journal_inode(fs, JFS_MIN_JOURNAL_BLOCKS, 0);
 	if (retval) {
 		com_err(argv[0], retval, "while adding journal to %s",
 			device_name);
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index ad0b05f..ff50f37 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -182,7 +182,7 @@ static int remove_journal_device(ext2_filsys fs)
 {
 	char		*journal_path;
 	ext2_filsys	jfs;
-	char		buf[1024];
+	char		buf[SUPERBLOCK_SIZE];
 	journal_superblock_t	*jsb;
 	int		i, nr_users;
 	errcode_t	retval;
@@ -225,7 +225,7 @@ static int remove_journal_device(ext2_filsys fs)
 	}
 
 	/* Get the journal superblock */
-	if ((retval = io_channel_read_blk64(jfs->io, 1, -1024, buf))) {
+	if ((retval = io_channel_read_blk64(jfs->io, 1, -SUPERBLOCK_SIZE, buf))) {
 		com_err(program_name, retval, "%s",
 			_("while reading journal superblock"));
 		goto no_valid_journal;
@@ -256,7 +256,7 @@ static int remove_journal_device(ext2_filsys fs)
 	jsb->s_nr_users = htonl(nr_users);
 
 	/* Write back the journal superblock */
-	if ((retval = io_channel_write_blk64(jfs->io, 1, -1024, buf))) {
+	if ((retval = io_channel_write_blk64(jfs->io, 1, -SUPERBLOCK_SIZE, buf))) {
 		com_err(program_name, retval,
 			"while writing journal superblock.");
 		goto no_valid_journal;
-- 
2.0.1

