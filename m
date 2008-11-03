From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -v2 1/9] ext4: sparse fixes
Date: Mon,  3 Nov 2008 23:06:01 +0530
Message-ID: <1225733769-23734-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:32783 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbYKCRgQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 12:36:16 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id mA3HZF0i016040
	for <linux-ext4@vger.kernel.org>; Tue, 4 Nov 2008 04:35:15 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA3HaGfd4583522
	for <linux-ext4@vger.kernel.org>; Tue, 4 Nov 2008 04:36:16 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mA3HaEE5013573
	for <linux-ext4@vger.kernel.org>; Tue, 4 Nov 2008 04:36:14 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/ext4.h    |    3 +++
 fs/ext4/extents.c |    4 ++--
 fs/ext4/inode.c   |    2 +-
 fs/ext4/mballoc.c |    4 +++-
 fs/ext4/super.c   |    4 ++--
 5 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 0d65757..fee616d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1350,6 +1350,9 @@ extern int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode,
 			sector_t block, unsigned long max_blocks,
 			struct buffer_head *bh, int create,
 			int extend_disksize, int flag);
+extern int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
+		__u64 start, __u64 len);
+
 #endif	/* __KERNEL__ */
 
 #endif	/* _EXT4_H */
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index a17f53c..400b9c4 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3115,7 +3115,7 @@ long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
 /*
  * Callback function called for each extent to gather FIEMAP information.
  */
-int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
+static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
 		       struct ext4_ext_cache *newex, struct ext4_extent *ex,
 		       void *data)
 {
@@ -3184,7 +3184,7 @@ int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
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
index 0643f9c..20c8b09 100644
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
@@ -2246,7 +2248,7 @@ ext4_mb_store_history(struct ext4_allocation_context *ac)
 
 
 /* Create and initialize ext4_group_info data for the given group. */
-int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
+static int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 			  struct ext4_group_desc *desc)
 {
 	int i, len;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 5bfc235..133da2e 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2022,8 +2022,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
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

