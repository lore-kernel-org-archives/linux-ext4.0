From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/2] ext4: make static functions static & remove prototypes
Date: Wed, 15 Sep 2010 13:26:46 -0500
Message-ID: <4C910FE6.6040004@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852Ab0IOS0u (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Sep 2010 14:26:50 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o8FIQopi019364
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 15 Sep 2010 14:26:50 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id o8FIQkYv007923
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 15 Sep 2010 14:26:49 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Just a tidyup; many functions are used in only one file,
and yet are not marked static, and have prototypes in headers.
In 2 cases in mballoc.c I moved the function ahead of its
first use.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

 balloc.c       |    2 
 ext4.h         |    9 ---
 ext4_extents.h |   10 ---
 extents.c      |   27 +++++----
 ialloc.c       |   11 ++-
 inode.c        |    3 -
 mballoc.c      |  157 ++++++++++++++++++++++++++++-----------------------------
 7 files changed, 103 insertions(+), 116 deletions(-)


diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index bd30799..a12cefc 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -489,7 +489,7 @@ error_return:
  * Check if filesystem has nblocks free & available for allocation.
  * On success return 1, return 0 on failure.
  */
-int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nblocks)
+static int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nblocks)
 {
 	s64 free_blocks, dirty_blocks, root_blocks;
 	struct percpu_counter *fbc = &sbi->s_freeblocks_counter;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 889ec9d..cb4d204 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1561,7 +1561,6 @@ extern unsigned long ext4_bg_num_gdb(struct super_block *sb,
 extern ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, unsigned long *count, int *errp);
 extern int ext4_claim_free_blocks(struct ext4_sb_info *sbi, s64 nblocks);
-extern int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nblocks);
 extern void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 				ext4_fsblk_t block, unsigned long count);
 extern ext4_fsblk_t ext4_count_free_blocks(struct super_block *);
@@ -1605,10 +1604,6 @@ extern struct inode * ext4_orphan_get(struct super_block *, unsigned long);
 extern unsigned long ext4_count_free_inodes(struct super_block *);
 extern unsigned long ext4_count_dirs(struct super_block *);
 extern void ext4_check_inodes_bitmap(struct super_block *);
-extern unsigned ext4_init_inode_bitmap(struct super_block *sb,
-				       struct buffer_head *bh,
-				       ext4_group_t group,
-				       struct ext4_group_desc *desc);
 extern void mark_bitmap_end(int start_bit, int end_bit, char *bitmap);
 
 /* mballoc.c */
@@ -1627,9 +1622,6 @@ extern void ext4_free_blocks(handle_t *handle, struct inode *inode,
 			     unsigned long count, int flags);
 extern int ext4_mb_add_groupinfo(struct super_block *sb,
 		ext4_group_t i, struct ext4_group_desc *desc);
-extern int ext4_mb_get_buddy_cache_lock(struct super_block *, ext4_group_t);
-extern void ext4_mb_put_buddy_cache_lock(struct super_block *,
-						ext4_group_t, int);
 /* inode.c */
 struct buffer_head *ext4_getblk(handle_t *, struct inode *,
 						ext4_lblk_t, int, int *);
@@ -1657,7 +1649,6 @@ extern void ext4_get_inode_flags(struct ext4_inode_info *);
 extern int ext4_alloc_da_blocks(struct inode *inode);
 extern void ext4_set_aops(struct inode *inode);
 extern int ext4_writepage_trans_blocks(struct inode *);
-extern int ext4_meta_trans_blocks(struct inode *, int nrblocks, int idxblocks);
 extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
 extern int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from);
diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index bdb6ce7..e427082 100644
--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -237,19 +237,9 @@ extern int ext4_ext_calc_credits_for_single_extent(struct inode *inode,
 extern int ext4_can_extents_be_merged(struct inode *inode,
 				      struct ext4_extent *ex1,
 				      struct ext4_extent *ex2);
-extern int ext4_ext_try_to_merge(struct inode *inode,
-				 struct ext4_ext_path *path,
-				 struct ext4_extent *);
-extern unsigned int ext4_ext_check_overlap(struct inode *, struct ext4_extent *, struct ext4_ext_path *);
 extern int ext4_ext_insert_extent(handle_t *, struct inode *, struct ext4_ext_path *, struct ext4_extent *, int);
-extern int ext4_ext_walk_space(struct inode *, ext4_lblk_t, ext4_lblk_t,
-							ext_prepare_callback, void *);
 extern struct ext4_ext_path *ext4_ext_find_extent(struct inode *, ext4_lblk_t,
 							struct ext4_ext_path *);
-extern int ext4_ext_search_left(struct inode *, struct ext4_ext_path *,
-						ext4_lblk_t *, ext4_fsblk_t *);
-extern int ext4_ext_search_right(struct inode *, struct ext4_ext_path *,
-						ext4_lblk_t *, ext4_fsblk_t *);
 extern void ext4_ext_drop_refs(struct ext4_ext_path *);
 extern int ext4_ext_check_inode(struct inode *inode);
 #endif /* _EXT4_EXTENTS */
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 06328d3..2b39483 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -739,7 +739,7 @@ err:
  * insert new index [@logical;@ptr] into the block at @curp;
  * check where to insert: before @curp or after @curp
  */
-int ext4_ext_insert_index(handle_t *handle, struct inode *inode,
+static int ext4_ext_insert_index(handle_t *handle, struct inode *inode,
 				struct ext4_ext_path *curp,
 				int logical, ext4_fsblk_t ptr)
 {
@@ -1232,7 +1232,7 @@ out:
  * returns 0 at @phys
  * return value contains 0 (success) or error code
  */
-int
+static int
 ext4_ext_search_left(struct inode *inode, struct ext4_ext_path *path,
 			ext4_lblk_t *logical, ext4_fsblk_t *phys)
 {
@@ -1297,7 +1297,7 @@ ext4_ext_search_left(struct inode *inode, struct ext4_ext_path *path,
  * returns 0 at @phys
  * return value contains 0 (success) or error code
  */
-int
+static int
 ext4_ext_search_right(struct inode *inode, struct ext4_ext_path *path,
 			ext4_lblk_t *logical, ext4_fsblk_t *phys)
 {
@@ -1585,9 +1585,10 @@ ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
  * Returns 0 if the extents (ex and ex+1) were _not_ merged and returns
  * 1 if they got merged.
  */
-int ext4_ext_try_to_merge(struct inode *inode,
-			  struct ext4_ext_path *path,
-			  struct ext4_extent *ex)
+static int
+ext4_ext_try_to_merge(struct inode *inode,
+		      struct ext4_ext_path *path,
+		      struct ext4_extent *ex)
 {
 	struct ext4_extent_header *eh;
 	unsigned int depth, len;
@@ -1632,9 +1633,10 @@ int ext4_ext_try_to_merge(struct inode *inode,
  * such that there will be no overlap, and then returns 1.
  * If there is no overlap found, it returns 0.
  */
-unsigned int ext4_ext_check_overlap(struct inode *inode,
-				    struct ext4_extent *newext,
-				    struct ext4_ext_path *path)
+static unsigned int
+ext4_ext_check_overlap(struct inode *inode,
+		       struct ext4_extent *newext,
+		       struct ext4_ext_path *path)
 {
 	ext4_lblk_t b1, b2;
 	unsigned int depth, len1;
@@ -1845,9 +1847,10 @@ cleanup:
 	return err;
 }
 
-int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
-			ext4_lblk_t num, ext_prepare_callback func,
-			void *cbdata)
+static int
+ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
+		    ext4_lblk_t num, ext_prepare_callback func,
+		    void *cbdata)
 {
 	struct ext4_ext_path *path = NULL;
 	struct ext4_ext_cache cbex;
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 45853e0..cdff49a 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -65,9 +65,10 @@ void mark_bitmap_end(int start_bit, int end_bit, char *bitmap)
 }
 
 /* Initializes an uninitialized inode bitmap */
-unsigned ext4_init_inode_bitmap(struct super_block *sb, struct buffer_head *bh,
-				ext4_group_t block_group,
-				struct ext4_group_desc *gdp)
+static unsigned long
+ext4_init_inode_bitmap(struct super_block *sb, struct buffer_head *bh,
+		       ext4_group_t block_group,
+		       struct ext4_group_desc *gdp)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
@@ -411,8 +412,8 @@ struct orlov_stats {
  * for a particular block group or flex_bg.  If flex_size is 1, then g
  * is a block group number; otherwise it is flex_bg number.
  */
-void get_orlov_stats(struct super_block *sb, ext4_group_t g,
-		       int flex_size, struct orlov_stats *stats)
+static void get_orlov_stats(struct super_block *sb, ext4_group_t g,
+			    int flex_size, struct orlov_stats *stats)
 {
 	struct ext4_group_desc *desc;
 	struct flex_groups *flex_group = EXT4_SB(sb)->s_flex_groups;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 4b8debe..86a9094 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5643,7 +5643,8 @@ static int ext4_index_trans_blocks(struct inode *inode, int nrblocks, int chunk)
  *
  * Also account for superblock, inode, quota and xattr blocks
  */
-int ext4_meta_trans_blocks(struct inode *inode, int nrblocks, int chunk)
+static int
+ext4_meta_trans_blocks(struct inode *inode, int nrblocks, int chunk)
 {
 	ext4_group_t groups, ngroups = ext4_get_groups_count(inode->i_sb);
 	int gdpblocks;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4b4ad4b..b7bfae1 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -939,6 +939,85 @@ out:
 }
 
 /*
+ * lock the group_info alloc_sem of all the groups
+ * belonging to the same buddy cache page. This
+ * make sure other parallel operation on the buddy
+ * cache doesn't happen  whild holding the buddy cache
+ * lock
+ */
+static int
+ext4_mb_get_buddy_cache_lock(struct super_block *sb, ext4_group_t group)
+{
+	int i;
+	int block, pnum;
+	int blocks_per_page;
+	int groups_per_page;
+	ext4_group_t ngroups = ext4_get_groups_count(sb);
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
+		if ((first_group + i) >= ngroups)
+			break;
+		grp = ext4_get_group_info(sb, first_group + i);
+		/* take all groups write allocation
+		 * semaphore. This make sure there is
+		 * no block allocation going on in any
+		 * of that groups
+		 */
+		down_write_nested(&grp->alloc_sem, i);
+	}
+	return i;
+}
+
+static void ext4_mb_put_buddy_cache_lock(struct super_block *sb,
+					 ext4_group_t group, int locked_group)
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
+/*
  * Locking note:  This routine calls ext4_mb_init_cache(), which takes the
  * block group lock of all groups for this page; do not hold the BG lock when
  * calling this routine!
@@ -1915,84 +1994,6 @@ static int ext4_mb_good_group(struct ext4_allocation_context *ac,
 	return 0;
 }
 
-/*
- * lock the group_info alloc_sem of all the groups
- * belonging to the same buddy cache page. This
- * make sure other parallel operation on the buddy
- * cache doesn't happen  whild holding the buddy cache
- * lock
- */
-int ext4_mb_get_buddy_cache_lock(struct super_block *sb, ext4_group_t group)
-{
-	int i;
-	int block, pnum;
-	int blocks_per_page;
-	int groups_per_page;
-	ext4_group_t ngroups = ext4_get_groups_count(sb);
-	ext4_group_t first_group;
-	struct ext4_group_info *grp;
-
-	blocks_per_page = PAGE_CACHE_SIZE / sb->s_blocksize;
-	/*
-	 * the buddy cache inode stores the block bitmap
-	 * and buddy information in consecutive blocks.
-	 * So for each group we need two blocks.
-	 */
-	block = group * 2;
-	pnum = block / blocks_per_page;
-	first_group = pnum * blocks_per_page / 2;
-
-	groups_per_page = blocks_per_page >> 1;
-	if (groups_per_page == 0)
-		groups_per_page = 1;
-	/* read all groups the page covers into the cache */
-	for (i = 0; i < groups_per_page; i++) {
-
-		if ((first_group + i) >= ngroups)
-			break;
-		grp = ext4_get_group_info(sb, first_group + i);
-		/* take all groups write allocation
-		 * semaphore. This make sure there is
-		 * no block allocation going on in any
-		 * of that groups
-		 */
-		down_write_nested(&grp->alloc_sem, i);
-	}
-	return i;
-}
-
-void ext4_mb_put_buddy_cache_lock(struct super_block *sb,
-					ext4_group_t group, int locked_group)
-{
-	int i;
-	int block, pnum;
-	int blocks_per_page;
-	ext4_group_t first_group;
-	struct ext4_group_info *grp;
-
-	blocks_per_page = PAGE_CACHE_SIZE / sb->s_blocksize;
-	/*
-	 * the buddy cache inode stores the block bitmap
-	 * and buddy information in consecutive blocks.
-	 * So for each group we need two blocks.
-	 */
-	block = group * 2;
-	pnum = block / blocks_per_page;
-	first_group = pnum * blocks_per_page / 2;
-	/* release locks on all the groups */
-	for (i = 0; i < locked_group; i++) {
-
-		grp = ext4_get_group_info(sb, first_group + i);
-		/* take all groups write allocation
-		 * semaphore. This make sure there is
-		 * no block allocation going on in any
-		 * of that groups
-		 */
-		up_write(&grp->alloc_sem);
-	}
-
-}
