From: akpm@linux-foundation.org
Subject: + fs-introduce-bgl_lock_ptr.patch added to -mm tree
Date: Tue, 18 Nov 2008 21:28:00 -0800
Message-ID: <200811190528.mAJ5S0v3015636@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: penberg@cs.helsinki.fi, adilger@sun.com, linux-ext4@vger.kernel.org
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     fs: introduce bgl_lock_ptr()
has been added to the -mm tree.  Its filename is
     fs-introduce-bgl_lock_ptr.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs: introduce bgl_lock_ptr()
From: Pekka Enberg <penberg@cs.helsinki.fi>

As suggested by Andreas Dilger, introduce a bgl_lock_ptr() helper in
<linux/blockgroup_lock.h> and add separate sb_bgl_lock() helpers to filesystem
specific header files to break the hidden dependency to struct
ext[234]_sb_info. Also, while at it, convert the macros to static inlines to
try make up for all the times I broke Andrew Morton's tree.

Cc: Andreas Dilger <adilger@sun.com>
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

fs-introduce-bgl_lock_ptr.patch
repeatable-slab-corruption-with-ltp-msgctl08.patch
linux-next.patch
ext4-allocate-s_blockgroup_lock-separately.patch
ext2-allocate-s_blockgroup_lock-separately.patch
ext3-allocate-s_blockgroup_lock-separately.patch
slab-leaks3-default-y.patch

