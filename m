From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] ext4: Convert bg_block_bitmap to bg_block_bitmap_lo
Date: Thu,  4 Oct 2007 01:50:53 -0400
Message-ID: <1191477059-5357-19-git-send-email-tytso@mit.edu>
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
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44814 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbXJDFvK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Oct 2007 01:51:10 -0400
In-Reply-To: <1191477059-5357-18-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Convert bg_block_bitmap to bg_block_bitmap_lo
This helps in catching some BUGS due to direct
partial access of these split fields.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/super.c         |    6 +++---
 include/linux/ext4_fs.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d8bb279..02a2418 100644
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
index ab608e8..c26e30e 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -105,7 +105,7 @@
  */
 struct ext4_group_desc
 {
-	__le32	bg_block_bitmap;	/* Blocks bitmap block */
+	__le32	bg_block_bitmap_lo;	/* Blocks bitmap block */
 	__le32	bg_inode_bitmap;	/* Inodes bitmap block */
 	__le32	bg_inode_table;		/* Inodes table block */
 	__le16	bg_free_blocks_count;	/* Free blocks count */
-- 
1.5.3.2.81.g17ed
