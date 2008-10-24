From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/2 v2] merge ext4_claim_free_blocks & ext4_has_free_blocks
Date: Fri, 24 Oct 2008 15:40:24 -0500
Message-ID: <490232B8.1040706@redhat.com>
References: <49022FB3.7080002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Paris <eparis@redhat.com>
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:40911 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327AbYJXUk0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Oct 2008 16:40:26 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id m9OKePDH027909
	for <linux-ext4@vger.kernel.org>; Fri, 24 Oct 2008 16:40:25 -0400
In-Reply-To: <49022FB3.7080002@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Mingming pointed out that ext4_claim_free_blocks & ext4_has_free_blocks
are largely cut & pasted; they can be collapsed/merged as follows.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

(whoops, forgot a quilt refresh before sending the last one...)

Index: linux-2.6/fs/ext4/balloc.c
===================================================================
--- linux-2.6.orig/fs/ext4/balloc.c	2008-10-24 15:32:33.301001639 -0500
+++ linux-2.6/fs/ext4/balloc.c	2008-10-24 15:32:36.076063815 -0500
@@ -589,8 +589,15 @@ void ext4_free_blocks(handle_t *handle, 
 	return;
 }
 
-int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
-						s64 nblocks)
+/**
+ * ext4_has_free_blocks()
+ * @sbi:	in-core super block structure.
+ * @nblocks:	number of needed blocks
+ *
+ * Check if filesystem has nblocks free & available for allocation.
+ * On success return 1, return 0 on failure.
+ */
+int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nblocks)
 {
 	s64 free_blocks, dirty_blocks;
 	s64 root_blocks = 0;
@@ -620,53 +627,21 @@ int ext4_claim_free_blocks(struct ext4_s
 	 */
 	if (free_blocks < ((root_blocks + nblocks) + dirty_blocks))
 		/* we don't have free space */
-		return -ENOSPC;
+		return 0;
 
-	/* Add the blocks to nblocks */
-	percpu_counter_add(dbc, nblocks);
-	return 0;
+	return 1;
 }
 
-/**
- * ext4_has_free_blocks()
- * @sbi:	in-core super block structure.
- * @nblocks:	number of neeed blocks
- *
- * Check if filesystem has free blocks available for allocation.
- * Return the number of blocks avaible for allocation for this request
- * On success, return nblocks
- */
-ext4_fsblk_t ext4_has_free_blocks(struct ext4_sb_info *sbi,
+int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
 						s64 nblocks)
 {
-	s64 free_blocks, dirty_blocks;
-	s64 root_blocks = 0;
-	struct percpu_counter *fbc = &sbi->s_freeblocks_counter;
-	struct percpu_counter *dbc = &sbi->s_dirtyblocks_counter;
-
-	free_blocks  = percpu_counter_read_positive(fbc);
-	dirty_blocks = percpu_counter_read_positive(dbc);
-
-	if (!capable(CAP_SYS_RESOURCE) &&
-		sbi->s_resuid != current->fsuid &&
-		(sbi->s_resgid == 0 || !in_group_p(sbi->s_resgid)))
-		root_blocks = ext4_r_blocks_count(sbi->s_es);
-
-	if (free_blocks - (nblocks + root_blocks + dirty_blocks) <
-						EXT4_FREEBLOCKS_WATERMARK) {
-		free_blocks  = percpu_counter_sum(fbc);
-		dirty_blocks = percpu_counter_sum(dbc);
-	}
-	if (free_blocks <= (root_blocks + dirty_blocks))
-		/* we don't have free space */
+	if (ext4_has_free_blocks(sbi, nblocks)) {
+		percpu_counter_add(&sbi->s_dirtyblocks_counter, nblocks);
 		return 0;
-
-	if (free_blocks - (root_blocks + dirty_blocks) < nblocks)
-		return free_blocks - (root_blocks + dirty_blocks);
-	return nblocks;
+	} else
+		return -ENOSPC;
 }
 
