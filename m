From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 07/39] tune2fs: speed up rewriting extent tree when enabling
 metadata_csum
Date: Sat, 25 Oct 2014 13:57:08 -0700
Message-ID: <20141025205708.532.99186.stgit@birch.djwong.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43744 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbaJYU5c (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Oct 2014 16:57:32 -0400
In-Reply-To: <20141025205623.532.12119.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When enabling checksums, tune2fs naively rewrites every extent in the
entire tree!  This is unnecessary since we only need to rewrite each
extent tree block; therefore, only rewrite the extent if it's the
first one in an internal extent tree block.

Also, don't bother iterating the extent tree when clearing checksums.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 misc/tune2fs.c |   49 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 16 deletions(-)


diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index d17c8de..ecbdea0 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -442,39 +442,56 @@ static errcode_t rewrite_extents(ext2_filsys fs, ext2_ino_t ino,
 {
 	ext2_extent_handle_t	handle;
 	struct ext2fs_extent	extent;
-	int			op = EXT2_EXTENT_ROOT;
 	errcode_t		errcode;
+	struct ext2_extent_info	info;
 
-	if (!(inode->i_flags & EXT4_EXTENTS_FL))
+	if (!(inode->i_flags & EXT4_EXTENTS_FL) ||
+	    !EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
 		return 0;
 
 	errcode = ext2fs_extent_open(fs, ino, &handle);
 	if (errcode)
 		return errcode;
 
-	while (1) {
-		errcode = ext2fs_extent_get(handle, op, &extent);
+	errcode = ext2fs_extent_get(handle, EXT2_EXTENT_ROOT, &extent);
+	if (errcode)
+		goto out;
+
+	do {
+		errcode = ext2fs_extent_get_info(handle, &info);
 		if (errcode)
 			break;
 
-		/* Root node is in the separately checksummed inode */
-		if (op == EXT2_EXTENT_ROOT) {
-			op = EXT2_EXTENT_NEXT;
-			continue;
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
 		}
-		op = EXT2_EXTENT_NEXT;
 
-		/* Only visit the first extent in each extent block */
-		if (extent.e_flags & EXT2_EXTENT_FLAGS_SECOND_VISIT)
-			continue;
-		errcode = ext2fs_extent_replace(handle, 0, &extent);
-		if (errcode)
-			break;
-	}
+		/* Skip to the end of a block of leaf nodes */
+		if (extent.e_flags & EXT2_EXTENT_FLAGS_LEAF) {
+			errcode = ext2fs_extent_get(handle,
+						    EXT2_EXTENT_LAST_SIB,
+						    &extent);
+			if (errcode)
+				break;
+		}
 
+		errcode = ext2fs_extent_get(handle, EXT2_EXTENT_NEXT, &extent);
+	} while (errcode == 0);
+
+out:
 	/* Ok if we run off the end */
 	if (errcode == EXT2_ET_EXTENT_NO_NEXT)
 		errcode = 0;
+	ext2fs_extent_free(handle);
 	return errcode;
 }
 

