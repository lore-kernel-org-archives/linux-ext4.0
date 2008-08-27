From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/4] ext2fs_block_iterate2: Add BLOCK_FLAG_APPEND support for extent-based files
Date: Wed, 27 Aug 2008 17:14:35 -0400
Message-ID: <1219871676-18456-3-git-send-email-tytso@mit.edu>
References: <20080827210636.GC26987@mit.edu>
 <1219871676-18456-1-git-send-email-tytso@mit.edu>
 <1219871676-18456-2-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Boh=C3=A9?= <frederic.bohe@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:51451 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752874AbYH0VOi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Aug 2008 17:14:38 -0400
In-Reply-To: <1219871676-18456-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is needed so that extent-based inodes (including a journal inode)
can be created via block_iterate.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/block.c |   28 ++++++++++++++++++++++++----
 1 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/block.c b/lib/ext2fs/block.c
index 14be1ba..2fc3c4a 100644
--- a/lib/ext2fs/block.c
+++ b/lib/ext2fs/block.c
@@ -361,7 +361,7 @@ errcode_t ext2fs_block_iterate2(ext2_filsys fs,
 	if (inode.i_flags & EXT4_EXTENTS_FL) {
 		ext2_extent_handle_t	handle;
 		struct ext2fs_extent	extent;
-		e2_blkcnt_t		blockcnt;
+		e2_blkcnt_t		blockcnt = 0;
 		blk_t			blk, new_blk;
 		int			op = EXT2_EXTENT_ROOT;
 		unsigned int		j;
@@ -373,9 +373,29 @@ errcode_t ext2fs_block_iterate2(ext2_filsys fs,
 		while (1) {
 			ctx.errcode = ext2fs_extent_get(handle, op, &extent);
 			if (ctx.errcode) {
-				if (ctx.errcode == EXT2_ET_EXTENT_NO_NEXT)
-					ctx.errcode = 0;
-				break;
+				if (ctx.errcode != EXT2_ET_EXTENT_NO_NEXT)
+					break;
+				ctx.errcode = 0;
+				if (!(flags & BLOCK_FLAG_APPEND))
+					break;
+				blk = 0;
+				r = (*ctx.func)(fs, &blk, blockcnt,
+						0, 0, priv_data);
+				ret |= r;
+				check_for_ro_violation_goto(&ctx, ret,
+							    extent_errout);
+				if (r & BLOCK_CHANGED) {
+					ctx.errcode = 
+						ext2fs_extent_set_bmap(handle,
+						       (blk64_t) blockcnt++,
+						       (blk64_t) blk, 0);
+					if (ctx.errcode)
+						goto errout;
+					continue;
+				} else {
+					ext2fs_extent_free(handle);
+					goto errout;
+				}
 			}
 
 			op = EXT2_EXTENT_NEXT;
-- 
1.5.6.1.205.ge2c7.dirty

