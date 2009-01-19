From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Use EXT4_GROUP_INFO_NEED_INIT_BIT during resize
Date: Mon, 19 Jan 2009 17:04:59 +0530
Message-ID: <20090119113459.GE9482@skywalker>
References: <E1LOG9D-0006h4-7R@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:49594 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbZASLfJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Jan 2009 06:35:09 -0500
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28smtp08.in.ibm.com (8.13.1/8.13.1) with ESMTP id n0JBIsdL004136
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 16:48:54 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id n0JBZ9VK3793102
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 17:05:09 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id n0JBZ5Qm026357
	for <linux-ext4@vger.kernel.org>; Mon, 19 Jan 2009 22:35:05 +1100
Content-Disposition: inline
In-Reply-To: <E1LOG9D-0006h4-7R@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Use EXT4_GROUP_INFO_NEED_INIT_BIT during resize

The new groups added during resize are flagged as
need_init group. Make sure we properly initialize these
groups. When we have block size < page size and we are adding
new groups the page may still be marked uptodate even though
we haven't initialized the group. While forcing the init
of buddy cache we need to make sure other groups part of the
same page of buddy cache is not using the cache.
group_info->alloc_sem is added to ensure the same.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>                                                            
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu> 

---
 fs/ext4/balloc.c  |   21 +++--
 fs/ext4/ext4.h    |    7 +-
 fs/ext4/mballoc.c |  259 +++++++++++++++++++++++++++++++++++++++++------------
 fs/ext4/mballoc.h |    3 +
 fs/ext4/resize.c  |   42 ++-------
 5 files changed, 229 insertions(+), 103 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 1b375bb..4235817 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -868,6 +868,7 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 	ext4_debug("Adding block(s) %llu-%llu\n", block, block + count - 1);
 
 	ext4_get_group_no_and_offset(sb, block, &block_group, &bit);
+	grp = ext4_get_group_info(sb, block_group);
 	/*
 	 * Check to see if we are freeing blocks across a group
 	 * boundary.
@@ -912,7 +913,11 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 	err = ext4_journal_get_write_access(handle, gd_bh);
 	if (err)
 		goto error_return;
-
+	/*
+	 * make sure we don't allow a parallel init on other groups in the
+	 * same buddy cache
+	 */
+	down_write(&grp->alloc_sem);
 	for (i = 0, blocks_freed = 0; i < count; i++) {
 		BUFFER_TRACE(bitmap_bh, "clear bit");
 		if (!ext4_clear_bit_atomic(sb_bgl_lock(sbi, block_group),
@@ -937,6 +942,13 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 		sbi->s_flex_groups[flex_group].free_blocks += blocks_freed;
 		spin_unlock(sb_bgl_lock(sbi, flex_group));
 	}
+	/*
+	 * request to reload the buddy with the
+	 * new bitmap information
+	 */
+	set_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &(grp->bb_state));
+	ext4_mb_update_group_info(grp, blocks_freed);
+	up_write(&grp->alloc_sem);
 
 	/* We dirtied the bitmap block */
 	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
@@ -948,13 +960,6 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 	if (!err)
 		err = ret;
 	sb->s_dirt = 1;
-	/*
-	 * request to reload the buddy with the
-	 * new bitmap information
-	 */
-	grp = ext4_get_group_info(sb, block_group);
-	set_bit(EXT4_GROUP_INFO_NEED_INIT_BIT, &(grp->bb_state));
-	ext4_mb_update_group_info(grp, blocks_freed);
 
 error_return:
 	brelse(bitmap_bh);
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 98de963..e605295 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1043,12 +1043,13 @@ extern int __init init_ext4_mballoc(void);
 extern void exit_ext4_mballoc(void);
 extern void ext4_mb_free_blocks(handle_t *, struct inode *,
 		unsigned long, unsigned long, int, unsigned long *);
-extern int ext4_mb_add_more_groupinfo(struct super_block *sb,
+extern int ext4_mb_add_groupinfo(struct super_block *sb,
 		ext4_group_t i, struct ext4_group_desc *desc);
 extern void ext4_mb_update_group_info(struct ext4_group_info *grp,
 		ext4_grpblk_t add);
-
-
+extern int ext4_mb_get_buddy_cache_lock(struct super_block *, ext4_group_t);
+extern void ext4_mb_put_buddy_cache_lock(struct super_block *,
+						ext4_group_t, int);
 /* inode.c */
 int ext4_forget(handle_t *handle, int is_metadata, struct inode *inode,
 		struct buffer_head *bh, ext4_fsblk_t blocknr);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 9cf497c..dd7a092 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -896,18 +896,20 @@ static noinline_for_stack int
 ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
 					struct ext4_buddy *e4b)
 {
-	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	struct inode *inode = sbi->s_buddy_cache;
 	int blocks_per_page;
 	int block;
 	int pnum;
 	int poff;
 	struct page *page;
 	int ret;
+ 	struct ext4_group_info *grp;
+ 	struct ext4_sb_info *sbi = EXT4_SB(sb);
+ 	struct inode *inode = sbi->s_buddy_cache;
 
 	mb_debug("load group %lu\n", group);
 
 	blocks_per_page = PAGE_CACHE_SIZE / sb->s_blocksize;
+	grp = ext4_get_group_info(sb, group);
 
 	e4b->bd_blkbits = sb->s_blocksize_bits;
 	e4b->bd_info = ext4_get_group_info(sb, group);
@@ -915,6 +917,15 @@ ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
 	e4b->bd_group = group;
 	e4b->bd_buddy_page = NULL;
 	e4b->bd_bitmap_page = NULL;
+	e4b->alloc_semp = &grp->alloc_sem;
+
+	/* Take the read lock on the group alloc
+	 * sem. This would make sure a parallel
+	 * ext4_mb_init_group happening on other
+	 * groups mapped by the page is blocked
+	 * till we are done with allocation
+	 */
+	down_read(e4b->alloc_semp);
 
 	/*
 	 * the buddy cache inode stores the block bitmap
@@ -930,6 +941,14 @@ ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
 	page = find_get_page(inode->i_mapping, pnum);
 	if (page == NULL || !PageUptodate(page)) {
 		if (page)
+			/*
+			 * drop the page reference and try
+			 * to get the page with lock. If we
+			 * are not uptodate that implies
+			 * somebody just created the page but
+			 * is yet to initialize the same. So
+			 * wait for it to initialize.
+			 */
 			page_cache_release(page);
 		page = find_or_create_page(inode->i_mapping, pnum, GFP_NOFS);
 		if (page) {
@@ -995,6 +1014,9 @@ err:
 		page_cache_release(e4b->bd_buddy_page);
 	e4b->bd_buddy = NULL;
 	e4b->bd_bitmap = NULL;
+
+	/* Done with the buddy cache */
+	up_read(e4b->alloc_semp);
 	return ret;
 }
 
@@ -1004,6 +1026,8 @@ static void ext4_mb_release_desc(struct ext4_buddy *e4b)
 		page_cache_release(e4b->bd_bitmap_page);
 	if (e4b->bd_buddy_page)
 		page_cache_release(e4b->bd_buddy_page);
+	/* Done with the buddy cache */
+	up_read(e4b->alloc_semp);
 }
 
 
@@ -1714,6 +1738,173 @@ static int ext4_mb_good_group(struct ext4_allocation_context *ac,
 	return 0;
 }
 
+/*
+ * lock the group_info alloc_sem of all the groups
+ * belonging to the same buddy cache page. This
+ * make sure other parallel operation on the buddy
+ * cache doesn't happen  whild holding the buddy cache
+ * lock
+ */
+int ext4_mb_get_buddy_cache_lock(struct super_block *sb, ext4_group_t group)
+{
+	int i;
+	int block, pnum;
+	int blocks_per_page;
+	int groups_per_page;
+	ext4_group_t first_group;
+	struct ext4_group_info *grp;
+
+	blocks_per_page = PAGE_CACHE_SIZE / sb->s_blocksize;
+	/*
+	 * the buddy cache inode stores the block bitmap
+	 * and buddy information in consecutive blocks.
+	 * So for each group we need two blocks.
+	 */
+	block = group * 2;
+	pnum = block / blocks_per_page;
+	first_group = pnum * blocks_per_page / 2;
+
+	groups_per_page = blocks_per_page >> 1;
+	if (groups_per_page == 0)
+		groups_per_page = 1;
+	/* read all groups the page covers into the cache */
+	for (i = 0; i < groups_per_page; i++) {
+
+		if ((first_group + i) >= EXT4_SB(sb)->s_groups_count)
+			break;
+		grp = ext4_get_group_info(sb, first_group + i);
+		/* take all groups write allocation
+		 * semaphore. This make sure there is
+		 * no block allocation going on in any
+		 * of that groups
+		 */
+		down_write(&grp->alloc_sem);
+	}
+	return i;
+}
+
+void ext4_mb_put_buddy_cache_lock(struct super_block *sb,
+					ext4_group_t group, int locked_group)
+{
+	int i;
+	int block, pnum;
+	int blocks_per_page;
+	ext4_group_t first_group;
+	struct ext4_group_info *grp;
+
+	blocks_per_page = PAGE_CACHE_SIZE / sb->s_blocksize;
+	/*
+	 * the buddy cache inode stores the block bitmap
+	 * and buddy information in consecutive blocks.
+	 * So for each group we need two blocks.
+	 */
+	block = group * 2;
+	pnum = block / blocks_per_page;
+	first_group = pnum * blocks_per_page / 2;
+	/* release locks on all the groups */
+	for (i = 0; i < locked_group; i++) {
+
+		grp = ext4_get_group_info(sb, first_group + i);
+		/* take all groups write allocation
+		 * semaphore. This make sure there is
+		 * no block allocation going on in any
+		 * of that groups
+		 */
+		up_write(&grp->alloc_sem);
+	}
+
+}
+
+static int ext4_mb_init_group(struct super_block *sb, ext4_group_t group)
+{
+
+	int ret;
+	void *bitmap;
+	int blocks_per_page;
+	int block, pnum, poff;
+	int num_grp_locked = 0;
+	struct ext4_group_info *this_grp;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct inode *inode = sbi->s_buddy_cache;
+	struct page *page = NULL, *bitmap_page = NULL;
+
+	mb_debug("init group %lu\n", group);
+	blocks_per_page = PAGE_CACHE_SIZE / sb->s_blocksize;
+	this_grp = ext4_get_group_info(sb, group);
+	/*
+	 * This ensures we don't add group
+	 * to this buddy cache via resize
+	 */
+	num_grp_locked =  ext4_mb_get_buddy_cache_lock(sb, group);
+	if (!EXT4_MB_GRP_NEED_INIT(this_grp)) {
+		/*
+		 * somebody initialized the group
+		 * return without doing anything
+		 */
+		ret = 0;
+		goto err;
+	}
+	/*
+	 * the buddy cache inode stores the block bitmap
+	 * and buddy information in consecutive blocks.
+	 * So for each group we need two blocks.
+	 */
+	block = group * 2;
+	pnum = block / blocks_per_page;
+	poff = block % blocks_per_page;
+	page = find_or_create_page(inode->i_mapping, pnum, GFP_NOFS);
+	if (page) {
+		BUG_ON(page->mapping != inode->i_mapping);
+		ret = ext4_mb_init_cache(page, NULL);
+		if (ret) {
+			unlock_page(page);
+			goto err;
+		}
+		unlock_page(page);
+	}
+	if (page == NULL || !PageUptodate(page)) {
+		ret = -EIO;
+		goto err;
+	}
+	mark_page_accessed(page);
+	bitmap_page = page;
+	bitmap = page_address(page) + (poff * sb->s_blocksize);
+
+	/* init buddy cache */
+	block++;
+	pnum = block / blocks_per_page;
+	poff = block % blocks_per_page;
+	page = find_or_create_page(inode->i_mapping, pnum, GFP_NOFS);
+	if (page == bitmap_page) {
+		/*
+		 * If both the bitmap and buddy are in
+		 * the same page we don't need to force
+		 * init the buddy
+		 */
+		unlock_page(page);
+	} else if (page) {
+		BUG_ON(page->mapping != inode->i_mapping);
+		ret = ext4_mb_init_cache(page, bitmap);
+		if (ret) {
+			unlock_page(page);
+			goto err;
+		}
+		unlock_page(page);
+	}
+	if (page == NULL || !PageUptodate(page)) {
+		ret = -EIO;
+		goto err;
+	}
+	mark_page_accessed(page);
+err:
+	ext4_mb_put_buddy_cache_lock(sb, group, num_grp_locked);
+	if (bitmap_page)
+		page_cache_release(bitmap_page);
+	if (page)
+		page_cache_release(page);
+	return ret;
+}
+
 static noinline_for_stack int
 ext4_mb_regular_allocator(struct ext4_allocation_context *ac)
 {
@@ -1797,7 +1988,7 @@ repeat:
 				group = 0;
 
 			/* quick check to skip empty groups */
-			grp = ext4_get_group_info(ac->ac_sb, group);
+			grp = ext4_get_group_info(sb, group);
 			if (grp->bb_free == 0)
 				continue;
 
@@ -1810,10 +2001,9 @@ repeat:
 				 * we need full data about the group
 				 * to make a good selection
 				 */
-				err = ext4_mb_load_buddy(sb, group, &e4b);
+				err = ext4_mb_init_group(sb, group);
 				if (err)
 					goto out;
-				ext4_mb_release_desc(&e4b);
 			}
 
 			/*
@@ -2321,6 +2511,7 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 	}
 
 	INIT_LIST_HEAD(&meta_group_info[i]->bb_prealloc_list);
+	init_rwsem(&meta_group_info[i]->alloc_sem);
 
 #ifdef DOUBLE_CHECK
 	{
@@ -2347,54 +2538,6 @@ exit_meta_group_info:
 } /* ext4_mb_add_groupinfo */
 
 /*
- * Add a group to the existing groups.
- * This function is used for online resize
- */
-int ext4_mb_add_more_groupinfo(struct super_block *sb, ext4_group_t group,
-			       struct ext4_group_desc *desc)
-{
-	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	struct inode *inode = sbi->s_buddy_cache;
-	int blocks_per_page;
-	int block;
-	int pnum;
-	struct page *page;
-	int err;
-
-	/* Add group based on group descriptor*/
-	err = ext4_mb_add_groupinfo(sb, group, desc);
-	if (err)
-		return err;
-
-	/*
-	 * Cache pages containing dynamic mb_alloc datas (buddy and bitmap
-	 * datas) are set not up to date so that they will be re-initilaized
-	 * during the next call to ext4_mb_load_buddy
-	 */
-
-	/* Set buddy page as not up to date */
-	blocks_per_page = PAGE_CACHE_SIZE / sb->s_blocksize;
-	block = group * 2;
-	pnum = block / blocks_per_page;
-	page = find_get_page(inode->i_mapping, pnum);
-	if (page != NULL) {
-		ClearPageUptodate(page);
-		page_cache_release(page);
-	}
-
-	/* Set bitmap page as not up to date */
-	block++;
-	pnum = block / blocks_per_page;
-	page = find_get_page(inode->i_mapping, pnum);
-	if (page != NULL) {
-		ClearPageUptodate(page);
-		page_cache_release(page);
-	}
-
-	return 0;
-}
-
-/*
  * Update an existing group.
  * This function is used for online resize
  */
@@ -4705,11 +4848,6 @@ do_more:
 	err = ext4_journal_get_write_access(handle, gd_bh);
 	if (err)
 		goto error_return;
-
-	err = ext4_mb_load_buddy(sb, block_group, &e4b);
-	if (err)
-		goto error_return;
-
 #ifdef AGGRESSIVE_CHECK
 	{
 		int i;
@@ -4723,6 +4861,8 @@ do_more:
 	/* We dirtied the bitmap block */
 	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
 	err = ext4_journal_dirty_metadata(handle, bitmap_bh);
+	if (err)
+		goto error_return;
 
 	if (ac) {
 		ac->ac_b_ex.fe_group = block_group;
@@ -4731,6 +4871,9 @@ do_more:
 		ext4_mb_store_history(ac);
 	}
 
+	err = ext4_mb_load_buddy(sb, block_group, &e4b);
+	if (err)
+		goto error_return;
 	if (metadata) {
 		/* blocks being freed are metadata. these blocks shouldn't
 		 * be used until this transaction is committed */
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 850aa8a..9a020e6 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -18,6 +18,7 @@
 #include <linux/pagemap.h>
 #include <linux/seq_file.h>
 #include <linux/version.h>
+#include <linux/mutex.h>
 #include "ext4_jbd2.h"
 #include "ext4.h"
 #include "group.h"
@@ -119,6 +120,7 @@ struct ext4_group_info {
 #ifdef DOUBLE_CHECK
 	void		*bb_bitmap;
 #endif
+	struct rw_semaphore alloc_sem;
 	unsigned short	bb_counters[];
 };
 
@@ -244,6 +246,7 @@ struct ext4_buddy {
 	struct super_block *bd_sb;
 	__u16 bd_blkbits;
 	ext4_group_t bd_group;
+	struct rw_semaphore *alloc_semp;
 };
 #define EXT4_MB_BITMAP(e4b)	((e4b)->bd_bitmap)
 #define EXT4_MB_BUDDY(e4b)	((e4b)->bd_buddy)
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index d7e9761..cfb8e36 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -745,6 +745,7 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 	struct inode *inode = NULL;
 	handle_t *handle;
 	int gdb_off, gdb_num;
+	int num_grp_locked = 0;
 	int err, err2;
 
 	gdb_num = input->group / EXT4_DESC_PER_BLOCK(sb);
@@ -785,6 +786,7 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 		}
 	}
 
+
 	if ((err = verify_group_input(sb, input)))
 		goto exit_put;
 
@@ -853,6 +855,7 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
          * using the new disk blocks.
          */
 
+	num_grp_locked = ext4_mb_get_buddy_cache_lock(sb, input->group);
 	/* Update group descriptor block for new group */
 	gdp = (struct ext4_group_desc *)((char *)primary->b_data +
 					 gdb_off * EXT4_DESC_SIZE(sb));
@@ -869,9 +872,11 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 	 * descriptor
 	 */
 	if (test_opt(sb, MBALLOC)) {
-		err = ext4_mb_add_more_groupinfo(sb, input->group, gdp);
-		if (err)
+		err = ext4_mb_add_groupinfo(sb, input->group, gdp);
+		if (err) {
+			ext4_mb_put_buddy_cache_lock(sb, input->group, num_grp_locked);
 			goto exit_journal;
+		}
 	}
 	/*
 	 * Make the new blocks and inodes valid next.  We do this before
@@ -913,6 +918,7 @@ int ext4_group_add(struct super_block *sb, struct ext4_new_group_data *input)
 
 	/* Update the global fs size fields */
 	sbi->s_groups_count++;
+	ext4_mb_put_buddy_cache_lock(sb, input->group, num_grp_locked);
 
 	ext4_journal_dirty_metadata(handle, primary);
 
@@ -1080,38 +1086,6 @@ int ext4_group_extend(struct super_block *sb, struct ext4_super_block *es,
 	if ((err = ext4_journal_stop(handle)))
 		goto exit_put;
 
-	/*
-	 * Mark mballoc pages as not up to date so that they will be updated
-	 * next time they are loaded by ext4_mb_load_buddy.
-	 */
-	if (test_opt(sb, MBALLOC)) {
-		struct ext4_sb_info *sbi = EXT4_SB(sb);
-		struct inode *inode = sbi->s_buddy_cache;
-		int blocks_per_page;
-		int block;
-		int pnum;
-		struct page *page;
-
-		/* Set buddy page as not up to date */
-		blocks_per_page = PAGE_CACHE_SIZE / sb->s_blocksize;
-		block = group * 2;
-		pnum = block / blocks_per_page;
-		page = find_get_page(inode->i_mapping, pnum);
-		if (page != NULL) {
-			ClearPageUptodate(page);
-			page_cache_release(page);
-		}
-
-		/* Set bitmap page as not up to date */
-		block++;
-		pnum = block / blocks_per_page;
-		page = find_get_page(inode->i_mapping, pnum);
-		if (page != NULL) {
-			ClearPageUptodate(page);
-			page_cache_release(page);
-		}
-	}
