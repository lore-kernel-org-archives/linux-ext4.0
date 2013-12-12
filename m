From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] libext2fs: clamp block-map punch range end to 2^32 blocks
Date: Thu, 12 Dec 2013 13:13:25 -0800
Message-ID: <20131212211325.10844.50409.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50439 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab3LLVN3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Dec 2013 16:13:29 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In the ^extent case, passing ~0ULL as the 'end' parameter to
ext2fs_punch() causes the (end - start + 1) calculation to overflow to
zero.  Since the old-style mapped block files cannot have more than
2^32 blocks, just clamp it to ~0U.

This fixes a regression in t_quota_2off with the patch "libext2fs: use
ext2fs_punch() to truncate quota file" applied.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/punch.c |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
index f138297..9fff704 100644
--- a/lib/ext2fs/punch.c
+++ b/lib/ext2fs/punch.c
@@ -435,6 +435,8 @@ extern errcode_t ext2fs_punch(ext2_filsys fs, ext2_ino_t ino,
 
 		if (start > ~0U)
 			return 0;
+		if (end > ~0U)
+			end = ~0U;
 		count = ((end - start + 1) < ~0U) ? (end - start + 1) : ~0U;
 		retval = ext2fs_punch_ind(fs, inode, block_buf, 
 					  (blk_t) start, count);

