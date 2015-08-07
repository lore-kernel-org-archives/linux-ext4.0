From: Jan Kara <jack@suse.com>
Subject: [PATCH 07/19] ext2fs: Provide helper for wiping resize inode
Date: Fri,  7 Aug 2015 12:51:17 +0200
Message-ID: <1438944689-24562-8-git-send-email-jack@suse.com>
References: <1438944689-24562-1-git-send-email-jack@suse.com>
Cc: Ted Tso <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Jan Kara <jack@suse.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39135 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbbHGKvp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 7 Aug 2015 06:51:45 -0400
In-Reply-To: <1438944689-24562-1-git-send-email-jack@suse.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Provide a helper function ext2fs_wipe_resize_inode() which clears resize
inode and use it from resize2fs.

Signed-off-by: Jan Kara <jack@suse.com>
---
 lib/ext2fs/ext2fs.h  |  1 +
 lib/ext2fs/res_gdt.c | 34 ++++++++++++++++++++++++++++++++++
 resize/resize2fs.c   | 26 ++------------------------
 3 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 3eda8d1f4ad3..0b8d1f6f22b1 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1588,6 +1588,7 @@ extern errcode_t ext2fs_read_bb_FILE(ext2_filsys fs, FILE *f,
 
 /* res_gdt.c */
 extern errcode_t ext2fs_create_resize_inode(ext2_filsys fs);
+extern errcode_t ext2fs_wipe_resize_inode(ext2_filsys fs);
 
 /*sha256.c */
 #define EXT2FS_SHA256_LENGTH 32
diff --git a/lib/ext2fs/res_gdt.c b/lib/ext2fs/res_gdt.c
index 46db61c5cf0d..5a44f5676df4 100644
--- a/lib/ext2fs/res_gdt.c
+++ b/lib/ext2fs/res_gdt.c
@@ -238,3 +238,37 @@ out_free:
 	return retval;
 }
 
+/* Clear resize inode so that it can be recreated */
+errcode_t ext2fs_wipe_resize_inode(ext2_filsys fs)
+{
+	struct ext2_inode	inode;
+	errcode_t		retval;
+
+	retval = ext2fs_read_inode(fs, EXT2_RESIZE_INO, &inode);
+	if (retval)
+		goto errout;
+
+	ext2fs_iblk_set(fs, &inode, 1);
+
+	retval = ext2fs_write_inode(fs, EXT2_RESIZE_INO, &inode);
+	if (retval)
+		goto errout;
+
+	/* Check resize inode is sane */
+	if (!inode.i_block[EXT2_DIND_BLOCK]) {
+		retval = EINVAL;
+		goto errout;
+	}
+
+	retval = ext2fs_zero_blocks2(fs, inode.i_block[EXT2_DIND_BLOCK], 1,
+				     NULL, NULL);
+	if (retval)
+		goto errout;
+
+	retval = ext2fs_create_resize_inode(fs);
+	if (retval)
+		goto errout;
+
+errout:
+	return retval;
+}
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 9d21cebe16aa..a8ba8adcfb86 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -2535,34 +2535,12 @@ static errcode_t reserve_sparse_super2_last_group(ext2_resize_t rfs,
  */
 static errcode_t fix_resize_inode(ext2_filsys fs)
 {
-	struct ext2_inode	inode;
 	errcode_t		retval;
 
-	if (!(fs->super->s_feature_compat &
-	      EXT2_FEATURE_COMPAT_RESIZE_INODE))
+	if (!(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_RESIZE_INODE))
 		return 0;
 
-	retval = ext2fs_read_inode(fs, EXT2_RESIZE_INO, &inode);
-	if (retval) goto errout;
-
-	ext2fs_iblk_set(fs, &inode, 1);
-
-	retval = ext2fs_write_inode(fs, EXT2_RESIZE_INO, &inode);
-	if (retval) goto errout;
-
-	if (!inode.i_block[EXT2_DIND_BLOCK]) {
-		/*
-		 * Avoid zeroing out block #0; that's rude.  This
-		 * should never happen anyway since the filesystem
-		 * should be fsck'ed and we assume it is consistent.
-		 */
-		fprintf(stderr, "%s",
-			_("Should never happen: resize inode corrupt!\n"));
-		exit(1);
-	}
