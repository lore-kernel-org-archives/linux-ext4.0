From: Nick Dokos <nicholas.dokos@hp.com>
Subject: [PATCH 1/5][64-BIT] ext2fs_block_alloc_stats2: fix size comparison for 64-bit compatibility.
Date: Wed, 08 Apr 2009 17:46:05 -0400
Message-ID: <11636.1239227165@alphaville.usa.hp.com>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com, linux-ext4@vger.kernel.org,
	Valerie Aurora <vaurora@redhat.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:21656 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763006AbZDHVqG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 8 Apr 2009 17:46:06 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The block number comparison in ext2fs_block_alloc_stats2() is invalid
for 64-bit filesystems: it compares the block number to the low
32-bits of the blocks_count in the superblock. That caused the journal
file for a 32TiB filesystem to be malformed and the resulting filesystem
could not be mounted.

The function now uses ext2fs_blocks_count() [from blknum.c] to calculate
the number of blocks.

With this change, the journal looks sane and the filesystem could be
mounted.

Signed-off-by: Nick Dokos <nicholas.dokos@hp.com>
---
 lib/ext2fs/alloc_stats.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/alloc_stats.c b/lib/ext2fs/alloc_stats.c
index 7895aee..f0c5a64 100644
--- a/lib/ext2fs/alloc_stats.c
+++ b/lib/ext2fs/alloc_stats.c
@@ -65,7 +65,7 @@ void ext2fs_block_alloc_stats2(ext2_filsys fs, blk64_t blk, int inuse)
 	int	group = ext2fs_group_of_blk2(fs, blk);
 
 #ifndef OMIT_COM_ERR
-	if (blk >= fs->super->s_blocks_count) {
+	if (blk >= ext2fs_blocks_count(fs->super)) {
 		com_err("ext2fs_block_alloc_stats2", 0,
 			"Illegal block number: %lu", blk);
 		return;
-- 
1.6.0.6

