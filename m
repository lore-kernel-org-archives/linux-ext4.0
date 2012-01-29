From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 4/4] ext4: enable online-resizing support meta_bg and bit64
Date: Mon, 30 Jan 2012 00:01:06 +0800
Message-ID: <1327852866-4448-5-git-send-email-xiaoqiangnk@gmail.com>
References: <1327852866-4448-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: adilger@gmail.com, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33752 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382Ab2CVNlj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 Mar 2012 09:41:39 -0400
Received: by gghe5 with SMTP id e5so1731125ggh.19
        for <linux-ext4@vger.kernel.org>; Thu, 22 Mar 2012 06:41:38 -0700 (PDT)
In-Reply-To: <1327852866-4448-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch let online-resizing support meta_bg and bit64 features.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ioctl.c  |   15 ----
 fs/ext4/resize.c |  216 ++++++++++++++++++++++++++++++++++++++++--------------
 2 files changed, 161 insertions(+), 70 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 6eee255..6e1ec89 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -354,26 +354,11 @@ group_add_out:
 			return -EOPNOTSUPP;
 		}
 
-		if (EXT4_HAS_INCOMPAT_FEATURE(sb,
-			       EXT4_FEATURE_INCOMPAT_META_BG)) {
-			ext4_msg(sb, KERN_ERR,
-				 "Online resizing not (yet) supported with meta_bg");
-			return -EOPNOTSUPP;
-		}
-
 		if (copy_from_user(&n_blocks_count, (__u64 __user *)arg,
 				   sizeof(__u64))) {
 			return -EFAULT;
 		}
 
-		if (n_blocks_count > MAX_32_NUM &&
-		    !EXT4_HAS_INCOMPAT_FEATURE(sb,
-					       EXT4_FEATURE_INCOMPAT_64BIT)) {
-			ext4_msg(sb, KERN_ERR,
-				 "File system only supports 32-bit block numbers");
-			return -EOPNOTSUPP;
-		}
-
 		err = ext4_resize_begin(sb);
 		if (err)
 			return err;
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 3999a19..150827b 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -45,6 +45,28 @@ void ext4_resize_end(struct super_block *sb)
 	smp_mb__after_clear_bit();
 }
 
+static ext4_group_t ext4_meta_bg_first_group(struct super_block *sb,
+					     ext4_group_t group) {
+	return (group >> EXT4_DESC_PER_BLOCK_BITS(sb)) <<
+	       EXT4_DESC_PER_BLOCK_BITS(sb);
+}
+
+static ext4_fsblk_t ext4_meta_bg_first_block_no(struct super_block *sb,
+					     ext4_group_t group) {
+	group = ext4_meta_bg_first_group(sb, group);
+	return ext4_group_first_block_no(sb, group);
+}
+
+static ext4_grpblk_t ext4_group_overhead_blocks(struct super_block *sb,
+						ext4_group_t group) {
+	ext4_grpblk_t overhead;
+	overhead = ext4_bg_num_gdb(sb, group);
+	if (ext4_bg_has_super(sb, group))
+		overhead += 1 +
+			  le16_to_cpu(EXT4_SB(sb)->s_es->s_reserved_gdt_blocks);
+	return overhead;
+}
+
 #define outside(b, first, last)	((b) < (first) || (b) >= (last))
 #define inside(b, first, last)	((b) >= (first) && (b) < (last))
 
@@ -57,9 +79,7 @@ static int verify_group_input(struct super_block *sb,
 	ext4_fsblk_t end = start + input->blocks_count;
 	ext4_group_t group = input->group;
 	ext4_fsblk_t itend = input->inode_table + sbi->s_itb_per_group;
-	unsigned overhead = ext4_bg_has_super(sb, group) ?
-		(1 + ext4_bg_num_gdb(sb, group) +
-		 le16_to_cpu(es->s_reserved_gdt_blocks)) : 0;
+	unsigned overhead = ext4_group_overhead_blocks(sb, group);
 	ext4_fsblk_t metaend = start + overhead;
 	struct buffer_head *bh = NULL;
 	ext4_grpblk_t free_blocks_count, offset;
@@ -204,7 +224,6 @@ static void ext4_alloc_group_tables(struct super_block *sb,
 				int flexbg_size)
 {
 	struct ext4_new_group_data *group_data = flex_gd->groups;
-	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
 	ext4_fsblk_t start_blk;
 	ext4_fsblk_t last_blk;
 	ext4_group_t src_group;
@@ -227,20 +246,20 @@ next_group:
 	start_blk = ext4_group_first_block_no(sb, src_group);
 	last_blk = start_blk + group_data[src_group - group].blocks_count;
 
-	overhead = ext4_bg_has_super(sb, src_group) ?
-		   (1 + ext4_bg_num_gdb(sb, src_group) +
-		    le16_to_cpu(es->s_reserved_gdt_blocks)) : 0;
+	overhead = ext4_group_overhead_blocks(sb, src_group);
 
 	start_blk += overhead;
 
 	BUG_ON(src_group >= group_data[0].group + flex_gd->count);
 	/* We collect contiguous blocks as much as possible. */
 	src_group++;
-	for (; src_group <= last_group; src_group++)
-		if (!ext4_bg_has_super(sb, src_group))
+	for (; src_group <= last_group; src_group++) {
+		overhead = ext4_group_overhead_blocks(sb, src_group);
+		if (overhead != 0)
 			last_blk += group_data[src_group - group].blocks_count;
 		else
 			break;
+	}
 
 	/* Allocate block bitmaps */
 	for (; bb_index < flex_gd->count; bb_index++) {
@@ -431,11 +450,13 @@ static int setup_new_flex_group_blocks(struct super_block *sb,
 	ext4_group_t group, count;
 	struct buffer_head *bh = NULL;
 	int reserved_gdb, i, j, err = 0, err2;
+	int meta_bg;
 
 	BUG_ON(!flex_gd->count || !group_data ||
 	       group_data[0].group != sbi->s_groups_count);
 
 	reserved_gdb = le16_to_cpu(es->s_reserved_gdt_blocks);
+	meta_bg = EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_META_BG);
 
 	/* This transaction may be extended/restarted along the way */
 	handle = ext4_journal_start_sb(sb, EXT4_MAX_TRANS_DATA);
@@ -445,15 +466,25 @@ static int setup_new_flex_group_blocks(struct super_block *sb,
 	group = group_data[0].group;
 	for (i = 0; i < flex_gd->count; i++, group++) {
 		unsigned long gdblocks;
+		ext4_grpblk_t overhead;
 
 		gdblocks = ext4_bg_num_gdb(sb, group);
 		start = ext4_group_first_block_no(sb, group);
 
-		if (!ext4_bg_has_super(sb, group))
+		if (meta_bg == 0 && !ext4_bg_has_super(sb, group))
 			goto handle_itb;
 
+		if (meta_bg == 1) {
+			ext4_group_t first_group;
+			first_group = ext4_meta_bg_first_group(sb, group);
+			if (first_group != group + 1 &&
+			    first_group != group + EXT4_DESC_PER_BLOCK(sb) - 1)
+				goto handle_itb;
+		}
+
+		block = start + ext4_bg_has_super(sb, group);
 		/* Copy all of the GDT blocks into the backup in this group */
-		for (j = 0, block = start + 1; j < gdblocks; j++, block++) {
+		for (j = 0; j < gdblocks; j++, block++) {
 			struct buffer_head *gdb;
 
 			ext4_debug("update backup group %#04llx\n", block);
@@ -523,11 +554,11 @@ handle_bb:
 			err = PTR_ERR(bh);
 			goto out;
 		}
-		if (ext4_bg_has_super(sb, group)) {
+		overhead = ext4_group_overhead_blocks(sb, group);
+		if (overhead != 0) {
 			ext4_debug("mark backup superblock %#04llx (+0)\n",
 				   start);
-			ext4_set_bits(bh->b_data, 0, gdblocks + reserved_gdb +
-						     1);
+			ext4_set_bits(bh->b_data, 0, overhead);
 		}
 		ext4_mark_bitmap_end(group_data[i].blocks_count,
 				     sb->s_blocksize * 8, bh->b_data);
@@ -824,6 +855,45 @@ exit_bh:
 }
 
 /*
+ * add_new_gdb_meta_bg is the sister of add_new_gdb.
+ */
+static int add_new_gdb_meta_bg(struct super_block *sb,
+			       handle_t *handle, ext4_group_t group) {
+	ext4_fsblk_t gdblock;
+	struct buffer_head *gdb_bh;
+	struct buffer_head **o_group_desc, **n_group_desc;
+	unsigned long gdb_num = group / EXT4_DESC_PER_BLOCK(sb);
+	int err;
+
+	gdblock = ext4_meta_bg_first_block_no(sb, group) +
+		   ext4_bg_has_super(sb, group);
+	gdb_bh = sb_bread(sb, gdblock);
+	if (!gdb_bh)
+		return -EIO;
+	n_group_desc = ext4_kvmalloc((gdb_num + 1) *
+				     sizeof(struct buffer_head *),
+				     GFP_NOFS);
+	if (!n_group_desc) {
+		err = -ENOMEM;
+		ext4_warning(sb, "not enough memory for %lu groups",
+			     gdb_num + 1);
+		return err;
+	}
+
+	o_group_desc = EXT4_SB(sb)->s_group_desc;
+	memcpy(n_group_desc, o_group_desc,
+	       EXT4_SB(sb)->s_gdb_count * sizeof(struct buffer_head *));
+	n_group_desc[gdb_num] = gdb_bh;
+	EXT4_SB(sb)->s_group_desc = n_group_desc;
+	EXT4_SB(sb)->s_gdb_count++;
+	ext4_kvfree(o_group_desc);
+	err = ext4_journal_get_write_access(handle, gdb_bh);
+	if (unlikely(err))
+		brelse(gdb_bh);
+	return err;
+}
+
+/*
  * Called when we are adding a new group which has a backup copy of each of
  * the GDT blocks (i.e. sparse group) and there are reserved GDT blocks.
  * We need to add these reserved backup GDT blocks to the resize inode, so
@@ -951,15 +1021,15 @@ exit_free:
  * do not copy the full number of backups at this time.  The resize
  * which changed s_groups_count will backup again.
  */
-static void update_backups(struct super_block *sb,
-			   int blk_off, char *data, int size)
+static void update_backups(struct super_block *sb, int blk_off, char *data,
+			   int size, int meta_bg)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	const ext4_group_t last = sbi->s_groups_count;
+	ext4_group_t last;
 	unsigned three = 1;
 	unsigned five = 5;
 	unsigned seven = 7;
-	ext4_group_t group;
+	ext4_group_t group = 0;
 	int rest = sb->s_blocksize - size;
 	handle_t *handle;
 	int err = 0, err2;
@@ -971,8 +1041,17 @@ static void update_backups(struct super_block *sb,
 		goto exit_err;
 	}
 
-	while ((group = ext4_list_backups(sb, &three, &five, &seven)) < last) {
+	if (meta_bg == 0) {
+		group = ext4_list_backups(sb, &three, &five, &seven);
+		last = sbi->s_groups_count;
+	} else {
+		group = ext4_meta_bg_first_group(sb, group) + 1;
+		last = (ext4_group_t)(group + EXT4_DESC_PER_BLOCK(sb) - 2);
+	}
+
+	while (group < sbi->s_groups_count) {
 		struct buffer_head *bh;
+		ext4_fsblk_t backup_block;
 
 		/* Out of journal space, and can't get more - abort - so sad */
 		if (ext4_handle_valid(handle) &&
@@ -980,15 +1059,21 @@ static void update_backups(struct super_block *sb,
 		    ext4_journal_extend(handle, EXT4_MAX_TRANS_DATA) &&
 		    (err = ext4_journal_restart(handle, EXT4_MAX_TRANS_DATA)))
 			break;
+		if (meta_bg == 0)
+			backup_block = ext4_group_first_block_no(sb, group) +
+				       blk_off;
+		else
+			backup_block = ext4_group_first_block_no(sb, group) +
+				       ext4_bg_has_super(sb, group);
 
-		bh = sb_getblk(sb, ext4_group_first_block_no(sb, group) +
-				   blk_off);
+		bh = sb_getblk(sb, backup_block);
 		if (!bh) {
 			err = -EIO;
 			break;
 		}
-		ext4_debug("update metadata backup %#04lx\n",
-			  (unsigned long)bh->b_blocknr);
+		ext4_debug("update metadata backup %#04lx(+%llu)\n",
+			   (unsigned long)bh->b_blocknr, backup_block -
+			   ext4_group_first_block_no(sb, group));
 		if ((err = ext4_journal_get_write_access(handle, bh)))
 			break;
 		lock_buffer(bh);
@@ -1001,6 +1086,13 @@ static void update_backups(struct super_block *sb,
 		if (unlikely(err))
 			ext4_std_error(sb, err);
 		brelse(bh);
+
+		if (meta_bg == 0)
+			group = ext4_list_backups(sb, &three, &five, &seven);
+		else if (group == last)
+			break;
+		else
+			group = last;
 	}
 	if ((err2 = ext4_journal_stop(handle)) && !err)
 		err = err2;
@@ -1043,7 +1135,9 @@ static int ext4_add_new_descs(handle_t *handle, struct super_block *sb,
 	struct ext4_super_block *es = sbi->s_es;
 	struct buffer_head *gdb_bh;
 	int i, gdb_off, gdb_num, err = 0;
+	int meta_bg;		
 
+	meta_bg = EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_META_BG);
 	for (i = 0; i < count; i++, group++) {
 		int reserved_gdb = ext4_bg_has_super(sb, group) ?
 			le16_to_cpu(es->s_reserved_gdt_blocks) : 0;
@@ -1063,8 +1157,11 @@ static int ext4_add_new_descs(handle_t *handle, struct super_block *sb,
 
 			if (!err && reserved_gdb && ext4_bg_num_gdb(sb, group))
 				err = reserve_backup_gdb(handle, resize_inode, group);
-		} else
+		} else if (meta_bg != 0) {
+			err = add_new_gdb_meta_bg(sb, handle, group);
+		} else {
 			err = add_new_gdb(handle, resize_inode, group);
+		}
 		if (err)
 			break;
 	}
@@ -1173,6 +1270,7 @@ static void ext4_update_super(struct super_block *sb,
 	le32_add_cpu(&es->s_free_inodes_count, EXT4_INODES_PER_GROUP(sb) *
 		     flex_gd->count);
 
+	ext4_debug("free blocks count %llu", ext4_free_blocks_count(es));
 	/*
 	 * We need to protect s_groups_count against other CPUs seeing
 	 * inconsistent state in the superblock.
@@ -1207,6 +1305,7 @@ static void ext4_update_super(struct super_block *sb,
 	percpu_counter_add(&sbi->s_freeinodes_counter,
 			   EXT4_INODES_PER_GROUP(sb) * flex_gd->count);
 
+	ext4_debug("free blocks count %llu", percpu_counter_read(&sbi->s_freeclusters_counter));
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb,
 				      EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
 	    sbi->s_log_groups_per_flex) {
@@ -1292,10 +1391,13 @@ exit_journal:
 	if (!err) {
 		int gdb_num, gdb_num_end;
 		ext4_fsblk_t first_block;
+		int meta_bg;
 
+		meta_bg = EXT4_HAS_INCOMPAT_FEATURE(sb,
+						EXT4_FEATURE_INCOMPAT_META_BG);
 		first_block = ext4_group_first_block_no(sb, 0);
 		update_backups(sb, sbi->s_sbh->b_blocknr - first_block,
-			       (char *)es, sizeof(struct ext4_super_block));
+			       (char *)es, sizeof(struct ext4_super_block), 0);
 
 		gdb_num = group / EXT4_DESC_PER_BLOCK(sb);
 		gdb_num_end = (group + flex_gd->count - 1) /
@@ -1304,7 +1406,7 @@ exit_journal:
 			struct buffer_head *gdb_bh;
 			gdb_bh = sbi->s_group_desc[gdb_num];
 			update_backups(sb, gdb_bh->b_blocknr - first_block,
-				       gdb_bh->b_data, gdb_bh->b_size);
+				       gdb_bh->b_data, gdb_bh->b_size, meta_bg);
 		}
 	}
 exit:
@@ -1348,9 +1450,7 @@ static int ext4_setup_next_flex_gd(struct super_block *sb,
 
 		group_data[i].group = group + i;
 		group_data[i].blocks_count = blocks_per_group;
-		overhead = ext4_bg_has_super(sb, group + i) ?
-			   (1 + ext4_bg_num_gdb(sb, group + i) +
-			    le16_to_cpu(es->s_reserved_gdt_blocks)) : 0;
+		overhead = ext4_group_overhead_blocks(sb, group + i);
 		group_data[i].free_blocks_count = blocks_per_group - overhead;
 		if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
 					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
@@ -1493,11 +1593,13 @@ errout:
 		err = err2;
 
 	if (!err) {
+		ext4_fsblk_t first_block;
+		first_block = ext4_group_first_block_no(sb, 0);
 		if (test_opt(sb, DEBUG))
 			printk(KERN_DEBUG "EXT4-fs: extended group to %llu "
 			       "blocks\n", ext4_blocks_count(es));
-		update_backups(sb, EXT4_SB(sb)->s_sbh->b_blocknr, (char *)es,
-			       sizeof(struct ext4_super_block));
+		update_backups(sb, EXT4_SB(sb)->s_sbh->b_blocknr - first_block,
+			       (char *)es, sizeof(struct ext4_super_block), 0);
 	}
 	return err;
 }
@@ -1592,14 +1694,11 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
 	struct buffer_head *bh;
-	struct inode *resize_inode;
-	ext4_fsblk_t o_blocks_count;
+	struct inode *resize_inode = NULL;
+	ext4_grpblk_t add, offset;
 	ext4_group_t o_group;
 	ext4_group_t n_group;
-	ext4_grpblk_t offset, add;
-	unsigned long n_desc_blocks;
-	unsigned long o_desc_blocks;
-	unsigned long desc_blocks;
+	ext4_fsblk_t o_blocks_count;
 	int err = 0, flexbg_size = 1;
 
 	o_blocks_count = ext4_blocks_count(es);
@@ -1621,23 +1720,30 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
 	ext4_get_group_no_and_offset(sb, n_blocks_count - 1, &n_group, &offset);
 	ext4_get_group_no_and_offset(sb, o_blocks_count - 1, &o_group, &offset);
 
-	n_desc_blocks = (n_group + EXT4_DESC_PER_BLOCK(sb)) /
-			EXT4_DESC_PER_BLOCK(sb);
-	o_desc_blocks = (sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb) - 1) /
-			EXT4_DESC_PER_BLOCK(sb);
-	desc_blocks = n_desc_blocks - o_desc_blocks;
-
-	if (desc_blocks &&
-	    (!EXT4_HAS_COMPAT_FEATURE(sb, EXT4_FEATURE_COMPAT_RESIZE_INODE) ||
-	     le16_to_cpu(es->s_reserved_gdt_blocks) < desc_blocks)) {
-		ext4_warning(sb, "No reserved GDT blocks, can't resize");
-		return -EPERM;
-	}
+	if(!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_META_BG)) {
+		unsigned long n_desc_blocks;
+		unsigned long o_desc_blocks;
+		unsigned long desc_blocks;
+
+		n_desc_blocks = (n_group + EXT4_DESC_PER_BLOCK(sb)) /
+				EXT4_DESC_PER_BLOCK(sb);
+		o_desc_blocks = (sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb)
+				 - 1) / EXT4_DESC_PER_BLOCK(sb);
+		desc_blocks = n_desc_blocks - o_desc_blocks;
+
+		if (desc_blocks &&
+		    (!EXT4_HAS_COMPAT_FEATURE(sb,
+					EXT4_FEATURE_COMPAT_RESIZE_INODE) ||
+		     le16_to_cpu(es->s_reserved_gdt_blocks) < desc_blocks)) {
+			ext4_warning(sb, "No reserved GDT blocks, can't resize");
+			return -EPERM;
+		}
 
-	resize_inode = ext4_iget(sb, EXT4_RESIZE_INO);
-	if (IS_ERR(resize_inode)) {
-		ext4_warning(sb, "Error opening resize inode");
-		return PTR_ERR(resize_inode);
+		resize_inode = ext4_iget(sb, EXT4_RESIZE_INO);
+		if (IS_ERR(resize_inode)) {
+			ext4_warning(sb, "Error opening resize inode");
+			return PTR_ERR(resize_inode);
+		}
 	}
 
 	/* See if the device is actually as big as what was requested */
@@ -1687,8 +1793,8 @@ int ext4_resize_fs(struct super_block *sb, ext4_fsblk_t n_blocks_count)
 out:
 	if (flex_gd)
 		free_flex_gd(flex_gd);
