From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 6/6] libext2fs: try to roll back when splitting an extent fails
Date: Mon, 20 Jan 2014 22:22:17 -0800
Message-ID: <20140121062217.20507.51789.stgit@birch.djwong.org>
References: <20140121062138.20507.60259.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20892 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbaAUGWX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jan 2014 01:22:23 -0500
In-Reply-To: <20140121062138.20507.60259.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If a client asks us to remap a block in the middle of an extent, we
potentially have to allocate a fair number of blocks to handle extent
tree splits.  A failure in either of the ext2fs_extent_insert calls
leaves us with an extent tree that no longer maps the logical block in
question and everything that came after it!  Therefore, try to roll
back the extent tree changes before returning an error code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/extent.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)


diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 2928695..87921e6 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -1438,13 +1438,17 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 			goto done;
 	} else {
 		__u32	orig_length;
+		blk64_t	orig_lblk;
+		struct ext2fs_extent orig_extent;
+		errcode_t r2;
 
 #ifdef DEBUG
 		printf("(re/un)mapping in middle of extent\n");
 #endif
 		/* need to split this extent; later */
-
+		orig_lblk = extent.e_lblk;
 		orig_length = extent.e_len;
+		orig_extent = extent;
 
 		/* shorten pre-split extent */
 		extent.e_len = (logical - extent.e_lblk);
@@ -1456,8 +1460,13 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 			/* insert new extent after current */
 			retval = ext2fs_extent_insert(handle,
 					EXT2_EXTENT_INSERT_AFTER, &newextent);
-			if (retval)
+			if (retval) {
+				r2 = ext2fs_extent_goto(handle, orig_lblk);
+				if (r2 == 0)
+					ext2fs_extent_replace(handle, 0,
+							      &orig_extent);
 				goto done;
+			}
 		}
 		/* add post-split extent */
 		extent.e_pblk += extent.e_len + 1;
@@ -1465,8 +1474,18 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 		extent.e_len = orig_length - extent.e_len - 1;
 		retval = ext2fs_extent_insert(handle,
 				EXT2_EXTENT_INSERT_AFTER, &extent);
-		if (retval)
+		if (retval) {
+			if (physical) {
+				r2 = ext2fs_extent_goto(handle,
+							newextent.e_lblk);
+				if (r2 == 0)
+					ext2fs_extent_delete(handle, 0);
+			}
+			r2 = ext2fs_extent_goto(handle, orig_lblk);
+			if (r2 == 0)
+				ext2fs_extent_replace(handle, 0, &orig_extent);
 			goto done;
+		}
 	}
 
 done:

