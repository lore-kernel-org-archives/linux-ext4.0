From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 06/25] libext2fs: fix tests that set LARGE_FILE
Date: Thu, 17 Oct 2013 21:49:35 -0700
Message-ID: <20131018044935.7339.68127.stgit@birch.djwong.org>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47446 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab3JREtk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Oct 2013 00:49:40 -0400
In-Reply-To: <20131018044854.7339.48457.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For each site where we test for a large file (> 2GB) and set the
LARGE_FILE feature, use a helper function to make the size test
consistent with the test that's in e2fsck.  This fixes the fsck
complaints when we try to create a 2GB journal (not so hard with 64k
block size) and fixes the incorrect test in fileio.c.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c         |    3 ++-
 lib/ext2fs/ext2fs.h    |    6 ++++++
 lib/ext2fs/fileio.c    |    2 +-
 lib/ext2fs/mkjournal.c |    2 +-
 4 files changed, 10 insertions(+), 3 deletions(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index ab23e42..8c18a93 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2281,7 +2281,8 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		}
 		pctx->num = 0;
 	}
-	if (LINUX_S_ISREG(inode->i_mode) && EXT2_I_SIZE(inode) >= 0x80000000UL)
+	if (LINUX_S_ISREG(inode->i_mode) &&
+	    ext2fs_needs_large_file_feature(EXT2_I_SIZE(inode)))
 		ctx->large_files++;
 	if ((pb.num_blocks != ext2fs_inode_i_blocks(fs, inode)) ||
 	    ((fs->super->s_feature_ro_compat &
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 1ef4d67..8f82dae 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -646,6 +646,12 @@ static inline int ext2fs_has_group_desc_csum(ext2_filsys fs)
 			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
 }
 
+/* The LARGE_FILE feature should be set if we have stored files 2GB+ in size */
+static inline int ext2fs_needs_large_file_feature(unsigned long long file_size)
+{
+	return file_size >= 0x80000000ULL;
+}
+
 /* alloc.c */
 extern errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir, int mode,
 				  ext2fs_inode_bitmap map, ext2_ino_t *ret);
diff --git a/lib/ext2fs/fileio.c b/lib/ext2fs/fileio.c
index 02e6263..6b213b5 100644
--- a/lib/ext2fs/fileio.c
+++ b/lib/ext2fs/fileio.c
@@ -400,7 +400,7 @@ errcode_t ext2fs_file_set_size2(ext2_file_t file, ext2_off64_t size)
 
 	/* If we're writing a large file, set the large_file flag */
 	if (LINUX_S_ISREG(file->inode.i_mode) &&
-	    EXT2_I_SIZE(&file->inode) > 0x7FFFFFFULL &&
+	    ext2fs_needs_large_file_feature(EXT2_I_SIZE(&file->inode)) &&
 	    (!EXT2_HAS_RO_COMPAT_FEATURE(file->fs->super,
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE) ||
 	     file->fs->super->s_rev_level == EXT2_GOOD_OLD_REV)) {
diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index c636a97..2afd3b7 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -378,7 +378,7 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 	inode_size = (unsigned long long)fs->blocksize * num_blocks;
 	inode.i_size = inode_size & 0xFFFFFFFF;
 	inode.i_size_high = (inode_size >> 32) & 0xFFFFFFFF;
-	if (inode.i_size_high)
+	if (ext2fs_needs_large_file_feature(inode_size))
 		fs->super->s_feature_ro_compat |=
 			EXT2_FEATURE_RO_COMPAT_LARGE_FILE;
 	ext2fs_iblk_add_blocks(fs, &inode, es.newblocks);

