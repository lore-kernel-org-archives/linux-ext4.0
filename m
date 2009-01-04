From: akpm@linux-foundation.org
Subject: [patch 4/7] fs: introduce bgl_lock_ptr()
Date: Sun, 04 Jan 2009 12:00:48 -0800
Message-ID: <200901042000.n04K0mPT011680@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, penberg@cs.helsinki.fi, adilger@sun.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759250AbZADUB0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Jan 2009 15:01:26 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Pekka Enberg <penberg@cs.helsinki.fi>

As suggested by Andreas Dilger, introduce a bgl_lock_ptr() helper in
<linux/blockgroup_lock.h> and add separate sb_bgl_lock() helpers to filesystem
specific header files to break the hidden dependency to struct
ext[234]_sb_info. Also, while at it, convert the macros to static inlines to
try make up for all the times I broke Andrew Morton's tree.

Acked-by: Andreas Dilger <adilger@sun.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/ext4_sb.h               |    6 ++++++
 include/linux/blockgroup_lock.h |    7 +++++--
 include/linux/ext2_fs_sb.h      |    6 ++++++
 include/linux/ext3_fs_sb.h      |    6 ++++++
 4 files changed, 23 insertions(+), 2 deletions(-)

diff -puN fs/ext4/ext4_sb.h~fs-introduce-bgl_lock_ptr fs/ext4/ext4_sb.h
--- a/fs/ext4/ext4_sb.h~fs-introduce-bgl_lock_ptr
+++ a/fs/ext4/ext4_sb.h
@@ -146,4 +146,10 @@ struct ext4_sb_info {
 	struct flex_groups *s_flex_groups;
 };
 
+static inline spinlock_t *
+sb_bgl_lock(struct ext4_sb_info *sbi, unsigned int block_group)
+{
+	return bgl_lock_ptr(&sbi->s_blockgroup_lock, block_group);
+}
+
 #endif	/* _EXT4_SB */
diff -puN include/linux/blockgroup_lock.h~fs-introduce-bgl_lock_ptr include/linux/blockgroup_lock.h
--- a/include/linux/blockgroup_lock.h~fs-introduce-bgl_lock_ptr
+++ a/include/linux/blockgroup_lock.h
@@ -53,7 +53,10 @@ static inline void bgl_lock_init(struct 
  * The accessor is a macro so we can embed a blockgroup_lock into different
  * superblock types
  */
-#define sb_bgl_lock(sb, block_group) \
-	(&(sb)->s_blockgroup_lock.locks[(block_group) & (NR_BG_LOCKS-1)].lock)
+static inline spinlock_t *
+bgl_lock_ptr(struct blockgroup_lock *bgl, unsigned int block_group)
+{
+	return &bgl->locks[(block_group) & (NR_BG_LOCKS-1)].lock;
+}
 
 #endif
diff -puN include/linux/ext2_fs_sb.h~fs-introduce-bgl_lock_ptr include/linux/ext2_fs_sb.h
--- a/include/linux/ext2_fs_sb.h~fs-introduce-bgl_lock_ptr
+++ a/include/linux/ext2_fs_sb.h
@@ -108,4 +108,10 @@ struct ext2_sb_info {
 	struct ext2_reserve_window_node s_rsv_window_head;
 };
 
+static inline spinlock_t *
+sb_bgl_lock(struct ext2_sb_info *sbi, unsigned int block_group)
+{
+	return bgl_lock_ptr(&sbi->s_blockgroup_lock, block_group);
+}
+
 #endif	/* _LINUX_EXT2_FS_SB */
diff -puN include/linux/ext3_fs_sb.h~fs-introduce-bgl_lock_ptr include/linux/ext3_fs_sb.h
--- a/include/linux/ext3_fs_sb.h~fs-introduce-bgl_lock_ptr
+++ a/include/linux/ext3_fs_sb.h
@@ -83,4 +83,10 @@ struct ext3_sb_info {
 #endif
 };
 
+static inline spinlock_t *
+sb_bgl_lock(struct ext3_sb_info *sbi, unsigned int block_group)
+{
+	return bgl_lock_ptr(&sbi->s_blockgroup_lock, block_group);
+}
+
 #endif	/* _LINUX_EXT3_FS_SB */
_
