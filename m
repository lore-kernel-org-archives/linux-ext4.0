From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: fix potential use after free during resize V3
Date: Tue,  9 Dec 2014 23:37:15 +0400
Message-ID: <1418153835-18329-1-git-send-email-dmonakhov@openvz.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:16237 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099AbaLIThX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Dec 2014 14:37:23 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need some sort of synchronization while updating ->s_group_desc
because there are a lot of users which can access old ->s_group_desc
array after it was released.

Testcases: xfstests ext4/306 ext4/004 ext4/005

changes from V2:
  - sparse compatibility: add rcu annotations
  - use async rcu cleanup instead of synchronize_rcu

changes from V1:
  - use RCU instead seqcount

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/balloc.c |   12 +++++--
 fs/ext4/ext4.h   |    7 ++++-
 fs/ext4/resize.c |   89 ++++++++++++++++++++++++++++++++++-------------------
 fs/ext4/super.c  |   25 +++++++++------
 4 files changed, 86 insertions(+), 47 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 83a6f49..982adb2 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -282,6 +282,7 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block *sb,
 	unsigned int offset;
 	ext4_group_t ngroups = ext4_get_groups_count(sb);
 	struct ext4_group_desc *desc;
+	struct buffer_head *gd_bh;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
 	if (block_group >= ngroups) {
@@ -293,7 +294,10 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block *sb,
 
 	group_desc = block_group >> EXT4_DESC_PER_BLOCK_BITS(sb);
 	offset = block_group & (EXT4_DESC_PER_BLOCK(sb) - 1);
-	if (!sbi->s_group_desc[group_desc]) {
+	rcu_read_lock();
+	gd_bh = rcu_dereference(sbi->s_group_desc)->bh[group_desc];
+	rcu_read_unlock();
+	if (!gd_bh) {
 		ext4_error(sb, "Group descriptor not loaded - "
 			   "block_group = %u, group_desc = %u, desc = %u",
 			   block_group, group_desc, offset);
@@ -301,10 +305,10 @@ struct ext4_group_desc * ext4_get_group_desc(struct super_block *sb,
 	}
 
 	desc = (struct ext4_group_desc *)(
-		(__u8 *)sbi->s_group_desc[group_desc]->b_data +
-		offset * EXT4_DESC_SIZE(sb));
+		(__u8 *)gd_bh->b_data + offset * EXT4_DESC_SIZE(sb));
 	if (bh)
-		*bh = sbi->s_group_desc[group_desc];
+		*bh = gd_bh;
+
 	return desc;
 }
 
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c24665e..a6076c8 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1169,6 +1169,11 @@ struct ext4_super_block {
 /* Number of quota types we support */
 #define EXT4_MAXQUOTAS 2
 
+struct ext4_gd_array {
+	struct rcu_head rcu;
+	struct buffer_head *bh[0];
+};
+
 /*
  * fourth extended-fs super-block data in memory
  */
@@ -1189,7 +1194,7 @@ struct ext4_sb_info {
 	loff_t s_bitmap_maxbytes;	/* max bytes for bitmap files */
 	struct buffer_head * s_sbh;	/* Buffer containing the super block */
 	struct ext4_super_block *s_es;	/* Pointer to the super block in the buffer */
-	struct buffer_head **s_group_desc;
+	struct ext4_gd_array __rcu *s_group_desc;
 	unsigned int s_mount_opt;
 	unsigned int s_mount_opt2;
 	unsigned int s_mount_flags;
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index bf76f40..4883fad 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -16,6 +16,11 @@
 
 #include "ext4_jbd2.h"
 
+static inline bool resize_is_inprogress(struct super_block *sb)
+{
+	return test_bit(EXT4_RESIZING, &EXT4_SB(sb)->s_resize_flags);
+}
+
 int ext4_resize_begin(struct super_block *sb)
 {
 	int ret = 0;
@@ -479,7 +484,6 @@ static int setup_new_flex_group_blocks(struct super_block *sb,
 
 	reserved_gdb = le16_to_cpu(es->s_reserved_gdt_blocks);
 	meta_bg = EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_META_BG);
-
 	/* This transaction may be extended/restarted along the way */
 	handle = ext4_journal_start_sb(sb, EXT4_HT_RESIZE, EXT4_MAX_TRANS_DATA);
 	if (IS_ERR(handle))
@@ -489,9 +493,12 @@ static int setup_new_flex_group_blocks(struct super_block *sb,
 	for (i = 0; i < flex_gd->count; i++, group++) {
 		unsigned long gdblocks;
 		ext4_grpblk_t overhead;
+		struct ext4_gd_array *gd_arr;
 
 		gdblocks = ext4_bg_num_gdb(sb, group);
 		start = ext4_group_first_block_no(sb, group);
+		gd_arr = rcu_dereference_protected(sbi->s_group_desc,
+						   resize_is_inprogress(sb));
 
 		if (meta_bg == 0 && !ext4_bg_has_super(sb, group))
 			goto handle_itb;
@@ -526,8 +533,7 @@ static int setup_new_flex_group_blocks(struct super_block *sb,
 				brelse(gdb);
 				goto out;
 			}
-			memcpy(gdb->b_data, sbi->s_group_desc[j]->b_data,
-			       gdb->b_size);
+			memcpy(gdb->b_data, gd_arr->bh[j]->b_data, gdb->b_size);
 			set_buffer_uptodate(gdb);
 
 			err = ext4_handle_dirty_metadata(handle, NULL, gdb);
@@ -725,6 +731,14 @@ static int verify_reserved_gdb(struct super_block *sb,
 	return gdbackups;
 }
 
+static void group_desc_callback(struct rcu_head *head)
+{
+	struct ext4_gd_array *gd_ar;
+
+	gd_ar = container_of(head, struct ext4_gd_array, rcu);
+	kvfree(gd_ar);
+}
+
 /*
  * Called when we need to bring a reserved group descriptor table block into
  * use from the resize inode.  The primary copy of the new GDT block currently
@@ -742,10 +756,11 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 		       ext4_group_t group)
 {
 	struct super_block *sb = inode->i_sb;
-	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_super_block *es = sbi->s_es;
 	unsigned long gdb_num = group / EXT4_DESC_PER_BLOCK(sb);
-	ext4_fsblk_t gdblock = EXT4_SB(sb)->s_sbh->b_blocknr + 1 + gdb_num;
-	struct buffer_head **o_group_desc, **n_group_desc;
+	ext4_fsblk_t gdblock = sbi->s_sbh->b_blocknr + 1 + gdb_num;
+	struct ext4_gd_array *o_group_desc, *n_group_desc;
 	struct buffer_head *dind;
 	struct buffer_head *gdb_bh;
 	int gdbackups;
@@ -763,10 +778,9 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
          * because the user tools have no way of handling this.  Probably a
          * bad time to do it anyways.
          */
-	if (EXT4_SB(sb)->s_sbh->b_blocknr !=
-	    le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block)) {
+	if (sbi->s_sbh->b_blocknr != le32_to_cpu(es->s_first_data_block)) {
 		ext4_warning(sb, "won't resize using backup superblock at %llu",
-			(unsigned long long)EXT4_SB(sb)->s_sbh->b_blocknr);
+			(unsigned long long)sbi->s_sbh->b_blocknr);
 		return -EPERM;
 	}
 
@@ -795,8 +809,8 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 		goto exit_dind;
 	}
 
-	BUFFER_TRACE(EXT4_SB(sb)->s_sbh, "get_write_access");
-	err = ext4_journal_get_write_access(handle, EXT4_SB(sb)->s_sbh);
+	BUFFER_TRACE(sbi->s_sbh, "get_write_access");
+	err = ext4_journal_get_write_access(handle, sbi->s_sbh);
 	if (unlikely(err))
 		goto exit_dind;
 
@@ -815,7 +829,8 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 	if (unlikely(err))
 		goto exit_dind;
 
-	n_group_desc = ext4_kvmalloc((gdb_num + 1) *
+	n_group_desc = ext4_kvmalloc(sizeof(struct ext4_gd_array) +
+				     (gdb_num + 1) *
 				     sizeof(struct buffer_head *),
 				     GFP_NOFS);
 	if (!n_group_desc) {
@@ -850,14 +865,14 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 	}
 	brelse(dind);
 
-	o_group_desc = EXT4_SB(sb)->s_group_desc;
-	memcpy(n_group_desc, o_group_desc,
-	       EXT4_SB(sb)->s_gdb_count * sizeof(struct buffer_head *));
-	n_group_desc[gdb_num] = gdb_bh;
-	EXT4_SB(sb)->s_group_desc = n_group_desc;
-	EXT4_SB(sb)->s_gdb_count++;
-	kvfree(o_group_desc);
-
+	o_group_desc = rcu_dereference_protected(sbi->s_group_desc,
+						 resize_is_inprogress(sb));
+	memcpy(n_group_desc->bh, o_group_desc->bh,
+	       sbi->s_gdb_count * sizeof(struct buffer_head *));
+	n_group_desc->bh[gdb_num] = gdb_bh;
+	rcu_assign_pointer(sbi->s_group_desc, n_group_desc);
+	sbi->s_gdb_count++;
+	call_rcu(&o_group_desc->rcu, group_desc_callback);
 	le16_add_cpu(&es->s_reserved_gdt_blocks, -1);
 	err = ext4_handle_dirty_super(handle, sb);
 	if (err)
@@ -884,7 +899,7 @@ static int add_new_gdb_meta_bg(struct super_block *sb,
 			       handle_t *handle, ext4_group_t group) {
 	ext4_fsblk_t gdblock;
 	struct buffer_head *gdb_bh;
-	struct buffer_head **o_group_desc, **n_group_desc;
+	struct ext4_gd_array *o_group_desc, *n_group_desc;
 	unsigned long gdb_num = group / EXT4_DESC_PER_BLOCK(sb);
 	int err;
 
@@ -893,7 +908,8 @@ static int add_new_gdb_meta_bg(struct super_block *sb,
 	gdb_bh = sb_bread(sb, gdblock);
 	if (!gdb_bh)
 		return -EIO;
-	n_group_desc = ext4_kvmalloc((gdb_num + 1) *
+	n_group_desc = ext4_kvmalloc(sizeof(struct ext4_group_desc) +
+				     (gdb_num + 1) *
 				     sizeof(struct buffer_head *),
 				     GFP_NOFS);
 	if (!n_group_desc) {
@@ -903,13 +919,15 @@ static int add_new_gdb_meta_bg(struct super_block *sb,
 		return err;
 	}
 
-	o_group_desc = EXT4_SB(sb)->s_group_desc;
-	memcpy(n_group_desc, o_group_desc,
+	o_group_desc = rcu_dereference_protected(EXT4_SB(sb)->s_group_desc,
+						 resize_is_inprogress(sb));
+	memcpy(n_group_desc->bh, o_group_desc->bh,
 	       EXT4_SB(sb)->s_gdb_count * sizeof(struct buffer_head *));
-	n_group_desc[gdb_num] = gdb_bh;
-	EXT4_SB(sb)->s_group_desc = n_group_desc;
+	n_group_desc->bh[gdb_num] = gdb_bh;
+	rcu_assign_pointer(EXT4_SB(sb)->s_group_desc, n_group_desc);
 	EXT4_SB(sb)->s_gdb_count++;
-	kvfree(o_group_desc);
+	call_rcu(&o_group_desc->rcu, group_desc_callback);
+
 	BUFFER_TRACE(gdb_bh, "get_write_access");
 	err = ext4_journal_get_write_access(handle, gdb_bh);
 	if (unlikely(err))
@@ -1160,12 +1178,14 @@ static int ext4_add_new_descs(handle_t *handle, struct super_block *sb,
 
 	meta_bg = EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_META_BG);
 	for (i = 0; i < count; i++, group++) {
+		struct ext4_gd_array *gd_arr;
 		int reserved_gdb = ext4_bg_has_super(sb, group) ?
 			le16_to_cpu(es->s_reserved_gdt_blocks) : 0;
 
 		gdb_off = group % EXT4_DESC_PER_BLOCK(sb);
 		gdb_num = group / EXT4_DESC_PER_BLOCK(sb);
-
+		gd_arr = rcu_dereference_protected(sbi->s_group_desc,
+					   resize_is_inprogress(sb));
 		/*
 		 * We will only either add reserved group blocks to a backup group
 		 * or remove reserved blocks for the first group in a new group block.
@@ -1173,7 +1193,7 @@ static int ext4_add_new_descs(handle_t *handle, struct super_block *sb,
 		 * use non-sparse filesystems anymore.  This is already checked above.
 		 */
 		if (gdb_off) {
-			gdb_bh = sbi->s_group_desc[gdb_num];
+			gdb_bh = gd_arr->bh[gdb_num];
 			BUFFER_TRACE(gdb_bh, "get_write_access");
 			err = ext4_journal_get_write_access(handle, gdb_bh);
 
@@ -1240,12 +1260,14 @@ static int ext4_setup_new_descs(handle_t *handle, struct super_block *sb,
 	struct ext4_new_group_data	*group_data = flex_gd->groups;
 	struct ext4_group_desc		*gdp;
 	struct ext4_sb_info		*sbi = EXT4_SB(sb);
+	struct ext4_gd_array		*gd_arr;
 	struct buffer_head		*gdb_bh;
 	ext4_group_t			group;
 	__u16				*bg_flags = flex_gd->bg_flags;
 	int				i, gdb_off, gdb_num, err = 0;
-	
 
+	gd_arr = rcu_dereference_protected(sbi->s_group_desc,
+					   resize_is_inprogress(sb));
 	for (i = 0; i < flex_gd->count; i++, group_data++, bg_flags++) {
 		group = group_data->group;
 
@@ -1255,7 +1277,7 @@ static int ext4_setup_new_descs(handle_t *handle, struct super_block *sb,
 		/*
 		 * get_write_access() has been called on gdb_bh by ext4_add_new_desc().
 		 */
-		gdb_bh = sbi->s_group_desc[gdb_num];
+		gdb_bh = gd_arr->bh[gdb_num];
 		/* Update group descriptor block for new group */
 		gdp = (struct ext4_group_desc *)(gdb_bh->b_data +
 						 gdb_off * EXT4_DESC_SIZE(sb));
@@ -1476,13 +1498,16 @@ exit_journal:
 		int meta_bg = EXT4_HAS_INCOMPAT_FEATURE(sb,
 				EXT4_FEATURE_INCOMPAT_META_BG);
 		sector_t old_gdb = 0;
+		struct ext4_gd_array *gd;
 
+		gd = rcu_dereference_protected(sbi->s_group_desc,
+					       resize_is_inprogress(sb));
 		update_backups(sb, sbi->s_sbh->b_blocknr, (char *)es,
 			       sizeof(struct ext4_super_block), 0);
 		for (; gdb_num <= gdb_num_end; gdb_num++) {
 			struct buffer_head *gdb_bh;
 
-			gdb_bh = sbi->s_group_desc[gdb_num];
+			gdb_bh = gd->bh[gdb_num];
 			if (old_gdb == gdb_bh->b_blocknr)
 				continue;
 			update_backups(sb, gdb_bh->b_blocknr, gdb_bh->b_data,
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4fca81c..8633d5d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -801,8 +801,8 @@ static void ext4_put_super(struct super_block *sb)
 	kobject_del(&sbi->s_kobj);
 
 	for (i = 0; i < sbi->s_gdb_count; i++)
-		brelse(sbi->s_group_desc[i]);
-	kvfree(sbi->s_group_desc);
+		brelse(rcu_dereference_protected(sbi->s_group_desc, 1)->bh[i]);
+	kvfree(rcu_dereference_protected(sbi->s_group_desc, 1));
 	kvfree(sbi->s_flex_groups);
 	percpu_counter_destroy(&sbi->s_freeclusters_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
@@ -3414,6 +3414,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	int err = 0;
 	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
 	ext4_group_t first_not_zeroed;
+	struct buffer_head **gdb_bh;
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
@@ -3871,10 +3872,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			(EXT4_MAX_BLOCK_FILE_PHYS / EXT4_BLOCKS_PER_GROUP(sb)));
 	db_count = (sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb) - 1) /
 		   EXT4_DESC_PER_BLOCK(sb);
-	sbi->s_group_desc = ext4_kvmalloc(db_count *
-					  sizeof(struct buffer_head *),
-					  GFP_KERNEL);
-	if (sbi->s_group_desc == NULL) {
+	RCU_INIT_POINTER(sbi->s_group_desc,
+			 ext4_kvmalloc(sizeof(struct ext4_gd_array) +
+				       db_count * sizeof(struct buffer_head *),
+				       GFP_KERNEL));
+	if (rcu_access_pointer(sbi->s_group_desc) == NULL) {
 		ext4_msg(sb, KERN_ERR, "not enough memory");
 		ret = -ENOMEM;
 		goto failed_mount;
@@ -3889,15 +3891,18 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 
 	bgl_lock_init(sbi->s_blockgroup_lock);
 
+	gdb_bh = rcu_dereference_protected(sbi->s_group_desc, 1)->bh;
 	for (i = 0; i < db_count; i++) {
+		struct buffer_head *bh;
 		block = descriptor_loc(sb, logical_sb_block, i);
-		sbi->s_group_desc[i] = sb_bread_unmovable(sb, block);
-		if (!sbi->s_group_desc[i]) {
+		bh = sb_bread_unmovable(sb, block);
+		if (!bh) {
 			ext4_msg(sb, KERN_ERR,
 			       "can't read group descriptor %d", i);
 			db_count = i;
 			goto failed_mount2;
 		}
+		gdb_bh[i] = bh;
 	}
 	if (!ext4_check_descriptors(sb, &first_not_zeroed)) {
 		ext4_msg(sb, KERN_ERR, "group descriptors corrupted!");
@@ -4251,8 +4256,8 @@ failed_mount3:
 		kthread_stop(sbi->s_mmp_tsk);
 failed_mount2:
 	for (i = 0; i < db_count; i++)
-		brelse(sbi->s_group_desc[i]);
-	kvfree(sbi->s_group_desc);
+		brelse(gdb_bh[i]);
+	kvfree(rcu_dereference_protected(sbi->s_group_desc, 1));
 failed_mount:
 	if (sbi->s_chksum_driver)
 		crypto_free_shash(sbi->s_chksum_driver);
-- 
1.7.1

