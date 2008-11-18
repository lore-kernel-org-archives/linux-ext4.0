From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Remove unneeded code.
Date: Tue, 18 Nov 2008 16:55:27 +0530
Message-ID: <1227007527-4732-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:55155 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbYKRL0u (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 18 Nov 2008 06:26:50 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id mAIBQmi0026200
	for <linux-ext4@vger.kernel.org>; Tue, 18 Nov 2008 22:26:48 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAIBPj0Z2146420
	for <linux-ext4@vger.kernel.org>; Tue, 18 Nov 2008 22:25:45 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mAIBPVaJ031937
	for <linux-ext4@vger.kernel.org>; Tue, 18 Nov 2008 22:25:32 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This also caused an ext4_error when mounting a file system
with only one block group.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/super.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 70f6d61..ddfa29b 100644
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
