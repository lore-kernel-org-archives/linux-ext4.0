From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Fix use of uninitialized data
Date: Thu, 15 May 2008 00:17:11 +0530
Message-ID: <1210790832-20680-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1210790832-20680-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:41768 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003AbYENSrQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 May 2008 14:47:16 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id m4EIlEvM025330
	for <linux-ext4@vger.kernel.org>; Thu, 15 May 2008 00:17:14 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4EIl4Sc1474684
	for <linux-ext4@vger.kernel.org>; Thu, 15 May 2008 00:17:04 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m4EIlDLB023854
	for <linux-ext4@vger.kernel.org>; Thu, 15 May 2008 00:17:14 +0530
In-Reply-To: <1210790832-20680-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix use of uninitialized data with debug enabled.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 7871f46..4e79e48 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2748,8 +2748,6 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	sbi = EXT4_SB(sb);
 	es = sbi->s_es;
 
-	ext4_debug("using block group %lu(%d)\n", ac->ac_b_ex.fe_group,
-			gdp->bg_free_blocks_count);
 
 	err = -EIO;
 	bitmap_bh = read_block_bitmap(sb, ac->ac_b_ex.fe_group);
@@ -2765,6 +2763,9 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	if (!gdp)
 		goto out_err;
 
+	ext4_debug("using block group %lu(%d)\n", ac->ac_b_ex.fe_group,
+			gdp->bg_free_blocks_count);
+
 	err = ext4_journal_get_write_access(handle, gdp_bh);
 	if (err)
 		goto out_err;
@@ -3134,8 +3135,7 @@ static void ext4_mb_use_inode_pa(struct ext4_allocation_context *ac,
 static void ext4_mb_use_group_pa(struct ext4_allocation_context *ac,
 				struct ext4_prealloc_space *pa)
 {
-	unsigned len = ac->ac_o_ex.fe_len;
