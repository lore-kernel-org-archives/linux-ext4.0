From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Don't claim block from group which has corrupt bitmap
Date: Mon, 11 Feb 2008 17:00:18 +0530
Message-ID: <1202729418-5582-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu, cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:56944 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751247AbYBKLaV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Feb 2008 06:30:21 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id m1BBUHCa016500
	for <linux-ext4@vger.kernel.org>; Mon, 11 Feb 2008 17:00:17 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1BBUH2U823340
	for <linux-ext4@vger.kernel.org>; Mon, 11 Feb 2008 17:00:17 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id m1BBUG7H014513
	for <linux-ext4@vger.kernel.org>; Mon, 11 Feb 2008 11:30:17 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext4_mb_complex_scan_group, if the extent length of the newly
found extentet is greater than than the total free blocks counted
in group info, break without claiming the block.

Document different ext4_error usage, explaining the state with which we
continue if we mount with errors=continue

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index dd0fcfc..898eefc 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -967,6 +967,10 @@ static void ext4_mb_generate_buddy(struct super_block *sb,
 		ext4_error(sb, __FUNCTION__,
 			"EXT4-fs: group %lu: %u blocks in bitmap, %u in gd\n",
 			group, free, grp->bb_free);
+		/*
+		 * If we intent to continue, we consider group descritor
+		 * corrupt and update bb_free using bitmap value
+		 */
 		grp->bb_free = free;
 	}
 
@@ -1822,7 +1826,7 @@ static void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
 						EXT4_BLOCKS_PER_GROUP(sb), i);
 		if (i >= EXT4_BLOCKS_PER_GROUP(sb)) {
 			/*
-			 * IF we corrupt the bitmap  we won't find any
+			 * IF we have corrupt bitmap, we won't find any
 			 * free blocks even though group info says we
 			 * we have free blocks
 			 */
@@ -1838,6 +1842,12 @@ static void ext4_mb_complex_scan_group(struct ext4_allocation_context *ac,
 			ext4_error(sb, __FUNCTION__, "%d free blocks as per "
 					"group info. But got %d blocks\n",
 					free, ex.fe_len);
+			/*
+			 * The number of free blocks differs. This mostly
+			 * indicate that the bitmap is corrupt. So exit
+			 * without claiming the space.
+			 */
+			break;
 		}
 
 		ext4_mb_measure_extent(ac, &ex, e4b);
@@ -3771,6 +3781,10 @@ static int ext4_mb_release_inode_pa(struct ext4_buddy *e4b,
 			(unsigned long) pa->pa_len);
 		ext4_error(sb, __FUNCTION__, "free %u, pa_free %u\n",
 						free, pa->pa_free);
+		/*
+		 * pa is already deleted so we use the value obtained
+		 * from the bitmap and continue.
+		 */
 	}
 	atomic_add(free, &sbi->s_mb_discarded);
 	if (ac)
-- 
1.5.4.23.gef5b9-dirty
