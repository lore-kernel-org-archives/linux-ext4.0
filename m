From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 4/5] make extent_goto() deterministic when logical block not found
Date: Mon,  7 Apr 2008 22:00:59 -0500
Message-ID: <1207623660-1088-5-git-send-email-sandeen@redhat.com>
References: <1207623660-1088-1-git-send-email-sandeen@redhat.com>
Cc: tytso@mit.edu, Eric Sandeen <sandeen@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758632AbYDKSQX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Apr 2008 14:16:23 -0400
In-Reply-To: <1207623660-1088-1-git-send-email-sandeen@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Make sure that extent_goto() leaves us at the last extent
prior to the requested logical block, if the logical block
requested lands in a hole.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 lib/ext2fs/extent.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 9f19e7b..e7b7e85 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -553,6 +553,12 @@ errcode_t ext2fs_extent_free_path(ext2_extent_path_t path)
 }
 #endif
 
+/*
+ * Go to the node at leaf_level which contains logical block blk.
+ *
+ * If "blk" has no mapping (hole) then handle is left at last
+ * extent before blk.
+ */
 static errcode_t extent_goto(ext2_extent_handle_t handle,
 			     int leaf_level, blk64_t blk)
 {
@@ -566,11 +572,16 @@ static errcode_t extent_goto(ext2_extent_handle_t handle,
 	dbg_print_extent("root", &extent);
 	while (1) {
 		if (handle->level - leaf_level == handle->max_depth) {
+			/* block is in this &extent */
 			if ((blk >= extent.e_lblk) &&
 			    (blk < extent.e_lblk + extent.e_len))
 				return 0;
-			if (blk < extent.e_lblk)
+			if (blk < extent.e_lblk) {
+				retval = ext2fs_extent_get(handle,
+							   EXT2_EXTENT_PREV_SIB,
+							   &extent);
 				return EXT2_ET_EXTENT_NOT_FOUND;
+			}
 			retval = ext2fs_extent_get(handle,
 						   EXT2_EXTENT_NEXT_SIB,
 						   &extent);
-- 
1.5.4.1

