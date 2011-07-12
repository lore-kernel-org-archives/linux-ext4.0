From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH] ext4: fall back to vmalloc() for large allocations
Date: Tue, 12 Jul 2011 15:40:46 -0600
Message-ID: <1310506846-25843-1-git-send-email-adilger@whamcloud.com>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@whamcloud.com>,
	Yu Jian <yujian@whamcloud.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:2633 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab1GLVku (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jul 2011 17:40:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

For very large ext4 filesystems (128TB and larger) kmalloc() of
some per-group structures can fail at mount time due to memory
fragmentation.  If kmalloc() fails, fall back to vmalloc() for
the s_group_info and s_group_desc arrays.

Signed-off-by: Yu Jian <yujian@whamcloud.com>
Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 fs/ext4/mballoc.c |   49 +++++++++++++++++++++++++++++++++----------------
 fs/ext4/super.c   |   29 +++++++++++++++++++++++------
 2 files changed, 56 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 6ed859d..72c5796 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2325,25 +2325,37 @@ static int ext4_mb_init_backend(struct super_block *sb)
 	while (array_size < sizeof(*sbi->s_group_info) *
 	       num_meta_group_infos_max)
 		array_size = array_size << 1;
-	/* An 8TB filesystem with 64-bit pointers requires a 4096 byte
-	 * kmalloc. A 128kb malloc should suffice for a 256TB filesystem.
-	 * So a two level scheme suffices for now. */
+	/* A 16TB filesystem with 64-bit pointers requires an 8192 byte
+	 * kmalloc(). Filesystems larger than 2^32 blocks (16TB normally)
+	 * have group descriptors at least twice as large (64 bytes or
+	 * more vs. 32 bytes for traditional ext3 filesystems), so a 128TB
+	 * filesystem needs a 128kB allocation, which may need vmalloc(). */
 	sbi->s_group_info = kzalloc(array_size, GFP_KERNEL);
 	if (sbi->s_group_info == NULL) {
-		printk(KERN_ERR "EXT4-fs: can't allocate buddy meta group\n");
-		return -ENOMEM;
+		sbi->s_group_info = vmalloc(array_size);
+		if (sbi->s_group_info != NULL) {
+			memset(sbi->s_group_info, 0, array_size);
+		} else {
+			ext4_msg(sb, KERN_ERR, "no memory for groupinfo (%u)\n",
+				 array_size);
+			return -ENOMEM;
+		}
 	}
 	sbi->s_buddy_cache = new_inode(sb);
 	if (sbi->s_buddy_cache == NULL) {
-		printk(KERN_ERR "EXT4-fs: can't get new inode\n");
+		ext4_msg(sb, KERN_ERR, "can't get new inode\n");
 		goto err_freesgi;
 	}
-	sbi->s_buddy_cache->i_ino = get_next_ino();
+	/* To avoid potentially colliding with an valid on-disk inode number,
+	 * use EXT4_BAD_INO for the buddy cache inode number.  This inode is
+	 * not in the inode hash, so it should never be found by iget(), but
+	 * this will avoid confusion if it ever shows up during debugging. */
+	sbi->s_buddy_cache->i_ino = EXT4_BAD_INO;
 	EXT4_I(sbi->s_buddy_cache)->i_disksize = 0;
 	for (i = 0; i < ngroups; i++) {
 		desc = ext4_get_group_desc(sb, i, NULL);
 		if (desc == NULL) {
-			printk(KERN_ERR
+			ext4_msg(sb, KERN_ERR,
 				"EXT4-fs: can't read descriptor %u\n", i);
 			goto err_freebuddy;
 		}
@@ -2362,7 +2374,10 @@ err_freebuddy:
 		kfree(sbi->s_group_info[i]);
 	iput(sbi->s_buddy_cache);
 err_freesgi:
-	kfree(sbi->s_group_info);
+	if (is_vmalloc_addr(sbi->s_group_info))
+		vfree(sbi->s_group_info);
+	else
+		kfree(sbi->s_group_info);
 	return -ENOMEM;
 }
 
@@ -2457,12 +2472,6 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 		i++;
 	} while (i <= sb->s_blocksize_bits + 1);
 
-	/* init file for buddy data */
-	ret = ext4_mb_init_backend(sb);
-	if (ret != 0) {
-		goto out;
-	}
-
 	spin_lock_init(&sbi->s_md_lock);
 	spin_lock_init(&sbi->s_bal_lock);
 
@@ -2487,6 +2496,11 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 		spin_lock_init(&lg->lg_prealloc_lock);
 	}
 
+	/* init file for buddy data */
+	ret = ext4_mb_init_backend(sb);
+	if (ret != 0)
+		goto out;
+
 	if (sbi->s_proc)
 		proc_create_data("mb_groups", S_IRUGO, sbi->s_proc,
 				 &ext4_mb_seq_groups_fops, sb);
@@ -2544,7 +2558,10 @@ int ext4_mb_release(struct super_block *sb)
 			EXT4_DESC_PER_BLOCK_BITS(sb);
 		for (i = 0; i < num_meta_group_infos; i++)
 			kfree(sbi->s_group_info[i]);
-		kfree(sbi->s_group_info);
+		if (is_vmalloc_addr(sbi->s_group_info))
+			vfree(sbi->s_group_info);
+		else
+			kfree(sbi->s_group_info);
 	}
 	kfree(sbi->s_mb_offsets);
 	kfree(sbi->s_mb_maxs);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9ea71aa..556084b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -789,7 +789,12 @@ static void ext4_put_super(struct super_block *sb)
 
 	for (i = 0; i < sbi->s_gdb_count; i++)
 		brelse(sbi->s_group_desc[i]);
-	kfree(sbi->s_group_desc);
+
+	if (is_vmalloc_addr(sbi->s_group_desc))
+		vfree(sbi->s_group_desc);
+	else
+		kfree(sbi->s_group_desc);
+
 	if (is_vmalloc_addr(sbi->s_flex_groups))
 		vfree(sbi->s_flex_groups);
 	else
@@ -3059,6 +3064,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	int ret = -ENOMEM;
 	int blocksize;
 	unsigned int db_count;
+	size_t size;
 	unsigned int i;
 	int needs_recovery, has_huge_files;
 	__u64 blocks_count;
@@ -3408,11 +3414,18 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			(EXT4_MAX_BLOCK_FILE_PHYS / EXT4_BLOCKS_PER_GROUP(sb)));
 	db_count = (sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb) - 1) /
 		   EXT4_DESC_PER_BLOCK(sb);
-	sbi->s_group_desc = kmalloc(db_count * sizeof(struct buffer_head *),
-				    GFP_KERNEL);
+	size = (size_t)db_count * sizeof(struct buffer_head *);
+	sbi->s_group_desc = kzalloc(size, GFP_KERNEL);
 	if (sbi->s_group_desc == NULL) {
-		ext4_msg(sb, KERN_ERR, "not enough memory");
-		goto failed_mount;
+		sbi->s_group_desc = vmalloc(size);
+		if (sbi->s_group_desc != NULL) {
+			memset(sbi->s_group_desc, 0, size);
+		} else {
+			ext4_msg(sb, KERN_ERR, "no memory for %u groups (%u)\n",
+				 sbi->s_groups_count, (unsigned int)size);
+			ret = -ENOMEM;
+			goto failed_mount;
+	 	}
 	}
 
 #ifdef CONFIG_PROC_FS
@@ -3756,7 +3769,11 @@ failed_mount3:
 failed_mount2:
 	for (i = 0; i < db_count; i++)
 		brelse(sbi->s_group_desc[i]);
-	kfree(sbi->s_group_desc);
+
+	if (is_vmalloc_addr(sbi->s_group_desc))
+		vfree(sbi->s_group_desc);
+	else
+		kfree(sbi->s_group_desc);
 failed_mount:
 	if (sbi->s_proc) {
 		remove_proc_entry(sb->s_id, ext4_proc_root);
-- 
1.7.3.4

