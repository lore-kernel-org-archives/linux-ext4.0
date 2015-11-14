From: Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 3/4] libext2fs: fix block-mapped file punch
Date: Fri, 13 Nov 2015 18:10:28 -0700
Message-ID: <1447463429-5966-3-git-send-email-andreas.dilger@intel.com>
References: <1447463429-5966-1-git-send-email-andreas.dilger@intel.com>
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <andreas.dilger@intel.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out-no.shaw.ca ([64.59.134.9]:47733 "EHLO
	smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbbKNBSl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Nov 2015 20:18:41 -0500
In-Reply-To: <1447463429-5966-1-git-send-email-andreas.dilger@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If ext2fs_punch() is called with "end = ~0U" (which is natural from
a programming POV) it tries to compute "count" based on "start" and
"end", but doesn't quite get it right.

Fix ext2fs_punch() if "end" is anywhere beyond the 2^32 block limit
so that the 32-bit calculations don't overflow.  Pass "count=~0"
in this case, and also handle that explicitly in ext2_punch_ind().
Since ext2_punch_ind() is itself a public function, so it makes
sense to fix this in both places.

Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 lib/ext2fs/punch.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
index 2a2cf10..0c954c1 100644
--- a/lib/ext2fs/punch.c
+++ b/lib/ext2fs/punch.c
@@ -119,6 +119,9 @@ static errcode_t ext2fs_punch_ind(ext2_filsys fs, struct ext2_inode *inode,
 	}
 
 	addr_per_block = (blk_t) fs->blocksize >> 2;
+	/* make sure that count + start doesn't overflow a 32-bit value */
+	if (count == ~0U)
+		count = ~0U - start;
 
 	for (level = 0; level < 4; level++, max *= (blk64_t)addr_per_block) {
 #ifdef PUNCH_DEBUG
@@ -458,14 +461,19 @@ errcode_t ext2fs_punch(ext2_filsys fs, ext2_ino_t ino,
 
 		if (start > ~0U)
 			return 0;
-		if (end > ~0U)
-			end = ~0U;
-		count = ((end - start + 1) < ~0U) ? (end - start + 1) : ~0U;
-		retval = ext2fs_punch_ind(fs, inode, block_buf, 
-					  (blk_t) start, count);
+		if (end >= ~0U || end - start + 1 >= ~0U)
+			count = ~0U;
+		else
+			count = end - start + 1;
+		retval = ext2fs_punch_ind(fs, inode, block_buf,
+					  (blk_t)start, count);
 	}
 	if (retval)
 		return retval;
 
+#ifdef PUNCH_DEBUG
+	printf("%u: write inode size now %u blocks %u\n",
+		ino, inode->i_size, inode->i_blocks);
+#endif
 	return ext2fs_write_inode(fs, ino, inode);
 }
-- 
1.7.3.4

