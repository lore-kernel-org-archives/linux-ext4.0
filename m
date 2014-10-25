From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 22/39] libext2fs: ext2fs_new_block2() should call
 alloc_block hook
Date: Sat, 25 Oct 2014 13:58:45 -0700
Message-ID: <20141025205845.532.41514.stgit@birch.djwong.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44107 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbaJYU7I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Oct 2014 16:59:08 -0400
In-Reply-To: <20141025205623.532.12119.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If ext2fs_new_block2() is called without a specific block map, we
should call the alloc_block hook before checking fs->block_map.  This
helps us to avoid a bug in e2fsck where we need to allocate a block
but instead of consulting block_found_map, we use the FS bitmaps,
which (prior to pass 5) could be wrong.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c     |    2 +-
 lib/ext2fs/alloc.c |   15 +++++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 36eea16..d4760ef 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -3790,7 +3790,7 @@ static errcode_t e2fsck_get_alloc_block(ext2_filsys fs, blk64_t goal,
 				return retval;
 		}
 
-		retval = ext2fs_new_block2(fs, goal, 0, &new_block);
+		retval = ext2fs_new_block2(fs, goal, fs->block_map, &new_block);
 		if (retval)
 			return retval;
 	}
diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 578fd7f..d1c1a84 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -137,9 +137,23 @@ errcode_t ext2fs_new_block2(ext2_filsys fs, blk64_t goal,
 {
 	errcode_t retval;
 	blk64_t	b = 0;
+	errcode_t (*gab)(ext2_filsys fs, blk64_t goal, blk64_t *ret);
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
+	if (!map && fs->get_alloc_block) {
+		/*
+		 * In case there are clients out there whose get_alloc_block
+		 * handlers call ext2fs_new_block2 with a NULL block map,
+		 * temporarily swap out the function pointer so that we don't
+		 * end up in an infinite loop.
+		 */
+		gab = fs->get_alloc_block;
+		fs->get_alloc_block = NULL;
+		retval = gab(fs, goal, &b);
+		fs->get_alloc_block = gab;
+		goto allocated;
+	}
 	if (!map)
 		map = fs->block_map;
 	if (!map)
@@ -153,6 +167,7 @@ errcode_t ext2fs_new_block2(ext2_filsys fs, blk64_t goal,
 	if ((retval == ENOENT) && (goal != fs->super->s_first_data_block))
 		retval = ext2fs_find_first_zero_block_bitmap2(map,
 			fs->super->s_first_data_block, goal - 1, &b);
+allocated:
 	if (retval == ENOENT)
 		return EXT2_ET_BLOCK_ALLOC_FAIL;
 	if (retval)

