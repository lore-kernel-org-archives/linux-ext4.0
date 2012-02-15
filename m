From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] libext2fs: fix BLOCK_ABORT handling in the block iterator for extents
Date: Wed, 15 Feb 2012 17:27:51 -0500
Message-ID: <1329344871-16253-1-git-send-email-tytso@mit.edu>
References: <20120215222342.GB20023@thunk.org>
Cc: djwong@us.ibm.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45627 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755871Ab2BOW14 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Feb 2012 17:27:56 -0500
In-Reply-To: <20120215222342.GB20023@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When processing files that contain extents, the block iterator
functions were not properly handling the BLOCK_ABORT bit.  This could
cause problems such as ext2fs_link() adding a directory entry multiple
times.

Thanks to Darrick Wong <djwong@us.ibm.com> for reporting this.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/block.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/lib/ext2fs/block.c b/lib/ext2fs/block.c
index 6a5c10d..85a1803 100644
--- a/lib/ext2fs/block.c
+++ b/lib/ext2fs/block.c
@@ -414,7 +414,7 @@ errcode_t ext2fs_block_iterate3(ext2_filsys fs,
 						0, 0, priv_data);
 				ret |= r;
 				check_for_ro_violation_goto(&ctx, ret,
-							    extent_errout);
+							    extent_done);
 				if (r & BLOCK_CHANGED) {
 					ctx.errcode =
 						ext2fs_extent_set_bmap(handle,
@@ -448,6 +448,8 @@ errcode_t ext2fs_block_iterate3(ext2_filsys fs,
 						if (ctx.errcode)
 							break;
 					}
+					if (ret & BLOCK_ABORT)
+						break;
 				}
 				continue;
 			}
@@ -473,23 +475,23 @@ errcode_t ext2fs_block_iterate3(ext2_filsys fs,
 						0, 0, priv_data);
 				ret |= r;
 				check_for_ro_violation_goto(&ctx, ret,
-							    extent_errout);
+							    extent_done);
 				if (r & BLOCK_CHANGED) {
 					ctx.errcode =
 						ext2fs_extent_set_bmap(handle,
 						       (blk64_t) blockcnt,
 						       new_blk, uninit);
 					if (ctx.errcode)
-						goto extent_errout;
+						goto extent_done;
 				}
 				if (ret & BLOCK_ABORT)
-					break;
+					goto extent_done;
 			}
 		}
 
-	extent_errout:
+	extent_done:
 		ext2fs_extent_free(handle);
-		ret |= BLOCK_ERROR | BLOCK_ABORT;
+		ret |= BLOCK_ERROR; /* ctx.errcode is always valid here */
 		goto errout;
 	}
 
-- 
1.7.9.107.g97f9a

