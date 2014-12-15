From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] libext2fs: speed up the max extent depth api call
Date: Sun, 14 Dec 2014 22:37:45 -0800
Message-ID: <20141215063745.GA5368@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31122 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaLOGht (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Dec 2014 01:37:49 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The maximum extent tree depth really only depends on the filesystem
block size, so cache the last result if possible.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/extent.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index b1130f6..19f38fd 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -1725,9 +1725,16 @@ size_t ext2fs_max_extent_depth(ext2_extent_handle_t handle)
 	size_t extents_per_block = (handle->fs->blocksize -
 				    sizeof(struct ext3_extent_header)) /
 				   sizeof(struct ext3_extent);
+	static unsigned int last_blocksize = 0;
+	static size_t last_result = 0;
 
-	return 1 + ((ul_log2(EXT_MAX_EXTENT_LBLK) - ul_log2(iblock_extents)) /
+	if (last_blocksize && last_blocksize == handle->fs->blocksize)
+		return last_result;
+
+	last_result = 1 + ((ul_log2(EXT_MAX_EXTENT_LBLK) - ul_log2(iblock_extents)) /
 		    ul_log2(extents_per_block));
+	last_blocksize = handle->fs->blocksize;
+	return last_result;
 }
 
 #ifdef DEBUG
