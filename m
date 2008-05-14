From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Fix FLEX_BG and uninit group usage.
Date: Thu, 15 May 2008 00:17:12 +0530
Message-ID: <1210790832-20680-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1210790832-20680-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1210790832-20680-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:36891 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbYENSrR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 May 2008 14:47:17 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp01.in.ibm.com (8.13.1/8.13.1) with ESMTP id m4EIlFlZ002535
	for <linux-ext4@vger.kernel.org>; Thu, 15 May 2008 00:17:15 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4EIl5nx1224872
	for <linux-ext4@vger.kernel.org>; Thu, 15 May 2008 00:17:05 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m4EIlE69023897
	for <linux-ext4@vger.kernel.org>; Thu, 15 May 2008 00:17:15 +0530
In-Reply-To: <1210790832-20680-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With FLEX_BG we allocate block bitmap, inode bitmap, and
inode table outside the group. So when initialzing the
uninit block group we don't need to set bits corresponding
to these meta-data in the bitmaps. Also return the right
number of free blocks when counting the available free
blocks in uninit group.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/balloc.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 5c80eb5..fb63f01 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -109,7 +109,14 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 
 		for (bit = 0; bit < bit_max; bit++)
 			ext4_set_bit(bit, bh->b_data);
-
+		/*
+		 * With FLEX_BG uninit group we have all the
+		 * blocks available for use. So no need
+		 * to set any bits in bitmap
+		 */
+		 if (EXT4_HAS_INCOMPAT_FEATURE(sb,
+					 EXT4_FEATURE_INCOMPAT_FLEX_BG))
+			return free_blocks;
 		start = ext4_group_first_block_no(sb, block_group);
 
 		/* Set bits for block and inode bitmaps, and inode table */
@@ -126,6 +133,12 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 		 */
 		mark_bitmap_end(group_blocks, sb->s_blocksize * 8, bh->b_data);
 	}
+	/*
+	 * With FLEX_BG uninit group we have all the
+	 * blocks available for use.
+	 */
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
+		return free_blocks;
 
 	return free_blocks - sbi->s_itb_per_group - 2;
 }
-- 
1.5.5.1.211.g65ea3.dirty

