Return-Path: <SRS0=nfm4=NB=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:41480 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727613AbeJUWJv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 21 Oct 2018 18:09:51 -0400
From: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] libext2fs: refactor code which fixes up the checksums in an extent tree
Date: Sun, 21 Oct 2018 09:55:20 -0400
Message-Id: <20181021135520.31566-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The code to recalculate the checksums in an extent tree (which is
needed after an inode is relocated so it has a different inode number)
was duplicated in tune2fs and resize2fs.  In addition, this work could
be done in a much more efficient way inside lib/ext2fs/extent.c.

This commit creates a new library function which corrects the
checksums in an inode's extent tree, named: ext2fs_fix_extents_checksums()

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 lib/ext2fs/ext2fs.h |  4 ++-
 lib/ext2fs/extent.c | 48 ++++++++++++++++++++++++++++++++++++
 misc/tune2fs.c      | 60 +--------------------------------------------
 resize/resize2fs.c  | 56 ++----------------------------------------
 4 files changed, 54 insertions(+), 114 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 185be5df5..a5fc90a9e 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1295,7 +1295,9 @@ extern errcode_t ext2fs_extent_goto(ext2_extent_handle_t handle,
 extern errcode_t ext2fs_extent_goto2(ext2_extent_handle_t handle,
 				     int leaf_level, blk64_t blk);
 extern errcode_t ext2fs_extent_fix_parents(ext2_extent_handle_t handle);
-size_t ext2fs_max_extent_depth(ext2_extent_handle_t handle);
+extern size_t ext2fs_max_extent_depth(ext2_extent_handle_t handle);
+extern errcode_t ext2fs_fix_extents_checksums(ext2_filsys fs, ext2_ino_t ino,
+					      struct ext2_inode *inode);
 
 /* fallocate.c */
 #define EXT2_FALLOCATE_ZERO_BLOCKS	(0x1)
diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index a9cdae797..ac3dbfec9 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -1737,6 +1737,54 @@ size_t ext2fs_max_extent_depth(ext2_extent_handle_t handle)
 	return last_result;
 }
 
+errcode_t ext2fs_fix_extents_checksums(ext2_filsys fs, ext2_ino_t ino,
+				       struct ext2_inode *inode)
+{
+	ext2_extent_handle_t	handle;
+	struct ext2fs_extent	extent;
+	errcode_t		errcode;
+	int    			save_flags = fs->flags;
+
+	if (!ext2fs_has_feature_metadata_csum(fs->super) ||
+	    (inode && !(inode->i_flags & EXT4_EXTENTS_FL)))
+		return 0;
+
+	errcode = ext2fs_extent_open2(fs, ino, inode, &handle);
+	if (errcode) {
+		if (errcode == EXT2_ET_INODE_NOT_EXTENT)
+			errcode = 0;
+		return errcode;
+	}
+
+	fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
+	errcode = ext2fs_extent_get(handle, EXT2_EXTENT_ROOT, &extent);
+	if (errcode)
+		goto out;
+
+	do {
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
+		if (errcode == EXT2_ET_EXTENT_CSUM_INVALID)
+			errcode = update_path(handle);
+	} while (errcode == 0);
+
+out:
+	/* Ok if we run off the end */
+	if (errcode == EXT2_ET_EXTENT_NO_NEXT)
+		errcode = 0;
+	ext2fs_extent_free(handle);
+	fs->flags = save_flags;
+	return errcode;
+}
+
 #ifdef DEBUG
 /*
  * Override debugfs's prompt
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index a680b461c..616bdc630 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -497,64 +497,6 @@ static void convert_64bit(ext2_filsys fs, int direction)
 		fprintf(stderr, _("' to disable 64-bit mode.\n"));
 }
 
-/* Rewrite extents */
-static errcode_t rewrite_extents(ext2_filsys fs, ext2_ino_t ino,
-				 struct ext2_inode *inode)
-{
-	ext2_extent_handle_t	handle;
-	struct ext2fs_extent	extent;
-	errcode_t		errcode;
-	struct ext2_extent_info	info;
-
-	if (!(inode->i_flags & EXT4_EXTENTS_FL) ||
-	    !ext2fs_has_feature_metadata_csum(fs->super))
-		return 0;
-
-	errcode = ext2fs_extent_open(fs, ino, &handle);
-	if (errcode)
-		return errcode;
-
-	errcode = ext2fs_extent_get(handle, EXT2_EXTENT_ROOT, &extent);
-	if (errcode)
-		goto out;
-
-	do {
-		errcode = ext2fs_extent_get_info(handle, &info);
-		if (errcode)
-			break;
-
-		/*
-		 * If this is the first extent in an extent block that we
-		 * haven't visited, rewrite the extent to force the ETB
-		 * checksum to be rewritten.
-		 */
-		if (info.curr_entry == 1 && info.curr_level != 0 &&
-		    !(extent.e_flags & EXT2_EXTENT_FLAGS_SECOND_VISIT)) {
-			errcode = ext2fs_extent_replace(handle, 0, &extent);
-			if (errcode)
-				break;
-		}
-
-		/* Skip to the end of a block of leaf nodes */
-		if (extent.e_flags & EXT2_EXTENT_FLAGS_LEAF) {
-			errcode = ext2fs_extent_get(handle,
-						    EXT2_EXTENT_LAST_SIB,
-						    &extent);
-			if (errcode)
-				break;
-		}
-
-		errcode = ext2fs_extent_get(handle, EXT2_EXTENT_NEXT, &extent);
-	} while (errcode == 0);
-
-out:
-	/* Ok if we run off the end */
-	if (errcode == EXT2_ET_EXTENT_NO_NEXT)
-		errcode = 0;
-	ext2fs_extent_free(handle);
-	return errcode;
-}
-
 /*
  * Rewrite directory blocks with checksums
  */
@@ -849,7 +791,7 @@ static void rewrite_one_inode(struct rewrite_context *ctx, ext2_ino_t ino,
 	if (retval)
 		fatal_err(retval, "while writing inode");
 
-	retval = rewrite_extents(ctx->fs, ino, inode);
+	retval = ext2fs_fix_extents_checksums(ctx->fs, ino, inode);
 	if (retval)
 		fatal_err(retval, "while rewriting extents");
 
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 38032e5c3..c2e10471b 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1927,59 +1927,6 @@ out:
 	return err;
 }
 
-/* Rewrite extents */
-static errcode_t rewrite_extents(ext2_filsys fs, ext2_ino_t ino)
-{
-	ext2_extent_handle_t	handle;
-	struct ext2fs_extent	extent;
-	errcode_t		errcode;
-	struct ext2_extent_info	info;
-
-	errcode = ext2fs_extent_open(fs, ino, &handle);
-	if (errcode)
-		return errcode;
-
-	errcode = ext2fs_extent_get(handle, EXT2_EXTENT_ROOT, &extent);
-	if (errcode)
-		goto out;
-
-	do {
-		errcode = ext2fs_extent_get_info(handle, &info);
-		if (errcode)
-			break;
-
-		/*
-		 * If this is the first extent in an extent block that we
-		 * haven't visited, rewrite the extent to force the ETB
-		 * checksum to be rewritten.
-		 */
-		if (info.curr_entry == 1 && info.curr_level != 0 &&
-		    !(extent.e_flags & EXT2_EXTENT_FLAGS_SECOND_VISIT)) {
-			errcode = ext2fs_extent_replace(handle, 0, &extent);
-			if (errcode)
-				break;
-		}
-
-		/* Skip to the end of a block of leaf nodes */
-		if (extent.e_flags & EXT2_EXTENT_FLAGS_LEAF) {
-			errcode = ext2fs_extent_get(handle,
-						    EXT2_EXTENT_LAST_SIB,
-						    &extent);
-			if (errcode)
-				break;
-		}
-
-		errcode = ext2fs_extent_get(handle, EXT2_EXTENT_NEXT, &extent);
-	} while (errcode == 0);
-
-out:
-	/* Ok if we run off the end */
-	if (errcode == EXT2_ET_EXTENT_NO_NEXT)
-		errcode = 0;
-	ext2fs_extent_free(handle);
-	return errcode;
-}
-
 static void quiet_com_err_proc(const char *whoami EXT2FS_ATTR((unused)),
 			       errcode_t code EXT2FS_ATTR((unused)),
 			       const char *fmt EXT2FS_ATTR((unused)),
@@ -2276,7 +2223,8 @@ remap_blocks:
 		/* Fix up extent block checksums with the new inode number */
 		if (ext2fs_has_feature_metadata_csum(rfs->old_fs->super) &&
 		    (inode->i_flags & EXT4_EXTENTS_FL)) {
-			retval = rewrite_extents(rfs->old_fs, new_inode);
+			retval = ext2fs_fix_extents_checksums(rfs->old_fs,
+							      new_inode, NULL);
 			if (retval)
 				goto errout;
 		}
-- 
2.18.0.rc0
