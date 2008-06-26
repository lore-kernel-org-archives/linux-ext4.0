From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Subject: [PATCH] ext4: fix online resize with mballoc
Date: Thu, 26 Jun 2008 16:58:03 +0200
Message-ID: <1214492283.10187.17.camel@localhost>
References: <20080626143704.642665893@bull.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:36681 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbYFZO50 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Jun 2008 10:57:26 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id C282719E012
	for <linux-ext4@vger.kernel.org>; Thu, 26 Jun 2008 16:57:58 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 16924-10 for <linux-ext4@vger.kernel.org>;
 Thu, 26 Jun 2008 16:57:54 +0200 (CEST)
Received: from cyclope.frec.bull.fr (cyclope.frec.bull.fr [129.183.4.9])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 86FC719E005
	for <linux-ext4@vger.kernel.org>; Thu, 26 Jun 2008 16:57:54 +0200 (CEST)
Received: from [129.183.101.236] (dhcp0527.frec.bull.fr [129.183.101.236])
	by cyclope.frec.bull.fr (Postfix) with ESMTP id 5354427289
	for <linux-ext4@vger.kernel.org>; Thu, 26 Jun 2008 16:57:52 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Frederic Bohe <frederic.bohe@bull.net>

Update group infos when updating a group's descriptor.
Add group infos when adding a group's descriptor.
Refresh cache pages used by mb_alloc when changes occur.

Signed-off-by: Frederic Bohe <frederic.bohe@bull.net>
---
This patch apply on top of 2.6.26-rc6 + ext4-patch-queue-37b3e39765d8521ba2252bfec81bb91504fa35c8

It fixes oops when a filesystem is resized online while being mounted with mballoc.
Two oops have been identified:
The first one occurs when unmounting the resized filesystem.
The second one happens when trying to write to a group added during the online resize.

This patch has been tested with:
        - small (100MB) and large (5TB) filesystems.
        - 1K blocks and 4K blocks filesystems.
        - inode size=256 up to 1024.

Tests consist in :
        - online resizing, filling all blocks of the fs, unmounting, fs check
        - filling all blocks of the fs, online resizing, filling newly added groups, unmounting, fs check
        - Concurrent file copy/online resize, unmounting, fs check.

Non regression tests :
        - offline resizing.
        - online resizing without mballoc.

 ext4.h    |    4 +
 mballoc.c |  207 ++++++++++++++++++++++++++++++++++++++++++++++----------------
 resize.c  |   40 +++++++++++
 3 files changed, 199 insertions(+), 52 deletions(-)

Index: linux-2.6.26-rc6.patch_resize/fs/ext4/ext4.h
===================================================================
--- linux-2.6.26-rc6.patch_resize.orig/fs/ext4/ext4.h	2008-06-25 11:08:43.000000000 +0200
+++ linux-2.6.26-rc6.patch_resize/fs/ext4/ext4.h	2008-06-25 11:09:38.000000000 +0200
@@ -1115,6 +1115,10 @@ extern int __init init_ext4_mballoc(void
 extern void exit_ext4_mballoc(void);
 extern void ext4_mb_free_blocks(handle_t *, struct inode *,
 		unsigned long, unsigned long, int, unsigned long *);
+extern int ext4_mb_add_more_groupinfo(struct super_block *sb,
+		ext4_group_t i, struct ext4_group_desc *desc);
+extern void ext4_mb_update_group_info(struct ext4_group_info *grp,
+		ext4_grpblk_t add);
 

 /* inode.c */
Index: linux-2.6.26-rc6.patch_resize/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.26-rc6.patch_resize.orig/fs/ext4/mballoc.c	2008-06-25 11:09:30.000000000 +0200
+++ linux-2.6.26-rc6.patch_resize/fs/ext4/mballoc.c	2008-06-26 14:43:31.000000000 +0200
@@ -2235,21 +2235,176 @@ ext4_mb_store_history(struct ext4_alloca
 #define ext4_mb_history_init(sb)
 #endif
 
+
+/* Create and initialize ext4_group_info data */
+/* for the given group. */
+
+int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
+struct ext4_group_desc *desc)
+{
+	int i, len;
+	int metalen = 0;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_group_info **meta_group_info;
+
+	/* First check if this group is the first of a reserved block.
+	 * If it's true, we have to allocate a new table of pointers
+	 * to ext4_group_info structures
+	 */
+	if (group % EXT4_DESC_PER_BLOCK(sb) == 0) {
+		metalen = sizeof(*meta_group_info)
+			<< EXT4_DESC_PER_BLOCK_BITS(sb);
+		meta_group_info = kmalloc(metalen, GFP_KERNEL);
+		if (meta_group_info == NULL) {
+			printk(KERN_ERR "EXT4-fs: can't allocate mem for a "
+			"buddy group\n");
+			goto exit_meta_group_info;
+		}
+		sbi->s_group_info[group >>
+			EXT4_DESC_PER_BLOCK_BITS(sb)] = meta_group_info;
+	}
+
+	/*
+	 * calculate needed size. if change bb_counters size,
+	 * don't forget about ext4_mb_generate_buddy()
+	 */
+	len = sizeof(struct ext4_group_info);
+	len += sizeof(unsigned short) * (sb->s_blocksize_bits + 2);
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
+		ext4_free_blocks_after_init(sb, group, desc);
+	} else {
+		meta_group_info[i]->bb_free =
+		le16_to_cpu(desc->bg_free_blocks_count);
+	}
+
+	INIT_LIST_HEAD(&meta_group_info[i]->bb_prealloc_list);
+
+#ifdef DOUBLE_CHECK
+	{
+	struct buffer_head *bh;
+	meta_group_info[i]->bb_bitmap =
+		kmalloc(sb->s_blocksize, GFP_KERNEL);
+	BUG_ON(meta_group_info[i]->bb_bitmap == NULL);
+	bh = ext4_read_block_bitmap(sb, group);
+	BUG_ON(bh == NULL);
+	memcpy(meta_group_info[i]->bb_bitmap, bh->b_data,
+		sb->s_blocksize);
+	put_bh(bh);
+	}
+#endif
+
+	return 0;
+exit_group_info:
+	/* If a meta_group_info table has been allocated, release it now */
+	if (group % EXT4_DESC_PER_BLOCK(sb) == 0)
+		kfree(sbi->s_group_info[group >> EXT4_DESC_PER_BLOCK_BITS(sb)]);
+exit_meta_group_info:
+	return -ENOMEM;
+} /* ext4_mb_add_groupinfo */
+
+/* Add a group to the existing groups.
+ * This function is used for online resize
+ */
+int ext4_mb_add_more_groupinfo(struct super_block *sb, ext4_group_t group,
+				struct ext4_group_desc *desc)
+{
+	struct inode *inode = EXT4_SB(sb)->s_buddy_cache;
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
+	/* Cache pages containing dynamic mb_alloc datas (buddy and bitmap
+	* datas) are set not up to date so that they will be re-initilaized
+	* during the next call to ext4_mb_load_buddy
+	*/
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
+/* Update an existing group.
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
 	struct ext4_group_info **meta_group_info;
+	struct ext4_group_desc *desc;
+
+	/* This is the number of blocks used by GDT */
+	num_meta_group_infos = (sbi->s_groups_count + EXT4_DESC_PER_BLOCK(sb) -
+				1) >> EXT4_DESC_PER_BLOCK_BITS(sb);
+
+	/* This is the total number of blocks used by GDT including
+	* the number of reserved blocks for GDT.
+	* The s_group_info array is allocated with this value
+	* to allow a clean online resize without a complex
+	* manipulation of pointer.
+	* The drawback is the unused memory when no resize
+	* occurs but it's very low in terms of pages
+	* (see comments below)
+	*/
+	num_meta_group_infos_max = num_meta_group_infos +
+				le16_to_cpu(es->s_reserved_gdt_blocks);
 
 	/* An 8TB filesystem with 64-bit pointers requires a 4096 byte
 	 * kmalloc. A 128kb malloc should suffice for a 256TB filesystem.
 	 * So a two level scheme suffices for now. */
 	sbi->s_group_info = kmalloc(sizeof(*sbi->s_group_info) *
-				    num_meta_group_infos, GFP_KERNEL);
+				    num_meta_group_infos_max, GFP_KERNEL);
 	if (sbi->s_group_info == NULL) {
 		printk(KERN_ERR "EXT4-fs: can't allocate buddy meta group\n");
 		return -ENOMEM;
@@ -2276,62 +2431,15 @@ static int ext4_mb_init_backend(struct s
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
Index: linux-2.6.26-rc6.patch_resize/fs/ext4/resize.c
===================================================================
--- linux-2.6.26-rc6.patch_resize.orig/fs/ext4/resize.c	2008-06-25 11:08:43.000000000 +0200
+++ linux-2.6.26-rc6.patch_resize/fs/ext4/resize.c	2008-06-26 14:44:32.000000000 +0200
@@ -865,6 +865,13 @@ int ext4_group_add(struct super_block *s
 	gdp->bg_free_inodes_count = cpu_to_le16(EXT4_INODES_PER_GROUP(sb));
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, input->group, gdp);
 
+	/* We can allocate memory for mb_alloc based on the new group
+	 * descriptor */
+	if (test_opt(sb, MBALLOC)) {
+		err = ext4_mb_add_more_groupinfo(sb, input->group, gdp);
+		if (err)
+			goto exit_journal;
+	}
 	/*
 	 * Make the new blocks and inodes valid next.  We do this before
 	 * increasing the group count so that once the group is enabled,
@@ -957,6 +964,8 @@ int ext4_group_extend(struct super_block
 	handle_t *handle;
 	int err;
 	unsigned long freed_blocks;
+	ext4_group_t group;
+	struct ext4_group_info *grp;
 
 	/* We don't need to worry about locking wrt other resizers just
 	 * yet: we're going to revalidate es->s_blocks_count after
@@ -988,7 +997,7 @@ int ext4_group_extend(struct super_block
 	}
 
 	/* Handle the remaining blocks in the last group only. */
-	ext4_get_group_no_and_offset(sb, o_blocks_count, NULL, &last);
+	ext4_get_group_no_and_offset(sb, o_blocks_count, &group, &last);
 
 	if (last == 0) {
 		ext4_warning(sb, __func__,
@@ -1060,6 +1069,43 @@ int ext4_group_extend(struct super_block
 		   o_blocks_count + add);
 	if ((err = ext4_journal_stop(handle)))
 		goto exit_put;
+
+	/* Mark mballoc pages as not up to date so that they will be updated
+	 * next time they are loaded by ext4_mb_load_buddy.
+	 */
+	if (test_opt(sb, MBALLOC)) {
+		struct inode *inode = EXT4_SB(sb)->s_buddy_cache;
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

