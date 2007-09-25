From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 3/7] ext4: Convert s_blocks_count to s_blocks_count_lo
Date: Tue, 25 Sep 2007 23:50:05 +0530
Message-ID: <11907444213671-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11907444091038-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11907444192997-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: adilger@clusterfs.com, cmm@us.ibm.com,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:59235 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbXIYSUk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2007 14:20:40 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id l8PIKcVl003424
	for <linux-ext4@vger.kernel.org>; Wed, 26 Sep 2007 04:20:38 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8PIOCEH291534
	for <linux-ext4@vger.kernel.org>; Wed, 26 Sep 2007 04:24:12 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8PIKMX9026559
	for <linux-ext4@vger.kernel.org>; Wed, 26 Sep 2007 04:20:22 +1000
In-Reply-To: <11907444192997-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Convert s_blocks_count to s_blocks_count_lo
This helps in finding BUGs due to direct partial access of
these split 64 bit values

Also fix direct partial access in ext4 code

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/mballoc.c       |    4 ++--
 fs/ext4/super.c         |    4 ++--
 include/linux/ext4_fs.h |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index c4e6c92..5b804b2 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4036,7 +4036,7 @@ int ext4_mb_initialize_context(struct ext4_allocation_context *ac,
 	/* start searching from the goal */
 	goal = ar->goal;
 	if (goal < le32_to_cpu(es->s_first_data_block) ||
-			goal >= le32_to_cpu(es->s_blocks_count))
+			goal >= ext4_blocks_count(es))
 		goal = le32_to_cpu(es->s_first_data_block);
 	ext4_get_group_no_and_offset(sb, goal, &group, &block);
 
@@ -4337,7 +4337,7 @@ void ext4_mb_free_blocks(handle_t *handle, struct inode *inode,
 	es = EXT4_SB(sb)->s_es;
 	if (block < le32_to_cpu(es->s_first_data_block) ||
 	    block + count < block ||
-	    block + count > le32_to_cpu(es->s_blocks_count)) {
+	    block + count > ext4_blocks_count(es)) {
 		ext4_error(sb, __FUNCTION__,
 			    "Freeing blocks not in datazone - "
 			    "block = %lu, count = %lu", block, count);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 60050e2..0f38bd1 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2653,7 +2653,7 @@ static int ext4_statfs (struct dentry * dentry, struct kstatfs * buf)
 
 	if (test_opt(sb, MINIX_DF)) {
 		sbi->s_overhead_last = 0;
-	} else if (sbi->s_blocks_last != le32_to_cpu(es->s_blocks_count)) {
+	} else if (sbi->s_blocks_last != ext4_blocks_count(es)) {
 		unsigned long ngroups = sbi->s_groups_count, i;
 		ext4_fsblk_t overhead = 0;
 		smp_rmb();
@@ -2688,7 +2688,7 @@ static int ext4_statfs (struct dentry * dentry, struct kstatfs * buf)
 		overhead += ngroups * (2 + sbi->s_itb_per_group);
 		sbi->s_overhead_last = overhead;
 		smp_wmb();
-		sbi->s_blocks_last = le32_to_cpu(es->s_blocks_count);
+		sbi->s_blocks_last = ext4_blocks_count(es);
 	}
 
 	buf->f_type = EXT4_SUPER_MAGIC;
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 411d259..7846558 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -563,7 +563,7 @@ do {									       \
  */
 struct ext4_super_block {
 /*00*/	__le32	s_inodes_count;		/* Inodes count */
-	__le32	s_blocks_count;		/* Blocks count */
+	__le32	s_blocks_count_lo;	/* Blocks count */
 	__le32	s_r_blocks_count;	/* Reserved blocks count */
 	__le32	s_free_blocks_count;	/* Free blocks count */
 /*10*/	__le32	s_free_inodes_count;	/* Free inodes count */
@@ -1067,7 +1067,7 @@ extern void ext4_inode_table_set(struct super_block *sb,
 static inline ext4_fsblk_t ext4_blocks_count(struct ext4_super_block *es)
 {
 	return ((ext4_fsblk_t)le32_to_cpu(es->s_blocks_count_hi) << 32) |
-		le32_to_cpu(es->s_blocks_count);
+		le32_to_cpu(es->s_blocks_count_lo);
 }
 
 static inline ext4_fsblk_t ext4_r_blocks_count(struct ext4_super_block *es)
@@ -1085,7 +1085,7 @@ static inline ext4_fsblk_t ext4_free_blocks_count(struct ext4_super_block *es)
 static inline void ext4_blocks_count_set(struct ext4_super_block *es,
 					 ext4_fsblk_t blk)
 {
-	es->s_blocks_count = cpu_to_le32((u32)blk);
+	es->s_blocks_count_lo = cpu_to_le32((u32)blk);
 	es->s_blocks_count_hi = cpu_to_le32(blk >> 32);
 }
 
-- 
1.5.3.1.91.gd3392-dirty
