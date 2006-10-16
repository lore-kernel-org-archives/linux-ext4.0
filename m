From: Eric Sandeen <esandeen@redhat.com>
Subject: [PATCH] remove some unused function arguments in ext2, ext3 and jbd
Date: Mon, 16 Oct 2006 11:23:39 -0500
Message-ID: <4533B20B.1050708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:479 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1422640AbWJPQXn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Oct 2006 12:23:43 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id k9GGNgt9004793
	for <linux-ext4@vger.kernel.org>; Mon, 16 Oct 2006 12:23:42 -0400
Received: from pobox-2.corp.redhat.com (pobox-2.corp.redhat.com [10.11.255.15])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id k9GGNgAp024924
	for <linux-ext4@vger.kernel.org>; Mon, 16 Oct 2006 12:23:42 -0400
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by pobox-2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id k9GGNews026241
	for <linux-ext4@vger.kernel.org>; Mon, 16 Oct 2006 12:23:41 -0400
To: ext4 development <linux-ext4@vger.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Doing some rainy-day cleanup last night :)

I don't think there's any reason to keep these unused function args...

I'm also wondering about:

void
journal_release_buffer(handle_t *handle, struct buffer_head *bh)
{
        BUFFER_TRACE(bh, "entry");
}

why is this function there?

Hrm, guess now I need to look over ext4 as well.

Anyway, here's what I've got:

 fs/ext2/ialloc.c    |   10 +++-------
 fs/ext3/balloc.c    |    6 +++---
 fs/ext3/ialloc.c    |   10 +++-------
 fs/ext3/inode.c     |    5 ++---
 fs/ext3/namei.c     |   10 +++++-----
 fs/ext3/super.c     |    4 ++--
 fs/ext3/xattr.c     |   10 ++++------
 fs/jbd/journal.c    |    2 +-
 include/linux/jbd.h |    6 +++---
 9 files changed, 26 insertions(+), 37 deletions(-)

Index: linux-2.6.18/fs/ext3/balloc.c
===================================================================
--- linux-2.6.18.orig/fs/ext3/balloc.c
+++ linux-2.6.18/fs/ext3/balloc.c
@@ -652,7 +652,7 @@ claim_block(spinlock_t *lock, ext3_grpbl
  * ext3_journal_release_buffer(), else we'll run out of credits.
  */
 static ext3_grpblk_t
-ext3_try_to_allocate(struct super_block *sb, handle_t *handle, int group,
+ext3_try_to_allocate(struct super_block *sb, int group,
 			struct buffer_head *bitmap_bh, ext3_grpblk_t grp_goal,
 			unsigned long *count, struct ext3_reserve_window *my_rsv)
 {
@@ -1089,7 +1089,7 @@ ext3_try_to_allocate_with_rsv(struct sup
 	 * or last attempt to allocate a block with reservation turned on failed
 	 */
 	if (my_rsv == NULL ) {
-		ret = ext3_try_to_allocate(sb, handle, group, bitmap_bh,
+		ret = ext3_try_to_allocate(sb, group, bitmap_bh,
 						grp_goal, count, NULL);
 		goto out;
 	}
@@ -1135,7 +1135,7 @@ ext3_try_to_allocate_with_rsv(struct sup
 		if ((my_rsv->rsv_start >= group_first_block + EXT3_BLOCKS_PER_GROUP(sb))
 		    || (my_rsv->rsv_end < group_first_block))
 			BUG();
-		ret = ext3_try_to_allocate(sb, handle, group, bitmap_bh, grp_goal,
+		ret = ext3_try_to_allocate(sb, group, bitmap_bh, grp_goal,
 					   &num, &my_rsv->rsv_window);
 		if (ret >= 0) {
 			my_rsv->rsv_alloc_hit += num;
Index: linux-2.6.18/fs/ext3/ialloc.c
===================================================================
--- linux-2.6.18.orig/fs/ext3/ialloc.c
+++ linux-2.6.18/fs/ext3/ialloc.c
@@ -190,16 +190,12 @@ error_return:
 }
 
 /*
- * There are two policies for allocating an inode.  If the new inode is
- * a directory, then a forward search is made for a block group with both
+ * Allocate an inode.  A forward search is made for a block group with both
  * free space and a low directory-to-inode ratio; if that fails, then of
  * the groups with above-average free space, that group with the fewest
  * directories already is chosen.
- *
- * For other inodes, search forward from the parent directory\'s block
- * group to find a free inode.
  */
-static int find_group_dir(struct super_block *sb, struct inode *parent)
+static int find_group_dir(struct super_block *sb)
 {
 	int ngroups = EXT3_SB(sb)->s_groups_count;
 	int freei, avefreei;
@@ -451,7 +447,7 @@ struct inode *ext3_new_inode(handle_t *h
 	es = sbi->s_es;
 	if (S_ISDIR(mode)) {
 		if (test_opt (sb, OLDALLOC))
-			group = find_group_dir(sb, dir);
+			group = find_group_dir(sb);
 		else
 			group = find_group_orlov(sb, dir);
 	} else 
Index: linux-2.6.18/fs/ext3/inode.c
===================================================================
--- linux-2.6.18.orig/fs/ext3/inode.c
+++ linux-2.6.18/fs/ext3/inode.c
@@ -439,7 +439,6 @@ static ext3_fsblk_t ext3_find_near(struc
  *	ext3_find_goal - find a prefered place for allocation.
  *	@inode: owner
  *	@block:  block we want
- *	@chain:  chain of indirect blocks
  *	@partial: pointer to the last triple within a chain
  *	@goal:	place to store the result.
  *
@@ -448,7 +447,7 @@ static ext3_fsblk_t ext3_find_near(struc
  */
 
 static ext3_fsblk_t ext3_find_goal(struct inode *inode, long block,
-		Indirect chain[4], Indirect *partial)
+		Indirect *partial)
 {
 	struct ext3_block_alloc_info *block_i;
 
@@ -884,7 +883,7 @@ int ext3_get_blocks_handle(handle_t *han
 	if (S_ISREG(inode->i_mode) && (!ei->i_block_alloc_info))
 		ext3_init_block_alloc_info(inode);
 
-	goal = ext3_find_goal(inode, iblock, chain, partial);
+	goal = ext3_find_goal(inode, iblock, partial);
 
 	/* the number of blocks need to allocate for [d,t]indirect blocks */
 	indirect_blks = (chain + depth) - partial - 1;
Index: linux-2.6.18/fs/ext3/namei.c
===================================================================
--- linux-2.6.18.orig/fs/ext3/namei.c
+++ linux-2.6.18/fs/ext3/namei.c
@@ -1613,12 +1613,12 @@ static int ext3_delete_entry (handle_t *
  * do not perform it in these functions.  We perform it at the call site,
  * if it is needed.
  */
-static inline void ext3_inc_count(handle_t *handle, struct inode *inode)
+static inline void ext3_inc_count(struct inode *inode)
 {
 	inode->i_nlink++;
 }
 
-static inline void ext3_dec_count(handle_t *handle, struct inode *inode)
+static inline void ext3_dec_count(struct inode *inode)
 {
 	inode->i_nlink--;
 }
@@ -1632,7 +1632,7 @@ static int ext3_add_nondir(handle_t *han
 		d_instantiate(dentry, inode);
 		return 0;
 	}
-	ext3_dec_count(handle, inode);
+	ext3_dec_count(inode);
 	iput(inode);
 	return err;
 }
@@ -2153,7 +2153,7 @@ retry:
 		err = __page_symlink(inode, symname, l,
 				mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS);
 		if (err) {
-			ext3_dec_count(handle, inode);
+			ext3_dec_count(inode);
 			ext3_mark_inode_dirty(handle, inode);
 			iput (inode);
 			goto out_stop;
@@ -2192,7 +2192,7 @@ retry:
 		handle->h_sync = 1;
 
 	inode->i_ctime = CURRENT_TIME_SEC;
-	ext3_inc_count(handle, inode);
+	ext3_inc_count(inode);
 	atomic_inc(&inode->i_count);
 
 	err = ext3_add_nondir(handle, dentry, inode);
Index: linux-2.6.18/fs/ext3/super.c
===================================================================
--- linux-2.6.18.orig/fs/ext3/super.c
+++ linux-2.6.18/fs/ext3/super.c
@@ -365,7 +365,7 @@ static inline struct inode *orphan_list_
 	return &list_entry(l, struct ext3_inode_info, i_orphan)->vfs_inode;
 }
 
-static void dump_orphan_list(struct super_block *sb, struct ext3_sb_info *sbi)
+static void dump_orphan_list(struct ext3_sb_info *sbi)
 {
 	struct list_head *l;
 
@@ -416,7 +416,7 @@ static void ext3_put_super (struct super
 	 * detected an error and taken the fs readonly, but the
 	 * in-memory list had better be clean by this point. */
 	if (!list_empty(&sbi->s_orphan))
-		dump_orphan_list(sb, sbi);
+		dump_orphan_list(sbi);
 	J_ASSERT(list_empty(&sbi->s_orphan));
 
 	invalidate_bdev(sb->s_bdev, 0);
Index: linux-2.6.18/fs/ext3/xattr.c
===================================================================
--- linux-2.6.18.orig/fs/ext3/xattr.c
+++ linux-2.6.18/fs/ext3/xattr.c
@@ -891,8 +891,7 @@ ext3_xattr_ibody_find(struct inode *inod
 }
 
 static int
-ext3_xattr_ibody_set(handle_t *handle, struct inode *inode,
-		     struct ext3_xattr_info *i,
+ext3_xattr_ibody_set(struct inode *inode, struct ext3_xattr_info *i,
 		     struct ext3_xattr_ibody_find *is)
 {
 	struct ext3_xattr_ibody_header *header;
@@ -986,11 +985,11 @@ ext3_xattr_set_handle(handle_t *handle, 
 		goto cleanup;
 	if (!value) {
 		if (!is.s.not_found)
-			error = ext3_xattr_ibody_set(handle, inode, &i, &is);
+			error = ext3_xattr_ibody_set(inode, &i, &is);
 		else if (!bs.s.not_found)
 			error = ext3_xattr_block_set(handle, inode, &i, &bs);
 	} else {
-		error = ext3_xattr_ibody_set(handle, inode, &i, &is);
+		error = ext3_xattr_ibody_set(inode, &i, &is);
 		if (!error && !bs.s.not_found) {
 			i.value = NULL;
 			error = ext3_xattr_block_set(handle, inode, &i, &bs);
@@ -1000,8 +999,7 @@ ext3_xattr_set_handle(handle_t *handle, 
 				goto cleanup;
 			if (!is.s.not_found) {
 				i.value = NULL;
-				error = ext3_xattr_ibody_set(handle, inode, &i,
-							     &is);
+				error = ext3_xattr_ibody_set(inode, &i, &is);
 			}
 		}
 	}
Index: linux-2.6.18/fs/jbd/journal.c
===================================================================
--- linux-2.6.18.orig/fs/jbd/journal.c
+++ linux-2.6.18/fs/jbd/journal.c
@@ -1614,7 +1614,7 @@ int journal_blocks_per_page(struct inode
  * Simple support for retrying memory allocations.  Introduced to help to
  * debug different VM deadlock avoidance strategies. 
  */
-void * __jbd_kmalloc (const char *where, size_t size, gfp_t flags, int retry)
+void * __jbd_kmalloc (size_t size, gfp_t flags, int retry)
 {
 	return kmalloc(size, flags | (retry ? __GFP_NOFAIL : 0));
 }
Index: linux-2.6.18/include/linux/jbd.h
===================================================================
--- linux-2.6.18.orig/include/linux/jbd.h
+++ linux-2.6.18/include/linux/jbd.h
@@ -71,14 +71,14 @@ extern int journal_enable_debug;
 #define jbd_debug(f, a...)	/**/
 #endif
 
-extern void * __jbd_kmalloc (const char *where, size_t size, gfp_t flags, int retry);
+extern void * __jbd_kmalloc(size_t size, gfp_t flags, int retry);
 extern void * jbd_slab_alloc(size_t size, gfp_t flags);
 extern void jbd_slab_free(void *ptr, size_t size);
 
 #define jbd_kmalloc(size, flags) \
-	__jbd_kmalloc(__FUNCTION__, (size), (flags), journal_oom_retry)
+	__jbd_kmalloc((size), (flags), journal_oom_retry)
 #define jbd_rep_kmalloc(size, flags) \
-	__jbd_kmalloc(__FUNCTION__, (size), (flags), 1)
+	__jbd_kmalloc((size), (flags), 1)
 
 #define JFS_MIN_JOURNAL_BLOCKS 1024
 
Index: linux-2.6.18/fs/ext2/ialloc.c
===================================================================
--- linux-2.6.18.orig/fs/ext2/ialloc.c
+++ linux-2.6.18/fs/ext2/ialloc.c
@@ -203,16 +203,12 @@ static void ext2_preread_inode(struct in
 }
 
 /*
- * There are two policies for allocating an inode.  If the new inode is
- * a directory, then a forward search is made for a block group with both
+ * Allocate an inode.  A forward search is made for a block group with both
  * free space and a low directory-to-inode ratio; if that fails, then of
  * the groups with above-average free space, that group with the fewest
  * directories already is chosen.
- *
- * For other inodes, search forward from the parent directory\'s block
- * group to find a free inode.
  */
-static int find_group_dir(struct super_block *sb, struct inode *parent)
+static int find_group_dir(struct super_block *sb)
 {
 	int ngroups = EXT2_SB(sb)->s_groups_count;
 	int avefreei = ext2_count_free_inodes(sb) / ngroups;
@@ -469,7 +465,7 @@ struct inode *ext2_new_inode(struct inod
 	es = sbi->s_es;
 	if (S_ISDIR(mode)) {
 		if (test_opt(sb, OLDALLOC))
-			group = find_group_dir(sb, dir);
+			group = find_group_dir(sb);
 		else
 			group = find_group_orlov(sb, dir);
 	} else 
