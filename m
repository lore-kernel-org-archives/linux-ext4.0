From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [RFC][PATCH 1/7]ext4: Add EXT4_IOC_ADD_GLOBAL_ALLOC_RULE restricts
 block allocation
Date: Tue, 23 Jun 2009 17:25:12 +0900
Message-ID: <4A409168.3020404@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext4: Add EXT4_IOC_ADD_GLOBAL_ALLOC_RULE restricts block allocation

From: Akira Fujita <a-fujita@rs.jp.nec.com>

This ioctl adds block allocation restriction to FS where fd is located in
with EXT4_IOC_ADD_GLOBAL_ALLOC_RULE.

  #define EXT4_IOC_ADD_GLOBAL_ALLOC_RULE _IOW('f', 16, struct ext4_alloc_rule);

  struct ext4_alloc_rule {
        __u64 start;            /* first physical block this rule covers */
        __u64 len;              /* number of blocks covered by this rule */
        __u32 alloc_flag;       /* 0:mandatory, 1:advisory */
  };

  Note: We can not set multiple block allocation restriction rules
        to same block.

alloc_flag of ext4_alloc_rule structure is set as "mandatory" or "advisory".
Restricted blocks with "mandatory" are never used by block allocator.
But in "advisory" case, block allocator is allowed to use restricted blocks
when there are no free blocks on FS.
 	 	
How to manage block allocation restriction:
ext4_sb_info->s_bg_arule_list has ext4_bg_alloc_rule_list structure
which managements the information of restricted blocks for each block group
as list structure.
 	
  ext4_sb_info
        |
  s_bg_arule_list ->[   bg1   ]->[   bg5   ] (struct ext4_bg_alloc_rule_list)
                        |             |
                    start:end    start:end
                    [   0:2000]  [8000:9000] (struct ext4_bg_alloc_rule)
                    [3000:3500]
                    [6000:8000]                  blocksize is 4096

Used block count with block allocation restriction:
ext4_bg_alloc_rule_list has two counters (mand_restricted_blks and
adv_restricted_blks) that hold how many blocks are restricted by mandatory
or advisory.  Only the mand_restricted_blks counter affects to
FS free blocks, since blocks with advisory will be used
when there is no other free blocks to use.

  For example, when block allocation restriction is set as follows,
  mand_restricted_blks is 3000 and adv_restricted_blks is 2000,
  therefore FS's free blocks becomes 2192 (6000-8191) in this case.


  block_per_group:                 8192
  used blocks:                      3000-5999
  free blocks:                     0-2999, 6000-8191
  allocation rule(mandatory):      0-3999
  allocation rule(advisory) :      5000-7999

  BG n |------------------------------|
       0                              8191
  used |         |-----------|        |
       0         3000     5999
  free |---------|           |--------|
       0      2999           6000     8191
  mand |**********----|
       0           3999
  adv                     |--+++++++++|
                          5000     7999

  mand_restricted_blks (*) is where "free" and "mand" overlap.
  adv_restricted_blks (+) is where "free" and "adv" overlap.


Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 fs/ext4/balloc.c  |   22 ++-
 fs/ext4/ext4.h    |   37 +++++-
 fs/ext4/ioctl.c   |   16 ++
 fs/ext4/mballoc.c |  438 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/ext4/super.c   |    9 +-
 5 files changed, 512 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index e2126d7..7f08069 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -546,35 +546,45 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
  */
 int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nblocks)
 {
-	s64 free_blocks, dirty_blocks, root_blocks;
+	s64 free_blocks, dirty_blocks, root_blocks, restricted_blocks;
 	struct percpu_counter *fbc = &sbi->s_freeblocks_counter;
 	struct percpu_counter *dbc = &sbi->s_dirtyblocks_counter;
+	struct percpu_counter *rbc = &sbi->s_restricted_blocks_counter;

 	free_blocks  = percpu_counter_read_positive(fbc);
 	dirty_blocks = percpu_counter_read_positive(dbc);
+	restricted_blocks = percpu_counter_read_positive(rbc);
 	root_blocks = ext4_r_blocks_count(sbi->s_es);

-	if (free_blocks - (nblocks + root_blocks + dirty_blocks) <
-						EXT4_FREEBLOCKS_WATERMARK) {
+	if (free_blocks - (nblocks + root_blocks + dirty_blocks +
+	    restricted_blocks) < EXT4_FREEBLOCKS_WATERMARK) {
 		free_blocks  = percpu_counter_sum_positive(fbc);
 		dirty_blocks = percpu_counter_sum_positive(dbc);
+		restricted_blocks = percpu_counter_sum_positive(rbc);
 		if (dirty_blocks < 0) {
 			printk(KERN_CRIT "Dirty block accounting "
 					"went wrong %lld\n",
 					(long long)dirty_blocks);
 		}
+		if (restricted_blocks < 0) {
+			printk(KERN_CRIT "Restricted block accounting "
+					"went wrong %lld\n",
+					(long long)restricted_blocks);
+		}
 	}
 	/* Check whether we have space after
-	 * accounting for current dirty blocks & root reserved blocks.
+	 * accounting for current dirty blocks, root reserved blocks
+	 * and allocation-restricted blocks.
 	 */
-	if (free_blocks >= ((root_blocks + nblocks) + dirty_blocks))
+	if (free_blocks >= ((root_blocks + nblocks) +
+	    dirty_blocks + restricted_blocks))
 		return 1;

 	/* Hm, nope.  Are (enough) root reserved blocks available? */
 	if (sbi->s_resuid == current_fsuid() ||
 	    ((sbi->s_resgid != 0) && in_group_p(sbi->s_resgid)) ||
 	    capable(CAP_SYS_RESOURCE)) {
-		if (free_blocks >= (nblocks + dirty_blocks))
+		if (free_blocks >= (nblocks + dirty_blocks + restricted_blocks))
 			return 1;
 	}

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 0ca49f4..1d2d550 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -88,7 +88,10 @@ typedef unsigned int ext4_group_t;
 #define EXT4_MB_HINT_TRY_GOAL		512
 /* blocks already pre-reserved by delayed allocation */
 #define EXT4_MB_DELALLOC_RESERVED      1024
-
+/* some part of filesystems are in-allocatable */
+#define EXT4_MB_BLOCKS_RESTRICTED      2048
+/* use in-allocatable blocks that have advisory flag */
+#define EXT4_MB_ALLOC_ADVISORY	       4096

 struct ext4_allocation_request {
 	/* target inode for block we're allocating */
@@ -353,6 +356,7 @@ struct ext4_new_group_data {
  /* note ioctl 11 reserved for filesystem-independent FIEMAP ioctl */
 #define EXT4_IOC_ALLOC_DA_BLKS		_IO('f', 12)
 #define EXT4_IOC_MOVE_EXT		_IOWR('f', 15, struct move_extent)
+#define EXT4_IOC_ADD_GLOBAL_ALLOC_RULE	_IOW('f', 16, struct ext4_alloc_rule)

 /*
  * ioctl commands in 32 bit emulation
@@ -373,6 +377,31 @@ struct ext4_new_group_data {

 #define EXT4_IOC_DEBUG_DELALLOC		_IO('f', 42)

+#define EXT4_MB_ALLOC_RULE_MANDATORY	0
+#define EXT4_MB_ALLOC_RULE_ADVISORY	1
+
+struct ext4_alloc_rule {
+	__u64 start;		/* first physical block this rule covers */
+	__u64 len;		/* number of blocks covered by this rule */
+	__u32 alloc_flag;	/* mandatory...0 advisory...1 */
+};
+
+struct ext4_bg_alloc_rule_list {
+	struct list_head bg_arule_list;	/* blockgroup list */
+	ext4_group_t bg_num;		/* blockgroup number */
+	ext4_grpblk_t mand_restricted_blks; /* number of the restricted blocks by mandatory allocation rule */
+	ext4_grpblk_t adv_restricted_blks;  /* number of the restricted blocks by advisory allocation rule */
+	struct list_head arule_list;	/* the range in the blockgroup */
+};
+
+struct ext4_bg_alloc_rule {
+	struct list_head arule_list;	/* the range in the blockgroup */
+	struct list_head tmp_list;	/* to add ext4_alloc_rule */
+	ext4_grpblk_t start;		/* allocate start block */
+	ext4_grpblk_t end;		/* allocate end block */
+	int alloc_flag;			/* 0(mandatory) or 1(advisory) */
+};
+
 /*
  *  Mount options
  */
@@ -877,6 +906,7 @@ struct ext4_sb_info {
 	struct percpu_counter s_dirs_counter;
 	struct percpu_counter s_dirtyblocks_counter;
 	struct blockgroup_lock *s_blockgroup_lock;
+	struct percpu_counter s_restricted_blocks_counter;
 	struct proc_dir_entry *s_proc;
 	struct kobject s_kobj;
 	struct completion s_kobj_unregister;
@@ -967,6 +997,9 @@ struct ext4_sb_info {

 	unsigned int s_log_groups_per_flex;
 	struct flex_groups *s_flex_groups;
+
+	rwlock_t s_bg_arule_lock;
+	struct list_head s_bg_arule_list;
 };

 static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
@@ -1352,6 +1385,8 @@ extern void ext4_mb_update_group_info(struct ext4_group_info *grp,
 extern int ext4_mb_get_buddy_cache_lock(struct super_block *, ext4_group_t);
 extern void ext4_mb_put_buddy_cache_lock(struct super_block *,
 						ext4_group_t, int);
+extern int ext4_mb_add_global_arule(struct inode *, struct ext4_alloc_rule *);
+
 /* inode.c */
 int ext4_forget(handle_t *handle, int is_metadata, struct inode *inode,
 		struct buffer_head *bh, ext4_fsblk_t blocknr);
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index a0edf61..8505e3a 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -260,6 +260,22 @@ setversion_out:
 		return err;
 	}

+	case EXT4_IOC_ADD_GLOBAL_ALLOC_RULE: {
+		struct ext4_alloc_rule arule;
+		int err;
+
+		if (copy_from_user(&arule,
+				(struct ext4_alloc_rule __user *)arg,
+				sizeof(arule)))
+			return -EFAULT;
+
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
+
+		err = ext4_mb_add_global_arule(inode, &arule);
+		return err;
+	}
+
 	case EXT4_IOC_GROUP_ADD: {
 		struct ext4_new_group_data input;
 		struct super_block *sb = inode->i_sb;
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 519a0a6..0719900 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1188,6 +1188,120 @@ static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 	mb_check_buddy(e4b);
 }

+/*
+ * Find a pointer to ext4_bg_alloc_rule_list that indicates @bg,
+ * and set it to @ret_list.
+ * If there is no entry, return NULL.
+ */
+static void mb_arule_find_group(struct ext4_sb_info *sbi,
+		struct ext4_bg_alloc_rule_list **ret_list, ext4_group_t bg)
+{
+	struct list_head *arule_head = &sbi->s_bg_arule_list;
+	struct ext4_bg_alloc_rule_list *pos, *n;
+
+	*ret_list = NULL;
+	list_for_each_entry_safe(pos, n, arule_head, bg_arule_list) {
+		if (pos->bg_num > bg)
+			return;
+		else if (pos->bg_num == bg) {
+			*ret_list = pos;
+			return;
+		}
+	}
+}
+
+static ext4_grpblk_t
+ext4_mb_count_unused_blocks(void *bd_bitmap, ext4_grpblk_t start,
+				ext4_grpblk_t end) {
+	ext4_grpblk_t i, blocks = 0;
+
+	for (i = start; i <= end; i++) {
+		if (!mb_test_bit(i, bd_bitmap))
+			blocks++;
+	}
+	return blocks;
+}
+
+static void
+__mb_arule_count_overlap(struct ext4_buddy *e4b,
+			struct ext4_bg_alloc_rule_list *arule,
+			ext4_grpblk_t start, int len,
+			ext4_grpblk_t *mand_blocks, ext4_grpblk_t *adv_blocks)
+{
+	struct list_head *arule_head = &arule->arule_list;
+	struct ext4_bg_alloc_rule *pos, *n;
+	ext4_grpblk_t end, search_start, search_end, overlap;
+
+	*mand_blocks = 0;
+	*adv_blocks = 0;
+
+	search_start = start;
+	search_end = start + len - 1;
+	end = search_end;
+	list_for_each_entry_safe(pos, n, arule_head, arule_list) {
+
+		if (pos->start > end)
+			return;
+
+		if (pos->start <= end && pos->end >= start) {
+			search_start = start < pos->start ? pos->start :
+								   start;
+			search_end = end > pos->end ? pos->end : end;
+			overlap = search_end - search_start + 1 -
+				  ext4_mb_count_unused_blocks(e4b->bd_bitmap,
+						search_start, search_end);
+			if (pos->alloc_flag == EXT4_MB_ALLOC_RULE_ADVISORY)
+				*adv_blocks += overlap;
+			else
+				*mand_blocks += overlap;
+		}
+	}
+}
+
+/*
+ * Count the number of blocks that on the unallocatable space from @start to
+ * @start + @len.
+ * If there is overlap. @mand_blocks or/and @adv_blocks are changed.
+ */
+static void
+mb_arule_count_overlap(struct ext4_allocation_context *ac,
+			struct ext4_buddy *e4b, ext4_group_t bg,
+			ext4_grpblk_t start, int len,
+			ext4_grpblk_t *mand_blocks, ext4_grpblk_t *adv_blocks)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_inode->i_sb);
+	struct ext4_bg_alloc_rule_list *target_bg_list = NULL;
+
+	if (!(ac->ac_flags & EXT4_MB_BLOCKS_RESTRICTED))
+		return;
+
+	read_lock(&sbi->s_bg_arule_lock);
+	mb_arule_find_group(sbi, &target_bg_list, bg);
+	if (target_bg_list == NULL) {
+		read_unlock(&sbi->s_bg_arule_lock);
+		return;
+	}
+
+	__mb_arule_count_overlap(e4b, target_bg_list, start, len,
+				mand_blocks, adv_blocks);
+	read_unlock(&sbi->s_bg_arule_lock);
+}
+
+static void
+ext4_mb_calc_restricted(struct ext4_sb_info *sbi,
+			struct ext4_bg_alloc_rule_list **arule_list,
+			int alloc_flag,
+			ext4_grpblk_t restricted)
+{
+	if (alloc_flag == EXT4_MB_ALLOC_RULE_ADVISORY)
+		(*arule_list)->adv_restricted_blks += restricted;
+	else {
+		(*arule_list)->mand_restricted_blks += restricted;
+		percpu_counter_add(&sbi->s_restricted_blocks_counter,
+				(s64)restricted);
+	}
+}
+
 static int mb_find_extent(struct ext4_buddy *e4b, int order, int block,
 				int needed, struct ext4_free_extent *ex)
 {
@@ -2733,6 +2847,9 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
 	if (sbi->s_journal)
 		sbi->s_journal->j_commit_callback = release_blocks_on_commit;

+	rwlock_init(&sbi->s_bg_arule_lock);
+	INIT_LIST_HEAD(&sbi->s_bg_arule_list);
+
 	printk(KERN_INFO "EXT4-fs: mballoc enabled\n");
 	return 0;
 }
@@ -4698,13 +4815,14 @@ void ext4_mb_free_blocks(handle_t *handle, struct inode *inode,
 	struct ext4_group_desc *gdp;
 	struct ext4_super_block *es;
 	unsigned int overflow;
-	ext4_grpblk_t bit;
+	ext4_grpblk_t bit, mand_blocks = 0, adv_blocks = 0;
 	struct buffer_head *gd_bh;
 	ext4_group_t block_group;
 	struct ext4_sb_info *sbi;
 	struct ext4_buddy e4b;
 	int err = 0;
 	int ret;
+	struct ext4_bg_alloc_rule_list *ret_list = NULL;

 	*freed = 0;

@@ -4797,6 +4915,19 @@ do_more:
 	err = ext4_mb_load_buddy(sb, block_group, &e4b);
 	if (err)
 		goto error_return;
+
+	ext4_lock_group(sb, block_group);
+	if (!list_empty(&EXT4_SB(sb)->s_bg_arule_list)) {
+		/*
+		 * Count up the num of blocks overlap with unallocatable
+		 * range.
+		 */
+		ac->ac_flags |= EXT4_MB_BLOCKS_RESTRICTED;
+		mb_arule_count_overlap(ac, &e4b, block_group, bit, count,
+					&mand_blocks, &adv_blocks);
+	}
+	ext4_unlock_group(sb, block_group);
+
 	if (metadata && ext4_handle_valid(handle)) {
 		struct ext4_free_data *new_entry;
 		/*
@@ -4823,11 +4954,28 @@ do_more:
 		ext4_mb_return_to_preallocation(inode, &e4b, block, count);
 	}

+	/* Modify the number of restricted blocks */
+	if (mand_blocks || adv_blocks) {
+		read_lock(&EXT4_SB(sb)->s_bg_arule_lock);
+		mb_arule_find_group(EXT4_SB(sb), &ret_list, e4b.bd_group);
+		if (ret_list != NULL) {
+			if (mand_blocks)
+				ext4_mb_calc_restricted(sbi, &ret_list,
+						EXT4_MB_ALLOC_RULE_MANDATORY,
+						(s64)mand_blocks);
+			if (adv_blocks)
+				ext4_mb_calc_restricted(sbi, &ret_list,
+						EXT4_MB_ALLOC_RULE_ADVISORY,
+						(s64)adv_blocks);
+		}
+		read_unlock(&EXT4_SB(sb)->s_bg_arule_lock);
+	}
+
 	ret = ext4_free_blks_count(sb, gdp) + count;
 	ext4_free_blks_set(sb, gdp, ret);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
 	ext4_unlock_group(sb, block_group);
-	percpu_counter_add(&sbi->s_freeblocks_counter, count);
+	percpu_counter_add(&sbi->s_freeblocks_counter, (s64)count);

 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, block_group);
@@ -4862,3 +5010,289 @@ error_return:
 		kmem_cache_free(ext4_ac_cachep, ac);
 	return;
 }
+
+static void ext4_mb_release_tmp_list(struct list_head *list,
+						struct ext4_sb_info *sbi)
+{
+	struct ext4_bg_alloc_rule_list *bg_arule_list, *tmp_arule_list;
+	struct ext4_bg_alloc_rule *bg_arule, *tmp_arule;
+
+	list_for_each_entry_safe(bg_arule, tmp_arule, list, tmp_list) {
+		list_del(&bg_arule->arule_list);
+		list_del(&bg_arule->tmp_list);
+		kfree(bg_arule);
+		bg_arule = NULL;
+	}
+
+	list_for_each_entry_safe(bg_arule_list, tmp_arule_list,
+				&sbi->s_bg_arule_list, bg_arule_list) {
+		if (list_empty(&bg_arule_list->arule_list)) {
+			list_del(&bg_arule_list->bg_arule_list);
+			kfree(bg_arule_list);
+			bg_arule_list = NULL;
+		}
+	}
+
+	return;
+}
+
+static int ext4_mb_check_arule(struct inode *inode,
+						struct ext4_alloc_rule *arule)
+{
+	struct super_block *sb = inode->i_sb;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	ext4_fsblk_t blocks_count = ext4_blocks_count(sbi->s_es);
+	ext4_fsblk_t first_data_block;
+
+	/* FIXME: indirect block is not supported */
+	if (!EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_EXTENTS)) {
+		ext4_debug("Not extent based file or filesystem\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (arule->len == 0) {
+		ext4_debug("Can't set len=0\n");
+		return -EINVAL;
+	}
+
+	if (arule->start >= blocks_count || arule->len > blocks_count) {
+		ext4_debug("Can't set more than %llu blocks: "
+				"start=%llu, len=%llu\n", blocks_count+1,
+				(ext4_fsblk_t)arule->start,
+				(ext4_fsblk_t)arule->len);
+		return -EINVAL;
+	}
+
+	first_data_block = le32_to_cpu(sbi->s_es->s_first_data_block);
+	if (arule->start + arule->len > blocks_count ||
+	    arule->start + arule->len - 1 < first_data_block) {
+		ext4_debug("alloc_rule shows out of FS: start+len=%llu\n",
+				(ext4_fsblk_t)(arule->start + arule->len));
+		return -EINVAL;
+	}
+
+	if (arule->alloc_flag != EXT4_MB_ALLOC_RULE_MANDATORY &&
+			arule->alloc_flag != EXT4_MB_ALLOC_RULE_ADVISORY) {
+		ext4_debug("alloc_flag should be 0 or 1: alloc_flag=%u\n",
+				(unsigned)arule->alloc_flag);
+		return -EINVAL;
+	}
+
+	/* We consider about the boot block if bs = 1k */
+	if (arule->start < first_data_block) {
+		ext4_fsblk_t diff;
+
+		printk(KERN_INFO "%s: alloc_rule->start isn't in data block."
+				 "\nThe argument is modified to cover "
+				 "[%llu:%llu]\n", __func__, first_data_block,
+						arule->start + arule->len - 1);
+		diff = first_data_block - arule->start;
+		arule->start += diff;
+		arule->len -= diff;
+	}
+
+	return 0;
+}
+
+static int
+ext4_mb_add_bg_arule(struct super_block *sb,
+			struct ext4_bg_alloc_rule_list *bg_arule_list,
+			struct ext4_bg_alloc_rule *add_arule)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_bg_alloc_rule *bg_arule, *tmp_arule;
+	struct ext4_buddy e4b;
+	ext4_group_t group_no = bg_arule_list->bg_num;
+	ext4_grpblk_t restricted_blocks;
+	int err;
+
+	err = ext4_mb_load_buddy(sb, group_no, &e4b);
+	if (err)
+		return err;
+
+	ext4_lock_group(sb, group_no);
+
+	restricted_blocks = ext4_mb_count_unused_blocks(e4b.bd_bitmap,
+					add_arule->start, add_arule->end);
+	ext4_mb_calc_restricted(sbi, &bg_arule_list, add_arule->alloc_flag,
+				restricted_blocks);
+
+	list_for_each_entry_safe(bg_arule, tmp_arule,
+				&bg_arule_list->arule_list, arule_list) {
+		if (add_arule->start == bg_arule->end + 1 &&
+		    add_arule->alloc_flag == bg_arule->alloc_flag) {
+			add_arule->start = bg_arule->start;
+			list_del(&bg_arule->arule_list);
+		} else if (add_arule->end == bg_arule->start - 1 &&
+			   add_arule->alloc_flag == bg_arule->alloc_flag) {
+			add_arule->end = bg_arule->end;
+			list_del(&bg_arule->arule_list);
+		}
+	}
+
+	list_for_each_entry_safe(bg_arule, tmp_arule,
+				&bg_arule_list->arule_list, arule_list) {
+		if (bg_arule->start > add_arule->start) {
+			list_add_tail(&add_arule->arule_list,
+						&bg_arule->arule_list);
+			break;
+		}
+		/* if bg_arule is the last entry, call list_add */
+		if (list_is_last(&bg_arule->arule_list,
+						&bg_arule_list->arule_list))
+			list_add(&add_arule->arule_list,
+						&bg_arule->arule_list);
+	}
+
+	if (list_empty(&bg_arule_list->arule_list))
+		list_add(&add_arule->arule_list, &bg_arule_list->arule_list);
+
+	ext4_unlock_group(sb, group_no);
+	ext4_mb_release_desc(&e4b);
+
+	return 0;
+}
+
+int ext4_mb_add_global_arule(struct inode *inode,
+					struct ext4_alloc_rule *arule)
+{
+	struct super_block *sb = inode->i_sb;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct percpu_counter *dbc = &sbi->s_dirtyblocks_counter;
+	struct ext4_bg_alloc_rule_list *bg_arule_list, *tmp_arule_list;
+	struct ext4_bg_alloc_rule_list *new_arule_list = NULL;
+	struct ext4_bg_alloc_rule *bg_arule, *tmp_arule, *add_arule = NULL;
+	struct list_head add_arule_list;
+	ext4_fsblk_t start, end;
+	ext4_grpblk_t bg_start = 0, bg_end = 0;
+	ext4_group_t start_bgnum, end_bgnum;
+	s64 dirty_blocks;
+	int ret, add_flag = 0;
+	unsigned long bg_size = EXT4_BLOCKS_PER_GROUP(sb);
+
+	ret = ext4_mb_check_arule(inode, arule);
+	if (ret < 0)
+		return ret;
+
+	dirty_blocks = percpu_counter_read_positive(dbc);
+	/* Confirm this arule does not violate the reserved delalloc space */
+	if (!ext4_has_free_blocks(sbi, (s64)arule->len + dirty_blocks))
+		return -ENOSPC;
+
+	start = arule->start;
+	end = arule->start + arule->len - 1;
+
+	ext4_get_group_no_and_offset(sb, start, &start_bgnum, NULL);
+	ext4_get_group_no_and_offset(sb, end, &end_bgnum, NULL);
+
+	write_lock(&sbi->s_bg_arule_lock);
+	list_for_each_entry_safe(bg_arule_list, tmp_arule_list,
+					&sbi->s_bg_arule_list, bg_arule_list) {
+		if (bg_arule_list->bg_num < start_bgnum ||
+				bg_arule_list->bg_num > end_bgnum)
+			continue;
+
+		if (start_bgnum < bg_arule_list->bg_num)
+			bg_start = 0;
+		else
+			ext4_get_group_no_and_offset(sb, start, NULL,
+							&bg_start);
+
+		if (end_bgnum > bg_arule_list->bg_num)
+			bg_end = bg_size - 1;
+		else
+			ext4_get_group_no_and_offset(sb, end, NULL, &bg_end);
+
+		list_for_each_entry_safe(bg_arule, tmp_arule,
+				&bg_arule_list->arule_list, arule_list) {
+
+			if (bg_start <= bg_arule->end &&
+						bg_end >= bg_arule->start) {
+				ext4_debug("Overlapping blocks\n");
+				ret = -EINVAL;
+				goto out;
+			} else if (bg_end < bg_arule->start)
+				break;
+		}
+	}
+
+	/* devide alloc rules per blockgroup */
+	INIT_LIST_HEAD(&add_arule_list);
+	while (start <= end) {
+		add_arule = kmalloc(sizeof(struct ext4_bg_alloc_rule),
+								GFP_KERNEL);
+		if (add_arule == NULL) {
+			ext4_mb_release_tmp_list(&add_arule_list, sbi);
+			ret = -ENOMEM;
+			goto out;
+		}
+		INIT_LIST_HEAD(&add_arule->arule_list);
+		INIT_LIST_HEAD(&add_arule->tmp_list);
+		ext4_get_group_no_and_offset(sb, start, NULL,
+						&add_arule->start);
+		add_arule->alloc_flag = arule->alloc_flag;
+		/* if end is out of bg in start, fix it */
+		if (end_bgnum > start_bgnum)
+			add_arule->end = (ext4_group_t)(bg_size - 1);
+		else
+			ext4_get_group_no_and_offset(sb, end, NULL,
+							&add_arule->end);
+
+		list_add(&add_arule->tmp_list, &add_arule_list);
+
+		list_for_each_entry_safe(bg_arule_list, tmp_arule_list,
+					&sbi->s_bg_arule_list, bg_arule_list) {
+			if (bg_arule_list->bg_num < start_bgnum)
+				continue;
+			else if (bg_arule_list->bg_num == start_bgnum) {
+				ret = ext4_mb_add_bg_arule(sb, bg_arule_list,
+						add_arule);
+				if (ret < 0)
+					goto out;
+
+				add_flag = 1;
+			}
+
+			break;
+		}
+
+		/*
+		 * If there is no goal bg_arule_list, crate new
+		 * bg_arule_list.
+		 */
+		if (!add_flag) {
+			new_arule_list = kmalloc(
+					sizeof(struct ext4_bg_alloc_rule_list),
+					GFP_KERNEL);
+			if (new_arule_list == NULL) {
+				ext4_mb_release_tmp_list(&add_arule_list, sbi);
+				ret = -ENOMEM;
+				goto out;
+			}
+			/* init new bg_alloc_rule_list */
+			INIT_LIST_HEAD(&new_arule_list->bg_arule_list);
+			INIT_LIST_HEAD(&new_arule_list->arule_list);
+			new_arule_list->bg_num = start_bgnum;
+			new_arule_list->mand_restricted_blks = 0;
+			new_arule_list->adv_restricted_blks = 0;
+
+			ret = ext4_mb_add_bg_arule(sb,
+						new_arule_list, add_arule);
+			if (ret < 0)
+				goto out;
+
+			/* add new bg_alloc_rule_list to sbi */
+			list_add_tail(&new_arule_list->bg_arule_list,
+					&bg_arule_list->bg_arule_list);
+		}
+
+		/* set next bg's start block number */
+		start_bgnum++;
+		start = ext4_group_first_block_no(sb, start_bgnum);
+		add_flag = 0;
+	}
+
+out:
+	write_unlock(&sbi->s_bg_arule_lock);
+	return 0;
+}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c110cd1..e5fe18a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -615,6 +615,7 @@ static void ext4_put_super(struct super_block *sb)
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
 	percpu_counter_destroy(&sbi->s_dirtyblocks_counter);
+	percpu_counter_destroy(&sbi->s_restricted_blocks_counter);
 	brelse(sbi->s_sbh);
 #ifdef CONFIG_QUOTA
 	for (i = 0; i < MAXQUOTAS; i++)
@@ -2672,6 +2673,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	if (!err) {
 		err = percpu_counter_init(&sbi->s_dirtyblocks_counter, 0);
 	}
+	if (!err) {
+		err = percpu_counter_init(&sbi->s_restricted_blocks_counter, 0);
+	}
 	if (err) {
 		ext4_msg(sb, KERN_ERR, "insufficient memory");
 		goto failed_mount3;
@@ -3649,7 +3653,10 @@ static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_bsize = sb->s_blocksize;
 	buf->f_blocks = ext4_blocks_count(es) - sbi->s_overhead_last;
 	buf->f_bfree = percpu_counter_sum_positive(&sbi->s_freeblocks_counter) -
-		       percpu_counter_sum_positive(&sbi->s_dirtyblocks_counter);
+		       percpu_counter_sum_positive(
+				&sbi->s_dirtyblocks_counter) -
+		       percpu_counter_sum_positive(
+				&sbi->s_restricted_blocks_counter);
 	ext4_free_blocks_count_set(es, buf->f_bfree);
 	buf->f_bavail = buf->f_bfree - ext4_r_blocks_count(es);
 	if (buf->f_bfree < ext4_r_blocks_count(es))
