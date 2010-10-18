From: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH] ext4: make functions local
Date: Mon, 18 Oct 2010 08:44:57 -0700
Message-ID: <20101018084457.03dfe942@nehalam>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:57576 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756864Ab0JRPpA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Oct 2010 11:45:00 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Make functions local to file if possible by making them static.
Remove dead code ext4_error_file which was defined
but never used anywhere.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

---
 fs/ext4/balloc.c       |    2 +-
 fs/ext4/ext4.h         |   17 -----------------
 fs/ext4/ext4_extents.h |   10 ----------
 fs/ext4/extents.c      |   28 ++++++++++++++--------------
 fs/ext4/ialloc.c       |   11 ++++++-----
 fs/ext4/inode.c        |    2 +-
 fs/ext4/mballoc.c      |   11 ++++++++---
 fs/ext4/super.c        |   29 +----------------------------
 8 files changed, 31 insertions(+), 79 deletions(-)

--- a/fs/ext4/balloc.c	2010-10-05 23:45:39.675118247 +0900
+++ b/fs/ext4/balloc.c	2010-10-05 23:46:29.579120467 +0900
@@ -489,7 +489,7 @@ error_return:
  * Check if filesystem has nblocks free & available for allocation.
  * On success return 1, return 0 on failure.
  */
-int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nblocks)
+static int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nblocks)
 {
 	s64 free_blocks, dirty_blocks, root_blocks;
 	struct percpu_counter *fbc = &sbi->s_freeblocks_counter;
--- a/fs/ext4/ext4.h	2010-10-05 23:44:06.756117405 +0900
+++ b/fs/ext4/ext4.h	2010-10-05 23:55:47.547119736 +0900
@@ -62,9 +62,6 @@
 #define EXT4_ERROR_INODE_BLOCK(inode, block, fmt, a...)			\
 	ext4_error_inode((inode), __func__, __LINE__, (block), (fmt), ## a)
 
-#define EXT4_ERROR_FILE(file, fmt, a...)	\
-	ext4_error_file(__func__, __LINE__, (file), (fmt), ## a)
-
 /* data type for block offset of block group */
 typedef int ext4_grpblk_t;
 
@@ -1533,8 +1530,6 @@ ext4_group_first_block_no(struct super_b
 void ext4_get_group_no_and_offset(struct super_block *sb, ext4_fsblk_t blocknr,
 			ext4_group_t *blockgrpp, ext4_grpblk_t *offsetp);
 
-extern struct proc_dir_entry *ext4_proc_root;
-
 /*
  * Function prototypes
  */
@@ -1561,7 +1556,6 @@ extern unsigned long ext4_bg_num_gdb(str
 extern ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, unsigned long *count, int *errp);
 extern int ext4_claim_free_blocks(struct ext4_sb_info *sbi, s64 nblocks);
-extern int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nblocks);
 extern void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 				ext4_fsblk_t block, unsigned long count);
 extern ext4_fsblk_t ext4_count_free_blocks(struct super_block *);
@@ -1605,10 +1599,6 @@ extern struct inode * ext4_orphan_get(st
 extern unsigned long ext4_count_free_inodes(struct super_block *);
 extern unsigned long ext4_count_dirs(struct super_block *);
 extern void ext4_check_inodes_bitmap(struct super_block *);
-extern unsigned ext4_init_inode_bitmap(struct super_block *sb,
-				       struct buffer_head *bh,
-				       ext4_group_t group,
-				       struct ext4_group_desc *desc);
 extern void mark_bitmap_end(int start_bit, int end_bit, char *bitmap);
 
 /* mballoc.c */
@@ -1627,9 +1617,6 @@ extern void ext4_free_blocks(handle_t *h
 			     unsigned long count, int flags);
 extern int ext4_mb_add_groupinfo(struct super_block *sb,
 		ext4_group_t i, struct ext4_group_desc *desc);
-extern int ext4_mb_get_buddy_cache_lock(struct super_block *, ext4_group_t);
-extern void ext4_mb_put_buddy_cache_lock(struct super_block *,
-						ext4_group_t, int);
 /* inode.c */
 struct buffer_head *ext4_getblk(handle_t *, struct inode *,
 						ext4_lblk_t, int, int *);
@@ -1657,7 +1644,6 @@ extern void ext4_get_inode_flags(struct 
 extern int ext4_alloc_da_blocks(struct inode *inode);
 extern void ext4_set_aops(struct inode *inode);
 extern int ext4_writepage_trans_blocks(struct inode *);
-extern int ext4_meta_trans_blocks(struct inode *, int nrblocks, int idxblocks);
 extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
 extern int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from);
@@ -1695,9 +1681,6 @@ extern void __ext4_error(struct super_bl
 extern void ext4_error_inode(struct inode *, const char *, unsigned int,
 			     ext4_fsblk_t, const char *, ...)
 	__attribute__ ((format (printf, 5, 6)));
-extern void ext4_error_file(struct file *, const char *, unsigned int,
-			    const char *, ...)
-	__attribute__ ((format (printf, 4, 5)));
 extern void __ext4_std_error(struct super_block *, const char *,
 			     unsigned int, int);
 extern void __ext4_abort(struct super_block *, const char *, unsigned int,
--- a/fs/ext4/ext4_extents.h	2010-10-05 23:40:32.468117473 +0900
+++ b/fs/ext4/ext4_extents.h	2010-10-05 23:56:06.891118028 +0900
@@ -237,19 +237,9 @@ extern int ext4_ext_calc_credits_for_sin
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
--- a/fs/ext4/extents.c	2010-10-05 23:40:32.536118292 +0900
+++ b/fs/ext4/extents.c	2010-10-05 23:43:25.592117861 +0900
@@ -739,9 +739,9 @@ err:
  * insert new index [@logical;@ptr] into the block at @curp;
  * check where to insert: before @curp or after @curp
  */
-int ext4_ext_insert_index(handle_t *handle, struct inode *inode,
-				struct ext4_ext_path *curp,
-				int logical, ext4_fsblk_t ptr)
+static int ext4_ext_insert_index(handle_t *handle, struct inode *inode,
+				 struct ext4_ext_path *curp,
+				 int logical, ext4_fsblk_t ptr)
 {
 	struct ext4_extent_idx *ix;
 	int len, err;
@@ -1232,7 +1232,7 @@ out:
  * returns 0 at @phys
  * return value contains 0 (success) or error code
  */
-int
+static int
 ext4_ext_search_left(struct inode *inode, struct ext4_ext_path *path,
 			ext4_lblk_t *logical, ext4_fsblk_t *phys)
 {
@@ -1297,7 +1297,7 @@ ext4_ext_search_left(struct inode *inode
  * returns 0 at @phys
  * return value contains 0 (success) or error code
  */
-int
+static int
 ext4_ext_search_right(struct inode *inode, struct ext4_ext_path *path,
 			ext4_lblk_t *logical, ext4_fsblk_t *phys)
 {
@@ -1585,9 +1585,9 @@ ext4_can_extents_be_merged(struct inode 
  * Returns 0 if the extents (ex and ex+1) were _not_ merged and returns
  * 1 if they got merged.
  */
-int ext4_ext_try_to_merge(struct inode *inode,
-			  struct ext4_ext_path *path,
-			  struct ext4_extent *ex)
+static int ext4_ext_try_to_merge(struct inode *inode,
+				 struct ext4_ext_path *path,
+				 struct ext4_extent *ex)
 {
 	struct ext4_extent_header *eh;
 	unsigned int depth, len;
@@ -1632,9 +1632,9 @@ int ext4_ext_try_to_merge(struct inode *
  * such that there will be no overlap, and then returns 1.
  * If there is no overlap found, it returns 0.
  */
-unsigned int ext4_ext_check_overlap(struct inode *inode,
-				    struct ext4_extent *newext,
-				    struct ext4_ext_path *path)
+static unsigned int ext4_ext_check_overlap(struct inode *inode,
+					   struct ext4_extent *newext,
+					   struct ext4_ext_path *path)
 {
 	ext4_lblk_t b1, b2;
 	unsigned int depth, len1;
@@ -1845,9 +1845,9 @@ cleanup:
 	return err;
 }
 
-int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
-			ext4_lblk_t num, ext_prepare_callback func,
-			void *cbdata)
+static int ext4_ext_walk_space(struct inode *inode, ext4_lblk_t block,
+			       ext4_lblk_t num, ext_prepare_callback func,
+			       void *cbdata)
 {
 	struct ext4_ext_path *path = NULL;
 	struct ext4_ext_cache cbex;
--- a/fs/ext4/ialloc.c	2010-10-05 23:44:06.864117937 +0900
+++ b/fs/ext4/ialloc.c	2010-10-05 23:45:25.471119195 +0900
@@ -65,9 +65,10 @@ void mark_bitmap_end(int start_bit, int 
 }
 
 /* Initializes an uninitialized inode bitmap */
-unsigned ext4_init_inode_bitmap(struct super_block *sb, struct buffer_head *bh,
-				ext4_group_t block_group,
-				struct ext4_group_desc *gdp)
+static unsigned ext4_init_inode_bitmap(struct super_block *sb,
+				       struct buffer_head *bh,
+				       ext4_group_t block_group,
+				       struct ext4_group_desc *gdp)
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
--- a/fs/ext4/inode.c	2010-10-05 23:46:45.567117620 +0900
+++ b/fs/ext4/inode.c	2010-10-05 23:46:54.155118182 +0900
@@ -5643,7 +5643,7 @@ static int ext4_index_trans_blocks(struc
  *
  * Also account for superblock, inode, quota and xattr blocks
  */
-int ext4_meta_trans_blocks(struct inode *inode, int nrblocks, int chunk)
+static int ext4_meta_trans_blocks(struct inode *inode, int nrblocks, int chunk)
 {
 	ext4_group_t groups, ngroups = ext4_get_groups_count(inode->i_sb);
 	int gdpblocks;
--- a/fs/ext4/mballoc.c	2010-10-05 23:47:03.288118121 +0900
+++ b/fs/ext4/mballoc.c	2010-10-05 23:48:14.703119117 +0900
@@ -344,6 +344,10 @@ static void ext4_mb_generate_from_freeli
 						ext4_group_t group);
 static void release_blocks_on_commit(journal_t *journal, transaction_t *txn);
 
+static int ext4_mb_get_buddy_cache_lock(struct super_block *, ext4_group_t);
+static void ext4_mb_put_buddy_cache_lock(struct super_block *,
+					  ext4_group_t, int);
+
 static inline void *mb_correct_addr_and_bit(int *bit, void *addr)
 {
 #if BITS_PER_LONG == 64
@@ -1922,7 +1926,8 @@ static int ext4_mb_good_group(struct ext
  * cache doesn't happen  whild holding the buddy cache
  * lock
  */
-int ext4_mb_get_buddy_cache_lock(struct super_block *sb, ext4_group_t group)
+static int ext4_mb_get_buddy_cache_lock(struct super_block *sb,
+					ext4_group_t group)
 {
 	int i;
 	int block, pnum;
@@ -1961,8 +1966,8 @@ int ext4_mb_get_buddy_cache_lock(struct 
 	return i;
 }
 
-void ext4_mb_put_buddy_cache_lock(struct super_block *sb,
-					ext4_group_t group, int locked_group)
+static void ext4_mb_put_buddy_cache_lock(struct super_block *sb,
+					 ext4_group_t group, int locked_group)
 {
 	int i;
 	int block, pnum;
--- a/fs/ext4/super.c	2010-10-05 23:49:08.392117518 +0900
+++ b/fs/ext4/super.c	2010-10-05 23:55:20.356315778 +0900
@@ -50,7 +50,7 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/ext4.h>
 
-struct proc_dir_entry *ext4_proc_root;
+static struct proc_dir_entry *ext4_proc_root;
 static struct kset *ext4_kset;
 
 static int ext4_load_journal(struct super_block *, struct ext4_super_block *,
@@ -416,33 +416,6 @@ void ext4_error_inode(struct inode *inod
 	ext4_handle_error(inode->i_sb);
 }
 
-void ext4_error_file(struct file *file, const char *function,
-		     unsigned int line, const char *fmt, ...)
-{
-	va_list args;
-	struct ext4_super_block *es;
-	struct inode *inode = file->f_dentry->d_inode;
-	char pathname[80], *path;
-
-	es = EXT4_SB(inode->i_sb)->s_es;
-	es->s_last_error_ino = cpu_to_le32(inode->i_ino);
-	save_error_info(inode->i_sb, function, line);
-	va_start(args, fmt);
-	path = d_path(&(file->f_path), pathname, sizeof(pathname));
-	if (!path)
-		path = "(unknown)";
-	printk(KERN_CRIT
-	       "EXT4-fs error (device %s): %s:%d: inode #%lu "
-	       "(comm %s path %s): ",
-	       inode->i_sb->s_id, function, line, inode->i_ino,
-	       current->comm, path);
-	vprintk(fmt, args);
-	printk("\n");
-	va_end(args);
-
-	ext4_handle_error(inode->i_sb);
-}
