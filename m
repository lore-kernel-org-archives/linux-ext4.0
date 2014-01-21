From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 5/6] libext2fs: don't hang on to unmapped block if extent tree
 update fails
Date: Mon, 20 Jan 2014 22:22:11 -0800
Message-ID: <20140121062211.20507.54603.stgit@birch.djwong.org>
References: <20140121062138.20507.60259.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34922 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaAUGWQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jan 2014 01:22:16 -0500
In-Reply-To: <20140121062138.20507.60259.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we're doing a BMAP_ALLOC allocation and the extent tree update
fails, there's no point in hanging on to the newly allocated block.
So, free it to make fsck happy.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/bmap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
index b944c27..db2fd72 100644
--- a/lib/ext2fs/bmap.c
+++ b/lib/ext2fs/bmap.c
@@ -255,8 +255,10 @@ got_block:
 	set_extent:
 		retval = ext2fs_extent_set_bmap(handle, block,
 						blk64, 0);
-		if (retval)
+		if (retval) {
+			ext2fs_block_alloc_stats2(fs, blk64, -1);
 			return retval;
+		}
 		/* Update inode after setting extent */
 		retval = ext2fs_read_inode(fs, ino, inode);
 		if (retval)

