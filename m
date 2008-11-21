From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 1/5] ext4: Remove unneeded code.
Date: Fri, 21 Nov 2008 22:14:31 +0530
Message-ID: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:55177 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbYKUQpR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Nov 2008 11:45:17 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id mALGindi005185
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 22:14:59 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mALGi9r83981334
	for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 22:14:09 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id mALGicmH015299
	for <linux-ext4@vger.kernel.org>; Sat, 22 Nov 2008 03:44:39 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This also caused an ext4_error when mounting a file system
with only one block group.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/super.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0582522..b5c7658 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1451,7 +1451,6 @@ static int ext4_fill_flex_info(struct super_block *sb)
 	ext4_group_t flex_group_count;
 	ext4_group_t flex_group;
 	int groups_per_flex = 0;
-	__u64 block_bitmap = 0;
 	int i;
 
 	if (!sbi->s_es->s_log_groups_per_flex) {
@@ -1474,9 +1473,6 @@ static int ext4_fill_flex_info(struct super_block *sb)
 		goto failed;
 	}
 
-	gdp = ext4_get_group_desc(sb, 1, &bh);
-	block_bitmap = ext4_block_bitmap(sb, gdp) - 1;
