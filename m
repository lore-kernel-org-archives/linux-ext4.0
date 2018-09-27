Return-Path: <SRS0=0UAC=MJ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from forward105p.mail.yandex.net ([77.88.28.108]:39069 "EHLO
        forward105p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727530AbeI1CJ1 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 27 Sep 2018 22:09:27 -0400
From: Andrey Abramov <st5pub@yandex.ru>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrey Abramov <st5pub@yandex.ru>
Subject: [PATCH] Fixed some code style issues in the fs/ext4/...
Date: Thu, 27 Sep 2018 22:41:43 +0300
Message-Id: <20180927194143.32665-1-st5pub@yandex.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Andrey Abramov <st5pub@yandex.ru>
---
 fs/ext4/balloc.c         |  7 +++----
 fs/ext4/block_validity.c |  4 +++-
 fs/ext4/file.c           | 16 ++++++++++------
 3 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index e5d6ee61ff48..87dca171d7f6 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -239,7 +239,7 @@ unsigned ext4_free_clusters_after_init(struct super_block *sb,
 				       ext4_group_t block_group,
 				       struct ext4_group_desc *gdp)
 {
-	return num_clusters_in_group(sb, block_group) - 
+	return num_clusters_in_group(sb, block_group) -
 		ext4_num_overhead_clusters(sb, block_group, gdp);
 }
 
@@ -261,7 +261,7 @@ unsigned ext4_free_clusters_after_init(struct super_block *sb,
  * @bh:			pointer to the buffer head to store the block
  *			group descriptor
  */
-struct ext4_group_desc * ext4_get_group_desc(struct super_block *sb,
+struct ext4_group_desc *ext4_get_group_desc(struct super_block *sb,
 					     ext4_group_t block_group,
 					     struct buffer_head **bh)
 {
@@ -823,8 +823,7 @@ unsigned long ext4_bg_num_gdb(struct super_block *sb, ext4_group_t group)
 	if (!ext4_has_feature_meta_bg(sb) || metagroup < first_meta_bg)
 		return ext4_bg_num_gdb_nometa(sb, group);
 
-	return ext4_bg_num_gdb_meta(sb,group);
-
+	return ext4_bg_num_gdb_meta(sb, group);
 }
 
 /*
diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index 913061c0de1b..35e96951eb84 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -154,11 +154,12 @@ int ext4_setup_system_zone(struct super_block *sb)
 	if (sbi->system_blks.rb_node)
 		return 0;
 
-	for (i=0; i < ngroups; i++) {
+	for (i = 0; i < ngroups; i++) {
 		if (ext4_bg_has_super(sb, i) &&
 		    ((i < 5) || ((i % flex_size) == 0)))
 			add_system_zone(sbi, ext4_group_first_block_no(sb, i),
 					ext4_bg_num_gdb(sb, i) + 1);
+
 		gdp = ext4_get_group_desc(sb, i, NULL);
 		ret = add_system_zone(sbi, ext4_block_bitmap(sb, gdp), 1);
 		if (ret)
@@ -174,6 +175,7 @@ int ext4_setup_system_zone(struct super_block *sb)
 
 	if (test_opt(sb, DEBUG))
 		debug_print_tree(sbi);
+
 	return 0;
 }
 
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 69d65d49837b..3e5ded9b3dd4 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -64,7 +64,10 @@ static ssize_t ext4_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
 
 static ssize_t ext4_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
-	if (unlikely(ext4_forced_shutdown(EXT4_SB(file_inode(iocb->ki_filp)->i_sb))))
+	if (unlikely(ext4_forced_shutdown(
+		EXT4_SB(file_inode(iocb->ki_filp)->i_sb)
+		)))
+
 		return -EIO;
 
 	if (!iov_iter_count(to))
@@ -89,14 +92,15 @@ static int ext4_release_file(struct inode *inode, struct file *filp)
 		ext4_clear_inode_state(inode, EXT4_STATE_DA_ALLOC_CLOSE);
 	}
 	/* if we are the last writer on the inode, drop the block reservation */
-	if ((filp->f_mode & FMODE_WRITE) &&
-			(atomic_read(&inode->i_writecount) == 1) &&
-		        !EXT4_I(inode)->i_reserved_data_blocks)
-	{
+	if ((filp->f_mode & FMODE_WRITE)
+		&& (atomic_read(&inode->i_writecount) == 1)
+		&& !EXT4_I(inode)->i_reserved_data_blocks) {
+
 		down_write(&EXT4_I(inode)->i_data_sem);
 		ext4_discard_preallocations(inode);
 		up_write(&EXT4_I(inode)->i_data_sem);
 	}
+
 	if (is_dx(inode) && filp->private_data)
 		ext4_htree_free_dir_info(filp->private_data);
 
@@ -429,7 +433,7 @@ static int ext4_sample_last_mounted(struct super_block *sb,
 	return err;
 }
 
-static int ext4_file_open(struct inode * inode, struct file * filp)
+static int ext4_file_open(struct inode *inode, struct file *filp)
 {
 	int ret;
 
-- 
2.19.0
