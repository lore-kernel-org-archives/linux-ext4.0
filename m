From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v4 05/22] Introduce IS_XIP(inode)
Date: Sun, 22 Dec 2013 16:49:32 -0500
Message-ID: <6d0bc5641877d08b254ae8eb4165ab98a8d4c0f6.1387748521.git.matthew.r.wilcox@intel.com>
References: <cover.1387748521.git.matthew.r.wilcox@intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <cover.1387748521.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1387748521.git.matthew.r.wilcox@intel.com>
References: <cover.1387748521.git.matthew.r.wilcox@intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Use an inode flag to tag inodes which should avoid using the page cache.
Convert ext2 to use it instead of mapping_is_xip or (when appropriate)
ext2_use_xip.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 fs/ext2/inode.c    | 9 ++++++---
 fs/ext2/xip.h      | 2 --
 include/linux/fs.h | 6 ++++++
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 8a33764..0e18d1e 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -731,7 +731,7 @@ static int ext2_get_blocks(struct inode *inode,
 		goto cleanup;
 	}
 
-	if (ext2_use_xip(inode->i_sb)) {
+	if (IS_XIP(inode)) {
 		/*
 		 * we need to clear the block
 		 */
@@ -1201,7 +1201,7 @@ static int ext2_setsize(struct inode *inode, loff_t newsize)
 
 	inode_dio_wait(inode);
 
-	if (mapping_is_xip(inode->i_mapping))
+	if (IS_XIP(inode))
 		error = xip_truncate_page(inode->i_mapping, newsize);
 	else if (test_opt(inode->i_sb, NOBH))
 		error = nobh_truncate_page(inode->i_mapping,
@@ -1273,7 +1273,8 @@ void ext2_set_inode_flags(struct inode *inode)
 {
 	unsigned int flags = EXT2_I(inode)->i_flags;
 
-	inode->i_flags &= ~(S_SYNC|S_APPEND|S_IMMUTABLE|S_NOATIME|S_DIRSYNC);
+	inode->i_flags &= ~(S_SYNC | S_APPEND | S_IMMUTABLE | S_NOATIME |
+				S_DIRSYNC | S_XIP);
 	if (flags & EXT2_SYNC_FL)
 		inode->i_flags |= S_SYNC;
 	if (flags & EXT2_APPEND_FL)
@@ -1284,6 +1285,8 @@ void ext2_set_inode_flags(struct inode *inode)
 		inode->i_flags |= S_NOATIME;
 	if (flags & EXT2_DIRSYNC_FL)
 		inode->i_flags |= S_DIRSYNC;
+	if (ext2_use_xip(inode->i_sb))
+		inode->i_flags |= S_XIP;
 }
 
 /* Propagate flags from i_flags to EXT2_I(inode)->i_flags */
diff --git a/fs/ext2/xip.h b/fs/ext2/xip.h
index 18b34d2..29be737 100644
--- a/fs/ext2/xip.h
+++ b/fs/ext2/xip.h
@@ -16,9 +16,7 @@ static inline int ext2_use_xip (struct super_block *sb)
 }
 int ext2_get_xip_mem(struct address_space *, pgoff_t, int,
 				void **, unsigned long *);
-#define mapping_is_xip(map) unlikely(map->a_ops->get_xip_mem)
 #else
-#define mapping_is_xip(map)			0
 #define ext2_xip_verify_sb(sb)			do { } while (0)
 #define ext2_use_xip(sb)			0
 #define ext2_clear_xip_target(inode, chain)	0
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 121f11f..80cfb42 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1639,6 +1639,7 @@ struct super_operations {
 #define S_IMA		1024	/* Inode has an associated IMA struct */
 #define S_AUTOMOUNT	2048	/* Automount/referral quasi-directory */
 #define S_NOSEC		4096	/* no suid or xattr security attributes */
+#define S_XIP		8192	/* Avoid using the page cache */
 
 /*
  * Note that nosuid etc flags are inode-specific: setting some file-system
@@ -1676,6 +1677,11 @@ struct super_operations {
 #define IS_IMA(inode)		((inode)->i_flags & S_IMA)
 #define IS_AUTOMOUNT(inode)	((inode)->i_flags & S_AUTOMOUNT)
 #define IS_NOSEC(inode)		((inode)->i_flags & S_NOSEC)
+#ifdef CONFIG_FS_XIP
+#define IS_XIP(inode)		((inode)->i_flags & S_XIP)
+#else
+#define IS_XIP(inode)		0
+#endif
 
 /*
  * Inode state bits.  Protected by inode->i_lock
-- 
1.8.4.rc3

