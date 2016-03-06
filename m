From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH 2/6] debugfs: improve dump_mmp handling
Date: Sat,  5 Mar 2016 17:38:32 -0700
Message-ID: <1457224716-72388-2-git-send-email-adilger@dilger.ca>
References: <1457224716-72388-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-no.shaw.ca ([64.59.134.12]:33819 "EHLO
	smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbcCFAqd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Mar 2016 19:46:33 -0500
In-Reply-To: <1457224716-72388-1-git-send-email-adilger@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If MMP is not enabled on a filesystem (s_mmp_block == 0), print this
clearly rather than "MMP: block number beyond filesystem range".

Add an option to "debugfs dump_mmp" to specify the MMP block number
instead of getting it from the superblock s_mmp_block field.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 debugfs/debugfs.8.in |  9 +++++++--
 debugfs/debugfs.c    | 25 ++++++++++++++++++++++---
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/debugfs/debugfs.8.in b/debugfs/debugfs.8.in
index bae14db..4928791 100644
--- a/debugfs/debugfs.8.in
+++ b/debugfs/debugfs.8.in
@@ -221,8 +221,13 @@ option is given set the owner, group and permissions information on
 to match
 .IR filespec .
 .TP
-.B dump_mmp
-Display the multiple-mount protection (mmp) field values.
+.BI dump_mmp " [mmp_block]"
+Display the multiple-mount protection (mmp) field values.  If
+.I mmp_block
+is specified then verify and dump the MMP values from the given block
+number, otherwise use the
+.B s_mmp_block
+field in the superblock to locate and use the existing MMP block.
 .TP
 .BI dx_hash " [-h hash_alg] [-s hash_seed] filename"
 Calculate the directory hash of
diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 5423634..260698c 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -2351,12 +2351,31 @@ try_again:
 void do_dump_mmp(int argc EXT2FS_ATTR((unused)), char *argv[])
 {
 	struct mmp_struct *mmp_s;
+	unsigned long long mmp_block;
 	time_t t;
 	errcode_t retval = 0;
 
 	if (check_fs_open(argv[0]))
 		return;
 
+	if (argc > 1) {
+		char *end = NULL;
+		mmp_block = strtoull(argv[1], &end, 0);
+		if (end == argv[0] || mmp_block == 0) {
+			fprintf(stderr, "%s: invalid MMP block '%s' given\n",
+				argv[0], argv[1]);
+			return;
+		}
+	} else {
+		mmp_block = current_fs->super->s_mmp_block;
+	}
+
+	if (mmp_block == 0) {
+		fprintf(stderr, "%s: MMP: not active on this filesystem.\n",
+			argv[0]);
+		return;
+	}
+
 	if (current_fs->mmp_buf == NULL) {
 		retval = ext2fs_get_mem(current_fs->blocksize,
 					&current_fs->mmp_buf);
@@ -2368,10 +2387,10 @@ void do_dump_mmp(int argc EXT2FS_ATTR((unused)), char *argv[])
 
 	mmp_s = current_fs->mmp_buf;
 
-	retval = ext2fs_mmp_read(current_fs, current_fs->super->s_mmp_block,
-				 current_fs->mmp_buf);
+	retval = ext2fs_mmp_read(current_fs, mmp_block, current_fs->mmp_buf);
 	if (retval) {
-		com_err(argv[0], retval, "reading MMP block.\n");
+		com_err(argv[0], retval, "reading MMP block %llu.\n",
+			mmp_block);
 		return;
 	}
 
-- 
1.8.0

