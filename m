From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: [PATCH 2/5] journal: use consts instead of 1024 and add helper for journal with 1k blocksize
Date: Thu, 10 Jul 2014 18:35:05 +0400
Message-ID: <1405002908-16332-3-git-send-email-a3at.mail@gmail.com>
References: <1405002908-16332-1-git-send-email-a3at.mail@gmail.com>
Cc: darrick.wong@oracle.com, adilger@dilger.ca, tytso@mit.edu,
	Azat Khuzhin <a3at.mail@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:45403 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527AbaGJOf0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2014 10:35:26 -0400
Received: by mail-lb0-f178.google.com with SMTP id 10so6271601lbg.9
        for <linux-ext4@vger.kernel.org>; Thu, 10 Jul 2014 07:35:24 -0700 (PDT)
In-Reply-To: <1405002908-16332-1-git-send-email-a3at.mail@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Use EXT2_MIN_BLOCK_SIZE/JFS_MIN_JOURNAL_BLOCKS instead of hardcoded 1024
when it is okay, and also add a helper ext2fs_journal_sb_start() that
will return start of journal sb with special case for fs with 1k block
size.

Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
---
 e2fsck/journal.c       |  5 ++---
 lib/ext2fs/ext2fs.h    |  1 +
 lib/ext2fs/mkjournal.c | 28 ++++++++++++++++------------
 misc/tune2fs.c         |  6 +++---
 4 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index a7b1150..785d283 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -443,8 +443,7 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 	if (ext_journal) {
 		blk64_t maxlen;
 
-		if (ctx->fs->blocksize == 1024)
-			start = 1;
+		start = ext2fs_journal_sb_start(ctx->fs->blocksize) - 1;
 		bh = getblk(dev_journal, start, ctx->fs->blocksize);
 		if (!bh) {
 			retval = EXT2_ET_NO_MEMORY;
@@ -455,7 +454,7 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 			brelse(bh);
 			goto errout;
 		}
-		memcpy(&jsuper, start ? bh->b_data :  bh->b_data + 1024,
+		memcpy(&jsuper, start ? bh->b_data :  bh->b_data + EXT2_SUPERBLOCK_OFFSET,
 		       sizeof(jsuper));
 		brelse(bh);
 #ifdef WORDS_BIGENDIAN
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index f21c389..1a96f24 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1504,6 +1504,7 @@ extern errcode_t ext2fs_add_journal_inode(ext2_filsys fs, blk_t num_blocks,
 extern errcode_t ext2fs_add_journal_inode2(ext2_filsys fs, blk_t num_blocks,
 					   blk64_t goal, int flags);
 extern int ext2fs_default_journal_size(__u64 num_blocks);
+extern int ext2fs_journal_sb_start(int blocksize);
 
 /* openfs.c */
 extern errcode_t ext2fs_open(const char *name, int flags, int superblock,
diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index 884d9c0..ae5cd56 100644
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
@@ -430,6 +427,13 @@ int ext2fs_default_journal_size(__u64 num_blocks)
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
@@ -437,7 +441,7 @@ errcode_t ext2fs_add_journal_device(ext2_filsys fs, ext2_filsys journal_dev)
 {
 	struct stat	st;
 	errcode_t	retval;
-	char		buf[1024];
+	char		buf[EXT2_SUPERBLOCK_SIZE];
 	journal_superblock_t	*jsb;
 	int		start;
 	__u32		i, nr_users;
@@ -450,10 +454,9 @@ errcode_t ext2fs_add_journal_device(ext2_filsys fs, ext2_filsys journal_dev)
 		return EXT2_ET_JOURNAL_NOT_BLOCK; /* Must be a block device */
 
 	/* Get the journal superblock */
-	start = 1;
-	if (journal_dev->blocksize == 1024)
-		start++;
-	if ((retval = io_channel_read_blk64(journal_dev->io, start, -1024,
+	start = ext2fs_journal_sb_start(journal_dev->blocksize);
+	if ((retval = io_channel_read_blk64(journal_dev->io, start,
+					    -EXT2_SUPERBLOCK_SIZE,
 					    buf)))
 		return retval;
 
@@ -479,7 +482,8 @@ errcode_t ext2fs_add_journal_device(ext2_filsys fs, ext2_filsys journal_dev)
 	}
 
 	/* Writeback the journal superblock */
-	if ((retval = io_channel_write_blk64(journal_dev->io, start, -1024, buf)))
+	if ((retval = io_channel_write_blk64(journal_dev->io, start,
+					    -EXT2_SUPERBLOCK_SIZE, buf)))
 		return retval;
 
 	fs->super->s_journal_inum = 0;
@@ -632,7 +636,7 @@ main(int argc, char **argv)
 		exit(1);
 	}
 
-	retval = ext2fs_add_journal_inode(fs, 1024, 0);
+	retval = ext2fs_add_journal_inode(fs, JFS_MIN_JOURNAL_BLOCKS, 0);
 	if (retval) {
 		com_err(argv[0], retval, "while adding journal to %s",
 			device_name);
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index d95cc3d..9d21623 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -187,7 +187,7 @@ static int remove_journal_device(ext2_filsys fs)
 {
 	char		*journal_path;
 	ext2_filsys	jfs;
-	char		buf[1024];
+	char		buf[EXT2_SUPERBLOCK_SIZE];
 	journal_superblock_t	*jsb;
 	int		i, nr_users;
 	errcode_t	retval;
@@ -230,7 +230,7 @@ static int remove_journal_device(ext2_filsys fs)
 	}
 
 	/* Get the journal superblock */
-	if ((retval = io_channel_read_blk64(jfs->io, 1, -1024, buf))) {
+	if ((retval = io_channel_read_blk64(jfs->io, 1, -EXT2_SUPERBLOCK_SIZE, buf))) {
 		com_err(program_name, retval, "%s",
 			_("while reading journal superblock"));
 		goto no_valid_journal;
@@ -261,7 +261,7 @@ static int remove_journal_device(ext2_filsys fs)
 	jsb->s_nr_users = htonl(nr_users);
 
 	/* Write back the journal superblock */
-	if ((retval = io_channel_write_blk64(jfs->io, 1, -1024, buf))) {
+	if ((retval = io_channel_write_blk64(jfs->io, 1, -EXT2_SUPERBLOCK_SIZE, buf))) {
 		com_err(program_name, retval,
 			"while writing journal superblock.");
 		goto no_valid_journal;
-- 
2.0.0

