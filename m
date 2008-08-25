From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -v2] ext4: Make sure all the block allocation paths reserve blocks
Date: Mon, 25 Aug 2008 16:50:29 +0530
Message-ID: <1219663233-21849-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1219663233-21849-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:39341 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753354AbYHYLUm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Aug 2008 07:20:42 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7PBKd4J025778
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 16:50:39 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7PBKbml1458278
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 16:50:38 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7PBKajf014083
	for <linux-ext4@vger.kernel.org>; Mon, 25 Aug 2008 16:50:37 +0530
In-Reply-To: <1219663233-21849-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With delayed allocation we need to make sure block are reserved
before we attempt to allocate them. Otherwise we get block
allocation failure (ENOSPC) during writepages which cannot
be handled. This would mean silent data loss (We do a printk
stating data will be lost). This patch update the DIO
and fallocate code path to do block reservation before block
allocation.

When free blocks count go below a threshold we switch to
a slow patch which looks at other CPU's accumulated percpu
counter values.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/balloc.c  |   72 ++++++++++++++++++++++++++++++++++++++++++++---------
 fs/ext4/ext4.h    |    2 +
 fs/ext4/inode.c   |    5 +---
 fs/ext4/mballoc.c |   23 +++++++++-------
 4 files changed, 76 insertions(+), 26 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index cfed283..4a53541 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1602,6 +1602,47 @@ ext4_try_to_allocate_with_rsv(struct super_block *sb, handle_t *handle,
 	return ret;
 }
 
+int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
+						ext4_fsblk_t nblocks)
+{
+	s64 free_blocks;
+	ext4_fsblk_t root_blocks = 0;
+	struct percpu_counter *fbc = &sbi->s_freeblocks_counter;
+
+	free_blocks = percpu_counter_read(fbc);
+
+	if (!capable(CAP_SYS_RESOURCE) &&
+		sbi->s_resuid != current->fsuid &&
+		(sbi->s_resgid == 0 || !in_group_p(sbi->s_resgid)))
+		root_blocks = ext4_r_blocks_count(sbi->s_es);
+#ifdef CONFIG_SMP
+	/* Each CPU can accumulate FBC_BATCH blocks in their local
+	 * counters. So we need to make sure we have free blocks more
+	 * than FBC_BATCH  * nr_cpu_ids. Also add a window of 4 times.
+	 */
+	if (free_blocks - (nblocks + root_blocks) <
+				(4 * (FBC_BATCH * nr_cpu_ids))) {
+		/*
+		 * We need to sum and claim under lock
+		 * This is the slow patch which will be
+		 * taken when we are very low on free blocks
+		 */
+		if (percpu_counter_sum_and_sub(fbc, nblocks + root_blocks))
+			return -ENOSPC;
+		/* add root_blocks back */
+		percpu_counter_add(fbc, root_blocks);
+		return 0;
+	}
+#endif
+	if (free_blocks < (root_blocks + nblocks))
+		/* we don't have free space */
+		return -ENOSPC;
+
+	/* reduce fs free blocks counter */
+	percpu_counter_sub(fbc, nblocks);
+	return 0;
+}
+
 /**
  * ext4_has_free_blocks()
  * @sbi:	in-core super block structure.
@@ -1624,9 +1665,15 @@ ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
 		(sbi->s_resgid == 0 || !in_group_p(sbi->s_resgid)))
 		root_blocks = ext4_r_blocks_count(sbi->s_es);
 #ifdef CONFIG_SMP
-	if (free_blocks - root_blocks < FBC_BATCH)
+	/* Each CPU can accumulate FBC_BATCH blocks in their local
+	 * counters. So we need to make sure we have free blocks more
+	 * than FBC_BATCH  * nr_cpu_ids. Also add a window of 4 times.
+	 */
+	if (free_blocks - (nblocks + root_blocks) <
+				(4 * (FBC_BATCH * nr_cpu_ids))) {
 		free_blocks =
 			percpu_counter_sum(&sbi->s_freeblocks_counter);
+	}
 #endif
 	if (free_blocks <= root_blocks)
 		/* we don't have free space */
@@ -1634,7 +1681,7 @@ ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
 	if (free_blocks - root_blocks < nblocks)
 		return free_blocks - root_blocks;
 	return nblocks;
- }
+}
 
 
 /**
@@ -1713,14 +1760,11 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
 		/*
 		 * With delalloc we already reserved the blocks
 		 */
-		*count = ext4_has_free_blocks(sbi, *count);
-	}
-	if (*count == 0) {
-		*errp = -ENOSPC;
-		return 0;	/*return with ENOSPC error */
+		if (ext4_claim_free_blocks(sbi, *count)) {
+			*errp = -ENOSPC;
+			return 0;	/*return with ENOSPC error */
+		}
 	}
-	num = *count;
-
 	/*
 	 * Check quota for allocation of this block.
 	 */
@@ -1915,9 +1959,13 @@ ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
 	le16_add_cpu(&gdp->bg_free_blocks_count, -num);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, group_no, gdp);
 	spin_unlock(sb_bgl_lock(sbi, group_no));
-	if (!EXT4_I(inode)->i_delalloc_reserved_flag)
-		percpu_counter_sub(&sbi->s_freeblocks_counter, num);
-
+	if (!EXT4_I(inode)->i_delalloc_reserved_flag && (*count != num)) {
+		/*
+		 * we allocated less blocks than we
+		 * claimed. Add the difference back.
+		 */
+		percpu_counter_add(&sbi->s_freeblocks_counter, *count - num);
+	}
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, group_no);
 		spin_lock(sb_bgl_lock(sbi, flex_group));
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 7f11b25..3738039 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1047,6 +1047,8 @@ extern ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
 					unsigned long *count, int *errp);
 extern ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, unsigned long *count, int *errp);
+extern int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
+						ext4_fsblk_t nblocks);
 extern ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
 						ext4_fsblk_t nblocks);
 extern void ext4_free_blocks (handle_t *handle, struct inode *inode,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1c289c1..d965a05 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1537,13 +1537,10 @@ static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
 	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
 	total = md_needed + nrblocks;
 
-	if (ext4_has_free_blocks(sbi, total) < total) {
+	if (ext4_claim_free_blocks(sbi, total)) {
 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
 		return -ENOSPC;
 	}
-	/* reduce fs free blocks counter */
-	percpu_counter_sub(&sbi->s_freeblocks_counter, total);
-
 	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
 	EXT4_I(inode)->i_reserved_meta_blocks = mdblocks;
 
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 82dd0e4..4404b46 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2977,9 +2977,15 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	 * at write_begin() time for delayed allocation
 	 * do not double accounting
 	 */
-	if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED))
-		percpu_counter_sub(&sbi->s_freeblocks_counter,
-					ac->ac_b_ex.fe_len);
+	if (!(ac->ac_flags & EXT4_MB_DELALLOC_RESERVED) &&
+			ac->ac_o_ex.fe_len != ac->ac_b_ex.fe_len) {
+		/*
+		 * we allocated less blocks than we calimed
+		 * Add the difference back
+		 */
+		percpu_counter_add(&sbi->s_freeblocks_counter,
+				ac->ac_o_ex.fe_len - ac->ac_b_ex.fe_len);
+	}
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi,
@@ -4391,14 +4397,11 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 		/*
 		 * With delalloc we already reserved the blocks
 		 */
-		ar->len = ext4_has_free_blocks(sbi, ar->len);
-	}
-
-	if (ar->len == 0) {
-		*errp = -ENOSPC;
-		return 0;
+		if (ext4_claim_free_blocks(sbi, ar->len)) {
+			*errp = -ENOSPC;
+			return 0;
+		}
 	}
