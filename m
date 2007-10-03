From: Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: [PATCH, RFC 1/3] ext4_grpnum_t: Add new type
Date: Tue, 02 Oct 2007 17:33:04 -0700
Message-ID: <4702E340.8070603@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:47538 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbXJCAcH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Oct 2007 20:32:07 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l930W32K012647
	for <linux-ext4@vger.kernel.org>; Tue, 2 Oct 2007 20:32:03 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l930W38l433724
	for <linux-ext4@vger.kernel.org>; Tue, 2 Oct 2007 18:32:03 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l930W2Pk024091
	for <linux-ext4@vger.kernel.org>; Tue, 2 Oct 2007 18:32:03 -0600
Received: from [9.47.16.62] (dyn9047016062.beaverton.ibm.com [9.47.16.62])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l930W25D024032
	for <linux-ext4@vger.kernel.org>; Tue, 2 Oct 2007 18:32:02 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Ext4: add new type ext4_grpnum_t, and change all group variables to this type.
from: mathur@us.ibm.com 

In many places variables for block group are of type int, which limits the
maximum filesystem size.  This patch introduces a new type
ext4_grpnum_t, of type unsigned long, to represent block group numbers in ext4.
All occurrences of block group variables are converted to type ext4_grpnum_t.

Signed-off-by: Avantika Mathur <mathur@us.ibm.com>
---
 fs/ext4/balloc.c           |   61 +++++++++++++++++++++++----------------------
 fs/ext4/group.h            |    8 +++--
 fs/ext4/ialloc.c           |   44 ++++++++++++++++----------------
 fs/ext4/inode.c            |    5 ++-
 fs/ext4/resize.c           |   12 ++++----
 fs/ext4/super.c            |   20 ++++++--------
 include/linux/ext4_fs.h    |   11 ++++----
 include/linux/ext4_fs_i.h  |    5 ++-
 include/linux/ext4_fs_sb.h |    2 -
 9 files changed, 88 insertions(+), 80 deletions(-)

Index: linux-2.6.23-rc8-new/fs/ext4/balloc.c
===================================================================
--- linux-2.6.23-rc8-new.orig/fs/ext4/balloc.c	2007-10-01 15:14:19.000000000 -0700
+++ linux-2.6.23-rc8-new/fs/ext4/balloc.c	2007-10-01 15:14:38.000000000 -0700
@@ -29,7 +29,7 @@
  * Calculate the block group number and offset, given a block number
  */
 void ext4_get_group_no_and_offset(struct super_block *sb, ext4_fsblk_t blocknr,
-		unsigned long *blockgrpp, ext4_grpblk_t *offsetp)
+		ext4_grpnum_t *blockgrpp, ext4_grpblk_t *offsetp)
 {
 	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
 	ext4_grpblk_t offset;
@@ -46,7 +46,7 @@
 /* Initializes an uninitialized block bitmap if given, and returns the
  * number of blocks free in the group. */
 unsigned ext4_init_block_bitmap(struct super_block *sb, struct buffer_head *bh,
-				int block_group, struct ext4_group_desc *gdp)
+		 ext4_grpnum_t block_group, struct ext4_group_desc *gdp)
 {
 	unsigned long start;
 	int bit, bit_max;
@@ -60,7 +60,7 @@
 		 * essentially implementing a per-group read-only flag. */
 		if (!ext4_group_desc_csum_verify(sbi, block_group, gdp)) {
 			ext4_error(sb, __FUNCTION__,
-				   "Checksum bad for group %u\n", block_group);
+				  "Checksum bad for group %lu\n", block_group);
 			gdp->bg_free_blocks_count = 0;
 			gdp->bg_free_inodes_count = 0;
 			gdp->bg_itable_unused = 0;
@@ -133,7 +133,7 @@
  *			group descriptor
  */
 struct ext4_group_desc * ext4_get_group_desc(struct super_block * sb,
-					     unsigned int block_group,
+					     ext4_grpnum_t block_group,
 					     struct buffer_head ** bh)
 {
 	unsigned long group_desc;
@@ -144,7 +144,7 @@
 	if (block_group >= sbi->s_groups_count) {
 		ext4_error (sb, "ext4_get_group_desc",
 			    "block_group >= groups_count - "
-			    "block_group = %d, groups_count = %lu",
+			    "block_group = %lu, groups_count = %lu",
 			    block_group, sbi->s_groups_count);
 
 		return NULL;
@@ -156,7 +156,7 @@
 	if (!sbi->s_group_desc[group_desc]) {
 		ext4_error (sb, "ext4_get_group_desc",
 			    "Group descriptor not loaded - "
-			    "block_group = %d, group_desc = %lu, desc = %lu",
+			    "block_group = %lu, group_desc = %lu, desc = %lu",
 			     block_group, group_desc, offset);
 		return NULL;
 	}
@@ -180,7 +180,7 @@
  * Return buffer_head on success or NULL in case of failure.
  */
 struct buffer_head *
-read_block_bitmap(struct super_block *sb, unsigned int block_group)
+read_block_bitmap(struct super_block *sb, ext4_grpnum_t block_group)
 {
 	struct ext4_group_desc * desc;
 	struct buffer_head * bh = NULL;
@@ -205,7 +205,7 @@
 	if (!bh)
 		ext4_error (sb, "read_block_bitmap",
 			    "Cannot read block bitmap - "
-			    "block_group = %d, block_bitmap = %llu",
+			    "block_group = %lu, block_bitmap = %llu",
 			    block_group,
 			    ext4_block_bitmap(sb, desc));
 error_out:
@@ -300,7 +300,7 @@
  */
 static int
 goal_in_my_reservation(struct ext4_reserve_window *rsv, ext4_grpblk_t grp_goal,
-			unsigned int group, struct super_block * sb)
+			ext4_grpnum_t group, struct super_block *sb)
 {
 	ext4_fsblk_t group_first_block, group_last_block;
 
@@ -522,7 +522,7 @@
 {
 	struct buffer_head *bitmap_bh = NULL;
 	struct buffer_head *gd_bh;
-	unsigned long block_group;
+	ext4_grpnum_t block_group;
 	ext4_grpblk_t bit;
 	unsigned long i;
 	unsigned long overflow;
@@ -912,9 +912,10 @@
  * ext4_journal_release_buffer(), else we'll run out of credits.
  */
 static ext4_grpblk_t
-ext4_try_to_allocate(struct super_block *sb, handle_t *handle, int group,
-			struct buffer_head *bitmap_bh, ext4_grpblk_t grp_goal,
-			unsigned long *count, struct ext4_reserve_window *my_rsv)
+ext4_try_to_allocate(struct super_block *sb, handle_t *handle,
+			ext4_grpnum_t group, struct buffer_head *bitmap_bh,
+			ext4_grpblk_t grp_goal, unsigned long *count,
+			struct ext4_reserve_window *my_rsv)
 {
 	ext4_fsblk_t group_first_block;
 	ext4_grpblk_t start, end;
@@ -1148,7 +1149,7 @@
  */
 static int alloc_new_reservation(struct ext4_reserve_window_node *my_rsv,
 		ext4_grpblk_t grp_goal, struct super_block *sb,
-		unsigned int group, struct buffer_head *bitmap_bh)
+		ext4_grpnum_t group, struct buffer_head *bitmap_bh)
 {
 	struct ext4_reserve_window_node *search_head;
 	ext4_fsblk_t group_first_block, group_end_block, start_block;
@@ -1346,7 +1347,7 @@
  */
 static ext4_grpblk_t
 ext4_try_to_allocate_with_rsv(struct super_block *sb, handle_t *handle,
-			unsigned int group, struct buffer_head *bitmap_bh,
+			ext4_grpnum_t group, struct buffer_head *bitmap_bh,
 			ext4_grpblk_t grp_goal,
 			struct ext4_reserve_window_node * my_rsv,
 			unsigned long *count, int *errp)
@@ -1520,8 +1521,8 @@
 {
 	struct buffer_head *bitmap_bh = NULL;
 	struct buffer_head *gdp_bh;
-	unsigned long group_no;
-	int goal_group;
+	ext4_grpnum_t group_no;
+	ext4_grpnum_t goal_group;
 	ext4_grpblk_t grp_target_blk;	/* blockgroup relative goal block */
 	ext4_grpblk_t grp_alloc_blk;	/* blockgroup-relative allocated block*/
 	ext4_fsblk_t ret_block;		/* filesyetem-wide allocated block */
@@ -1539,7 +1540,7 @@
 #ifdef EXT4FS_DEBUG
 	static int goal_hits, goal_attempts;
 #endif
-	unsigned long ngroups;
+	ext4_grpnum_t ngroups;
 	unsigned long num = *count;
 
 	*errp = -ENOSPC;
@@ -1839,8 +1840,8 @@
 {
 	ext4_fsblk_t desc_count;
 	struct ext4_group_desc *gdp;
-	int i;
-	unsigned long ngroups = EXT4_SB(sb)->s_groups_count;
+	ext4_grpnum_t i;
+	ext4_grpnum_t ngroups = EXT4_SB(sb)->s_groups_count;
 #ifdef EXT4FS_DEBUG
 	struct ext4_super_block *es;
 	ext4_fsblk_t bitmap_count;
@@ -1864,7 +1865,7 @@
 			continue;
 
 		x = ext4_count_free(bitmap_bh, sb->s_blocksize);
-		printk("group %d: stored = %d, counted = %lu\n",
+		printk("group %lu: stored = %d, counted = %lu\n",
 			i, le16_to_cpu(gdp->bg_free_blocks_count), x);
 		bitmap_count += x;
 	}
@@ -1897,7 +1898,7 @@
 	return ext4_test_bit (offset, map);
 }
 
-static inline int test_root(int a, int b)
+static inline int test_root(ext4_grpnum_t a, int b)
 {
 	int num = b;
 
@@ -1906,7 +1907,7 @@
 	return num == a;
 }
 
-static int ext4_group_sparse(int group)
+static int ext4_group_sparse(ext4_grpnum_t group)
 {
 	if (group <= 1)
 		return 1;
@@ -1924,7 +1925,7 @@
  *	Return the number of blocks used by the superblock (primary or backup)
  *	in this group.  Currently this will be only 0 or 1.
  */
-int ext4_bg_has_super(struct super_block *sb, int group)
+int ext4_bg_has_super(struct super_block *sb, ext4_grpnum_t group)
 {
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
 				EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER) &&
@@ -1933,18 +1934,20 @@
 	return 1;
 }
 
-static unsigned long ext4_bg_num_gdb_meta(struct super_block *sb, int group)
+static unsigned long ext4_bg_num_gdb_meta(struct super_block *sb,
+					ext4_grpnum_t group)
 {
 	unsigned long metagroup = group / EXT4_DESC_PER_BLOCK(sb);
-	unsigned long first = metagroup * EXT4_DESC_PER_BLOCK(sb);
-	unsigned long last = first + EXT4_DESC_PER_BLOCK(sb) - 1;
+	ext4_grpnum_t first = metagroup * EXT4_DESC_PER_BLOCK(sb);
+	ext4_grpnum_t last = first + EXT4_DESC_PER_BLOCK(sb) - 1;
 
 	if (group == first || group == first + 1 || group == last)
 		return 1;
 	return 0;
 }
 
-static unsigned long ext4_bg_num_gdb_nometa(struct super_block *sb, int group)
+static unsigned long ext4_bg_num_gdb_nometa(struct super_block *sb,
+					ext4_grpnum_t group)
 {
 	if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
 				EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER) &&
@@ -1962,7 +1965,7 @@
  *	(primary or backup) in this group.  In the future there may be a
  *	different number of descriptor blocks in each group.
  */
-unsigned long ext4_bg_num_gdb(struct super_block *sb, int group)
+unsigned long ext4_bg_num_gdb(struct super_block *sb, ext4_grpnum_t group)
 {
 	unsigned long first_meta_bg =
 			le32_to_cpu(EXT4_SB(sb)->s_es->s_first_meta_bg);
Index: linux-2.6.23-rc8-new/fs/ext4/ialloc.c
===================================================================
--- linux-2.6.23-rc8-new.orig/fs/ext4/ialloc.c	2007-10-01 15:14:19.000000000 -0700
+++ linux-2.6.23-rc8-new/fs/ext4/ialloc.c	2007-10-01 15:14:38.000000000 -0700
@@ -64,8 +64,8 @@
 }
 
 /* Initializes an uninitialized inode bitmap */
-unsigned ext4_init_inode_bitmap(struct super_block *sb,
-				struct buffer_head *bh, int block_group,
+unsigned ext4_init_inode_bitmap(struct super_block *sb, struct buffer_head *bh,
+				ext4_grpnum_t block_group,
 				struct ext4_group_desc *gdp)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -75,7 +75,7 @@
 	/* If checksum is bad mark all blocks and inodes use to prevent
 	 * allocation, essentially implementing a per-group read-only flag. */
 	if (!ext4_group_desc_csum_verify(sbi, block_group, gdp)) {
-		ext4_error(sb, __FUNCTION__, "Checksum bad for group %u\n",
+		ext4_error(sb, __FUNCTION__, "Checksum bad for group %lu\n",
 			   block_group);
 		gdp->bg_free_blocks_count = 0;
 		gdp->bg_free_inodes_count = 0;
@@ -98,7 +98,7 @@
  * Return buffer_head of bitmap on success or NULL.
  */
 static struct buffer_head *
-read_inode_bitmap(struct super_block * sb, unsigned long block_group)
+read_inode_bitmap(struct super_block *sb, ext4_grpnum_t block_group)
 {
 	struct ext4_group_desc *desc;
 	struct buffer_head *bh = NULL;
@@ -152,7 +152,7 @@
 	unsigned long ino;
 	struct buffer_head *bitmap_bh = NULL;
 	struct buffer_head *bh2;
-	unsigned long block_group;
+	ext4_grpnum_t block_group;
 	unsigned long bit;
 	struct ext4_group_desc * gdp;
 	struct ext4_super_block * es;
@@ -260,13 +260,13 @@
  * For other inodes, search forward from the parent directory\'s block
  * group to find a free inode.
  */
-static int find_group_dir(struct super_block *sb, struct inode *parent)
+static ext4_grpnum_t find_group_dir(struct super_block *sb, struct inode *parent)
 {
-	int ngroups = EXT4_SB(sb)->s_groups_count;
+	ext4_grpnum_t ngroups = EXT4_SB(sb)->s_groups_count;
 	unsigned int freei, avefreei;
 	struct ext4_group_desc *desc, *best_desc = NULL;
 	struct buffer_head *bh;
-	int group, best_group = -1;
+	ext4_grpnum_t group, best_group = -1;
 
 	freei = percpu_counter_read_positive(&EXT4_SB(sb)->s_freeinodes_counter);
 	avefreei = freei / ngroups;
@@ -315,12 +315,12 @@
 #define INODE_COST 64
 #define BLOCK_COST 256
 
-static int find_group_orlov(struct super_block *sb, struct inode *parent)
+static ext4_grpnum_t find_group_orlov(struct super_block *sb, struct inode *parent)
 {
-	int parent_group = EXT4_I(parent)->i_block_group;
+	ext4_grpnum_t parent_group = EXT4_I(parent)->i_block_group;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
-	int ngroups = sbi->s_groups_count;
+	ext4_grpnum_t ngroups = sbi->s_groups_count;
 	int inodes_per_group = EXT4_INODES_PER_GROUP(sb);
 	unsigned int freei, avefreei;
 	ext4_fsblk_t freeb, avefreeb;
@@ -328,7 +328,7 @@
 	unsigned int ndirs;
 	int max_debt, max_dirs, min_inodes;
 	ext4_grpblk_t min_blocks;
-	int group = -1, i;
+	ext4_grpnum_t group = -1, i;
 	struct ext4_group_desc *desc;
 	struct buffer_head *bh;
 
@@ -342,7 +342,7 @@
 	if ((parent == sb->s_root->d_inode) ||
 	    (EXT4_I(parent)->i_flags & EXT4_TOPDIR_FL)) {
 		int best_ndir = inodes_per_group;
-		int best_group = -1;
+		ext4_grpnum_t best_group = -1;
 
 		get_random_bytes(&group, sizeof(group));
 		parent_group = (unsigned)group % ngroups;
@@ -417,13 +417,13 @@
 	return -1;
 }
 
-static int find_group_other(struct super_block *sb, struct inode *parent)
+static ext4_grpnum_t find_group_other(struct super_block *sb, struct inode *parent)
 {
-	int parent_group = EXT4_I(parent)->i_block_group;
-	int ngroups = EXT4_SB(sb)->s_groups_count;
+	ext4_grpnum_t parent_group = EXT4_I(parent)->i_block_group;
+	ext4_grpnum_t ngroups = EXT4_SB(sb)->s_groups_count;
 	struct ext4_group_desc *desc;
 	struct buffer_head *bh;
-	int group, i;
+	ext4_grpnum_t group, i;
 
 	/*
 	 * Try to place the inode in its parent directory
@@ -490,7 +490,7 @@
 	struct super_block *sb;
 	struct buffer_head *bitmap_bh = NULL;
 	struct buffer_head *bh2;
-	int group;
+	ext4_grpnum_t group;
 	unsigned long ino = 0;
 	struct inode * inode;
 	struct ext4_group_desc * gdp = NULL;
@@ -586,7 +586,7 @@
 	    ino > EXT4_INODES_PER_GROUP(sb)) {
 		ext4_error(sb, __FUNCTION__,
 			   "reserved inode or inode > inodes count - "
-			   "block_group = %d, inode=%lu", group,
+			   "block_group = %lu, inode=%lu", group,
 			   ino + group * EXT4_INODES_PER_GROUP(sb));
 		err = -EIO;
 		goto fail;
@@ -780,7 +780,7 @@
 struct inode *ext4_orphan_get(struct super_block *sb, unsigned long ino)
 {
 	unsigned long max_ino = le32_to_cpu(EXT4_SB(sb)->s_es->s_inodes_count);
-	unsigned long block_group;
+	ext4_grpnum_t block_group;
 	int bit;
 	struct buffer_head *bitmap_bh = NULL;
 	struct inode *inode = NULL;
@@ -836,7 +836,7 @@
 {
 	unsigned long desc_count;
 	struct ext4_group_desc *gdp;
-	int i;
+	ext4_grpnum_t i;
 #ifdef EXT4FS_DEBUG
 	struct ext4_super_block *es;
 	unsigned long bitmap_count, x;
@@ -882,7 +882,7 @@
 unsigned long ext4_count_dirs (struct super_block * sb)
 {
 	unsigned long count = 0;
-	int i;
+	ext4_grpnum_t i;
 
 	for (i = 0; i < EXT4_SB(sb)->s_groups_count; i++) {
 		struct ext4_group_desc *gdp = ext4_get_group_desc (sb, i, NULL);
Index: linux-2.6.23-rc8-new/fs/ext4/inode.c
===================================================================
--- linux-2.6.23-rc8-new.orig/fs/ext4/inode.c	2007-10-01 15:14:19.000000000 -0700
+++ linux-2.6.23-rc8-new/fs/ext4/inode.c	2007-10-01 15:14:38.000000000 -0700
@@ -2501,7 +2501,8 @@
 static ext4_fsblk_t ext4_get_inode_block(struct super_block *sb,
 		unsigned long ino, struct ext4_iloc *iloc)
 {
-	unsigned long desc, group_desc, block_group;
+	unsigned long desc, group_desc;
+	ext4_grpnum_t block_group;
 	unsigned long offset;
 	ext4_fsblk_t block;
 	struct buffer_head *bh;
@@ -2588,7 +2589,7 @@
 			struct ext4_group_desc *desc;
 			int inodes_per_buffer;
 			int inode_offset, i;
-			int block_group;
+			ext4_grpnum_t block_group;
 			int start;
 
 			block_group = (inode->i_ino - 1) /
Index: linux-2.6.23-rc8-new/fs/ext4/resize.c
===================================================================
--- linux-2.6.23-rc8-new.orig/fs/ext4/resize.c	2007-10-01 15:14:19.000000000 -0700
+++ linux-2.6.23-rc8-new/fs/ext4/resize.c	2007-10-01 15:14:38.000000000 -0700
@@ -28,7 +28,7 @@
 	struct ext4_super_block *es = sbi->s_es;
 	ext4_fsblk_t start = ext4_blocks_count(es);
 	ext4_fsblk_t end = start + input->blocks_count;
-	unsigned group = input->group;
+	ext4_grpnum_t group = input->group;
 	ext4_fsblk_t itend = input->inode_table + sbi->s_itb_per_group;
 	unsigned overhead = ext4_bg_has_super(sb, group) ?
 		(1 + ext4_bg_num_gdb(sb, group) +
@@ -336,7 +336,7 @@
 			       struct buffer_head *primary)
 {
 	const ext4_fsblk_t blk = primary->b_blocknr;
-	const unsigned long end = EXT4_SB(sb)->s_groups_count;
+	const ext4_grpnum_t end = EXT4_SB(sb)->s_groups_count;
 	unsigned three = 1;
 	unsigned five = 5;
 	unsigned seven = 7;
@@ -635,12 +635,12 @@
 			   int blk_off, char *data, int size)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	const unsigned long last = sbi->s_groups_count;
+	const ext4_grpnum_t last = sbi->s_groups_count;
 	const int bpg = EXT4_BLOCKS_PER_GROUP(sb);
 	unsigned three = 1;
 	unsigned five = 5;
 	unsigned seven = 7;
-	unsigned group;
+	ext4_grpnum_t group;
 	int rest = sb->s_blocksize - size;
 	handle_t *handle;
 	int err = 0, err2;
@@ -695,7 +695,7 @@
 exit_err:
 	if (err) {
 		ext4_warning(sb, __FUNCTION__,
-			     "can't update backup for group %d (err %d), "
+			     "can't update backup for group %lu (err %d), "
 			     "forcing fsck on next reboot", group, err);
 		sbi->s_mount_state &= ~EXT4_VALID_FS;
 		sbi->s_es->s_state &= cpu_to_le16(~EXT4_VALID_FS);
@@ -931,7 +931,7 @@
 		      ext4_fsblk_t n_blocks_count)
 {
 	ext4_fsblk_t o_blocks_count;
-	unsigned long o_groups_count;
+	ext4_grpnum_t o_groups_count;
 	ext4_grpblk_t last;
 	ext4_grpblk_t add;
 	struct buffer_head * bh;
Index: linux-2.6.23-rc8-new/fs/ext4/super.c
===================================================================
--- linux-2.6.23-rc8-new.orig/fs/ext4/super.c	2007-10-01 15:14:19.000000000 -0700
+++ linux-2.6.23-rc8-new/fs/ext4/super.c	2007-10-01 15:14:38.000000000 -0700
@@ -1322,7 +1322,7 @@
 	struct ext4_group_desc * gdp = NULL;
 	int desc_block = 0;
 	int flexbg_flag = 0;
-	int i;
+	ext4_grpnum_t i;
 
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
 		flexbg_flag = 1;
@@ -1344,7 +1344,7 @@
 		if (block_bitmap < first_block || block_bitmap > last_block)
 		{
 			ext4_error (sb, "ext4_check_descriptors",
-				    "Block bitmap for group %d"
+				    "Block bitmap for group %lu"
 				    " not in group (block %llu)!",
 				    i, block_bitmap);
 			return 0;
@@ -1353,7 +1353,7 @@
 		if (inode_bitmap < first_block || inode_bitmap > last_block)
 		{
 			ext4_error (sb, "ext4_check_descriptors",
-				    "Inode bitmap for group %d"
+				    "Inode bitmap for group %lu"
 				    " not in group (block %llu)!",
 				    i, inode_bitmap);
 			return 0;
@@ -1363,17 +1363,16 @@
 		    inode_table + sbi->s_itb_per_group - 1 > last_block)
 		{
 			ext4_error (sb, "ext4_check_descriptors",
-				    "Inode table for group %d"
+				    "Inode table for group %lu"
 				    " not in group (block %llu)!",
 				    i, inode_table);
 			return 0;
 		}
 		if (!ext4_group_desc_csum_verify(sbi, i, gdp)) {
 			ext4_error(sb, __FUNCTION__,
-				   "Checksum for group %d failed (%u!=%u)\n", i,
-				   le16_to_cpu(ext4_group_desc_csum(sbi, i,
-								    gdp)),
-				   le16_to_cpu(gdp->bg_checksum));
+				   "Checksum for group %lu failed (%u!=%u)\n",
+				    i, le16_to_cpu(ext4_group_desc_csum(sbi, i,
+				    gdp)), le16_to_cpu(gdp->bg_checksum));
 			return 0;
 		}
 		if (!flexbg_flag)
@@ -1387,7 +1386,6 @@
 	return 1;
 }
 
-
 /* ext4_orphan_cleanup() walks a singly-linked list of inodes (starting at
  * the superblock) which were deleted from all directories, but held open by
  * a process at the time of a crash.  We walk the list and try to delete these
@@ -1530,7 +1528,7 @@
 				ext4_fsblk_t logical_sb_block, int nr)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	unsigned long bg, first_meta_bg;
+	ext4_grpnum_t bg, first_meta_bg;
 	int has_super = 0;
 
 	first_meta_bg = le32_to_cpu(sbi->s_es->s_first_meta_bg);
@@ -2644,7 +2642,7 @@
 	if (test_opt(sb, MINIX_DF)) {
 		sbi->s_overhead_last = 0;
 	} else if (sbi->s_blocks_last != le32_to_cpu(es->s_blocks_count)) {
-		unsigned long ngroups = sbi->s_groups_count, i;
+		ext4_grpnum_t ngroups = sbi->s_groups_count, i;
 		ext4_fsblk_t overhead = 0;
 		smp_rmb();
 
Index: linux-2.6.23-rc8-new/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.23-rc8-new.orig/include/linux/ext4_fs.h	2007-10-01 15:14:19.000000000 -0700
+++ linux-2.6.23-rc8-new/include/linux/ext4_fs.h	2007-10-01 15:14:38.000000000 -0700
@@ -875,7 +875,7 @@
 {
 	struct buffer_head *bh;
 	unsigned long offset;
-	unsigned long block_group;
+	ext4_grpnum_t block_group;
 };
 
 static inline struct ext4_inode *ext4_raw_inode(struct ext4_iloc *iloc)
@@ -900,7 +900,7 @@
 
 /* calculate the first block number of the group */
 static inline ext4_fsblk_t
-ext4_group_first_block_no(struct super_block *sb, unsigned long group_no)
+ext4_group_first_block_no(struct super_block *sb, ext4_grpnum_t group_no)
 {
 	return group_no * (ext4_fsblk_t)EXT4_BLOCKS_PER_GROUP(sb) +
 		le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block);
@@ -931,8 +931,9 @@
 			ext4_fsblk_t blocknr);
 extern ext4_grpblk_t ext4_block_group_offset(struct super_block *sb,
 			ext4_fsblk_t blocknr);
-extern int ext4_bg_has_super(struct super_block *sb, int group);
-extern unsigned long ext4_bg_num_gdb(struct super_block *sb, int group);
+extern int ext4_bg_has_super(struct super_block *sb, ext4_grpnum_t group);
+extern unsigned long ext4_bg_num_gdb(struct super_block *sb,
+			ext4_grpnum_t group);
 extern ext4_fsblk_t ext4_new_block (handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, int *errp);
 extern ext4_fsblk_t ext4_new_blocks (handle_t *handle, struct inode *inode,
@@ -945,7 +946,7 @@
 extern ext4_fsblk_t ext4_count_free_blocks (struct super_block *);
 extern void ext4_check_blocks_bitmap (struct super_block *);
 extern struct ext4_group_desc * ext4_get_group_desc(struct super_block * sb,
-						    unsigned int block_group,
+						    ext4_grpnum_t block_group,
 						    struct buffer_head ** bh);
 extern int ext4_should_retry_alloc(struct super_block *sb, int *retries);
 extern void ext4_init_block_alloc_info(struct inode *);
Index: linux-2.6.23-rc8-new/include/linux/ext4_fs_i.h
===================================================================
--- linux-2.6.23-rc8-new.orig/include/linux/ext4_fs_i.h	2007-10-01 15:14:19.000000000 -0700
+++ linux-2.6.23-rc8-new/include/linux/ext4_fs_i.h	2007-10-01 15:14:38.000000000 -0700
@@ -27,6 +27,9 @@
 /* data type for filesystem-wide blocks number */
 typedef unsigned long long ext4_fsblk_t;
 
+/* data type for block group number */
+typedef unsigned long ext4_grpnum_t;
+
 struct ext4_reserve_window {
 	ext4_fsblk_t	_rsv_start;	/* First byte reserved */
 	ext4_fsblk_t	_rsv_end;	/* Last byte reserved or 0 */
@@ -89,7 +92,7 @@
 	 * place a file's data blocks near its inode block, and new inodes
 	 * near to their parent directory's inode.
 	 */
-	__u32	i_block_group;
+	ext4_grpnum_t	i_block_group;
 	__u32	i_state;		/* Dynamic state flags for ext4 */
 
 	/* block reservation info */
Index: linux-2.6.23-rc8-new/include/linux/ext4_fs_sb.h
===================================================================
--- linux-2.6.23-rc8-new.orig/include/linux/ext4_fs_sb.h	2007-10-01 15:14:19.000000000 -0700
+++ linux-2.6.23-rc8-new/include/linux/ext4_fs_sb.h	2007-10-01 15:14:38.000000000 -0700
@@ -35,7 +35,7 @@
 	unsigned long s_itb_per_group;	/* Number of inode table blocks per group */
 	unsigned long s_gdb_count;	/* Number of group descriptor blocks */
 	unsigned long s_desc_per_block;	/* Number of group descriptors per block */
-	unsigned long s_groups_count;	/* Number of groups in the fs */
+	ext4_grpnum_t s_groups_count;	/* Number of groups in the fs */
 	unsigned long s_overhead_last;  /* Last calculated overhead */
 	unsigned long s_blocks_last;    /* Last seen block count */
 	struct buffer_head * s_sbh;	/* Buffer containing the super block */
Index: linux-2.6.23-rc8-new/fs/ext4/group.h
===================================================================
--- linux-2.6.23-rc8-new.orig/fs/ext4/group.h	2007-10-01 15:14:19.000000000 -0700
+++ linux-2.6.23-rc8-new/fs/ext4/group.h	2007-10-01 15:14:38.000000000 -0700
@@ -17,13 +17,15 @@
 extern int ext4_group_desc_csum_verify(struct ext4_sb_info *sbi, __u32 group,
 				       struct ext4_group_desc *gdp);
 struct buffer_head *read_block_bitmap(struct super_block *sb,
-				      unsigned int block_group);
+				      ext4_grpnum_t block_group);
 extern unsigned ext4_init_block_bitmap(struct super_block *sb,
-				       struct buffer_head *bh, int group,
+				       struct buffer_head *bh,
+				       ext4_grpnum_t group,
 				       struct ext4_group_desc *desc);
 #define ext4_free_blocks_after_init(sb, group, desc)			\
 		ext4_init_block_bitmap(sb, NULL, group, desc)
 extern unsigned ext4_init_inode_bitmap(struct super_block *sb,
-				       struct buffer_head *bh, int group,
+				       struct buffer_head *bh,
+				       ext4_grpnum_t group,
 				       struct ext4_group_desc *desc);
 #endif /* _LINUX_EXT4_GROUP_H */
