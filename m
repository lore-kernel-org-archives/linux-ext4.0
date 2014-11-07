From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 04/47] libext2fs: fix endian handling error;
 reduce fragmentation some
Date: Fri, 07 Nov 2014 13:51:08 -0800
Message-ID: <20141107215108.883.87199.stgit@birch.djwong.org>
References: <20141107215042.883.49888.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44867 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaKGVvN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2014 16:51:13 -0500
In-Reply-To: <20141107215042.883.49888.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we're going to read the "nr - 1" entry in an indirect block for use
as a "goal" input to the block allocator, we need to byteswap the
entry.  While we're at it, if we're allocating blocks for the zeroth
entry in the indirect block, we might as well use the indirect block
as the starting point to try to reduce fragmentation.

(d_fallocate_blkmap will test this...)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/bmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
index c1d0e6f..f819e9c 100644
--- a/lib/ext2fs/bmap.c
+++ b/lib/ext2fs/bmap.c
@@ -67,7 +67,7 @@ static _BMAP_INLINE_ errcode_t block_ind_bmap(ext2_filsys fs, int flags,
 #endif
 
 	if (!b && (flags & BMAP_ALLOC)) {
-		b = nr ? ((blk_t *) block_buf)[nr-1] : 0;
+		b = nr ? ext2fs_le32_to_cpu(((blk_t *)block_buf)[nr - 1]) : ind;
 		retval = ext2fs_alloc_block(fs, b,
 					    block_buf + fs->blocksize, &b);
 		if (retval)

