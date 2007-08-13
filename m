From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 4/4] Fixes to make it build and run
Date: Mon, 13 Aug 2007 15:52:25 +0530
Message-ID: <1187000580777-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1187000545401-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11870005502857-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1187000553923-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <11870005773291-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:58672 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938266AbXHMKX4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Aug 2007 06:23:56 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l7DAPu0X3493966
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 20:25:56 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.250.242])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l7DAQeFW063892
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 20:26:41 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l7DAN7Gg029066
	for <linux-ext4@vger.kernel.org>; Mon, 13 Aug 2007 20:23:07 +1000
In-Reply-To: <11870005773291-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

---
 fs/ext4/balloc.c        |   37 +++++++++++++++---
 fs/ext4/extents.c       |    7 +--
 fs/ext4/mballoc.c       |   96 ++++++++++++++--------------------------------
 include/linux/ext4_fs.h |   19 +++++----
 4 files changed, 74 insertions(+), 85 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 55f4be8..012c721 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -626,7 +626,7 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 			int metadata)
 {
 	struct super_block * sb;
-	int freed;
+	unsigned long dquot_freed_blocks;
 
 	/* this isn't the right place to decide whether block is metadata
 	 * inode.c/extents.c knows better, but for safety ... */
@@ -637,11 +637,13 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 	sb = inode->i_sb;
 
 	if (!test_opt(sb, MBALLOC) || !EXT4_SB(sb)->s_group_info)
-		ext4_free_blocks_sb(handle, sb, block, count, &freed);
+		ext4_free_blocks_sb(handle, sb, block, count,
+						&dquot_freed_blocks);
 	else
-		ext4_mb_free_blocks(handle, inode, block, count, metadata, &freed);
-	if (freed)
-		DQUOT_FREE_BLOCK(inode, freed);
+		ext4_mb_free_blocks(handle, inode, block, count,
+						metadata, &dquot_freed_blocks);
+	if (dquot_freed_blocks)
+		DQUOT_FREE_BLOCK(inode, dquot_freed_blocks);
 	return;
 }
 
@@ -1417,7 +1419,7 @@ int ext4_should_retry_alloc(struct super_block *sb, int *retries)
 }
 
 /**
- * ext4_new_blocks() -- core block(s) allocation function
+ * ext4_new_blocks_old() -- core block(s) allocation function
  * @handle:		handle to this transaction
  * @inode:		file inode
  * @goal:		given target block(filesystem wide)
@@ -1715,9 +1717,32 @@ ext4_fsblk_t ext4_new_block(handle_t *handle, struct inode *inode,
 	return ret;
 }
 
+ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
+		ext4_fsblk_t goal, unsigned long *count, int *errp)
+{
+	struct ext4_allocation_request ar;
+	ext4_fsblk_t ret;
 
+	if (!test_opt(inode->i_sb, MBALLOC)) {
+		ret = ext4_new_blocks_old(handle, inode, goal, count, errp);
+		return ret;
+	}
+
+	ar.inode = inode;
+	ar.goal = goal;
+	ar.len = *count;
+	ar.logical = 0;
+	ar.lleft = 0;
+	ar.pleft = 0;
+	ar.lright = 0;
+	ar.pright = 0;
+	ar.flags = 0;
+	ret = ext4_mb_new_blocks(handle, &ar, errp);
+	*count = ar.len;
+	return ret;
 }
 
+
 /**
  * ext4_count_free_blocks() -- count filesystem free blocks
  * @sb:		superblock
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 8d163d7..392286f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1863,7 +1863,7 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 	unsigned short ee_len =  ext4_ext_get_actual_len(ex);
 	int i, metadata = 0;
 
-	if (S_ISDIR(tree->inode->i_mode) || S_ISLNK(tree->inode->i_mode))
+	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode))
 		metadata = 1;
 #ifdef EXTENTS_STATS
 	{
@@ -2496,14 +2496,13 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 
 	/* find neighbour allocated blocks */
 	ar.lleft = iblock;
-	err = ext4_ext_search_left(&tree, path, &ar.lleft, &ar.pleft);
+	err = ext4_ext_search_left(inode, path, &ar.lleft, &ar.pleft);
 	if (err)
 		goto out2;
 	ar.lright = iblock;
-	err = ext4_ext_search_right(&tree, path, &ar.lright, &ar.pright);
+	err = ext4_ext_search_right(inode, path, &ar.lright, &ar.pright);
 	if (err)
 		goto out2;
-	/* FIXME!! allocated is updated with resepec to ar.pright */
 
 	/*
 	 * See if request is beyond maximum number of blocks we can have in
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 5fe758e..a28ba0c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -24,7 +24,7 @@
 #include <linux/time.h>
 #include <linux/fs.h>
 #include <linux/namei.h>
-#include <linux/ext4_jbd.h>
+#include <linux/ext4_jbd2.h>
 #include <linux/jbd.h>
 #include <linux/ext4_fs.h>
 #include <linux/quotaops.h>
@@ -303,7 +303,7 @@
  */
 #define MB_DEFAULT_STRIPE		256
 
-static kmem_cache_t *ext4_pspace_cachep = NULL;
+static struct kmem_cache *ext4_pspace_cachep = NULL;
 
 #ifdef EXT4_BB_MAX_BLOCKS
 #undef EXT4_BB_MAX_BLOCKS
@@ -361,7 +361,7 @@ struct ext4_prealloc_space {
 
 struct ext4_free_extent {
 	unsigned long fe_logical;
-	unsigned long fe_start;
+	ext4_grpblk_t fe_start;
 	unsigned long fe_group;
 	unsigned long fe_len;
 };
@@ -458,8 +458,8 @@ static struct proc_dir_entry *proc_root_ext4;
 
 int ext4_create (struct inode *, struct dentry *, int, struct nameidata *);
 struct buffer_head * read_block_bitmap(struct super_block *, unsigned int);
-unsigned long ext4_new_blocks_old(handle_t *handle, struct inode *inode,
-			unsigned long goal, unsigned long *count, int *errp);
+ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
+			ext4_fsblk_t goal, unsigned long *count, int *errp);
 void ext4_mb_release_blocks(struct super_block *, int);
 void ext4_mb_poll_new_transaction(struct super_block *, handle_t *);
 void ext4_mb_free_committed_blocks(struct super_block *);
@@ -473,26 +473,6 @@ void ext4_mb_put_pa(struct ext4_allocation_context *, struct super_block *, stru
 int ext4_mb_init_per_dev_proc(struct super_block *sb);
 int ext4_mb_destroy_per_dev_proc(struct super_block *sb);
 
-/*
- * Calculate the block group number and offset, given a block number
- */
-static void ext4_get_group_no_and_offset(struct super_block *sb,
-					unsigned long blocknr,
-					unsigned long *blockgrpp,
-					unsigned long *offsetp)
-{
-	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
-	unsigned long offset;
-
-	blocknr = blocknr - le32_to_cpu(es->s_first_data_block);
-	offset = blocknr % EXT4_BLOCKS_PER_GROUP(sb);
-	blocknr = blocknr / EXT4_BLOCKS_PER_GROUP(sb);
-	if (offsetp)
-		*offsetp = offset;
-	if (blockgrpp)
-	        *blockgrpp = blocknr;
-
-}
 
 static inline void
 ext4_lock_group(struct super_block *sb, int group)
@@ -1958,13 +1938,13 @@ static int ext4_mb_seq_history_show(struct seq_file *seq, void *v)
 	if (hs->op == EXT4_MB_HISTORY_ALLOC) {
 		fmt = "%-5u %-8u %-23s %-23s %-23s %-5u %-5u %-2u "
 			"%-5u %-5s %-5u %-6u\n";
-		sprintf(buf2, "%lu/%lu/%lu@%lu", hs->result.fe_group,
+		sprintf(buf2, "%lu/%d/%lu@%lu", hs->result.fe_group,
 			hs->result.fe_start, hs->result.fe_len,
 			hs->result.fe_logical);
-		sprintf(buf, "%lu/%lu/%lu@%lu", hs->orig.fe_group,
+		sprintf(buf, "%lu/%d/%lu@%lu", hs->orig.fe_group,
 			hs->orig.fe_start, hs->orig.fe_len,
 			hs->orig.fe_logical);
-		sprintf(buf3, "%lu/%lu/%lu@%lu", hs->goal.fe_group,
+		sprintf(buf3, "%lu/%d/%lu@%lu", hs->goal.fe_group,
 			hs->goal.fe_start, hs->goal.fe_len,
 			hs->goal.fe_logical);
 		seq_printf(seq, fmt, hs->pid, hs->ino, buf, buf3, buf2,
@@ -1973,20 +1953,20 @@ static int ext4_mb_seq_history_show(struct seq_file *seq, void *v)
 				hs->buddy ? 1 << hs->buddy : 0);
 	} else if (hs->op == EXT4_MB_HISTORY_PREALLOC) {
 		fmt = "%-5u %-8u %-23s %-23s %-23s\n";
-		sprintf(buf2, "%lu/%lu/%lu@%lu", hs->result.fe_group,
+		sprintf(buf2, "%lu/%d/%lu@%lu", hs->result.fe_group,
 			hs->result.fe_start, hs->result.fe_len,
 			hs->result.fe_logical);
-		sprintf(buf, "%lu/%lu/%lu@%lu", hs->orig.fe_group,
+		sprintf(buf, "%lu/%d/%lu@%lu", hs->orig.fe_group,
 			hs->orig.fe_start, hs->orig.fe_len,
 			hs->orig.fe_logical);
 		seq_printf(seq, fmt, hs->pid, hs->ino, buf, "", buf2);
 	} else if (hs->op == EXT4_MB_HISTORY_DISCARD) {
-		sprintf(buf2, "%lu/%lu/%lu", hs->result.fe_group,
+		sprintf(buf2, "%lu/%d/%lu", hs->result.fe_group,
 			hs->result.fe_start, hs->result.fe_len);
 		seq_printf(seq, "%-5u %-8u %-23s discard\n",
 				hs->pid, hs->ino, buf2);
 	} else if (hs->op == EXT4_MB_HISTORY_FREE) {
-		sprintf(buf2, "%lu/%lu/%lu", hs->result.fe_group,
+		sprintf(buf2, "%lu/%d/%lu", hs->result.fe_group,
 			hs->result.fe_start, hs->result.fe_len);
 		seq_printf(seq, "%-5u %-8u %-23s free\n",
 				hs->pid, hs->ino, buf2);
@@ -2809,7 +2789,7 @@ int __init init_ext4_proc(void)
 	ext4_pspace_cachep =
 		kmem_cache_create("ext4_prealloc_space",
 				     sizeof(struct ext4_prealloc_space),
-				     0, SLAB_RECLAIM_ACCOUNT, NULL, NULL);
+				     0, SLAB_RECLAIM_ACCOUNT, NULL);
 	if (ext4_pspace_cachep == NULL)
 		return -ENOMEM;
 
@@ -3242,7 +3222,7 @@ void ext4_mb_generate_from_pa(struct super_block *sb, void *bitmap, int group)
 	struct ext4_prealloc_space *pa;
 	struct list_head *cur;
 	unsigned long groupnr;
-	unsigned long start;
+	ext4_grpblk_t start;
 	int preallocated = 0, count = 0, len;
 
  	/* all form of preallocation discards first load group,
@@ -3348,7 +3328,7 @@ int ext4_mb_new_inode_pa(struct ext4_allocation_context *ac)
 	BUG_ON(ac->ac_status != AC_STATUS_FOUND);
 	BUG_ON(!S_ISREG(ac->ac_inode->i_mode));
 
-	pa = kmem_cache_alloc(ext4_pspace_cachep, SLAB_NOFS);
+	pa = kmem_cache_alloc(ext4_pspace_cachep, GFP_NOFS);
 	if (pa == NULL)
 		return -ENOMEM;
 
@@ -3433,7 +3413,7 @@ int ext4_mb_new_group_pa(struct ext4_allocation_context *ac)
 	BUG_ON(!S_ISREG(ac->ac_inode->i_mode));
 
 	BUG_ON(ext4_pspace_cachep == NULL);
-	pa = kmem_cache_alloc(ext4_pspace_cachep, SLAB_NOFS);
+	pa = kmem_cache_alloc(ext4_pspace_cachep, GFP_NOFS);
 	if (pa == NULL)
 		return -ENOMEM;
 
@@ -3500,7 +3480,8 @@ int ext4_mb_release_inode_pa(struct ext4_buddy *e3b,
 	struct ext4_allocation_context ac;
 	struct super_block *sb = e3b->bd_sb;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	unsigned long bit, end, next, group;
+	unsigned long end, next, group;
+	ext4_grpblk_t bit;
 	sector_t start;
 	int err = 0, free = 0;
 
@@ -3554,7 +3535,8 @@ int ext4_mb_release_group_pa(struct ext4_buddy *e3b,
 {
 	struct ext4_allocation_context ac;
 	struct super_block *sb = e3b->bd_sb;
-	unsigned long bit, group;
+	unsigned long group;
+	ext4_grpblk_t bit;
 
 	ac.ac_op = EXT4_MB_HISTORY_DISCARD;
 
@@ -3873,7 +3855,7 @@ int ext4_mb_initialize_context(struct ext4_allocation_context *ac,
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
 	unsigned long group, len, goal;
-	unsigned long block;
+	ext4_grpblk_t block;
 
 	/* we can't allocate > group size */
 	len = ar->len;
@@ -3988,12 +3970,15 @@ unsigned long ext4_mb_new_blocks(handle_t *handle,
 	sbi = EXT4_SB(sb);
 
 	if (!test_opt(sb, MBALLOC)) {
+#if 0
 		static int ext4_mballoc_warning = 0;
 		if (ext4_mballoc_warning++ == 0)
-			printk(KERN_ERR "EXT4-fs: multiblock request with "
+			printk(KERN_ERR "EXT3-fs: multiblock request with "
 					"mballoc disabled!\n");
 		ar->len = 1;
-		block = ext4_new_block_old(handle, ar->inode, ar->goal, errp);
+#endif
+		block = ext4_new_blocks_old(handle, ar->inode, ar->goal,
+								&(ar->len), errp);
 		return block;
 	}
 
@@ -4057,30 +4042,6 @@ out:
 }
 EXPORT_SYMBOL(ext4_mb_new_blocks);
 
-int ext4_new_block(handle_t *handle, struct inode *inode,
-		   unsigned long goal, int *errp)
-{
-	struct ext4_allocation_request ar;
-	unsigned long ret;
-
-	if (!test_opt(inode->i_sb, MBALLOC)) {
-		ret = ext4_new_block_old(handle, inode, goal, errp);
-		return ret;
-	}
-
-	ar.inode = inode;
-	ar.goal = goal;
-	ar.len = 1;
-	ar.logical = 0;
-	ar.lleft = 0;
-	ar.pleft = 0;
-	ar.lright = 0;
-	ar.pright = 0;
-	ar.flags = 0;
-	ret = ext4_mb_new_blocks(handle, &ar, errp);
-	return ret;
-}
-
 void ext4_mb_poll_new_transaction(struct super_block *sb, handle_t *handle)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -4177,14 +4138,15 @@ int ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e3b,
  */
 void ext4_mb_free_blocks(handle_t *handle, struct inode *inode,
 			unsigned long block, unsigned long count,
-			int metadata, int *freed)
+			int metadata, unsigned long *freed)
 {
 	struct buffer_head *bitmap_bh = NULL;
 	struct super_block *sb = inode->i_sb;
 	struct ext4_allocation_context ac;
 	struct ext4_group_desc *gdp;
 	struct ext4_super_block *es;
-	unsigned long bit, overflow;
+	unsigned long overflow;
+	ext4_grpblk_t bit;
 	struct buffer_head *gd_bh;
 	unsigned long block_group;
 	struct ext4_sb_info *sbi;
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index c2e819f..8796e6a 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -20,6 +20,8 @@
 #include <linux/blkdev.h>
 #include <linux/magic.h>
 
+#include <linux/ext4_fs_i.h>
+
 /*
  * The second extended filesystem constants/structures
  */
@@ -70,12 +72,12 @@
 
 struct ext4_allocation_request {
 	struct inode *inode;	/* target inode for block we're allocating */
-	unsigned long logical;	/* logical block in target inode */
-	unsigned long goal;	/* phys. target (a hint) */
-	unsigned long lleft;	/* the closest logical allocated block to the left */
-	unsigned long pleft;	/* phys. block for ^^^ */
-	unsigned long lright;	/* the closest logical allocated block to the right */
-	unsigned long pright;	/* phys. block for ^^^ */
+	ext4_fsblk_t logical;	/* logical block in target inode */
+	ext4_fsblk_t goal;	/* phys. target (a hint) */
+	ext4_fsblk_t lleft;	/* the closest logical allocated block to the left */
+	ext4_fsblk_t pleft;	/* phys. block for ^^^ */
+	ext4_fsblk_t lright;	/* the closest logical allocated block to the right */
+	ext4_fsblk_t pright;	/* phys. block for ^^^ */
 	unsigned long len;	/* how many blocks we want to allocate */
 	unsigned long flags;	/* flags. see above EXT4_MB_HINT_* */
 };
@@ -930,7 +932,7 @@ extern ext4_fsblk_t ext4_new_block (handle_t *handle, struct inode *inode,
 extern ext4_fsblk_t ext4_new_blocks (handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, unsigned long *count, int *errp);
 extern void ext4_free_blocks (handle_t *handle, struct inode *inode,
-			ext4_fsblk_t block, unsigned long count);
+			ext4_fsblk_t block, unsigned long count, int metadata);
 extern void ext4_free_blocks_sb (handle_t *handle, struct super_block *sb,
 				 ext4_fsblk_t block, unsigned long count,
 				unsigned long *pdquot_freed_blocks);
@@ -980,7 +982,8 @@ extern void ext4_mb_release_blocks(struct super_block *, int);
 extern void ext4_mb_discard_inode_preallocations(struct inode *);
 extern int __init init_ext4_proc(void);
 extern void exit_ext4_proc(void);
-extern void ext4_mb_free_blocks(handle_t *, struct inode *, unsigned long, unsigned long, int, int *);
+extern void ext4_mb_free_blocks(handle_t *, struct inode *,
+		unsigned long, unsigned long, int, unsigned long *);
 
 
 /* inode.c */
-- 
1.5.3.rc4.67.gf9286-dirty
