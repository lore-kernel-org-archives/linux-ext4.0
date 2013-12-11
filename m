From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 12/74] libext2fs: make symlinks safe for 64bit blocks and
 extents
Date: Tue, 10 Dec 2013 17:19:41 -0800
Message-ID: <20131211011941.30655.52101.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42342 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab3LKBTr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:19:47 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we have to create a big symlink (i.e. one that doesn't fit into
i_block[]), we are not 64bit block safe and the namei code does not
handle extents at all.  Fix both.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/namei.c   |    9 +++++++--
 lib/ext2fs/symlink.c |   20 ++++++--------------
 2 files changed, 13 insertions(+), 16 deletions(-)


diff --git a/lib/ext2fs/namei.c b/lib/ext2fs/namei.c
index efcc02b..307aecc 100644
--- a/lib/ext2fs/namei.c
+++ b/lib/ext2fs/namei.c
@@ -34,6 +34,7 @@ static errcode_t follow_link(ext2_filsys fs, ext2_ino_t root, ext2_ino_t dir,
 	char *buffer = 0;
 	errcode_t retval;
 	struct ext2_inode ei;
+	blk64_t blk;
 
 #ifdef NAMEI_DEBUG
 	printf("follow_link: root=%lu, dir=%lu, inode=%lu, lc=%d\n",
@@ -49,12 +50,16 @@ static errcode_t follow_link(ext2_filsys fs, ext2_ino_t root, ext2_ino_t dir,
 	if (link_count++ >= EXT2FS_MAX_NESTED_LINKS)
 		return EXT2_ET_SYMLINK_LOOP;
 
-	/* FIXME-64: Actually, this is FIXME EXTENTS */
 	if (ext2fs_inode_data_blocks(fs,&ei)) {
+		retval = ext2fs_bmap2(fs, inode, &ei, NULL, 0, 0, NULL, &blk);
+		if (retval)
+			return retval;
+
 		retval = ext2fs_get_mem(fs->blocksize, &buffer);
 		if (retval)
 			return retval;
-		retval = io_channel_read_blk(fs->io, ei.i_block[0], 1, buffer);
+
+		retval = io_channel_read_blk64(fs->io, blk, 1, buffer);
 		if (retval) {
 			ext2fs_free_mem(&buffer);
 			return retval;
diff --git a/lib/ext2fs/symlink.c b/lib/ext2fs/symlink.c
index e943412..ad80444 100644
--- a/lib/ext2fs/symlink.c
+++ b/lib/ext2fs/symlink.c
@@ -91,14 +91,12 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 		memset(block_buf, 0, fs->blocksize);
 		strcpy(block_buf, target);
 		if (fs->super->s_feature_incompat &
-		   EXT3_FEATURE_INCOMPAT_EXTENTS) {
+		    EXT3_FEATURE_INCOMPAT_EXTENTS) {
 			/*
 			 * The extent bmap is setup after the inode and block
 			 * have been written out below.
 			 */
 			inode.i_flags |= EXT4_EXTENTS_FL;
-		} else {
-			inode.i_block[0] = blk;
 		}
 	}
 
@@ -112,20 +110,14 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 		goto cleanup;
 
 	if (!fastlink) {
-		retval = io_channel_write_blk(fs->io, blk, 1, block_buf);
+		retval = ext2fs_bmap2(fs, ino, &inode, NULL, BMAP_SET, 0, NULL,
+				      &blk);
 		if (retval)
 			goto cleanup;
 
-		if (fs->super->s_feature_incompat &
-		    EXT3_FEATURE_INCOMPAT_EXTENTS) {
-			retval = ext2fs_extent_open2(fs, ino, &inode, &handle);
-			if (retval)
-				goto cleanup;
-			retval = ext2fs_extent_set_bmap(handle, 0, blk, 0);
-			ext2fs_extent_free(handle);
-			if (retval)
-				goto cleanup;
-		}
+		retval = io_channel_write_blk64(fs->io, blk, 1, block_buf);
+		if (retval)
+			goto cleanup;
 	}
 
 	/*

