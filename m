From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 1/2] misc: quiet signed/unsigned charactr compiler warnings
Date: Tue, 29 Jul 2014 17:30:39 -0600
Message-ID: <1406676640-5627-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-04.shaw.ca ([64.59.134.12]:9286 "EHLO
	smtp-out-04.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaG2Xam (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jul 2014 19:30:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Quiet warnings about signed vs. unsigned character mismatch.
Use __u8 for storing UUIDs instead of char to match the superblock
s_uuid field.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 debugfs/debugfs.c |    2 +-
 misc/tune2fs.c    |   21 ++++++++++++---------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index dc925de..00c2d38 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -2153,7 +2153,7 @@ void do_imap(int argc, char *argv[])
 void do_idump(int argc, char *argv[])
 {
 	ext2_ino_t	ino;
-	char		*buf;
+	unsigned char	*buf;
 	errcode_t	err;
 	int		isize;
 
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 0c1feb1..ffa42ba 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -207,8 +207,8 @@ static int get_journal_sb(ext2_filsys jfs, char buf[SUPERBLOCK_SIZE])
 	return 0;
 }
 
-static void *
-journal_user(char uuid[UUID_SIZE], char s_users[JFS_USERS_SIZE], int nr_users)
+static __u8 *journal_user(__u8 uuid[UUID_SIZE], __u8 s_users[JFS_USERS_SIZE],
+			  int nr_users)
 {
 	int i;
 	for (i = 0; i < nr_users; i++) {
@@ -1925,12 +1925,13 @@ static int tune2fs_setup_tdb(const char *name, io_manager *io_ptr)
 }
 
 int
-fs_update_journal_user(struct ext2_super_block *sb, char old_uuid[UUID_SIZE])
+fs_update_journal_user(struct ext2_super_block *sb, __u8 old_uuid[UUID_SIZE])
 {
 	int retval, nr_users, start;
 	journal_superblock_t *jsb;
 	ext2_filsys jfs;
-	char *j_uuid, *journal_path;
+	__u8 *j_uuid;
+	char *journal_path;
 	char uuid[UUID_STR_SIZE];
 	char buf[SUPERBLOCK_SIZE];
 
@@ -1953,7 +1954,8 @@ fs_update_journal_user(struct ext2_super_block *sb, char old_uuid[UUID_SIZE])
 		return retval;
 	}
 
-	if ((retval = get_journal_sb(jfs, buf))) {
+	retval = get_journal_sb(jfs, buf);
+	if (retval != 0) {
 		if (retval == EXT2_ET_UNSUPP_FEATURE)
 			fprintf(stderr, _("%s is not a journal device.\n"),
 				journal_path);
@@ -1964,7 +1966,8 @@ fs_update_journal_user(struct ext2_super_block *sb, char old_uuid[UUID_SIZE])
 	/* Find the filesystem UUID */
 	nr_users = ntohl(jsb->s_nr_users);
 
-	if (!(j_uuid = journal_user(old_uuid, jsb->s_users, nr_users))) {
+	j_uuid = journal_user(old_uuid, jsb->s_users, nr_users);
+	if (j_uuid == NULL) {
 		fputs(_("Filesystem's UUID not found on journal device.\n"),
 		      stderr);
 		return EXT2_ET_LOAD_EXT_JOURNAL;
@@ -1974,8 +1977,8 @@ fs_update_journal_user(struct ext2_super_block *sb, char old_uuid[UUID_SIZE])
 
 	start = ext2fs_journal_sb_start(jfs->blocksize);
 	/* Write back the journal superblock */
-	if ((retval = io_channel_write_blk64(jfs->io, start,
-	    -SUPERBLOCK_SIZE, buf))) {
+	retval = io_channel_write_blk64(jfs->io, start, -SUPERBLOCK_SIZE, buf);
+	if (retval != 0) {
 		com_err(program_name, retval,
 			"while writing journal superblock.");
 		return retval;
@@ -2274,7 +2277,7 @@ retry_open:
 		int set_csum = 0;
 		dgrp_t i;
 		char buf[SUPERBLOCK_SIZE];
-		char old_uuid[UUID_SIZE];
+		__u8 old_uuid[UUID_SIZE];
 
 		if (sb->s_feature_ro_compat &
 		    EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
-- 
1.7.3.4

