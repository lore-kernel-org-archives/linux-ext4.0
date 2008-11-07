From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH -V3 1/9] ext4: sparse fixes
Date: Fri, 7 Nov 2008 19:50:22 +0530
Message-ID: <20081107142022.GK25194@skywalker>
References: <1225997374-10846-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20081106220954.GM18939@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:49537 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbYKGOUj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2008 09:20:39 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id mA7EJZsv010850
	for <linux-ext4@vger.kernel.org>; Sat, 8 Nov 2008 01:19:35 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA7EKYwg253458
	for <linux-ext4@vger.kernel.org>; Sat, 8 Nov 2008 01:20:35 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mA7EKY6b017766
	for <linux-ext4@vger.kernel.org>; Sat, 8 Nov 2008 01:20:34 +1100
Content-Disposition: inline
In-Reply-To: <20081106220954.GM18939@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 06, 2008 at 05:09:54PM -0500, Theodore Tso wrote:
> On Fri, Nov 07, 2008 at 12:19:26AM +0530, Aneesh Kumar K.V wrote:
> >  #define EXT4_HAS_COMPAT_FEATURE(sb,mask)			\
> > -	(EXT4_SB(sb)->s_es->s_feature_compat & cpu_to_le32(mask))
> > +	(le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_compat) & mask)
> >  #define EXT4_HAS_RO_COMPAT_FEATURE(sb,mask)			\
> > -	(EXT4_SB(sb)->s_es->s_feature_ro_compat & cpu_to_le32(mask))
> > +	(le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_ro_compat) & mask)
> >  #define EXT4_HAS_INCOMPAT_FEATURE(sb,mask)			\
> > -	(EXT4_SB(sb)->s_es->s_feature_incompat & cpu_to_le32(mask))
> > +	(le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_incompat) & mask)
> 
> This is going to force a byte-swap instruction on every single
> big-endian system out there, which could potentially be costly, or at
> least undeed given that all of the times that these functions are
> called, the result gets used only as a booelan.
> 
> Can we shut up sparse by using a explicit cast to an unsigned int?

I did it that way first But found the error path needing conversion.
But i guess it is ok since it happen in the error path printk.

ext4: sparse fixes

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/ext4.h    |    9 ++++++---
 fs/ext4/extents.c |    4 ++--
 fs/ext4/file.c    |    3 ---
 fs/ext4/inode.c   |    2 +-
 fs/ext4/mballoc.c |    4 +++-
 fs/ext4/super.c   |   19 +++++++++++--------
 6 files changed, 23 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9415a1a..5fc8def 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -726,11 +726,11 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
  */
 
 #define EXT4_HAS_COMPAT_FEATURE(sb,mask)			\
-	(EXT4_SB(sb)->s_es->s_feature_compat & cpu_to_le32(mask))
+	(__force __u32)(EXT4_SB(sb)->s_es->s_feature_compat & cpu_to_le32(mask))
 #define EXT4_HAS_RO_COMPAT_FEATURE(sb,mask)			\
-	(EXT4_SB(sb)->s_es->s_feature_ro_compat & cpu_to_le32(mask))
+	(__force __u32)(EXT4_SB(sb)->s_es->s_feature_ro_compat & cpu_to_le32(mask))
 #define EXT4_HAS_INCOMPAT_FEATURE(sb,mask)			\
-	(EXT4_SB(sb)->s_es->s_feature_incompat & cpu_to_le32(mask))
+	(__force __u32)(EXT4_SB(sb)->s_es->s_feature_incompat & cpu_to_le32(mask))
 #define EXT4_SET_COMPAT_FEATURE(sb,mask)			\
 	EXT4_SB(sb)->s_es->s_feature_compat |= cpu_to_le32(mask)
 #define EXT4_SET_RO_COMPAT_FEATURE(sb,mask)			\
@@ -1284,6 +1284,9 @@ extern int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode,
 			sector_t block, unsigned int max_blocks,
 			struct buffer_head *bh, int create,
 			int extend_disksize, int flag);
+extern int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
+			__u64 start, __u64 len);
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
index 1ef1205..d42f748 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3856,7 +3856,7 @@ static int __ext4_get_inode_loc(struct inode *inode,
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
index d4c84f4..d597c1f 100644
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
 
@@ -2005,15 +2005,17 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	features = EXT4_HAS_INCOMPAT_FEATURE(sb, ~EXT4_FEATURE_INCOMPAT_SUPP);
 	if (features) {
 		printk(KERN_ERR "EXT4-fs: %s: couldn't mount because of "
-		       "unsupported optional features (%x).\n",
-		       sb->s_id, le32_to_cpu(features));
+		       "unsupported optional features (%x).\n", sb->s_id,
+			(le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_incompat) &
+			~EXT4_FEATURE_INCOMPAT_SUPP));
 		goto failed_mount;
 	}
 	features = EXT4_HAS_RO_COMPAT_FEATURE(sb, ~EXT4_FEATURE_RO_COMPAT_SUPP);
 	if (!(sb->s_flags & MS_RDONLY) && features) {
 		printk(KERN_ERR "EXT4-fs: %s: couldn't mount RDWR because of "
-		       "unsupported optional features (%x).\n",
-		       sb->s_id, le32_to_cpu(features));
+		       "unsupported optional features (%x).\n", sb->s_id,
+			(le32_to_cpu(EXT4_SB(sb)->s_es->s_feature_ro_compat) &
+			~EXT4_FEATURE_RO_COMPAT_SUPP));
 		goto failed_mount;
 	}
 	has_huge_files = EXT4_HAS_RO_COMPAT_FEATURE(sb,
@@ -3036,13 +3038,14 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 			ext4_mark_recovery_complete(sb, es);
 			lock_super(sb);
 		} else {
-			__le32 ret;
+			int ret;
 			if ((ret = EXT4_HAS_RO_COMPAT_FEATURE(sb,
 					~EXT4_FEATURE_RO_COMPAT_SUPP))) {
 				printk(KERN_WARNING "EXT4-fs: %s: couldn't "
 				       "remount RDWR because of unsupported "
-				       "optional features (%x).\n",
-				       sb->s_id, le32_to_cpu(ret));
+				       "optional features (%x).\n", sb->s_id,
+					(le32_to_cpu(sbi->s_es->s_feature_ro_compat)
+					& ~EXT4_FEATURE_RO_COMPAT_SUPP));
 				err = -EROFS;
 				goto restore_opts;
 			}
