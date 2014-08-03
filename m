From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] Revert "mke2fs: prevent creation of unmountable ext4 with large flex_bg count"
Date: Sun,  3 Aug 2014 14:13:24 -0400
Message-ID: <1407089605-575-1-git-send-email-tytso@mit.edu>
Cc: adilger@dilger.ca, a-fujita@rs.jp.nec.com,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42380 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbaHCSNe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 Aug 2014 14:13:34 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This reverts commit d988201ef9cb6f7b521e544061976ab4270a3f89.

The problem with this commit is that causes common small file system
configurations to fail.  For example:

    mke2fs -O flex_bg -b 4096 -I 1024 -F /tmp/tt 79106
    mke2fs 1.42.11 (09-Jul-2014)
    /tmp/tt: Invalid argument passed to ext2 library while setting
             up superblock

This check in ext2fs_initialize() was added to prevent the metadata
from being allocated beyond the end of the filesystem, but it is
also causing a wide range of failures for small filesystems.

We'll address this in a different way, by using a smarter algorithm
for deciding the layout of metadata blocks for the last flex block
group.

Reported: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 lib/ext2fs/initialize.c | 24 ------------------------
 1 file changed, 24 deletions(-)

diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index de358fd..36c94a9 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -91,10 +91,8 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	unsigned int	rem;
 	unsigned int	overhead = 0;
 	unsigned int	ipg;
-	unsigned int	flexbg_size;
 	dgrp_t		i;
 	blk64_t		free_blocks;
-	blk64_t		flexbg_overhead;
 	blk_t		numblocks;
 	int		rsv_gdt;
 	int		csum_flag;
@@ -421,28 +419,6 @@ ipg_retry:
 	}
 
 	/*
-	 * Calculate the flex_bg related metadata blocks count.
-	 * It includes the boot block, the super block,
-	 * the block group descriptors, the reserved gdt blocks,
-	 * the block bitmaps, the inode bitmaps and the inode tables.
-	 * This is a simple check, so that the backup superblock and
-	 * other feature related blocks are not considered.
-	 */
-	flexbg_size = 1 << fs->super->s_log_groups_per_flex;
-	flexbg_overhead = super->s_first_data_block + 1 +
-		fs->desc_blocks + super->s_reserved_gdt_blocks +
-		(__u64)flexbg_size * (2 + fs->inode_blocks_per_group);
-
-	/*
-	 * Disallow creating ext4 which breaks flex_bg metadata layout
-	 * obviously.
-	 */
-	if (flexbg_overhead > ext2fs_blocks_count(fs->super)) {
-		retval = EXT2_ET_INVALID_ARGUMENT;
-		goto cleanup;
-	}
