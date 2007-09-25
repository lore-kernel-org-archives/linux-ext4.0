From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/7] ext4: Convert bg_block_bitmap to bg_block_bitmap_lo
Date: Tue, 25 Sep 2007 23:50:03 +0530
Message-ID: <11907444091038-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: adilger@clusterfs.com, cmm@us.ibm.com,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:38742 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbXIYSUk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Sep 2007 14:20:40 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id l8PIKZew022103
	for <linux-ext4@vger.kernel.org>; Wed, 26 Sep 2007 04:20:35 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8PIO9YM245852
	for <linux-ext4@vger.kernel.org>; Wed, 26 Sep 2007 04:24:09 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8PIKIJW026483
	for <linux-ext4@vger.kernel.org>; Wed, 26 Sep 2007 04:20:19 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Convert bg_block_bitmap to bg_block_bitmap_lo
This helps in catching some BUGS due to direct
partial access of these split fields.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/super.c         |    6 +++---
 include/linux/ext4_fs.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d035653..fd2a6a6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -70,9 +70,9 @@ static void ext4_write_super_lockfs(struct super_block *sb);
 ext4_fsblk_t ext4_block_bitmap(struct super_block *sb,
 			       struct ext4_group_desc *bg)
 {
-	return le32_to_cpu(bg->bg_block_bitmap) |
+	return le32_to_cpu(bg->bg_block_bitmap_lo) |
 		(EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT ?
-		 (ext4_fsblk_t)le32_to_cpu(bg->bg_block_bitmap_hi) << 32 : 0);
+		(ext4_fsblk_t)le32_to_cpu(bg->bg_block_bitmap_hi) << 32 : 0);
 }
 
 ext4_fsblk_t ext4_inode_bitmap(struct super_block *sb,
@@ -94,7 +94,7 @@ ext4_fsblk_t ext4_inode_table(struct super_block *sb,
 void ext4_block_bitmap_set(struct super_block *sb,
 			   struct ext4_group_desc *bg, ext4_fsblk_t blk)
 {
-	bg->bg_block_bitmap = cpu_to_le32((u32)blk);
+	bg->bg_block_bitmap_lo = cpu_to_le32((u32)blk);
 	if (EXT4_DESC_SIZE(sb) >= EXT4_MIN_DESC_SIZE_64BIT)
 		bg->bg_block_bitmap_hi = cpu_to_le32(blk >> 32);
 }
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 046a6a7..89d56c1 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -150,7 +150,7 @@ struct ext4_allocation_request {
  */
 struct ext4_group_desc
 {
-	__le32	bg_block_bitmap;	/* Blocks bitmap block */
+	__le32	bg_block_bitmap_lo;	/* Blocks bitmap block */
 	__le32	bg_inode_bitmap;	/* Inodes bitmap block */
 	__le32	bg_inode_table;		/* Inodes table block */
 	__le16	bg_free_blocks_count;	/* Free blocks count */
-- 
1.5.3.1.91.gd3392-dirty
