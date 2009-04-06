From: Nick Dokos <nicholas.dokos@hp.com>
Subject: [PATCH][64-BIT]ext2fs_extent_get() truncates block to 32 bits.
Date: Mon, 06 Apr 2009 01:37:43 -0400
Message-ID: <2299.1238996263@gamaville.dokosmarshall.org>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:45543 "EHLO
	QMTA07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750900AbZDFFhs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 6 Apr 2009 01:37:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

e2image (after enabling 64-bitness) was reporting a corrupt extent header
in a 16TiB file created on a 32TiB filesystem. Checking the on-disk extents
did not uncover any problem. Debugging e2image showed truncation in the
ext2fs_extent_get() routine. Code examination showed an inconsistency
on line 428:

                blk = ext2fs_le32_to_cpu(ix->ei_leaf) +
                        ((__u64) ext2fs_le16_to_cpu(ix->ei_leaf_hi) << 32);

blk is treated as a 64 bit quantity but it is declared blk_t. This
changes it to blk64_t. With this change, e2image has been running (in raw mode)
for a couple of days without error (but it has not finished producing an image
yet !-). Also, although I have not checked exhaustively, debugfs seems to produce
the correct set of extents for the big file (stat <13>) - without this patch,
the physical block number wrapped at the 32-bit limit.

The second change is not based on debugging, just code examination:
ext2fs_alloc_block2() has been modified in the 64-bit patch series (in the patch
called add_64-bit_alloc_interface) so that its second argument (the goal block) is
a blk64_t. However, extent_node_split() calls it with its second argument explicitly
cast to blk_t. That looks wrong.

There are some more blk_t's used in this file (extent.c), but they are in #ifdef DEBUG
code, so I have not examined them any closer and I have not changed them (yet?).

Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>
---
 lib/ext2fs/extent.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index a6edd0c..1778955 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -273,7 +273,7 @@ errcode_t ext2fs_extent_get(ext2_extent_handle_t handle,
 	struct ext3_extent_idx		*ix = 0;
 	struct ext3_extent		*ex;
 	errcode_t			retval;
-	blk_t				blk;
+	blk64_t				blk;
 	blk64_t				end_blk;
 	int				orig_op, op;
 
@@ -904,7 +904,7 @@ static errcode_t extent_node_split(ext2_extent_handle_t handle)
 		goal_blk = (group * handle->fs->super->s_blocks_per_group) +
 			handle->fs->super->s_first_data_block;
 	}
-	retval = ext2fs_alloc_block2(handle->fs, (blk_t) goal_blk, block_buf,
+	retval = ext2fs_alloc_block2(handle->fs, goal_blk, block_buf,
 				    &new_node_pblk);
 	if (retval)
 		goto done;
-- 
1.6.0.3

