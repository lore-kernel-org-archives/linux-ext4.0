From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Memory leak fix ext4_group_info allocation.
Date: Wed, 15 Jul 2009 20:25:34 +0530
Message-ID: <1247669734-6819-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:49692 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbZGOOzo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jul 2009 10:55:44 -0400
Received: from d23relay01.au.ibm.com (d23relay01.au.ibm.com [202.81.31.243])
	by e23smtp07.au.ibm.com (8.13.1/8.13.1) with ESMTP id n6G0tdGb001066
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2009 10:55:39 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay01.au.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n6FEterv401748
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2009 00:55:40 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n6FEtdBk012191
	for <linux-ext4@vger.kernel.org>; Thu, 16 Jul 2009 00:55:40 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

commit 5f21b0e642d7bf6fe4434c9ba12bc9cb96b17cf7  was done to
reallocate groupinfo struct during resize properly. That goal
was to allocate new groupinfo struct when we are adding new block
groups during resize. Calling ext4_mb_add_group_info in the
mballoc initialization code path resulted in we reallocating
the group info struct . Fix this by not separately allocating
group info in the mballoc init path and always depend on
ext4_mb_add_group_info to allocate group info struct.

The earlier code also had a bug that we allocated less number of
group info struct for the last meta group. But on resize we
expected that we had EXT4_DESC_PER_BLOCK group info struct for
each meta group.

Reported-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Tested-by: Catalin Marinas <catalin.marinas@arm.com>
---
 fs/ext4/mballoc.c |   19 -------------------
 1 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 519a0a6..2a9d327 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2564,13 +2564,11 @@ static int ext4_mb_init_backend(struct super_block *sb)
 {
 	ext4_group_t ngroups = ext4_get_groups_count(sb);
 	ext4_group_t i;
-	int metalen;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
 	int num_meta_group_infos;
 	int num_meta_group_infos_max;
 	int array_size;
-	struct ext4_group_info **meta_group_info;
 	struct ext4_group_desc *desc;
 
 	/* This is the number of blocks used by GDT */
@@ -2615,22 +2613,6 @@ static int ext4_mb_init_backend(struct super_block *sb)
 		goto err_freesgi;
 	}
 	EXT4_I(sbi->s_buddy_cache)->i_disksize = 0;
-
-	metalen = sizeof(*meta_group_info) << EXT4_DESC_PER_BLOCK_BITS(sb);
-	for (i = 0; i < num_meta_group_infos; i++) {
-		if ((i + 1) == num_meta_group_infos)
-			metalen = sizeof(*meta_group_info) *
-				(ngroups -
-					(i << EXT4_DESC_PER_BLOCK_BITS(sb)));
-		meta_group_info = kmalloc(metalen, GFP_KERNEL);
-		if (meta_group_info == NULL) {
-			printk(KERN_ERR "EXT4-fs: can't allocate mem for a "
-			       "buddy group\n");
-			goto err_freemeta;
-		}
-		sbi->s_group_info[i] = meta_group_info;
-	}
