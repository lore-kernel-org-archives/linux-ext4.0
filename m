From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/3] libext2fs: Fix regression in ext2fs_extent_set_bmap()
Date: Sun, 19 Jul 2009 23:57:03 -0400
Message-ID: <1248062225-710-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:59387 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbZGTD5P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 19 Jul 2009 23:57:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Commit 0dc291611 introduced a regression when unmapping the first
block in an extent.  This caused e2fsck -fD to corrupt large
directories if the directory has to shrink by more than one block.
The problem was set_bmap should only go to a next leaf when setting a
first block in an extent, and not when it is unmapping the first block
in an extent.

Addresses-Debian-Bug: #537510

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/extent.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 7fcc2cf..9d7b7de 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -1296,11 +1296,12 @@ errcode_t ext2fs_extent_set_bmap(ext2_extent_handle_t handle,
 			}
 			if (retval)
 				goto done;
+			retval = ext2fs_extent_get(handle,
+						   EXT2_EXTENT_NEXT_LEAF,
+						   &extent);
+			if (retval)
+				goto done;
 		}
-		retval = ext2fs_extent_get(handle, EXT2_EXTENT_NEXT_LEAF,
-					   &extent);
-		if (retval)
-			goto done;
 		extent.e_pblk++;
 		extent.e_lblk++;
 		extent.e_len--;
-- 
1.6.3.2.1.gb9f7d.dirty

