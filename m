From: Daniel Bomar <dbdaniel42@gmail.com>
Subject: [PATCH] ext4: Fixed styling issues
Date: Sun,  7 Sep 2014 07:45:05 -0500
Message-ID: <1410093905-15431-1-git-send-email-dbdaniel42@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Daniel Bomar <dbdaniel42@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Fixed styling issues as reported by scripts/checkpatch.pl

Signed-off-by: Daniel Bomar <dbdaniel42@gmail.com>
---
 fs/ext4/ext4.h | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b0c225c..3728c38 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -282,8 +282,7 @@ struct ext4_io_submit {
 /*
  * Structure of a blocks group descriptor
  */
-struct ext4_group_desc
-{
+struct ext4_group_desc {
 	__le32	bg_block_bitmap_lo;	/* Blocks bitmap block */
 	__le32	bg_inode_bitmap_lo;	/* Inodes bitmap block */
 	__le32	bg_inode_table_lo;	/* Inodes table block */
@@ -1192,7 +1191,7 @@ struct ext4_sb_info {
 	unsigned int s_cluster_ratio;	/* Number of blocks per cluster */
 	unsigned int s_cluster_bits;	/* log2 of s_cluster_ratio */
 	loff_t s_bitmap_maxbytes;	/* max bytes for bitmap files */
-	struct buffer_head * s_sbh;	/* Buffer containing the super block */
+	struct buffer_head *s_sbh;	/* Buffer containing the super block */
 	struct ext4_super_block *s_es;	/* Pointer to the super block in the buffer */
 	struct buffer_head **s_group_desc;
 	unsigned int s_mount_opt;
@@ -1481,23 +1480,23 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
  * Feature set definitions
  */
 
-#define EXT4_HAS_COMPAT_FEATURE(sb,mask)			\
+#define EXT4_HAS_COMPAT_FEATURE(sb, mask)			\
 	((EXT4_SB(sb)->s_es->s_feature_compat & cpu_to_le32(mask)) != 0)
-#define EXT4_HAS_RO_COMPAT_FEATURE(sb,mask)			\
+#define EXT4_HAS_RO_COMPAT_FEATURE(sb, mask)			\
 	((EXT4_SB(sb)->s_es->s_feature_ro_compat & cpu_to_le32(mask)) != 0)
-#define EXT4_HAS_INCOMPAT_FEATURE(sb,mask)			\
+#define EXT4_HAS_INCOMPAT_FEATURE(sb, mask)			\
 	((EXT4_SB(sb)->s_es->s_feature_incompat & cpu_to_le32(mask)) != 0)
-#define EXT4_SET_COMPAT_FEATURE(sb,mask)			\
+#define EXT4_SET_COMPAT_FEATURE(sb, mask)			\
 	EXT4_SB(sb)->s_es->s_feature_compat |= cpu_to_le32(mask)
-#define EXT4_SET_RO_COMPAT_FEATURE(sb,mask)			\
+#define EXT4_SET_RO_COMPAT_FEATURE(sb, mask)			\
 	EXT4_SB(sb)->s_es->s_feature_ro_compat |= cpu_to_le32(mask)
-#define EXT4_SET_INCOMPAT_FEATURE(sb,mask)			\
+#define EXT4_SET_INCOMPAT_FEATURE(sb, mask)			\
 	EXT4_SB(sb)->s_es->s_feature_incompat |= cpu_to_le32(mask)
-#define EXT4_CLEAR_COMPAT_FEATURE(sb,mask)			\
+#define EXT4_CLEAR_COMPAT_FEATURE(sb, mask)			\
 	EXT4_SB(sb)->s_es->s_feature_compat &= ~cpu_to_le32(mask)
-#define EXT4_CLEAR_RO_COMPAT_FEATURE(sb,mask)			\
+#define EXT4_CLEAR_RO_COMPAT_FEATURE(sb, mask)			\
 	EXT4_SB(sb)->s_es->s_feature_ro_compat &= ~cpu_to_le32(mask)
-#define EXT4_CLEAR_INCOMPAT_FEATURE(sb,mask)			\
+#define EXT4_CLEAR_INCOMPAT_FEATURE(sb, mask)			\
 	EXT4_SB(sb)->s_es->s_feature_incompat &= ~cpu_to_le32(mask)
 
 #define EXT4_FEATURE_COMPAT_DIR_PREALLOC	0x0001
@@ -1749,7 +1748,7 @@ static inline u32 ext4_chksum(struct ext4_sb_info *sbi, u32 crc,
 	} desc;
 	int err;
 
-	BUG_ON(crypto_shash_descsize(sbi->s_chksum_driver)!=sizeof(desc.ctx));
+	BUG_ON(crypto_shash_descsize(sbi->s_chksum_driver) != sizeof(desc.ctx));
 
 	desc.shash.tfm = sbi->s_chksum_driver;
 	desc.shash.flags = 0;
@@ -1971,9 +1970,9 @@ extern int ext4_claim_free_clusters(struct ext4_sb_info *sbi,
 				    s64 nclusters, unsigned int flags);
 extern ext4_fsblk_t ext4_count_free_clusters(struct super_block *);
 extern void ext4_check_blocks_bitmap(struct super_block *);
-extern struct ext4_group_desc * ext4_get_group_desc(struct super_block * sb,
+extern struct ext4_group_desc *ext4_get_group_desc(struct super_block *sb,
 						    ext4_group_t block_group,
-						    struct buffer_head ** bh);
+						    struct buffer_head **bh);
 extern int ext4_should_retry_alloc(struct super_block *sb, int *retries);
 
 extern struct buffer_head *ext4_read_block_bitmap_nowait(struct super_block *sb,
-- 
2.1.0
