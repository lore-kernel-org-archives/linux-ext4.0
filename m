From: Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH 1/4] fs: introduce bgl_lock_ptr()
Date: Mon, 17 Nov 2008 23:54:44 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0811172354030.18904@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: adilger@sun.com, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, cl@linux-foundation.org,
	mpm@selenic.com, eduard.munteanu@linux360.ro
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42483 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321AbYKQVyr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Nov 2008 16:54:47 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Pekka Enberg <penberg@cs.helsinki.fi>

As suggested by Andreas Dilger, introduce a bgl_lock_ptr() helper in
<linux/blockgroup_lock.h> and add separate sb_bgl_lock() helpers to filesystem
specific header files to break the hidden dependency to struct
ext[234]_sb_info. Also, while at it, convert the macros to static inlines to
try make up for all the times I broke Andrew Morton's tree.

Cc: Andreas Dilger <adilger@sun.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 fs/ext4/ext4_sb.h               |    6 ++++++
 include/linux/blockgroup_lock.h |    7 +++++--
 include/linux/ext2_fs_sb.h      |    6 ++++++
 include/linux/ext3_fs_sb.h      |    6 ++++++
 4 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4_sb.h b/fs/ext4/ext4_sb.h
index 445fde6..b21f167 100644
--- a/fs/ext4/ext4_sb.h
+++ b/fs/ext4/ext4_sb.h
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
diff --git a/include/linux/blockgroup_lock.h b/include/linux/blockgroup_lock.h
index 8607312..e44b88b 100644
--- a/include/linux/blockgroup_lock.h
+++ b/include/linux/blockgroup_lock.h
@@ -53,7 +53,10 @@ static inline void bgl_lock_init(struct blockgroup_lock *bgl)
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
diff --git a/include/linux/ext2_fs_sb.h b/include/linux/ext2_fs_sb.h
index f273415..dc541f3 100644
--- a/include/linux/ext2_fs_sb.h
+++ b/include/linux/ext2_fs_sb.h
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
diff --git a/include/linux/ext3_fs_sb.h b/include/linux/ext3_fs_sb.h
index b65f028..e024e38 100644
--- a/include/linux/ext3_fs_sb.h
+++ b/include/linux/ext3_fs_sb.h
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
-- 
1.5.4.3

