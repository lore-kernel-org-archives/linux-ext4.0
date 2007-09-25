From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/7] ext4: Introduce le32_t and le16_t
Date: Tue, 25 Sep 2007 14:33:46 +0530
Message-ID: <11907110323296-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: adilger@clusterfs.com, cmm@us.ibm.com,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:46398 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbXIYJEn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2007 05:04:43 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id l8P94BQP032723
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 19:04:11 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8P97iSm129718
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 19:07:44 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8P94AJ6014830
	for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2007 19:04:10 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext4 file system layout contain different split members
like bg_block_bitmap  and bg_block_bitmap_hi. Introduce
data type le32_t and le16_t to be used as the type of
these split members. This prevents these members frome
being accessed directly. Accesing them directly gives
a compiler warning. This helps in catching some BUGS
due to direct partial access of these split fields.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/super.c           |    8 ++++----
 include/linux/ext4_fs.h   |    4 ++--
 include/linux/ext4_fs_i.h |    4 ++++
 3 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d035653..c8f8e4d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -70,9 +70,9 @@ static void ext4_write_super_lockfs(struct super_block *sb);
 ext4_fsblk_t ext4_block_bitmap(struct super_block *sb,
 			       struct ext4_group_desc *bg)
 {
-	return le32_to_cpu(bg->bg_block_bitmap) |
+	return le32_to_cpu(bg->bg_block_bitmap.value) |
 		(EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT ?
-		 (ext4_fsblk_t)le32_to_cpu(bg->bg_block_bitmap_hi) << 32 : 0);
+		 (ext4_fsblk_t)le32_to_cpu(bg->bg_block_bitmap_hi.value) << 32 : 0);
 }
 
 ext4_fsblk_t ext4_inode_bitmap(struct super_block *sb,
@@ -94,9 +94,9 @@ ext4_fsblk_t ext4_inode_table(struct super_block *sb,
 void ext4_block_bitmap_set(struct super_block *sb,
 			   struct ext4_group_desc *bg, ext4_fsblk_t blk)
 {
-	bg->bg_block_bitmap = cpu_to_le32((u32)blk);
+	bg->bg_block_bitmap.value = cpu_to_le32((u32)blk);
 	if (EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT)
-		bg->bg_block_bitmap_hi = cpu_to_le32(blk >> 32);
+		bg->bg_block_bitmap_hi.value = cpu_to_le32(blk >> 32);
 }
 
 void ext4_inode_bitmap_set(struct super_block *sb,
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 046a6a7..4494f8e 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -150,7 +150,7 @@ struct ext4_allocation_request {
  */
 struct ext4_group_desc
 {
-	__le32	bg_block_bitmap;	/* Blocks bitmap block */
+	le32_t	bg_block_bitmap;	/* Blocks bitmap block */
 	__le32	bg_inode_bitmap;	/* Inodes bitmap block */
 	__le32	bg_inode_table;		/* Inodes table block */
 	__le16	bg_free_blocks_count;	/* Free blocks count */
@@ -160,7 +160,7 @@ struct ext4_group_desc
 	__u32	bg_reserved[2];		/* Likely block/inode bitmap checksum */
 	__le16  bg_itable_unused;	/* Unused inodes count */
 	__le16  bg_checksum;		/* crc16(sb_uuid+group+desc) */
-	__le32	bg_block_bitmap_hi;	/* Blocks bitmap block MSB */
+	le32_t	bg_block_bitmap_hi;	/* Blocks bitmap block MSB */
 	__le32	bg_inode_bitmap_hi;	/* Inodes bitmap block MSB */
 	__le32	bg_inode_table_hi;	/* Inodes table block MSB */
 };
diff --git a/include/linux/ext4_fs_i.h b/include/linux/ext4_fs_i.h
index 22ba80e..d7eb271 100644
--- a/include/linux/ext4_fs_i.h
+++ b/include/linux/ext4_fs_i.h
@@ -27,6 +27,10 @@ typedef int ext4_grpblk_t;
 /* data type for filesystem-wide blocks number */
 typedef unsigned long long ext4_fsblk_t;
 
+/* data type to carry split 64 and 48 bits */
+typedef struct { __le16 value; } le16_t;
+typedef struct { __le32 value; } le32_t;
+
 struct ext4_reserve_window {
 	ext4_fsblk_t	_rsv_start;	/* First byte reserved */
 	ext4_fsblk_t	_rsv_end;	/* Last byte reserved or 0 */
-- 
1.5.3.1.91.gd3392-dirty
