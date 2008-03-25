From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH] ext2: Retry block allocation if new blocks are allocated from system zone.
Date: Wed, 26 Mar 2008 00:26:09 +0530
Message-ID: <1206471371-9659-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:42710 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbYCYS4W (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Mar 2008 14:56:22 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m2PIuC1V018607
	for <linux-ext4@vger.kernel.org>; Wed, 26 Mar 2008 00:26:12 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2PIuCuH1028350
	for <linux-ext4@vger.kernel.org>; Wed, 26 Mar 2008 00:26:12 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id m2PIuBfM015873
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 18:56:12 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the block allocator gets blocks out of system zone ext2 calls
ext2_error. But if the file system is mounted with errors=continue
retry block allocation. We need to mark the system zone
blocks as in use to make sure retry don't pick them again

System zone is the block range mapping block bitmap, inode bitmap
and inode table.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext2/balloc.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index e7b2baf..501399e 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -149,11 +149,12 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 			    block_group, le32_to_cpu(desc->bg_block_bitmap));
 		return NULL;
 	}
-	if (!ext2_valid_block_bitmap(sb, desc, block_group, bh)) {
-		brelse(bh);
-		return NULL;
-	}
 
+	ext2_valid_block_bitmap(sb, desc, block_group, bh);
+	/*
+	 * file system mounted not to panic on error,
+	 * continue with corrput bitmap
+	 */
 	return bh;
 }
 
@@ -1381,7 +1382,12 @@ allocated:
 			    "Allocating block in system zone - "
 			    "blocks from "E2FSBLK", length %lu",
 			    ret_block, num);
-		goto out;
+		/*
+		 * ext2_try_to_allocate marked the blocks we allocated
+		 * as in use. So we may want to selectively
+		 * mark some of the blocks as free
+		 */
+		goto retry_alloc;
 	}
 
 	performed_allocation = 1;
-- 
1.5.5.rc0.16.g02b00.dirty

