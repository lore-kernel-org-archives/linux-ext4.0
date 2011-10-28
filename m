From: Greg Harm <gharm@google.com>
Subject: [PATCH] Ext4: Don't normalize an falloc request if it can fit in 1 extent.
Date: Fri, 28 Oct 2011 11:01:57 -0700
Message-ID: <1319824917-28345-1-git-send-email-gharm@google.com>
Cc: linux-ext4@vger.kernel.org, Greg Harm <gharm@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:12991 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab1J1SC3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 28 Oct 2011 14:02:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If an fallocate request fits in EXT_UNINIT_MAX_LEN, then set the
EXT4_GET_BLOCKS_NO_NORMALIZE flag. For larger fallocate requests,
let mballoc.c normalize the request.
This fixes a problem where large requests were being split
into non-contiguous extents due to haldar@google.com's
"ext4: do not normalize block requests from fallocate."

Testing: Checked that 8.x MB falloc'ed files are still laid down
next to each other (contiguously).
Checked that the maximum size extent (127.9MB) is allocated as 1
extent.
Checked that a 1GB file is somewhat contiguous (often 5-6
non-contiguous extents now).
Checked that a 120MB file can still be falloc'ed even if there are no
single extents large enough to hold it.

Signed-off-by: Greg Harm <gharm@google.com>
---
 fs/ext4/extents.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 57cf568..9819216 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3761,6 +3761,7 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	int ret2 = 0;
 	int retries = 0;
 	struct ext4_map_blocks map;
+	int map_blocks_flags;
 	unsigned int credits, blkbits = inode->i_blkbits;
 
 	/*
@@ -3805,9 +3806,15 @@ retry:
 			ret = PTR_ERR(handle);
 			break;
 		}
-		ret = ext4_map_blocks(handle, inode, &map,
-				      EXT4_GET_BLOCKS_CREATE_UNINIT_EXT |
-				      EXT4_GET_BLOCKS_NO_NORMALIZE);
+		map_blocks_flags = EXT4_GET_BLOCKS_CREATE_UNINIT_EXT;
+		/*
+		 * Don't normalize the request if it can fit in one extent so
+		 * that it doesn't get unnecessarily split into multiple
+		 * extents.
+		 */
+		if (len <= EXT_UNINIT_MAX_LEN << blkbits)
+			map_blocks_flags |= EXT4_GET_BLOCKS_NO_NORMALIZE;
+		ret = ext4_map_blocks(handle, inode, &map, map_blocks_flags);
 		if (ret <= 0) {
 #ifdef EXT4FS_DEBUG
 			WARN_ON(ret <= 0);
-- 
1.7.3.1

