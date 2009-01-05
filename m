From: akpm@linux-foundation.org
Subject: - fs-introduce-bgl_lock_ptr.patch removed from -mm tree
Date: Sun, 04 Jan 2009 22:40:47 -0800
Message-ID: <200901050640.n056el62004845@imap1.linux-foundation.org>
To: penberg@cs.helsinki.fi, adilger@sun.com,
	linux-ext4@vger.kernel.org, mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750891AbZAEGkz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Jan 2009 01:40:55 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     fs: introduce bgl_lock_ptr()
has been removed from the -mm tree.  Its filename was
     fs-introduce-bgl_lock_ptr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: introduce bgl_lock_ptr()
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

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

origin.patch
repeatable-slab-corruption-with-ltp-msgctl08.patch
linux-next.patch
ext4-allocate-s_blockgroup_lock-separately.patch
mm-make-get_user_pages-interruptible.patch
mm-make-get_user_pages-interruptible-mmotm-ignore-sigkill-in-get_user_pages-during-munlock.patch
ext2-allocate-s_blockgroup_lock-separately.patch
ext3-allocate-s_blockgroup_lock-separately.patch
memcg-add-inactive_anon_is_low.patch
dma_alloc_coherent-clean-it-up.patch
dma-coherent-catch-oversized-requests-to-dma_alloc_from_coherent.patch
nilfs2-avoid-double-error-caused-by-nilfs_transaction_end.patch
kmemleak-add-the-base-support.patch
kmemleak-add-the-base-support-fix.patch
kmemleak-add-the-slab-memory-allocation-freeing-hooks.patch
kmemleak-add-the-slob-memory-allocation-freeing-hooks.patch
kmemleak-add-the-slub-memory-allocation-freeing-hooks.patch
kmemleak-remove-some-of-the-kmemleak-false-positives.patch
slab-leaks3-default-y.patch

