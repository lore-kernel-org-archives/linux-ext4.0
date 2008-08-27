From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V3 08/11] ext4: Signed arithematic fix
Date: Wed, 27 Aug 2008 20:58:33 +0530
Message-ID: <1219850916-8986-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1219850916-8986-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1219850916-8986-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:42482 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757486AbYH0P3L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 27 Aug 2008 11:29:11 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7RFT98M022773
	for <linux-ext4@vger.kernel.org>; Wed, 27 Aug 2008 20:59:09 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7RFT9ZL1790090
	for <linux-ext4@vger.kernel.org>; Wed, 27 Aug 2008 20:59:09 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7RFT8rK021998
	for <linux-ext4@vger.kernel.org>; Wed, 27 Aug 2008 20:59:08 +0530
In-Reply-To: <1219850916-8986-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch converts some usage of ext4_fsblk_t to s64
This is needed so that some of the sign conversion works
as expected in if loops.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/balloc.c |   19 ++++++++++---------
 fs/ext4/ext4.h   |    4 ++--
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 53fdb05..7fdc236 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1603,10 +1603,10 @@ ext4_try_to_allocate_with_rsv(struct super_block *sb, handle_t *handle,
 }
 
 int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
-						ext4_fsblk_t nblocks)
+						s64 nblocks)
 {
 	s64 free_blocks, dirty_blocks;
-	ext4_fsblk_t root_blocks = 0;
+	s64 root_blocks = 0;
 	struct percpu_counter *fbc = &sbi->s_freeblocks_counter;
 	struct percpu_counter *dbc = &sbi->s_dirtyblocks_counter;
 
@@ -1631,7 +1631,7 @@ int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
 	/* Check whether we have space after
 	 * accounting for current dirty blocks
 	 */
-	if (free_blocks < ((s64)(root_blocks + nblocks) + dirty_blocks))
+	if (free_blocks < ((root_blocks + nblocks) + dirty_blocks))
 		/* we don't have free space */
 		return -ENOSPC;
 
@@ -1650,10 +1650,10 @@ int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
  * On success, return nblocks
  */
 ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
-						ext4_fsblk_t nblocks)
+						s64 nblocks)
 {
-	ext4_fsblk_t free_blocks, dirty_blocks;
-	ext4_fsblk_t root_blocks = 0;
+	s64 free_blocks, dirty_blocks;
+	s64 root_blocks = 0;
 	struct percpu_counter *fbc = &sbi->s_freeblocks_counter;
 	struct percpu_counter *dbc = &sbi->s_dirtyblocks_counter;
 
@@ -1667,14 +1667,15 @@ ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
 
 	if (free_blocks - (nblocks + root_blocks + dirty_blocks) <
 						EXT4_FREEBLOCKS_WATERMARK) {
-		free_blocks  = percpu_counter_sum_positive(fbc);
-		dirty_blocks = percpu_counter_sum_positive(dbc);
+		free_blocks  = percpu_counter_sum(fbc);
+		dirty_blocks = percpu_counter_sum(dbc);
 	}
 	if (free_blocks <= (root_blocks + dirty_blocks))
 		/* we don't have free space */
 		return 0;
+
 	if (free_blocks - (root_blocks + dirty_blocks) < nblocks)
-		return free_blocks - root_blocks;
+		return free_blocks - (root_blocks + dirty_blocks);
 	return nblocks;
 }
 
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 71a4fde..13c69ed 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1048,9 +1048,9 @@ extern ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
 extern ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, unsigned long *count, int *errp);
 extern int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
-						ext4_fsblk_t nblocks);
+						s64 nblocks);
 extern ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
-						ext4_fsblk_t nblocks);
+						s64  nblocks);
 extern void ext4_free_blocks (handle_t *handle, struct inode *inode,
 			ext4_fsblk_t block, unsigned long count, int metadata);
 extern void ext4_free_blocks_sb (handle_t *handle, struct super_block *sb,
-- 
1.6.0.1.90.g27a6e

