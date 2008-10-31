From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: sparse fixes
Date: Fri, 31 Oct 2008 22:25:35 +0530
Message-ID: <1225472135-20297-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	frederic.bohe@bull.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:54829 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYJaQzl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Oct 2008 12:55:41 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp06.in.ibm.com (8.13.1/8.13.1) with ESMTP id m9VGtdLA008850
	for <linux-ext4@vger.kernel.org>; Fri, 31 Oct 2008 22:25:39 +0530
Received: from d28av05.in.ibm.com (d28av05.in.ibm.com [9.184.220.67])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9VGtcGR1216624
	for <linux-ext4@vger.kernel.org>; Fri, 31 Oct 2008 22:25:38 +0530
Received: from d28av05.in.ibm.com (loopback [127.0.0.1])
	by d28av05.in.ibm.com (8.13.1/8.13.3) with ESMTP id m9VGtc6n016278
	for <linux-ext4@vger.kernel.org>; Sat, 1 Nov 2008 03:55:38 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There are some locking fixes also in this patch.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/ext4.h    |    3 +++
 fs/ext4/extents.c |    4 ++--
 fs/ext4/inode.c   |    2 +-
 fs/ext4/mballoc.c |    5 ++++-
 fs/ext4/super.c   |    9 ++++-----
 5 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 4880cc3..46419f5 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1284,6 +1284,9 @@ extern int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode,
 			sector_t block, unsigned long max_blocks,
 			struct buffer_head *bh, int create,
 			int extend_disksize, int flag);
+extern int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
+		__u64 start, __u64 len);
+
 #endif	/* __KERNEL__ */
 
 #endif	/* _EXT4_H */
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ea2ce3c..b09b291 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3083,7 +3083,7 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
 /*
  * Callback function called for each extent to gather FIEMAP information.
  */
-int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
+static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
 		       struct ext4_ext_cache *newex, struct ext4_extent *ex,
 		       void *data)
 {
@@ -3152,7 +3152,7 @@ int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
 /* fiemap flags we can handle specified here */
 #define EXT4_FIEMAP_FLAGS	(FIEMAP_FLAG_SYNC|FIEMAP_FLAG_XATTR)
 
-int ext4_xattr_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo)
+static int ext4_xattr_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo)
 {
 	__u64 physical = 0;
 	__u64 length;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8dbf695..2d070ef 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3841,7 +3841,7 @@ static int __ext4_get_inode_loc(struct inode *inode,
 	ext4_fsblk_t		block;
 	int			inodes_per_block, inode_offset;
 
-	iloc->bh = 0;
+	iloc->bh = NULL;
 	if (!ext4_valid_inum(sb, inode->i_ino))
 		return -EIO;
 
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index dfe17a1..db05ffd 100644
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
@@ -4441,6 +4443,7 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 		else if (block >= (entry->start_blk + entry->count))
 			n = &(*n)->rb_right;
 		else {
+			ext4_unlock_group(sb, group);
 			ext4_error(sb, __func__,
 			    "Double free of blocks %d (%d %d)\n",
 			    block, entry->start_blk, entry->count);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index bdddea1..a725a5c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1455,9 +1455,8 @@ static int ext4_fill_flex_info(struct super_block *sb)
 
 	/* We allocate both existing and potentially added groups */
 	flex_group_count = ((sbi->s_groups_count + groups_per_flex - 1) +
-			    ((sbi->s_es->s_reserved_gdt_blocks +1 ) <<
-			      EXT4_DESC_PER_BLOCK_BITS(sb))) /
-			   groups_per_flex;
+			    ((le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks) + 1) <<
+			      EXT4_DESC_PER_BLOCK_BITS(sb))) / groups_per_flex;
 	sbi->s_flex_groups = kzalloc(flex_group_count *
 				     sizeof(struct flex_groups), GFP_KERNEL);
 	if (sbi->s_flex_groups == NULL) {
@@ -2014,8 +2013,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		       sb->s_id, le32_to_cpu(features));
 		goto failed_mount;
 	}
-	has_huge_files = EXT4_HAS_RO_COMPAT_FEATURE(sb,
-				    EXT4_FEATURE_RO_COMPAT_HUGE_FILE);
+	has_huge_files = le32_to_cpu(EXT4_HAS_RO_COMPAT_FEATURE(sb,
+				    EXT4_FEATURE_RO_COMPAT_HUGE_FILE));
 	if (has_huge_files) {
 		/*
 		 * Large file size enabled file system can only be
-- 
1.6.0.3.514.g2f91b

