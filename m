From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 49/47] libext2fs: don't report garbage inodes with really
 large inodes
Date: Wed, 26 Nov 2014 16:01:36 -0800
Message-ID: <20141127000136.GP10043@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25503 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaK0ABm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Nov 2014 19:01:42 -0500
Content-Disposition: inline
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the inode size is large enough that there are fewer than two inodes
per block, don't report an inode checksum failure as a garbage inode
during the scan because the "more than half are broken" criteria that
we use to decide if a block of inodes is garbage doesn't really apply.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/inode.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index 4b3e14e..17e49d8 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -424,6 +424,9 @@ static void check_inode_block_sanity(ext2_inode_scan scan, blk64_t num_blocks)
 	memset(block_status, 0, scan->inode_buffer_blocks);
 	inodes_per_block = EXT2_INODES_PER_BLOCK(scan->fs->super);
 
+	if (inodes_per_block < 2)
+		return;
+
 #ifdef WORDS_BIGENDIAN
 	if (ext2fs_get_mem(EXT2_INODE_SIZE(scan->fs->super), &inode))
 		return;
