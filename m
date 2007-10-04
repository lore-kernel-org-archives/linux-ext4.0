From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: Convert s_r_blocks_count and s_free_blocks_count
Date: Thu,  4 Oct 2007 01:50:56 -0400
Message-ID: <1191477059-5357-22-git-send-email-tytso@mit.edu>
References: <1191477059-5357-1-git-send-email-tytso@mit.edu>
 <1191477059-5357-2-git-send-email-tytso@mit.edu>
 <1191477059-5357-3-git-send-email-tytso@mit.edu>
 <1191477059-5357-4-git-send-email-tytso@mit.edu>
 <1191477059-5357-5-git-send-email-tytso@mit.edu>
 <1191477059-5357-6-git-send-email-tytso@mit.edu>
 <1191477059-5357-7-git-send-email-tytso@mit.edu>
 <1191477059-5357-8-git-send-email-tytso@mit.edu>
 <1191477059-5357-9-git-send-email-tytso@mit.edu>
 <1191477059-5357-10-git-send-email-tytso@mit.edu>
 <1191477059-5357-11-git-send-email-tytso@mit.edu>
 <1191477059-5357-12-git-send-email-tytso@mit.edu>
 <1191477059-5357-13-git-send-email-tytso@mit.edu>
 <1191477059-5357-14-git-send-email-tytso@mit.edu>
 <1191477059-5357-15-git-send-email-tytso@mit.edu>
 <1191477059-5357-16-git-send-email-tytso@mit.edu>
 <1191477059-5357-17-git-send-email-tytso@mit.edu>
 <1191477059-5357-18-git-send-email-tytso@mit.edu>
 <1191477059-5357-19-git-send-email-tytso@mit.edu>
 <1191477059-5357-20-git-send-email-tytso@mit.edu>
 <1191477059-5357-21-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44816 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbXJDFvK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Oct 2007 01:51:10 -0400
In-Reply-To: <1191477059-5357-21-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

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
index dc7fe4c..dbd114c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2635,7 +2635,7 @@ static int ext4_statfs (struct dentry * dentry, struct kstatfs * buf)
 	buf->f_bsize = sb->s_blocksize;
 	buf->f_blocks = ext4_blocks_count(es) - sbi->s_overhead_last;
 	buf->f_bfree = percpu_counter_sum(&sbi->s_freeblocks_counter);
-	es->s_free_blocks_count = cpu_to_le32(buf->f_bfree);
+	ext4_free_blocks_count_set(es, buf->f_bfree);
 	buf->f_bavail = buf->f_bfree - ext4_r_blocks_count(es);
 	if (buf->f_bfree < ext4_r_blocks_count(es))
 		buf->f_bavail = 0;
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 339412d..fb31c1a 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -502,8 +502,8 @@ do {									       \
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
@@ -1007,13 +1007,13 @@ static inline ext4_fsblk_t ext4_blocks_count(struct ext4_super_block *es)
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
@@ -1026,14 +1026,14 @@ static inline void ext4_blocks_count_set(struct ext4_super_block *es,
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
1.5.3.2.81.g17ed
