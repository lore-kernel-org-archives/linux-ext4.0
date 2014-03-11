From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 17/49] libext2fs: fix 64bit overflow in
 ext2fs_block_alloc_stats_range
Date: Mon, 10 Mar 2014 23:55:46 -0700
Message-ID: <20140311065546.30585.86235.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21472 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbaCKGzu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:55:50 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext2fs_block_alloc_stats_range(), the quantity "-inuse * n" is
calculated as a signed 32-bit quantity.  Unfortunately, gcc (4.6.3 on
Ubuntu 12.04) doesn't sign-extend this quantity to fill the blk64_t
parameter that ext2fs_free_blocks_count_add() wants, so the end result
is that the superblock gets a ridiculously huge free block count.

Changing the declaration of 'n' to blk64_t seems to fix this.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/alloc_stats.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/lib/ext2fs/alloc_stats.c b/lib/ext2fs/alloc_stats.c
index 5bb86ef..4feb24d 100644
--- a/lib/ext2fs/alloc_stats.c
+++ b/lib/ext2fs/alloc_stats.c
@@ -129,7 +129,7 @@ void ext2fs_block_alloc_stats_range(ext2_filsys fs, blk64_t blk,
 	while (num) {
 		int group = ext2fs_group_of_blk2(fs, blk);
 		blk64_t last_blk = ext2fs_group_last_block2(fs, group);
-		blk_t n = num;
+		blk64_t n = num;
 
 		if (blk + num > last_blk)
 			n = last_blk - blk + 1;

