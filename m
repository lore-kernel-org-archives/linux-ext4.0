From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 32/74] libext2fs: fix punching extents when there are no left
 extents
Date: Tue, 10 Dec 2013 17:21:54 -0800
Message-ID: <20131211012154.30655.52115.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42941 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab3LKBWA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:22:00 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When deleting an entire extent, we cannot always slip to the previous
leaf extent because there might not /be/ a previous extent.
Attempting to correct for that error by asking for the 'current' leaf
extent also doesn't work, because the failed attempt to change to the
previous extent leaves us with no current extent.

Fix this problem by recording the lblk of the next extent before
deleting the current extent and _goto()ing to the next extent after
the deletion.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/punch.c |   41 ++++++++++++++++++++++++++++++-----------
 1 file changed, 30 insertions(+), 11 deletions(-)


diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
index ceec336..9dfba2e 100644
--- a/lib/ext2fs/punch.c
+++ b/lib/ext2fs/punch.c
@@ -267,22 +267,41 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
 			retval = ext2fs_extent_replace(handle, 0, &extent);
 		} else {
 			struct ext2fs_extent	newex;
+			blk64_t			old_lblk, next_lblk;
 			dbg_printf("deleting current extent%s\n", "");
-			retval = ext2fs_extent_delete(handle, 0);
-			if (retval)
-				goto errout;
+
 			/*
-			 * We just moved the next extent into the current
-			 * extent's position, so re-read the extent next time.
+			 * Save the location of the next leaf, then slip
+			 * back to the current extent.
 			 */
+			retval = ext2fs_extent_get(handle, EXT2_EXTENT_CURRENT,
+						   &newex);
+			if (retval)
+				goto errout;
+			old_lblk = newex.e_lblk;
+
 			retval = ext2fs_extent_get(handle,
-						   EXT2_EXTENT_PREV_LEAF,
+						   EXT2_EXTENT_NEXT_LEAF,
 						   &newex);
-			/* Can't go back? Just reread current. */
-			if (retval == EXT2_ET_EXTENT_NO_PREV) {
-				retval = 0;
-				op = EXT2_EXTENT_CURRENT;
-			}
+			if (retval == EXT2_ET_EXTENT_NO_NEXT)
+				next_lblk = old_lblk;
+			else if (retval)
+				goto errout;
+			else
+				next_lblk = newex.e_lblk;
+
+			retval = ext2fs_extent_goto(handle, old_lblk);
+			if (retval)
+				goto errout;
+
+			/* Now delete the extent. */
+			retval = ext2fs_extent_delete(handle, 0);
+			if (retval)
+				goto errout;
+
+			/* Jump forward to the next extent. */
+			ext2fs_extent_goto(handle, next_lblk);
+			op = EXT2_EXTENT_CURRENT;
 		}
 		if (retval)
 			goto errout;

