From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [Updated PATCH] ext4: Use the correct block number when reading the super block.
Date: Mon, 31 Dec 2007 13:59:22 +0530
Message-ID: <1199089762-10378-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:45051 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753544AbXLaI3h (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Dec 2007 03:29:37 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp07.in.ibm.com (8.13.1/8.13.1) with ESMTP id lBV8TLWt001720
	for <linux-ext4@vger.kernel.org>; Mon, 31 Dec 2007 13:59:21 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id lBV8TLDe962632
	for <linux-ext4@vger.kernel.org>; Mon, 31 Dec 2007 13:59:21 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id lBV8TMom013614
	for <linux-ext4@vger.kernel.org>; Mon, 31 Dec 2007 08:29:23 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the block device hard sector size is larger than EXT4_MIN_BLOCK_SIZE we
end up with wrong block number when reading super block.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/super.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1ca0f54..3095370 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1629,8 +1629,8 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 	 * block sizes.  We need to calculate the offset from buffer start.
 	 */
 	if (blocksize != EXT4_MIN_BLOCK_SIZE) {
-		logical_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
-		offset = do_div(logical_sb_block, blocksize);
+		logical_sb_block = (sb_block * EXT4_MIN_BLOCK_SIZE) / blocksize;
+		offset = do_div((sb_block * EXT4_MIN_BLOCK_SIZE), blocksize);
 	} else {
 		logical_sb_block = sb_block;
 	}
@@ -1747,8 +1747,8 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 
 		brelse (bh);
 		sb_set_blocksize(sb, blocksize);
-		logical_sb_block = sb_block * EXT4_MIN_BLOCK_SIZE;
-		offset = do_div(logical_sb_block, blocksize);
+		logical_sb_block = (sb_block * EXT4_MIN_BLOCK_SIZE) / blocksize;
+		offset = do_div((sb_block * EXT4_MIN_BLOCK_SIZE), blocksize);
 		bh = sb_bread(sb, logical_sb_block);
 		if (!bh) {
 			printk(KERN_ERR
-- 
1.5.4.rc2-dirty
