From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 31/52] ext4: fix online resize with mballoc
Date: Sat,  5 Jul 2008 13:35:57 -0400
Message-ID: <1215279378-30504-32-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
 <1215279378-30504-6-git-send-email-tytso@mit.edu>
 <1215279378-30504-7-git-send-email-tytso@mit.edu>
 <1215279378-30504-8-git-send-email-tytso@mit.edu>
 <1215279378-30504-9-git-send-email-tytso@mit.edu>
 <1215279378-30504-10-git-send-email-tytso@mit.edu>
 <1215279378-30504-11-git-send-email-tytso@mit.edu>
 <1215279378-30504-12-git-send-email-tytso@mit.edu>
 <1215279378-30504-13-git-send-email-tytso@mit.edu>
 <1215279378-30504-14-git-send-email-tytso@mit.edu>
 <1215279378-30504-15-git-send-email-tytso@mit.edu>
 <1215279378-30504-16-git-send-email-tytso@mit.edu>
 <1215279378-30504-17-git-send-email-tytso@mit.edu>
 <1215279378-30504-18-git-send-email-tytso@mit.edu>
 <1215279378-30504-19-git-send-email-tytso@mit.edu>
 <1215279378-30504-20-git-send-email-tytso@mit.edu>
 <1215279378-30504-21-git-send-email-tytso@mit.edu>
 <1215279378-30504-22-git-send-email-tytso@mit.edu>
 <1215279378-30504-23-git-send-email-tytso@mit.edu>
 <1215279378-30504-24-git-send-email-tytso@mit.edu>
 <1215279378-30504-25-git-send-email-tytso@mit.edu>
 <1215279378-30504-26-git-send-email-tytso@mit.edu>
 <1215279378-30504-27-git-send-email-tytso@mit.edu>
 <1215279378-30504-28-git-send-email-tytso@mit.edu>
 <1215279378-30504-29-git-send-email-tytso@mit.edu>
 <1215279378-30504-30-git-send-email-tytso@mit.edu>
 <1215279378-30504-31-git-send-email-tytso@mit.edu>
Cc: Frederic Bohe <frederic.bohe@bull.net>,
	Mingming Cao <cmm@us.ibm.com>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33046 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753178AbYGERga (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jul 2008 13:36:30 -0400
In-Reply-To: <1215279378-30504-31-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Frederic Bohe <frederic.bohe@bull.net>

Update group infos when updating a group's descriptor.
Add group infos when adding a group's descriptor.
Refresh cache pages used by mb_alloc when changes occur.
This will probably need modifications when META_BG resizing will be allowed.

Signed-off-by: Frederic Bohe <frederic.bohe@bull.net>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/ext4.h    |    4 +
 fs/ext4/mballoc.c |  234 ++++++++++++++++++++++++++++++++++++++++-------------
 fs/ext4/resize.c  |   52 ++++++++++++-
 3 files changed, 234 insertions(+), 56 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 37ce906..b8b0ae7 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1033,6 +1033,10 @@ extern int __init init_ext4_mballoc(void);
 extern void exit_ext4_mballoc(void);
 extern void ext4_mb_free_blocks(handle_t *, struct inode *,
 		unsigned long, unsigned long, int, unsigned long *);
+extern int ext4_mb_add_more_groupinfo(struct super_block *sb,
+		ext4_group_t i, struct ext4_group_desc *desc);
+extern void ext4_mb_update_group_info(struct ext4_group_info *grp,
+		ext4_grpblk_t add);
 
 
 /* inode.c */
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 9ffad23..a1349b3 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2231,21 +2231,192 @@ ext4_mb_store_history(struct ext4_allocation_context *ac)
 #define ext4_mb_history_init(sb)
 #endif
 
+
+/* Create and initialize ext4_group_info data for the given group. */
+int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
+			  struct ext4_group_desc *desc)
+{
+	int i, len;
+	int metalen = 0;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_group_info **meta_group_info;
+
+	/*
+	 * First check if this group is the first of a reserved block.
+	 * If it's true, we have to allocate a new table of pointers
+	 * to ext4_group_info structures
+	 */
+	if (group % EXT4_DESC_PER_BLOCK(sb) == 0) {
+		metalen = sizeof(*meta_group_info) <<
+			EXT4_DESC_PER_BLOCK_BITS(sb);
+		meta_group_info = kmalloc(metalen, GFP_KERNEL);
+		if (meta_group_info == NULL) {
+			printk(KERN_ERR "EXT4-fs: can't allocate mem for a "
+			       "buddy group\n");
+			goto exit_meta_group_info;
+		}
+		sbi->s_group_info[group >> EXT4_DESC_PER_BLOCK_BITS(sb)] =
+			meta_group_info;
+	}
+
+	/*
+	 * calculate needed size. if change bb_counters size,
+	 * don't forget about ext4_mb_generate_buddy()
+	 */
+	len = offsetof(typeof(**meta_group_info),
+		       bb_counters[sb->s_blocksize_bits + 2]);
+
+	meta_group_info =
+		sbi->s_group_info[group >> EXT4_DESC_PER_BLOCK_BITS(sb)];
+	i = group & (EXT4_DESC_PER_BLOCK(sb) - 1);
+
+	meta_group_info[i] = kzalloc(len, GFP_KERNEL);
+	if (meta_group_info[i] == NULL) {
+		printk(KERN_ERR "EXT4-fs: can't allocate buddy mem\n");
+		goto exit_group_info;
+	}
+	set_bit(EXT4_GROUP_INFO_NEED_INIT_BIT,
+		&(meta_group_info[i]->bb_state));
+
+	/*
+	 * initialize bb_free to be able to skip
+	 * empty groups without initialization
+	 */
+	if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
+		meta_group_info[i]->bb_free =
+			ext4_free_blocks_after_init(sb, group, desc);
+	} else {
+		meta_group_info[i]->bb_free =
+			le16_to_cpu(desc->bg_free_blocks_count);
+	}
+
+	INIT_LIST_HEAD(&meta_group_info[i]->bb_prealloc_list);
+
+#ifdef DOUBLE_CHECK
+	{
+		struct buffer_head *bh;
+		meta_group_info[i]->bb_bitmap =
+			kmalloc(sb->s_blocksize, GFP_KERNEL);
+		BUG_ON(meta_group_info[i]->bb_bitmap == NULL);
+		bh = ext4_read_block_bitmap(sb, group);
+		BUG_ON(bh == NULL);
+		memcpy(meta_group_info[i]->bb_bitmap, bh->b_data,
+			sb->s_blocksize);
+		put_bh(bh);
+	}
+#endif
+
+	return 0;
+
+exit_group_info:
+	/* If a meta_group_info table has been allocated, release it now */
+	if (group % EXT4_DESC_PER_BLOCK(sb) == 0)
+		kfree(sbi->s_group_info[group >> EXT4_DESC_PER_BLOCK_BITS(sb)]);
+exit_meta_group_info:
+	return -ENOMEM;
+} /* ext4_mb_add_groupinfo */
+
+/*
+ * Add a group to the existing groups.
+ * This function is used for online resize
+ */
+int ext4_mb_add_more_groupinfo(struct super_block *sb, ext4_group_t group,
+			       struct ext4_group_desc *desc)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct inode *inode = sbi->s_buddy_cache;
+	int blocks_per_page;
+	int block;
+	int pnum;
+	struct page *page;
+	int err;
+
+	/* Add group based on group descriptor*/
+	err = ext4_mb_add_groupinfo(sb, group, desc);
+	if (err)
+		return err;
+
+	/*
+	 * Cache pages containing dynamic mb_alloc datas (buddy and bitmap
+	 * datas) are set not up to date so that they will be re-initilaized
+	 * during the next call to ext4_mb_load_buddy
+	 */
+
+	/* Set buddy page as not up to date */
+	blocks_per_page = PAGE_CACHE_SIZE / sb->s_blocksize;
+	block = group * 2;
+	pnum = block / blocks_per_page;
+	page = find_get_page(inode->i_mapping, pnum);
+	if (page != NULL) {
+		ClearPageUptodate(page);
+		page_cache_release(page);
+	}
+
+	/* Set bitmap page as not up to date */
+	block++;
+	pnum = block / blocks_per_page;
+	page = find_get_page(inode->i_mapping, pnum);
+	if (page != NULL) {
+		ClearPageUptodate(page);
+		page_cache_release(page);
+	}
+
+	return 0;
+}
+
+/*
+ * Update an existing group.
+ * This function is used for online resize
+ */
+void ext4_mb_update_group_info(struct ext4_group_info *grp, ext4_grpblk_t add)
+{
+	grp->bb_free += add;
+}
+
 static int ext4_mb_init_backend(struct super_block *sb)
 {
 	ext4_group_t i;
-	int j, len, metalen;
+	int metalen;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	int num_meta_group_infos =
-		(sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb) - 1) >>
-			EXT4_DESC_PER_BLOCK_BITS(sb);
+	struct ext4_super_block *es = sbi->s_es;
+	int num_meta_group_infos;
+	int num_meta_group_infos_max;
+	int array_size;
 	struct ext4_group_info **meta_group_info;
+	struct ext4_group_desc *desc;
+
+	/* This is the number of blocks used by GDT */
+	num_meta_group_infos = (sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb) -
+				1) >> EXT4_DESC_PER_BLOCK_BITS(sb);
 
+	/*
+	 * This is the total number of blocks used by GDT including
+	 * the number of reserved blocks for GDT.
+	 * The s_group_info array is allocated with this value
+	 * to allow a clean online resize without a complex
+	 * manipulation of pointer.
+	 * The drawback is the unused memory when no resize
+	 * occurs but it's very low in terms of pages
+	 * (see comments below)
+	 * Need to handle this properly when META_BG resizing is allowed
+	 */
+	num_meta_group_infos_max = num_meta_group_infos +
+				le16_to_cpu(es->s_reserved_gdt_blocks);
+
+	/*
+	 * array_size is the size of s_group_info array. We round it
+	 * to the next power of two because this approximation is done
+	 * internally by kmalloc so we can have some more memory
+	 * for free here (e.g. may be used for META_BG resize).
+	 */
+	array_size = 1;
+	while (array_size < sizeof(*sbi->s_group_info) *
+	       num_meta_group_infos_max)
+		array_size = array_size << 1;
 	/* An 8TB filesystem with 64-bit pointers requires a 4096 byte
 	 * kmalloc. A 128kb malloc should suffice for a 256TB filesystem.
 	 * So a two level scheme suffices for now. */
-	sbi->s_group_info = kmalloc(sizeof(*sbi->s_group_info) *
-				    num_meta_group_infos, GFP_KERNEL);
+	sbi->s_group_info = kmalloc(array_size, GFP_KERNEL);
 	if (sbi->s_group_info == NULL) {
 		printk(KERN_ERR "EXT4-fs: can't allocate buddy meta group\n");
 		return -ENOMEM;
@@ -2272,62 +2443,15 @@ static int ext4_mb_init_backend(struct super_block *sb)
 		sbi->s_group_info[i] = meta_group_info;
 	}
 
-	/*
-	 * calculate needed size. if change bb_counters size,
-	 * don't forget about ext4_mb_generate_buddy()
-	 */
-	len = sizeof(struct ext4_group_info);
-	len += sizeof(unsigned short) * (sb->s_blocksize_bits + 2);
 	for (i = 0; i < sbi->s_groups_count; i++) {
-		struct ext4_group_desc *desc;
-
-		meta_group_info =
-			sbi->s_group_info[i >> EXT4_DESC_PER_BLOCK_BITS(sb)];
-		j = i & (EXT4_DESC_PER_BLOCK(sb) - 1);
-
-		meta_group_info[j] = kzalloc(len, GFP_KERNEL);
-		if (meta_group_info[j] == NULL) {
-			printk(KERN_ERR "EXT4-fs: can't allocate buddy mem\n");
-			goto err_freebuddy;
-		}
 		desc = ext4_get_group_desc(sb, i, NULL);
 		if (desc == NULL) {
 			printk(KERN_ERR
 				"EXT4-fs: can't read descriptor %lu\n", i);
-			i++;
 			goto err_freebuddy;
 		}
-		set_bit(EXT4_GROUP_INFO_NEED_INIT_BIT,
-			&(meta_group_info[j]->bb_state));
-
-		/*
-		 * initialize bb_free to be able to skip
-		 * empty groups without initialization
-		 */
-		if (desc->bg_flags & cpu_to_le16(EXT4_BG_BLOCK_UNINIT)) {
-			meta_group_info[j]->bb_free =
-				ext4_free_blocks_after_init(sb, i, desc);
-		} else {
-			meta_group_info[j]->bb_free =
-				le16_to_cpu(desc->bg_free_blocks_count);
-		}
-
-		INIT_LIST_HEAD(&meta_group_info[j]->bb_prealloc_list);
-
-#ifdef DOUBLE_CHECK
-		{
-			struct buffer_head *bh;
-			meta_group_info[j]->bb_bitmap =
-				kmalloc(sb->s_blocksize, GFP_KERNEL);
-			BUG_ON(meta_group_info[j]->bb_bitmap == NULL);
-			bh = ext4_read_block_bitmap(sb, i);
-			BUG_ON(bh == NULL);
-			memcpy(meta_group_info[j]->bb_bitmap, bh->b_data,
-					sb->s_blocksize);
-			put_bh(bh);
-		}
-#endif
-
+		if (ext4_mb_add_groupinfo(sb, i, desc) != 0)
+			goto err_freebuddy;
 	}
 
 	return 0;
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 9ff7b1c..f000fbe 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -866,6 +866,15 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, input->group, gdp);
 
 	/*
+	 * We can allocate memory for mb_alloc based on the new group
+	 * descriptor
+	 */
+	if (test_opt(sb, MBALLOC)) {
+		err = ext4_mb_add_more_groupinfo(sb, input->group, gdp);
+		if (err)
+			goto exit_journal;
+	}
+	/*
 	 * Make the new blocks and inodes valid next.  We do this before
 	 * increasing the group count so that once the group is enabled,
 	 * all of its blocks and inodes are already valid.
@@ -957,6 +966,8 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
 	handle_t *handle;
 	int err;
 	unsigned long freed_blocks;
+	ext4_group_t group;
+	struct ext4_group_info *grp;
 
 	/* We don't need to worry about locking wrt other resizers just
 	 * yet: we're going to revalidate es->s_blocks_count after
@@ -988,7 +999,7 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
 	}
 
 	/* Handle the remaining blocks in the last group only. */
-	ext4_get_group_no_and_offset(sb, o_blocks_count, NULL, &last);
+	ext4_get_group_no_and_offset(sb, o_blocks_count, &group, &last);
 
 	if (last == 0) {
 		ext4_warning(sb, __func__,
@@ -1060,6 +1071,45 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
 		   o_blocks_count + add);
 	if ((err = ext4_journal_stop(handle)))
 		goto exit_put;
+
+	/*
+	 * Mark mballoc pages as not up to date so that they will be updated
+	 * next time they are loaded by ext4_mb_load_buddy.
+	 */
+	if (test_opt(sb, MBALLOC)) {
+		struct ext4_sb_info *sbi = EXT4_SB(sb);
+		struct inode *inode = sbi->s_buddy_cache;
+		int blocks_per_page;
+		int block;
+		int pnum;
+		struct page *page;
+
+		/* Set buddy page as not up to date */
+		blocks_per_page = PAGE_CACHE_SIZE / sb->s_blocksize;
+		block = group * 2;
+		pnum = block / blocks_per_page;
+		page = find_get_page(inode->i_mapping, pnum);
+		if (page != NULL) {
+			ClearPageUptodate(page);
+			page_cache_release(page);
+		}
+
+		/* Set bitmap page as not up to date */
+		block++;
+		pnum = block / blocks_per_page;
+		page = find_get_page(inode->i_mapping, pnum);
+		if (page != NULL) {
+			ClearPageUptodate(page);
+			page_cache_release(page);
+		}
+
+		/* Get the info on the last group */
+		grp = ext4_get_group_info(sb, group);
+
+		/* Update free blocks in group info */
+		ext4_mb_update_group_info(grp, add);
+	}
+
 	if (test_opt(sb, DEBUG))
 		printk(KERN_DEBUG "EXT4-fs: extended group to %llu blocks\n",
 		       ext4_blocks_count(es));
-- 
1.5.6.rc3.1.g36b7.dirty

