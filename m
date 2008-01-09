From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Use superblock s_raid_stripe_width as stripe size during block allocation.
Date: Wed,  9 Jan 2008 22:37:48 +0530
Message-ID: <1199898469-10369-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:51390 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751575AbYAIRIC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jan 2008 12:08:02 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id m09H7qo5025600
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jan 2008 22:37:52 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m09H7qfD897030
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jan 2008 22:37:52 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m09H7sN1006575
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jan 2008 17:07:54 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The stipe size used during block allocation is calculated as below.
a) if we specify a stripe=<value> option using mount time. Use that value.
b) if not use the value specified in super block.
b) If the value specfied at mount time is greater than blocks per group use
the value specified ini the super block.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/super.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index db1edc8..10330eb 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2136,6 +2136,16 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 	sbi->s_rsv_window_head.rsv_alloc_hit = 0;
 	sbi->s_rsv_window_head.rsv_goal_size = 0;
 	ext4_rsv_window_add(sb, &sbi->s_rsv_window_head);
+	/*
+	 * set the stripe size. If we have specified it via mount option, then
+	 * use the mount option value. If the value specified at mount time is
+	 * greater than the blocks per group use the super block value.
+	 * Allocator needs it be less than blocks per group.
+	 */
+	if (!sbi->s_stripe ||
+			sbi->s_stripe >= sbi->s_blocks_per_group) {
+		sbi->s_stripe = le32_to_cpu(es->s_raid_stripe_width);
+	}
 
 	/*
 	 * set up enough so that it can read an inode
-- 
1.5.4.rc2.60.gb2e62-dirty
