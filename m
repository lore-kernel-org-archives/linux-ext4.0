From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 4/7] ext4: Convert s_r_blocks_count and s_free_blocks_count
Date: Tue, 25 Sep 2007 23:50:06 +0530
Message-ID: <11907444233981-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11907444091038-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11907444192997-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11907444213671-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: adilger@clusterfs.com, cmm@us.ibm.com,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:50443 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbXIYSUl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2007 14:20:41 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id l8PIKe4B021328
	for <linux-ext4@vger.kernel.org>; Wed, 26 Sep 2007 04:20:40 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8PIKeum3580012
	for <linux-ext4@vger.kernel.org>; Wed, 26 Sep 2007 04:20:40 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8PIKNgi026599
	for <linux-ext4@vger.kernel.org>; Wed, 26 Sep 2007 04:20:24 +1000
In-Reply-To: <11907444213671-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Convert s_r_blocks_count and s_free_blocks_count to
s_r_blocks_count_lo and s_free_blocks_count_lo

This helps in finding BUGs due to direct partial access of
these split 64 bit values

Also fix direct partial access in ext4 code

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/super.c         |    2 +-
 include/linux/ext4_fs.h |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 0f38bd1..3c7446d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2695,7 +2695,7 @@ static int ext4_statfs (struct dentry * dentry, struct kstatfs * buf)
 	buf->f_bsize = sb->s_blocksize;
 	buf->f_blocks = ext4_blocks_count(es) - sbi->s_overhead_last;
 	buf->f_bfree = percpu_counter_sum(&sbi->s_freeblocks_counter);
-	es->s_free_blocks_count = cpu_to_le32(buf->f_bfree);
+	ext4_free_blocks_count_set(es, buf->f_bfree);
 	buf->f_bavail = buf->f_bfree - ext4_r_blocks_count(es);
 	if (buf->f_bfree < ext4_r_blocks_count(es))
 		buf->f_bavail = 0;
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 7846558..74cf8a8 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -564,8 +564,8 @@ do {									       \
 struct ext4_super_block {
 /*00*/	__le32	s_inodes_count;		/* Inodes count */
 	__le32	s_blocks_count_lo;	/* Blocks count */
-	__le32	s_r_blocks_count;	/* Reserved blocks count */
-	__le32	s_free_blocks_count;	/* Free blocks count */
+	__le32	s_r_blocks_count_lo;	/* Reserved blocks count */
+	__le32	s_free_blocks_count_lo;	/* Free blocks count */
 /*10*/	__le32	s_free_inodes_count;	/* Free inodes count */
 	__le32	s_first_data_block;	/* First Data Block */
 	__le32	s_log_block_size;	/* Block size */
@@ -1073,13 +1073,13 @@ static inline ext4_fsblk_t ext4_blocks_count(struct ext4_super_block *es)
 static inline ext4_fsblk_t ext4_r_blocks_count(struct ext4_super_block *es)
 {
 	return ((ext4_fsblk_t)le32_to_cpu(es->s_r_blocks_count_hi) << 32) |
-		le32_to_cpu(es->s_r_blocks_count);
+		le32_to_cpu(es->s_r_blocks_count_lo);
 }
 
 static inline ext4_fsblk_t ext4_free_blocks_count(struct ext4_super_block *es)
 {
 	return ((ext4_fsblk_t)le32_to_cpu(es->s_free_blocks_count_hi) << 32) |
-		le32_to_cpu(es->s_free_blocks_count);
+		le32_to_cpu(es->s_free_blocks_count_lo);
 }
 
 static inline void ext4_blocks_count_set(struct ext4_super_block *es,
@@ -1092,14 +1092,14 @@ static inline void ext4_blocks_count_set(struct ext4_super_block *es,
 static inline void ext4_free_blocks_count_set(struct ext4_super_block *es,
 					      ext4_fsblk_t blk)
 {
-	es->s_free_blocks_count = cpu_to_le32((u32)blk);
+	es->s_free_blocks_count_lo = cpu_to_le32((u32)blk);
 	es->s_free_blocks_count_hi = cpu_to_le32(blk >> 32);
 }
 
 static inline void ext4_r_blocks_count_set(struct ext4_super_block *es,
 					   ext4_fsblk_t blk)
 {
-	es->s_r_blocks_count = cpu_to_le32((u32)blk);
+	es->s_r_blocks_count_lo = cpu_to_le32((u32)blk);
 	es->s_r_blocks_count_hi = cpu_to_le32(blk >> 32);
 }
 
-- 
1.5.3.1.91.gd3392-dirty
