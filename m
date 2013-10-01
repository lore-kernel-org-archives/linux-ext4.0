From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 11/31] libext2fs: ind_punch() must not stop examining blocks
 prematurely
Date: Mon, 30 Sep 2013 18:27:53 -0700
Message-ID: <20131001012753.28415.4639.stgit@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22513 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345Ab3JAB16 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Sep 2013 21:27:58 -0400
In-Reply-To: <20131001012642.28415.89353.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When we're iterating the main loop in ind_punch(), "offset" tracks how far
we've progressed into the block map, "start" tells us where to start punching,
and "count" tells us how many blocks we are to punch after "start".  Therefore,
we would like to break out of the loop once the "offset" that we're looking at
has progressed past the end of the punch range.  Unfortunately, if start !=0,
the if-break clause in the loop causes us to break out of the loop early.

Therefore, change the breakout test to terminate the loop at the correct time.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/punch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
index aac1942..0929400 100644
--- a/lib/ext2fs/punch.c
+++ b/lib/ext2fs/punch.c
@@ -60,7 +60,7 @@ static errcode_t ind_punch(ext2_filsys fs, struct ext2_inode *inode,
 #endif
 	incr = 1 << ((EXT2_BLOCK_SIZE_BITS(fs->super)-2)*level);
 	for (i=0, offset=0; i < max; i++, p++, offset += incr) {
-		if (offset > count)
+		if (offset >= start + count)
 			break;
 		if (*p == 0 || (offset+incr) <= start)
 			continue;

