From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 09/31] libext2fs: Rewind extent pointer when totally deleting
 an extent
Date: Mon, 30 Sep 2013 18:27:40 -0700
Message-ID: <20131001012740.28415.55304.stgit@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22471 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab3JAB1o (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Sep 2013 21:27:44 -0400
In-Reply-To: <20131001012642.28415.89353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

During a punch operation, if we decide to delete an extent out of the extent
tree, the subsequent extents are moved on top of the current extent (that is to
say, they're memmmove'd down one slot).  Therefore it is not correct to advance
to the next leaf because that means we miss half the extents in the range!
Rereading the current pointer should be fine.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/punch.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)


diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
index b53653a..11c7668 100644
--- a/lib/ext2fs/punch.c
+++ b/lib/ext2fs/punch.c
@@ -186,6 +186,7 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
 	blk64_t			free_start, next;
 	__u32			free_count, newlen;
 	int			freed = 0;
+	int			op;
 
 	retval = ext2fs_extent_open2(fs, ino, inode, &handle);
 	if (retval)
@@ -195,6 +196,7 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
 	if (retval)
 		goto errout;
 	while (1) {
+		op = EXT2_EXTENT_NEXT_LEAF;
 		dbg_print_extent("main loop", &extent);
 		next = extent.e_lblk + extent.e_len;
 		dbg_printf("start %llu, end %llu, next %llu\n",
@@ -256,8 +258,23 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
 			dbg_print_extent("replacing", &extent);
 			retval = ext2fs_extent_replace(handle, 0, &extent);
 		} else {
+			struct ext2fs_extent	newex;
 			dbg_printf("deleting current extent%s\n", "");
 			retval = ext2fs_extent_delete(handle, 0);
+			if (retval)
+				goto errout;
+			/*
+			 * We just moved the next extent into the current
+			 * extent's position, so re-read the extent next time.
+			 */
+			retval = ext2fs_extent_get(handle,
+						   EXT2_EXTENT_PREV_LEAF,
+						   &newex);
+			/* Can't go back? Just reread current. */
+			if (retval == EXT2_ET_EXTENT_NO_PREV) {
+				retval = 0;
+				op = EXT2_EXTENT_CURRENT;
+			}
 		}
 		if (retval)
 			goto errout;
@@ -268,9 +285,10 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
 			freed++;
 		}
 	next_extent:
-		retval = ext2fs_extent_get(handle, EXT2_EXTENT_NEXT_LEAF,
+		retval = ext2fs_extent_get(handle, op,
 					   &extent);
-		if (retval == EXT2_ET_EXTENT_NO_NEXT)
+		if (retval == EXT2_ET_EXTENT_NO_NEXT ||
+		    retval == EXT2_ET_NO_CURRENT_NODE)
 			break;
 		if (retval)
 			goto errout;

