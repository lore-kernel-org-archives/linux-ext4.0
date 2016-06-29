From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH] ext4: check for extents that wrap around
Date: Thu, 30 Jun 2016 00:34:48 +0200
Message-ID: <1467239688-2588-1-git-send-email-vegard.nossum@oracle.com>
Cc: Phil Turnbull <phil.turnbull@oracle.com>,
	linux-ext4@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:34268 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbcF2Wey (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Jun 2016 18:34:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

An extent with lblock = 4294967295 and len = 1 will pass the
ext4_valid_extent() test:

	ext4_lblk_t last = lblock + len - 1;

	if (len == 0 || lblock > last)
		return 0;

since last = 4294967295 + 1 - 1 = 4294967295. This would later trigger
the BUG_ON(es->es_lblk + es->es_len < es->es_lblk) in ext4_es_end().

We can simplify it by removing the - 1 altogether and changing the test
to use lblock + len <= lblock, since now if len = 0, then lblock + 0 ==
lblock and it fails, and if len > 0 then lblock + len > lblock in order
to pass (i.e. it doesn't overflow).

Fixes: 5946d0893 ("ext4: check for overlapping extents in ext4_valid_extent_entries()")
Fixes: 2f974865f ("ext4: check for zero length extent explicitly")
Cc: Eryu Guan <guaneryu@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Phil Turnbull <phil.turnbull@oracle.com>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 fs/ext4/extents.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 2a2eef9..2f258c6 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -381,9 +381,13 @@ static int ext4_valid_extent(struct inode *inode, struct ext4_extent *ext)
 	ext4_fsblk_t block = ext4_ext_pblock(ext);
 	int len = ext4_ext_get_actual_len(ext);
 	ext4_lblk_t lblock = le32_to_cpu(ext->ee_block);
-	ext4_lblk_t last = lblock + len - 1;
 
-	if (len == 0 || lblock > last)
+	/*
+	 * We allow neither:
+	 *  - zero length
+	 *  - overflow/wrap-around
+	 */
+	if (lblock + len <= lblock)
 		return 0;
 	return ext4_data_block_valid(EXT4_SB(inode->i_sb), block, len);
 }
-- 
1.9.1

