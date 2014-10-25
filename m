From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 10/39] resize2fs: quickly rewrite extent blocks when moving
 an inode w/ metadata_csum
Date: Sat, 25 Oct 2014 13:57:27 -0700
Message-ID: <20141025205727.532.15520.stgit@birch.djwong.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43849 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbaJYU6B (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Oct 2014 16:58:01 -0400
In-Reply-To: <20141025205623.532.12119.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we're moving an inode on a metadata_csum filesystem, we need to
rewrite the checksum of all interior nodes of the extent tree.  The
current code does this inefficiently via set_bmap, but we can do this
more efficiently through direct iteration of the extent tree.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 resize/resize2fs.c |   74 +++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 64 insertions(+), 10 deletions(-)


diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index ff18817..212fee2 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1492,16 +1492,6 @@ static int process_block(ext2_filsys fs, blk64_t	*block_nr,
 		}
 	}
 
-	/*
-	 * If we moved inodes and metadata_csum is enabled, we must force the
-	 * extent block to be rewritten with new checksum.
-	 */
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
-	    pb->has_extents &&
-	    pb->old_ino != pb->ino)
-		ret |= BLOCK_CHANGED;
-
 	if (pb->is_dir) {
 		retval = ext2fs_add_dir_block2(fs->dblist, pb->ino,
 					       block, (int) blockcnt);
@@ -1581,6 +1571,59 @@ out:
 	return err;
 }
 
+/* Rewrite extents */
+static errcode_t rewrite_extents(ext2_filsys fs, ext2_ino_t ino)
+{
+	ext2_extent_handle_t	handle;
+	struct ext2fs_extent	extent;
+	errcode_t		errcode;
+	struct ext2_extent_info	info;
+
+	errcode = ext2fs_extent_open(fs, ino, &handle);
+	if (errcode)
+		return errcode;
+
+	errcode = ext2fs_extent_get(handle, EXT2_EXTENT_ROOT, &extent);
+	if (errcode)
+		goto out;
+
+	do {
+		errcode = ext2fs_extent_get_info(handle, &info);
+		if (errcode)
+			break;
+
+		/*
+		 * If this is the first extent in an extent block that we
+		 * haven't visited, rewrite the extent to force the ETB
+		 * checksum to be rewritten.
+		 */
+		if (info.curr_entry == 1 && info.curr_level != 0 &&
+		    !(extent.e_flags & EXT2_EXTENT_FLAGS_SECOND_VISIT)) {
+			errcode = ext2fs_extent_replace(handle, 0, &extent);
+			if (errcode)
+				break;
+		}
+
+		/* Skip to the end of a block of leaf nodes */
+		if (extent.e_flags & EXT2_EXTENT_FLAGS_LEAF) {
+			errcode = ext2fs_extent_get(handle,
+						    EXT2_EXTENT_LAST_SIB,
+						    &extent);
+			if (errcode)
+				break;
+		}
+
+		errcode = ext2fs_extent_get(handle, EXT2_EXTENT_NEXT, &extent);
+	} while (errcode == 0);
+
+out:
+	/* Ok if we run off the end */
+	if (errcode == EXT2_ET_EXTENT_NO_NEXT)
+		errcode = 0;
+	ext2fs_extent_free(handle);
+	return errcode;
+}
+
 static errcode_t inode_scan_and_fix(ext2_resize_t rfs)
 {
 	struct process_block_struct	pb;
@@ -1699,6 +1742,17 @@ remap_blocks:
 		if (retval)
 			goto errout;
 
+		/* Rewrite extent block checksums with new inode number */
+		if (EXT2_HAS_RO_COMPAT_FEATURE(rfs->old_fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+		    (inode->i_flags & EXT4_EXTENTS_FL)) {
+			rfs->old_fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
+			retval = rewrite_extents(rfs->old_fs, new_inode);
+			rfs->old_fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
+			if (retval)
+				goto errout;
+		}
+
 		/*
 		 * Update inodes to point to new blocks; schedule directory
 		 * blocks for inode remapping.  Need to write out dir blocks

