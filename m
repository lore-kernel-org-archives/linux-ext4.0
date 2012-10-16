From: Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: [PATCH 03/10] ext4: ext4.h: fixed coding style issue
Date: Wed, 17 Oct 2012 00:42:58 +0530
Message-ID: <1350414785-7848-3-git-send-email-mujeeb.adil@gmail.com>
References: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
Cc: Adil Mujeeb <mujeeb.adil@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Fixed some of issues reported by checkpatch.pl

Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
---
 linux-3.7-rc1/fs/ext4/ext4.h |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/linux-3.7-rc1/fs/ext4/ext4.h b/linux-3.7-rc1/fs/ext4/ext4.h
index 3ab2539..60e3802 100644
--- a/linux-3.7-rc1/fs/ext4/ext4.h
+++ b/linux-3.7-rc1/fs/ext4/ext4.h
@@ -289,8 +289,7 @@ struct ext4_io_submit {
 /*
  * Structure of a blocks group descriptor
  */
-struct ext4_group_desc
-{
+struct ext4_group_desc {
 	__le32	bg_block_bitmap_lo;	/* Blocks bitmap block */
 	__le32	bg_inode_bitmap_lo;	/* Inodes bitmap block */
 	__le32	bg_inode_table_lo;	/* Inodes table block */
@@ -721,17 +720,17 @@ struct move_extent {
 
 static inline __le32 ext4_encode_extra_time(struct timespec *time)
 {
-       return cpu_to_le32((sizeof(time->tv_sec) > 4 ?
+	return cpu_to_le32((sizeof(time->tv_sec) > 4 ?
 			   (time->tv_sec >> 32) & EXT4_EPOCH_MASK : 0) |
                           ((time->tv_nsec << EXT4_EPOCH_BITS) & EXT4_NSEC_MASK));
 }
 
 static inline void ext4_decode_extra_time(struct timespec *time, __le32 extra)
 {
-       if (sizeof(time->tv_sec) > 4)
+	if (sizeof(time->tv_sec) > 4)
 	       time->tv_sec |= (__u64)(le32_to_cpu(extra) & EXT4_EPOCH_MASK)
 			       << 32;
-       time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> EXT4_EPOCH_BITS;
+	time->tv_nsec = (le32_to_cpu(extra) & EXT4_NSEC_MASK) >> EXT4_EPOCH_BITS;
 }
 
 #define EXT4_INODE_SET_XTIME(xtime, inode, raw_inode)			       \
@@ -1099,7 +1098,7 @@ struct ext4_super_block {
 	__le32	s_r_blocks_count_hi;	/* Reserved blocks count */
 	__le32	s_free_blocks_count_hi;	/* Free blocks count */
 	__le16	s_min_extra_isize;	/* All inodes have at least # bytes */
-	__le16	s_want_extra_isize; 	/* New inodes should reserve # bytes */
+	__le16	s_want_extra_isize;	/* New inodes should reserve # bytes */
 	__le32	s_flags;		/* Miscellaneous flags */
 	__le16  s_raid_stride;		/* RAID stride */
 	__le16  s_mmp_update_interval;  /* # seconds to wait in MMP checking */
@@ -1164,7 +1163,7 @@ struct ext4_sb_info {
 	unsigned int s_cluster_ratio;	/* Number of blocks per cluster */
 	unsigned int s_cluster_bits;	/* log2 of s_cluster_ratio */
 	loff_t s_bitmap_maxbytes;	/* max bytes for bitmap files */
-	struct buffer_head * s_sbh;	/* Buffer containing the super block */
+	struct buffer_head *s_sbh;	/* Buffer containing the super block */
 	struct ext4_super_block *s_es;	/* Pointer to the super block in the buffer */
 	struct buffer_head **s_group_desc;
 	unsigned int s_mount_opt;
@@ -1686,7 +1685,7 @@ static inline u32 ext4_chksum(struct ext4_sb_info *sbi, u32 crc,
 	} desc;
 	int err;
 
-	BUG_ON(crypto_shash_descsize(sbi->s_chksum_driver)!=sizeof(desc.ctx));
+	BUG_ON(crypto_shash_descsize(sbi->s_chksum_driver) != sizeof(desc.ctx));
 
 	desc.shash.tfm = sbi->s_chksum_driver;
 	desc.shash.flags = 0;
@@ -1701,8 +1700,7 @@ static inline u32 ext4_chksum(struct ext4_sb_info *sbi, u32 crc,
 #ifdef __KERNEL__
 
 /* hash info structure used by the directory hash */
-struct dx_hash_info
-{
+struct dx_hash_info {
 	u32		hash;
 	u32		minor_hash;
 	int		hash_version;
@@ -1724,8 +1722,7 @@ struct dx_hash_info
 /*
  * Describe an inode's exact location on disk and in memory
  */
-struct ext4_iloc
-{
+struct ext4_iloc {
 	struct buffer_head *bh;
 	unsigned long offset;
 	ext4_group_t block_group;
@@ -1908,9 +1905,9 @@ extern int ext4_claim_free_clusters(struct ext4_sb_info *sbi,
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
@@ -1958,7 +1955,7 @@ extern struct inode *ext4_new_inode(handle_t *, struct inode *, umode_t,
 				    const struct qstr *qstr, __u32 goal,
 				    uid_t *owner);
 extern void ext4_free_inode(handle_t *, struct inode *);
-extern struct inode * ext4_orphan_get(struct super_block *, unsigned long);
+extern struct inode *ext4_orphan_get(struct super_block *, unsigned long);
 extern unsigned long ext4_count_free_inodes(struct super_block *);
 extern unsigned long ext4_count_dirs(struct super_block *);
 extern void ext4_check_inodes_bitmap(struct super_block *);
-- 
1.7.7.3
