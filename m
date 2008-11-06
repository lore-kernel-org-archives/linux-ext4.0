From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -V3 1/9] ext4: sparse fixes
Date: Fri,  7 Nov 2008 00:19:26 +0530
Message-ID: <1225997374-10846-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:41964 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbYKFS50 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 13:57:26 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by ausmtp06.au.ibm.com (8.13.8/8.13.8) with ESMTP id mA6ItlBg4403420
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 05:55:48 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA6InkkM4775998
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 05:49:49 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mA6InfGu022329
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 05:49:41 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/ext4.h    |    9 ++++++---
 fs/ext4/extents.c |    4 ++--
 fs/ext4/file.c    |    3 ---
 fs/ext4/inode.c   |    2 +-
 fs/ext4/mballoc.c |    4 +++-
 fs/ext4/super.c   |   10 +++++-----
 6 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9415a1a..c05d639 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -726,11 +726,11 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
  */
 
 #define EXT4_HAS_COMPAT_FEATURE(sb,mask)			\
-	(EXT4_SB(sb)->s_es->s_feature_compat & cpu_to_le32(mask))
+	(le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_compat) & mask)
 #define EXT4_HAS_RO_COMPAT_FEATURE(sb,mask)			\
-	(EXT4_SB(sb)->s_es->s_feature_ro_compat & cpu_to_le32(mask))
+	(le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_ro_compat) & mask)
 #define EXT4_HAS_INCOMPAT_FEATURE(sb,mask)			\
-	(EXT4_SB(sb)->s_es->s_feature_incompat & cpu_to_le32(mask))
+	(le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_incompat) & mask)
 #define EXT4_SET_COMPAT_FEATURE(sb,mask)			\
 	EXT4_SB(sb)->s_es->s_feature_compat |= cpu_to_le32(mask)
 #define EXT4_SET_RO_COMPAT_FEATURE(sb,mask)			\
@@ -1284,6 +1284,9 @@ extern int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode,
 			sector_t block, unsigned int max_blocks,
 			struct buffer_head *bh, int create,
 			int extend_disksize, int flag);
+extern int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
+		__u64 start, __u64 len);
+
 #endif	/* __KERNEL__ */
 
 #endif	/* _EXT4_H */
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6b8c687..228261e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3081,7 +3081,7 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
 /*
  * Callback function called for each extent to gather FIEMAP information.
  */
-int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
+static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
 		       struct ext4_ext_cache *newex, struct ext4_extent *ex,
 		       void *data)
 {
@@ -3150,7 +3150,7 @@ int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
 /* fiemap flags we can handle specified here */
 #define EXT4_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC|FIEMAP_FLAG_XATTR)
 
-int ext4_xattr_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo)
+static int ext4_xattr_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo)
 {
 	__u64 physical = 0;
 	__u64 length;
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 6bd11fb..f731cb5 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -140,9 +140,6 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
-extern int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
-		__u64 start, __u64 len);
-
 const struct file_operations ext4_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 810a862..b46bcb7 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3842,7 +3842,7 @@ static int __ext4_get_inode_loc(struct inode *inode,
 	ext4_fsblk_t		block;
 	int			inodes_per_block, inode_offset;
 
-	iloc->bh = 0;
+	iloc->bh = NULL;
 	if (!ext4_valid_inum(sb, inode->i_ino))
 		return -EIO;
 
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 59151c1..9cc93af 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1056,6 +1056,8 @@ static void mb_set_bits(spinlock_t *lock, void *bm, int cur, int len)
 
 static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 			  int first, int count)
+__releases(bitlock)
+__acquires(bitlock)
 {
 	int block = 0;
 	int max = 0;
@@ -2242,7 +2244,7 @@ ext4_mb_store_history(struct ext4_allocation_context *ac)
 
 
 /* Create and initialize ext4_group_info data for the given group. */
-int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
+static int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 			  struct ext4_group_desc *desc)
 {
 	int i, len;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d4c84f4..6bec662 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1876,7 +1876,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	int db_count;
 	int i;
 	int needs_recovery, has_huge_files;
-	__le32 features;
+	int features;
 	__u64 blocks_count;
 	int err;
 
@@ -2006,14 +2006,14 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (features) {
 		printk(KERN_ERR "EXT4-fs: %s: couldn't mount because of "
 		       "unsupported optional features (%x).\n",
-		       sb->s_id, le32_to_cpu(features));
+		       sb->s_id, features);
 		goto failed_mount;
 	}
 	features = EXT4_HAS_RO_COMPAT_FEATURE(sb, ~EXT4_FEATURE_RO_COMPAT_SUPP);
 	if (!(sb->s_flags & MS_RDONLY) && features) {
 		printk(KERN_ERR "EXT4-fs: %s: couldn't mount RDWR because of "
 		       "unsupported optional features (%x).\n",
-		       sb->s_id, le32_to_cpu(features));
+		       sb->s_id, features);
 		goto failed_mount;
 	}
 	has_huge_files = EXT4_HAS_RO_COMPAT_FEATURE(sb,
@@ -3036,13 +3036,13 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 			ext4_mark_recovery_complete(sb, es);
 			lock_super(sb);
 		} else {
-			__le32 ret;
+			int ret;
 			if ((ret = EXT4_HAS_RO_COMPAT_FEATURE(sb,
 					~EXT4_FEATURE_RO_COMPAT_SUPP))) {
 				printk(KERN_WARNING "EXT4-fs: %s: couldn't "
 				       "remount RDWR because of unsupported "
 				       "optional features (%x).\n",
-				       sb->s_id, le32_to_cpu(ret));
+				       sb->s_id, ret);
 				err = -EROFS;
 				goto restore_opts;
 			}
-- 
1.6.0.3.514.g2f91b

