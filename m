From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/7] ext4: Convert bg_inode_bitmap and bg_inode_table to new type
Date: Tue, 25 Sep 2007 14:33:47 +0530
Message-ID: <11907110501570-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11907110323296-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: adilger@clusterfs.com, cmm@us.ibm.com,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:56439 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbXIYJEh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2007 05:04:37 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id l8P94Lkn013793
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 19:04:21 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8P94LPL4694148
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 19:04:21 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8P94L9f015228
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 19:04:21 +1000
In-Reply-To: <11907110323296-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Convert bg_inode_bitmap and bg_inode_table to le32_t
This helps in finding BUGs due to direct partial access of
these split 64 bit values

Also fix one direct partial access

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/balloc.c        |    2 +-
 fs/ext4/super.c         |   18 +++++++++---------
 include/linux/ext4_fs.h |    8 ++++----
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 2a37635..b717a37 100644
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
index c8f8e4d..b9dda19 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -72,23 +72,23 @@ ext4_fsblk_t ext4_block_bitmap(struct super_block *sb,
 {
 	return le32_to_cpu(bg->bg_block_bitmap.value) |
 		(EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT ?
-		 (ext4_fsblk_t)le32_to_cpu(bg->bg_block_bitmap_hi.value) << 32 : 0);
+	 (ext4_fsblk_t)le32_to_cpu(bg->bg_block_bitmap_hi.value) << 32 : 0);
 }
 
 ext4_fsblk_t ext4_inode_bitmap(struct super_block *sb,
 			       struct ext4_group_desc *bg)
 {
-	return le32_to_cpu(bg->bg_inode_bitmap) |
+	return le32_to_cpu(bg->bg_inode_bitmap.value) |
 		(EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT ?
-		 (ext4_fsblk_t)le32_to_cpu(bg->bg_inode_bitmap_hi) << 32 : 0);
+	 (ext4_fsblk_t)le32_to_cpu(bg->bg_inode_bitmap_hi.value) << 32 : 0);
 }
 
 ext4_fsblk_t ext4_inode_table(struct super_block *sb,
 			      struct ext4_group_desc *bg)
 {
-	return le32_to_cpu(bg->bg_inode_table) |
+	return le32_to_cpu(bg->bg_inode_table.value) |
 		(EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT ?
-		 (ext4_fsblk_t)le32_to_cpu(bg->bg_inode_table_hi) << 32 : 0);
+	 (ext4_fsblk_t)le32_to_cpu(bg->bg_inode_table_hi.value) << 32 : 0);
 }
 
 void ext4_block_bitmap_set(struct super_block *sb,
@@ -102,17 +102,17 @@ void ext4_block_bitmap_set(struct super_block *sb,
 void ext4_inode_bitmap_set(struct super_block *sb,
 			   struct ext4_group_desc *bg, ext4_fsblk_t blk)
 {
-	bg->bg_inode_bitmap  = cpu_to_le32((u32)blk);
+	bg->bg_inode_bitmap.value  = cpu_to_le32((u32)blk);
 	if (EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT)
-		bg->bg_inode_bitmap_hi = cpu_to_le32(blk >> 32);
+		bg->bg_inode_bitmap_hi.value = cpu_to_le32(blk >> 32);
 }
 
 void ext4_inode_table_set(struct super_block *sb,
 			  struct ext4_group_desc *bg, ext4_fsblk_t blk)
 {
-	bg->bg_inode_table = cpu_to_le32((u32)blk);
+	bg->bg_inode_table.value = cpu_to_le32((u32)blk);
 	if (EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT)
-		bg->bg_inode_table_hi = cpu_to_le32(blk >> 32);
+		bg->bg_inode_table_hi.value = cpu_to_le32(blk >> 32);
 }
 
 /*
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 4494f8e..84ef557 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -151,8 +151,8 @@ struct ext4_allocation_request {
 struct ext4_group_desc
 {
 	le32_t	bg_block_bitmap;	/* Blocks bitmap block */
-	__le32	bg_inode_bitmap;	/* Inodes bitmap block */
-	__le32	bg_inode_table;		/* Inodes table block */
+	le32_t	bg_inode_bitmap;	/* Inodes bitmap block */
+	le32_t	bg_inode_table;		/* Inodes table block */
 	__le16	bg_free_blocks_count;	/* Free blocks count */
 	__le16	bg_free_inodes_count;	/* Free inodes count */
 	__le16	bg_used_dirs_count;	/* Directories count */
@@ -161,8 +161,8 @@ struct ext4_group_desc
 	__le16  bg_itable_unused;	/* Unused inodes count */
 	__le16  bg_checksum;		/* crc16(sb_uuid+group+desc) */
 	le32_t	bg_block_bitmap_hi;	/* Blocks bitmap block MSB */
-	__le32	bg_inode_bitmap_hi;	/* Inodes bitmap block MSB */
-	__le32	bg_inode_table_hi;	/* Inodes table block MSB */
+	le32_t	bg_inode_bitmap_hi;	/* Inodes bitmap block MSB */
+	le32_t	bg_inode_table_hi;	/* Inodes table block MSB */
 };
 
 #define EXT4_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not in use */
-- 
1.5.3.1.91.gd3392-dirty
