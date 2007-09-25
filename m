From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 4/7] ext4: Convert s_r_blocks_count[_hi] s_free_blocks_count[_hi] to le32_t
Date: Tue, 25 Sep 2007 14:33:49 +0530
Message-ID: <11907110772723-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11907110323296-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11907110501570-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11907110613446-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: adilger@clusterfs.com, cmm@us.ibm.com,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:52012 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbXIYJFU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2007 05:05:20 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id l8P9522D026317
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 19:05:02 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8P953QQ4833528
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 19:05:03 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8P952X3016508
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 19:05:03 +1000
In-Reply-To: <11907110613446-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Convert s_r_blocks_count[_hi] s_free_blocks_count[_hi] to le32_t
This helps in finding BUGs due to direct partial access of
these split 64 bit values

Also fix direct partial access in ext4 code

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/super.c         |    2 +-
 include/linux/ext4_fs.h |   24 ++++++++++++------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 069d5f3..8bc5afb 100644
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
index 53a8665..b96e792 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -564,8 +564,8 @@ do {									       \
 struct ext4_super_block {
 /*00*/	__le32	s_inodes_count;		/* Inodes count */
 	le32_t	s_blocks_count;		/* Blocks count */
-	__le32	s_r_blocks_count;	/* Reserved blocks count */
-	__le32	s_free_blocks_count;	/* Free blocks count */
+	le32_t	s_r_blocks_count;	/* Reserved blocks count */
+	le32_t	s_free_blocks_count;	/* Free blocks count */
 /*10*/	__le32	s_free_inodes_count;	/* Free inodes count */
 	__le32	s_first_data_block;	/* First Data Block */
 	__le32	s_log_block_size;	/* Block size */
@@ -634,8 +634,8 @@ struct ext4_super_block {
 	__le32	s_jnl_blocks[17];	/* Backup of the journal inode */
 	/* 64bit support valid if EXT4_FEATURE_COMPAT_64BIT */
 /*150*/	le32_t	s_blocks_count_hi;	/* Blocks count */
-	__le32	s_r_blocks_count_hi;	/* Reserved blocks count */
-	__le32	s_free_blocks_count_hi;	/* Free blocks count */
+	le32_t	s_r_blocks_count_hi;	/* Reserved blocks count */
+	le32_t	s_free_blocks_count_hi;	/* Free blocks count */
 	__le16	s_min_extra_isize;	/* All inodes have at least # bytes */
 	__le16	s_want_extra_isize; 	/* New inodes should reserve # bytes */
 	__le32	s_flags;		/* Miscellaneous flags */
@@ -1072,14 +1072,14 @@ static inline ext4_fsblk_t ext4_blocks_count(struct ext4_super_block *es)
 
 static inline ext4_fsblk_t ext4_r_blocks_count(struct ext4_super_block *es)
 {
-	return ((ext4_fsblk_t)le32_to_cpu(es->s_r_blocks_count_hi) << 32) |
-		le32_to_cpu(es->s_r_blocks_count);
+	return ((ext4_fsblk_t)le32_to_cpu(es->s_r_blocks_count_hi.value) << 32) |
+		le32_to_cpu(es->s_r_blocks_count.value);
 }
 
 static inline ext4_fsblk_t ext4_free_blocks_count(struct ext4_super_block *es)
 {
-	return ((ext4_fsblk_t)le32_to_cpu(es->s_free_blocks_count_hi) << 32) |
-		le32_to_cpu(es->s_free_blocks_count);
+	return ((ext4_fsblk_t)le32_to_cpu(es->s_free_blocks_count_hi.value) << 32) |
+		le32_to_cpu(es->s_free_blocks_count.value);
 }
 
 static inline void ext4_blocks_count_set(struct ext4_super_block *es,
@@ -1092,15 +1092,15 @@ static inline void ext4_blocks_count_set(struct ext4_super_block *es,
 static inline void ext4_free_blocks_count_set(struct ext4_super_block *es,
 					      ext4_fsblk_t blk)
 {
-	es->s_free_blocks_count = cpu_to_le32((u32)blk);
-	es->s_free_blocks_count_hi = cpu_to_le32(blk >> 32);
+	es->s_free_blocks_count.value = cpu_to_le32((u32)blk);
+	es->s_free_blocks_count_hi.value = cpu_to_le32(blk >> 32);
 }
 
 static inline void ext4_r_blocks_count_set(struct ext4_super_block *es,
 					   ext4_fsblk_t blk)
 {
-	es->s_r_blocks_count = cpu_to_le32((u32)blk);
-	es->s_r_blocks_count_hi = cpu_to_le32(blk >> 32);
+	es->s_r_blocks_count.value = cpu_to_le32((u32)blk);
+	es->s_r_blocks_count_hi.value = cpu_to_le32(blk >> 32);
 }
 
 
-- 
1.5.3.1.91.gd3392-dirty
