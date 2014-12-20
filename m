From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/31] misc: fix clang warnings and a resource leak
Date: Sat, 20 Dec 2014 13:16:47 -0800
Message-ID: <20141220211647.25563.61104.stgit@birch.djwong.org>
References: <20141220211640.25563.80596.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44976 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbaLTVQv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Dec 2014 16:16:51 -0500
In-Reply-To: <20141220211640.25563.80596.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/symlink.c |    2 +-
 misc/e2fuzz.c        |    2 +-
 resize/resize2fs.c   |    6 ++++--
 3 files changed, 6 insertions(+), 4 deletions(-)


diff --git a/lib/ext2fs/symlink.c b/lib/ext2fs/symlink.c
index 0732afe..279f48b 100644
--- a/lib/ext2fs/symlink.c
+++ b/lib/ext2fs/symlink.c
@@ -112,7 +112,7 @@ need_block:
 		ext2fs_iblk_set(fs, &inode, 1);
 		/* Slow symlinks, target stored in the first block */
 		memset(block_buf, 0, fs->blocksize);
-		strcpy(block_buf, target);
+		strncpy(block_buf, target, fs->blocksize);
 		if (fs->super->s_feature_incompat &
 		    EXT3_FEATURE_INCOMPAT_EXTENTS) {
 			/*
diff --git a/misc/e2fuzz.c b/misc/e2fuzz.c
index c08e3df..f786eac 100644
--- a/misc/e2fuzz.c
+++ b/misc/e2fuzz.c
@@ -273,7 +273,7 @@ int process_fs(const char *fsname)
 		if ((rand() % 2) && c < 128)
 			c |= 0x80;
 		if (verbose)
-			printf("Corrupting byte %jd in block %jd to 0x%x\n",
+			printf("Corrupting byte %zu in block %zu to 0x%x\n",
 			       off % fs->blocksize, off / fs->blocksize, c);
 		if (dryrun)
 			continue;
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 3fa13cf..2febfde 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -2311,8 +2311,10 @@ static errcode_t move_itables(ext2_resize_t rfs)
 		    ext2fs_inode_table_loc(fs, i))
 			to_move++;
 
-	if (to_move == 0)
-		return 0;
+	if (to_move == 0) {
+		retval = 0;
+		goto errout;
+	}
 
 	if (rfs->progress) {
 		retval = rfs->progress(rfs, E2_RSZ_MOVE_ITABLE_PASS,

