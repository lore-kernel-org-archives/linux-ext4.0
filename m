From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: Convert bg_inode_bitmap and bg_inode_table
Date: Thu,  4 Oct 2007 01:50:54 -0400
Message-ID: <1191477059-5357-20-git-send-email-tytso@mit.edu>
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
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44797 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437AbXJDFvJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Oct 2007 01:51:09 -0400
In-Reply-To: <1191477059-5357-19-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Convert bg_inode_bitmap and bg_inode_table to bg_inode_bitmap_lo
and bg_inode_table_lo.  This helps in finding BUGs due to
direct partial access of these split 64 bit values

Also fix one direct partial access

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/balloc.c        |    2 +-
 fs/ext4/super.c         |   12 ++++++------
 include/linux/ext4_fs.h |    4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index d1a8882..7a24b3f 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -103,7 +103,7 @@ unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
 		/* Set bits for block and inode bitmaps, and inode table */
 		ext4_set_bit(ext4_block_bitmap(sb, gdp) - start, bh->b_data);
 		ext4_set_bit(ext4_inode_bitmap(sb, gdp) - start, bh->b_data);
-		for (bit = le32_to_cpu(gdp->bg_inode_table) - start,
+		for (bit = (ext4_inode_table(sb, gdp) - start),
 		     bit_max = bit + sbi->s_itb_per_group; bit < bit_max; bit++)
 			ext4_set_bit(bit, bh->b_data);
 	}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 02a2418..7548408 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -78,17 +78,17 @@ ext4_fsblk_t ext4_block_bitmap(struct super_block *sb,
 ext4_fsblk_t ext4_inode_bitmap(struct super_block *sb,
 			       struct ext4_group_desc *bg)
 {
-	return le32_to_cpu(bg->bg_inode_bitmap) |
+	return le32_to_cpu(bg->bg_inode_bitmap_lo) |
 		(EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT ?
-		 (ext4_fsblk_t)le32_to_cpu(bg->bg_inode_bitmap_hi) << 32 : 0);
+		(ext4_fsblk_t)le32_to_cpu(bg->bg_inode_bitmap_hi) << 32 : 0);
 }
 
 ext4_fsblk_t ext4_inode_table(struct super_block *sb,
 			      struct ext4_group_desc *bg)
 {
-	return le32_to_cpu(bg->bg_inode_table) |
+	return le32_to_cpu(bg->bg_inode_table_lo) |
 		(EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT ?
-		 (ext4_fsblk_t)le32_to_cpu(bg->bg_inode_table_hi) << 32 : 0);
+		(ext4_fsblk_t)le32_to_cpu(bg->bg_inode_table_hi) << 32 : 0);
 }
 
 void ext4_block_bitmap_set(struct super_block *sb,
@@ -102,7 +102,7 @@ void ext4_block_bitmap_set(struct super_block *sb,
 void ext4_inode_bitmap_set(struct super_block *sb,
 			   struct ext4_group_desc *bg, ext4_fsblk_t blk)
 {
-	bg->bg_inode_bitmap  = cpu_to_le32((u32)blk);
+	bg->bg_inode_bitmap_lo  = cpu_to_le32((u32)blk);
 	if (EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT)
 		bg->bg_inode_bitmap_hi = cpu_to_le32(blk >> 32);
 }
@@ -110,7 +110,7 @@ void ext4_inode_bitmap_set(struct super_block *sb,
 void ext4_inode_table_set(struct super_block *sb,
 			  struct ext4_group_desc *bg, ext4_fsblk_t blk)
 {
-	bg->bg_inode_table = cpu_to_le32((u32)blk);
+	bg->bg_inode_table_lo = cpu_to_le32((u32)blk);
 	if (EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT)
 		bg->bg_inode_table_hi = cpu_to_le32(blk >> 32);
 }
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index c26e30e..5eb4953 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -106,8 +106,8 @@
 struct ext4_group_desc
 {
 	__le32	bg_block_bitmap_lo;	/* Blocks bitmap block */
-	__le32	bg_inode_bitmap;	/* Inodes bitmap block */
-	__le32	bg_inode_table;		/* Inodes table block */
+	__le32	bg_inode_bitmap_lo;	/* Inodes bitmap block */
+	__le32	bg_inode_table_lo;	/* Inodes table block */
 	__le16	bg_free_blocks_count;	/* Free blocks count */
 	__le16	bg_free_inodes_count;	/* Free inodes count */
 	__le16	bg_used_dirs_count;	/* Directories count */
-- 
1.5.3.2.81.g17ed
