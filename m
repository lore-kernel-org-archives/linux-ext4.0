From: devesh.pradhan1@gmail.com
Subject: [PATCH 3/3] fs : ext2: super: fixed '==' instead '=' braces,whitespace coding style issue.
Date: Wed,  7 Feb 2018 02:03:17 +0530
Message-ID: <20180206203317.14435-1-devesh.pradhan1@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        devesh pradhan <devesh.pradhan1@gmail.com>
To: jack@suse.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:37683 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752852AbeBFUd0 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Feb 2018 15:33:26 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: devesh pradhan <devesh.pradhan1@gmail.com>

fixed coding style issue.

Signed-off-by: devesh pradhan <devesh.pradhan1@gmail.com>
---
 fs/ext2/super.c | 59 ++++++++++++++++++++++++++-------------------------------
 1 file changed, 27 insertions(+), 32 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 554c98b8a93a..cb80bcb693a9 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -39,8 +39,8 @@
 #include "acl.h"
 
 static void ext2_write_super(struct super_block *sb);
-static int ext2_remount (struct super_block * sb, int * flags, char * data);
-static int ext2_statfs (struct dentry * dentry, struct kstatfs * buf);
+static int ext2_remount (struct super_block *sb, int *flags, char *data);
+static int ext2_statfs (struct dentry *dentry, struct kstatfs *buf);
 static int ext2_sync_fs(struct super_block *sb, int wait);
 static int ext2_freeze(struct super_block *sb);
 static int ext2_unfreeze(struct super_block *sb);
@@ -140,7 +140,7 @@ static inline void ext2_quota_off_umount(struct super_block *sb)
 }
 #endif
 
-static void ext2_put_super (struct super_block * sb)
+static void ext2_put_super (struct super_block *sb)
 {
 	int db_count;
 	int i;
@@ -176,7 +176,7 @@ static void ext2_put_super (struct super_block * sb)
 	kfree(sbi);
 }
 
-static struct kmem_cache * ext2_inode_cachep;
+static struct kmem_cache *ext2_inode_cachep;
 
 static struct inode *ext2_alloc_inode(struct super_block *sb)
 {
@@ -646,8 +646,8 @@ static int parse_options(char *options, struct super_block *sb,
 	return 1;
 }
 
-static int ext2_setup_super (struct super_block * sb,
-			      struct ext2_super_block * es,
+static int ext2_setup_super (struct super_block *sb,
+			      struct ext2_super_block *es,
 			      int read_only)
 {
 	int res = 0;
@@ -713,19 +713,17 @@ static int ext2_check_descriptors(struct super_block *sb)
 		else
 			last_block = first_block +
 				(EXT2_BLOCKS_PER_GROUP(sb) - 1);
-
 		if (le32_to_cpu(gdp->bg_block_bitmap) < first_block ||
-		    le32_to_cpu(gdp->bg_block_bitmap) > last_block)
-		{
+		    le32_to_cpu(gdp->bg_block_bitmap) > last_block) {
 			ext2_error (sb, "ext2_check_descriptors",
 				    "Block bitmap for group %d"
 				    " not in group (block %lu)!",
 				    i, (unsigned long) le32_to_cpu(gdp->bg_block_bitmap));
 			return 0;
 		}
+
 		if (le32_to_cpu(gdp->bg_inode_bitmap) < first_block ||
-		    le32_to_cpu(gdp->bg_inode_bitmap) > last_block)
-		{
+		    le32_to_cpu(gdp->bg_inode_bitmap) > last_block) {
 			ext2_error (sb, "ext2_check_descriptors",
 				    "Inode bitmap for group %d"
 				    " not in group (block %lu)!",
@@ -734,8 +732,7 @@ static int ext2_check_descriptors(struct super_block *sb)
 		}
 		if (le32_to_cpu(gdp->bg_inode_table) < first_block ||
 		    le32_to_cpu(gdp->bg_inode_table) + sbi->s_itb_per_group - 1 >
-		    last_block)
-		{
+		    last_block) {
 			ext2_error (sb, "ext2_check_descriptors",
 				    "Inode table for group %d"
 				    " not in group (block %lu)!",
@@ -800,7 +797,6 @@ static unsigned long descriptor_loc(struct super_block *sb,
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
 	unsigned long bg, first_meta_bg;
 	int has_super = 0;
-	
 	first_meta_bg = le32_to_cpu(sbi->s_es->s_first_meta_bg);
 
 	if (!EXT2_HAS_INCOMPAT_FEATURE(sb, EXT2_FEATURE_INCOMPAT_META_BG) ||
@@ -816,9 +812,9 @@ static unsigned long descriptor_loc(struct super_block *sb,
 static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct dax_device *dax_dev = fs_dax_get_by_bdev(sb->s_bdev);
-	struct buffer_head * bh;
-	struct ext2_sb_info * sbi;
-	struct ext2_super_block * es;
+	struct buffer_head *bh;
+	struct ext2_sb_info *sbi;
+	struct ext2_super_block *es;
 	struct inode *root;
 	unsigned long block;
 	unsigned long sb_block = get_sb_block(&data);
@@ -864,7 +860,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	/*
-	 * If the superblock doesn't start on a hardware sector boundary,
+	 * If the superblock doesn't start on a hardware sector boundary
 	 * calculate the offset.  
 	 */
 	if (blocksize != BLOCK_SIZE) {
@@ -874,7 +870,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 		logic_sb_block = sb_block;
 	}
 
-	if (!(bh = sb_bread(sb, logic_sb_block))) {
+	if (!(bh == sb_bread(sb, logic_sb_block))) {
 		ext2_msg(sb, KERN_ERR, "error: unable to read superblock");
 		goto failed_sbi;
 	}
@@ -904,8 +900,8 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 #ifdef CONFIG_EXT2_FS_POSIX_ACL
 	if (def_mount_opts & EXT2_DEFM_ACL)
 		set_opt(opts.s_mount_opt, POSIX_ACL);
-#endif
-	
+#endif	
+
 	if (le16_to_cpu(sbi->s_es->s_errors) == EXT2_ERRORS_PANIC)
 		set_opt(opts.s_mount_opt, ERRORS_PANIC);
 	else if (le16_to_cpu(sbi->s_es->s_errors) == EXT2_ERRORS_CONTINUE)
@@ -915,7 +911,6 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 
 	opts.s_resuid = make_kuid(&init_user_ns, le16_to_cpu(es->s_def_resuid));
 	opts.s_resgid = make_kgid(&init_user_ns, le16_to_cpu(es->s_def_resgid));
-	
 	set_opt(opts.s_mount_opt, RESERVATION);
 
 	if (!parse_options((char *) data, sb, &opts))
@@ -949,7 +944,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 			le32_to_cpu(features));
 		goto failed_mount;
 	}
-	if (!sb_rdonly(sb) && (features = EXT2_HAS_RO_COMPAT_FEATURE(sb, ~EXT2_FEATURE_RO_COMPAT_SUPP))){
+	if (!sb_rdonly(sb) && (features == EXT2_HAS_RO_COMPAT_FEATURE(sb, ~EXT2_FEATURE_RO_COMPAT_SUPP))) {
 		ext2_msg(sb, KERN_ERR, "error: couldn't mount RDWR because of "
 		       "unsupported optional features (%x)",
 		       le32_to_cpu(features));
@@ -977,7 +972,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 		logic_sb_block = (sb_block*BLOCK_SIZE) / blocksize;
 		offset = (sb_block*BLOCK_SIZE) % blocksize;
 		bh = sb_bread(sb, logic_sb_block);
-		if(!bh) {
+		if (!bh) {
 			ext2_msg(sb, KERN_ERR, "error: couldn't read"
 				"superblock on 2nd try");
 			goto failed_sbi;
@@ -1073,9 +1068,9 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 
 	if (EXT2_BLOCKS_PER_GROUP(sb) == 0)
 		goto cantfind_ext2;
- 	sbi->s_groups_count = ((le32_to_cpu(es->s_blocks_count) -
- 				le32_to_cpu(es->s_first_data_block) - 1)
- 					/ EXT2_BLOCKS_PER_GROUP(sb)) + 1;
+	sbi->s_groups_count = ((le32_to_cpu(es->s_blocks_count) -
+				le32_to_cpu(es->s_first_data_block) - 1)
+				/ EXT2_BLOCKS_PER_GROUP(sb)) + 1;
 	db_count = (sbi->s_groups_count + EXT2_DESC_PER_BLOCK(sb) - 1) /
 		   EXT2_DESC_PER_BLOCK(sb);
 	sbi->s_group_desc = kmalloc (db_count * sizeof (struct buffer_head *), GFP_KERNEL);
@@ -1314,10 +1309,10 @@ static void ext2_write_super(struct super_block *sb)
 		ext2_sync_fs(sb, 1);
 }
 
-static int ext2_remount (struct super_block * sb, int * flags, char * data)
+static int ext2_remount (struct super_block *sb, int *flags, char *data)
 {
-	struct ext2_sb_info * sbi = EXT2_SB(sb);
-	struct ext2_super_block * es;
+	struct ext2_sb_info *sbi = EXT2_SB(sb);
+	struct ext2_super_block *es;
 	struct ext2_mount_options new_opts;
 	int err;
 
@@ -1400,7 +1395,7 @@ static int ext2_remount (struct super_block * sb, int * flags, char * data)
 	return 0;
 }
 
-static int ext2_statfs (struct dentry * dentry, struct kstatfs * buf)
+static int ext2_statfs (struct dentry *dentry, struct kstatfs *buf)
 {
 	struct super_block *sb = dentry->d_sb;
 	struct ext2_sb_info *sbi = EXT2_SB(sb);
@@ -1639,7 +1634,7 @@ static int __init init_ext2_fs(void)
 	err = init_inodecache();
 	if (err)
 		return err;
-        err = register_filesystem(&ext2_fs_type);
+	err = register_filesystem(&ext2_fs_type);
 	if (err)
 		goto out;
 	return 0;
-- 
2.14.1
