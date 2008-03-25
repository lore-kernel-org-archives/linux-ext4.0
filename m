From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH] ext3: Retry block allocation if new blocks are allocated from system zone.
Date: Wed, 26 Mar 2008 00:26:10 +0530
Message-ID: <1206471371-9659-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1206471371-9659-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Mingming Cao <cmm@us.vnet.ibm.com>
To: cmm@us.ibm.com, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:54547 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981AbYCYS4X (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Mar 2008 14:56:23 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id m2PIuDa0019040
	for <linux-ext4@vger.kernel.org>; Wed, 26 Mar 2008 00:26:13 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m2PIuD5x1016002
	for <linux-ext4@vger.kernel.org>; Wed, 26 Mar 2008 00:26:13 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id m2PIuCep015888
	for <linux-ext4@vger.kernel.org>; Tue, 25 Mar 2008 18:56:13 GMT
In-Reply-To: <1206471371-9659-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the block allocator gets blocks out of system zone ext3 calls
ext3_error. But if the file system is mounted with errors=continue
retry block allocation. We need to mark the system zone blocks as
in use to make sure retry don't pick them again

System zone is the block range mapping block bitmap, inode bitmap and inode
table.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Mingming Cao <cmm@us.vnet.ibm.com>
---
 fs/ext3/balloc.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index da0cb2c..874362e 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -164,10 +164,11 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 			    block_group, le32_to_cpu(desc->bg_block_bitmap));
 		return NULL;
 	}
-	if (!ext3_valid_block_bitmap(sb, desc, block_group, bh)) {
-		brelse(bh);
-		return NULL;
-	}
+	ext3_valid_block_bitmap(sb, desc, block_group, bh);
+	/*
+	 * file system mounted not to panic on error,
+	 * continue with corrput bitmap
+	 */
 	return bh;
 }
 /*
@@ -1642,7 +1643,12 @@ allocated:
 			    "Allocating block in system zone - "
 			    "blocks from "E3FSBLK", length %lu",
 			     ret_block, num);
-		goto out;
+		/*
+		 * claim_block marked the blocks we allocated
+		 * as in use. So we may want to selectively
+		 * mark some of the blocks as free
+		 */
+		goto retry_alloc;
 	}
 
 	performed_allocation = 1;
-- 
1.5.5.rc0.16.g02b00.dirty

