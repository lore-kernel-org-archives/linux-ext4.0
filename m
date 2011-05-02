From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/4] ext3: Implement delayed allocation on page_mkwrite time
Date: Mon,  2 May 2011 22:56:56 +0200
Message-ID: <1304369816-14545-5-git-send-email-jack@suse.cz>
References: <1304369816-14545-1-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:46982 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755192Ab1EBU5W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 May 2011 16:57:22 -0400
In-Reply-To: <1304369816-14545-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

So far, ext3 was allocating necessary blocks for mmapped writes when
writepage() was called. There are several issues with this. The worst
being that user is allowed to arbitrarily exceed disk quotas because
writepage() is called from flusher thread context (which is root) and thus
quota limits are ignored. Another bad consequence is that data is just lost
if we find there's no space on the filesystem during ->writepage() time.

We solve these issues by implementing block reservation in page_mkwrite()
callback. We don't want to really allocate blocks on page_mkwrite() time
because for random writes via mmap (as seen for example with applications using
BerkeleyDB) it results in much more fragmented files and thus much worse
performance. So we allocate indirect blocks and reserve space for data block in
page_mkwrite() and do the allocation of data block from writepage().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/Makefile     |    3 +-
 fs/ext3/balloc.c     |  119 +++++++++++------
 fs/ext3/ext3.h       |   11 ++-
 fs/ext3/ext3_fs_i.h  |    4 +
 fs/ext3/ext3_fs_sb.h |    3 +-
 fs/ext3/file.c       |   19 +++-
 fs/ext3/ialloc.c     |    2 +-
 fs/ext3/inode.c      |  357 +++++++++++++++++++++++++++++++++++++++++++-------
 fs/ext3/resize.c     |    2 +-
 fs/ext3/super.c      |   22 +++-
 10 files changed, 442 insertions(+), 100 deletions(-)

diff --git a/fs/ext3/Makefile b/fs/ext3/Makefile
index e77766a..ed5cead 100644
--- a/fs/ext3/Makefile
+++ b/fs/ext3/Makefile
@@ -5,7 +5,8 @@
 obj-$(CONFIG_EXT3_FS) += ext3.o
 
 ext3-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o \
-	   ioctl.o namei.o super.o symlink.o hash.o resize.o ext3_jbd.o
+	   ioctl.o namei.o super.o symlink.o hash.o resize.o ext3_jbd.o \
+	   delalloc_counter.o
 
 ext3-$(CONFIG_EXT3_FS_XATTR)	 += xattr.o xattr_user.o xattr_trusted.o
 ext3-$(CONFIG_EXT3_FS_POSIX_ACL) += acl.o
diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index 12e8228..5534ce8 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -19,8 +19,10 @@
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
 #include <linux/blkdev.h>
+#include <linux/writeback.h>
 #include "ext3.h"
 #include "ext3_jbd.h"
+#include "delalloc_counter.h"
 
 /*
  * balloc.c contains the blocks allocation and deallocation routines
@@ -649,7 +651,7 @@ do_more:
 	spin_lock(sb_bgl_lock(sbi, block_group));
 	le16_add_cpu(&desc->bg_free_blocks_count, group_freed);
 	spin_unlock(sb_bgl_lock(sbi, block_group));
-	percpu_counter_add(&sbi->s_freeblocks_counter, count);
+	dac_free(&sbi->s_alloc_counter, count);
 
 	/* We dirtied the bitmap block */
 	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
@@ -1430,23 +1432,19 @@ out:
 }
 
 /**
- * ext3_has_free_blocks()
- * @sbi:		in-core super block structure.
+ * ext3_free_blocks_limit()
+ * @sb:			super block
  *
  * Check if filesystem has at least 1 free block available for allocation.
  */
-static int ext3_has_free_blocks(struct ext3_sb_info *sbi)
+ext3_fsblk_t ext3_free_blocks_limit(struct super_block *sb)
 {
-	ext3_fsblk_t free_blocks, root_blocks;
+	struct ext3_sb_info *sbi = EXT3_SB(sb);
 
-	free_blocks = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
-	root_blocks = le32_to_cpu(sbi->s_es->s_r_blocks_count);
-	if (free_blocks < root_blocks + 1 && !capable(CAP_SYS_RESOURCE) &&
-		sbi->s_resuid != current_fsuid() &&
-		(sbi->s_resgid == 0 || !in_group_p (sbi->s_resgid))) {
-		return 0;
-	}
-	return 1;
+	if (!capable(CAP_SYS_RESOURCE) && sbi->s_resuid != current_fsuid() &&
+	    (sbi->s_resgid == 0 || !in_group_p(sbi->s_resgid)))
+		return le32_to_cpu(sbi->s_es->s_r_blocks_count) + 1;
+	return 0;
 }
 
 /**
@@ -1463,12 +1461,16 @@ static int ext3_has_free_blocks(struct ext3_sb_info *sbi)
  */
 int ext3_should_retry_alloc(struct super_block *sb, int *retries)
 {
-	if (!ext3_has_free_blocks(EXT3_SB(sb)) || (*retries)++ > 3)
+	struct ext3_sb_info *sbi = EXT3_SB(sb);
+	ext3_fsblk_t limit;
+
+	limit = ext3_free_blocks_limit(sb);
+	if (dac_get_avail(&sbi->s_alloc_counter) <= limit || (*retries)++ > 3)
 		return 0;
 
 	jbd_debug(1, "%s: retrying operation after ENOSPC\n", sb->s_id);
-
-	return journal_force_commit_nested(EXT3_SB(sb)->s_journal);
+	/* There's a chance commit will free some blocks */
+	return journal_force_commit_nested(sbi->s_journal);
 }
 
 /**
@@ -1477,16 +1479,17 @@ int ext3_should_retry_alloc(struct super_block *sb, int *retries)
  * @inode:		file inode
  * @goal:		given target block(filesystem wide)
  * @count:		target number of blocks to allocate
+ * @reserved:		is the space for blocks already reserved
  * @errp:		error code
  *
  * ext3_new_blocks uses a goal block to assist allocation.  It tries to
  * allocate block(s) from the block group contains the goal block first. If that
  * fails, it will try to allocate block(s) from other block groups without
  * any specific goal block.
- *
  */
 ext3_fsblk_t ext3_new_blocks(handle_t *handle, struct inode *inode,
-			ext3_fsblk_t goal, unsigned long *count, int *errp)
+			ext3_fsblk_t goal, unsigned long *count,
+			bool reserved, int *errp)
 {
 	struct buffer_head *bitmap_bh = NULL;
 	struct buffer_head *gdp_bh;
@@ -1497,7 +1500,6 @@ ext3_fsblk_t ext3_new_blocks(handle_t *handle, struct inode *inode,
 	ext3_fsblk_t ret_block;		/* filesyetem-wide allocated block */
 	int bgi;			/* blockgroup iteration index */
 	int fatal = 0, err;
-	int performed_allocation = 0;
 	ext3_grpblk_t free_blocks;	/* number of free blocks in a group */
 	struct super_block *sb;
 	struct ext3_group_desc *gdp;
@@ -1518,17 +1520,31 @@ ext3_fsblk_t ext3_new_blocks(handle_t *handle, struct inode *inode,
 		printk("ext3_new_block: nonexistent device");
 		return 0;
 	}
+	sbi = EXT3_SB(sb);
 
 	/*
 	 * Check quota for allocation of this block.
 	 */
-	err = dquot_alloc_block(inode, num);
-	if (err) {
-		*errp = err;
-		return 0;
+	if (!reserved) {
+		err = dquot_alloc_block(inode, num);
+		if (err) {
+			*errp = -EDQUOT;
+			return 0;
+		}
+		/*
+		 * We need not succeed in allocating all these blocks but we
+		 * have to check & update delalloc counter before allocating
+		 * blocks. That guarantees that reserved blocks are always
+		 * possible to allocate...
+		 */
+		if (dac_alloc(&sbi->s_alloc_counter, num,
+			      ext3_free_blocks_limit(sb)) < 0) {
+			*errp = -ENOSPC;
+			dquot_free_block(inode, num);
+			return 0;
+		}
 	}
 
-	sbi = EXT3_SB(sb);
 	es = EXT3_SB(sb)->s_es;
 	ext3_debug("goal=%lu.\n", goal);
 	/*
@@ -1543,11 +1559,6 @@ ext3_fsblk_t ext3_new_blocks(handle_t *handle, struct inode *inode,
 	if (block_i && ((windowsz = block_i->rsv_window_node.rsv_goal_size) > 0))
 		my_rsv = &block_i->rsv_window_node;
 
-	if (!ext3_has_free_blocks(sbi)) {
-		*errp = -ENOSPC;
-		goto out;
-	}
-
 	/*
 	 * First, test whether the goal block is free.
 	 */
@@ -1677,8 +1688,6 @@ allocated:
 		goto retry_alloc;
 	}
 
-	performed_allocation = 1;
-
 #ifdef CONFIG_JBD_DEBUG
 	{
 		struct buffer_head *debug_bh;
@@ -1728,7 +1737,6 @@ allocated:
 	spin_lock(sb_bgl_lock(sbi, group_no));
 	le16_add_cpu(&gdp->bg_free_blocks_count, -num);
 	spin_unlock(sb_bgl_lock(sbi, group_no));
-	percpu_counter_sub(&sbi->s_freeblocks_counter, num);
 
 	BUFFER_TRACE(gdp_bh, "journal_dirty_metadata for group descriptor");
 	err = ext3_journal_dirty_metadata(handle, gdp_bh);
@@ -1740,7 +1748,18 @@ allocated:
 
 	*errp = 0;
 	brelse(bitmap_bh);
-	dquot_free_block(inode, *count-num);
+	if (reserved) {
+		dac_alloc_reserved(&sbi->s_alloc_counter, num);
+		dquot_claim_block(inode, num);
+	} else {
+		/*
+		 * We didn't succeed in allocating all blocks. Update counters
+		 * to fix overestimation we did at the beginning of this
+		 * function
+		 */
+		dac_free(&sbi->s_alloc_counter, *count - num);
+		dquot_free_block(inode, *count - num);
+	}
 	*count = num;
 	return ret_block;
 
@@ -1754,8 +1773,10 @@ out:
 	/*
 	 * Undo the block allocation
 	 */
-	if (!performed_allocation)
+	if (!reserved) {
 		dquot_free_block(inode, *count);
+		dac_free(&sbi->s_alloc_counter, *count);
+	}
 	brelse(bitmap_bh);
 	return 0;
 }
@@ -1765,7 +1786,7 @@ ext3_fsblk_t ext3_new_block(handle_t *handle, struct inode *inode,
 {
 	unsigned long count = 1;
 
-	return ext3_new_blocks(handle, inode, goal, &count, errp);
+	return ext3_new_blocks(handle, inode, goal, &count, 0, errp);
 }
 
 /**
@@ -1989,7 +2010,6 @@ ext3_grpblk_t ext3_trim_all_free(struct super_block *sb, unsigned int group,
 		spin_lock(sb_bgl_lock(sbi, group));
 		le16_add_cpu(&gdp->bg_free_blocks_count, start - next);
 		spin_unlock(sb_bgl_lock(sbi, group));
-		percpu_counter_sub(&sbi->s_freeblocks_counter, next - start);
 
 		free_blocks -= next - start;
 		/* Do not issue a TRIM on extents smaller than minblocks */
@@ -2023,7 +2043,6 @@ free_extent:
 		spin_lock(sb_bgl_lock(sbi, group));
 		le16_add_cpu(&gdp->bg_free_blocks_count, freed);
 		spin_unlock(sb_bgl_lock(sbi, group));
-		percpu_counter_add(&sbi->s_freeblocks_counter, freed);
 
 		start = next;
 		if (err < 0) {
@@ -2082,14 +2101,16 @@ err_out:
  */
 int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range)
 {
+	struct ext3_sb_info *sbi = EXT3_SB(sb);
 	ext3_grpblk_t last_block, first_block, free_blocks;
 	unsigned long first_group, last_group;
 	unsigned long group, ngroups;
 	struct ext3_group_desc *gdp;
-	struct ext3_super_block *es = EXT3_SB(sb)->s_es;
+	struct ext3_super_block *es = sbi->s_es;
 	uint64_t start, len, minlen, trimmed;
 	ext3_fsblk_t max_blks = le32_to_cpu(es->s_blocks_count);
 	int ret = 0;
+	ext3_fsblk_t reserve_blks;
 
 	start = (range->start >> sb->s_blocksize_bits) +
 		le32_to_cpu(es->s_first_data_block);
@@ -2104,7 +2125,7 @@ int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	if (start + len > max_blks)
 		len = max_blks - start;
 
-	ngroups = EXT3_SB(sb)->s_groups_count;
+	ngroups = sbi->s_groups_count;
 	smp_rmb();
 
 	/* Determine first and last group to examine based on start and len */
@@ -2118,6 +2139,24 @@ int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range)
 	if (first_group > last_group)
 		return -EINVAL;
 
+	/*
+	 * We reserve enough blocks with the delalloc counter so that we
+	 * don't have to bother with allocating / freeing them later.
+	 * We try to reserve at most one group worth of blocks or 1/2 of
+	 * available space to not disrupt allocations too much.
+	 */
+ 	reserve_blks = min_t(ext3_fsblk_t, EXT3_BLOCKS_PER_GROUP(sb),
+			dac_get_avail_sum(&sbi->s_alloc_counter) / 2);
+	/* Rather do nothing than disrupt running processes */
+	if (reserve_blks < minlen)
+		goto out;
+	while (dac_alloc(&sbi->s_alloc_counter, reserve_blks,
+			 ext3_free_blocks_limit(sb)) < 0) {
+		reserve_blks /= 2;
+		if (reserve_blks < minlen)
+			goto out;
+	}
+
 	for (group = first_group; group <= last_group; group++) {
 		gdp = ext3_get_group_desc(sb, group, NULL);
 		if (!gdp)
@@ -2148,7 +2187,7 @@ int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range)
 
 	if (ret >= 0)
 		ret = 0;
-
+	dac_free(&sbi->s_alloc_counter, reserve_blks);
 out:
 	range->len = trimmed * sb->s_blocksize;
 
diff --git a/fs/ext3/ext3.h b/fs/ext3/ext3.h
index 35c10e7..fe008eb 100644
--- a/fs/ext3/ext3.h
+++ b/fs/ext3/ext3.h
@@ -846,12 +846,14 @@ ext3_group_first_block_no(struct super_block *sb, unsigned long group_no)
 # define NORET_AND     noreturn,
 
 /* balloc.c */
+extern ext3_fsblk_t ext3_free_blocks_limit(struct super_block *sb);
 extern int ext3_bg_has_super(struct super_block *sb, int group);
 extern unsigned long ext3_bg_num_gdb(struct super_block *sb, int group);
 extern ext3_fsblk_t ext3_new_block (handle_t *handle, struct inode *inode,
 			ext3_fsblk_t goal, int *errp);
 extern ext3_fsblk_t ext3_new_blocks (handle_t *handle, struct inode *inode,
-			ext3_fsblk_t goal, unsigned long *count, int *errp);
+			ext3_fsblk_t goal, unsigned long *count,
+			bool reserved, int *errp);
 extern void ext3_free_blocks (handle_t *handle, struct inode *inode,
 			ext3_fsblk_t block, unsigned long count);
 extern void ext3_free_blocks_sb (handle_t *handle, struct super_block *sb,
@@ -899,9 +901,13 @@ int ext3_forget(handle_t *handle, int is_metadata, struct inode *inode,
 		struct buffer_head *bh, ext3_fsblk_t blocknr);
 struct buffer_head * ext3_getblk (handle_t *, struct inode *, long, int, int *);
 struct buffer_head * ext3_bread (handle_t *, struct inode *, int, int, int *);
+#define EXT3_GET_BLOCKS_CREATE		0x01
+#define EXT3_GET_BLOCKS_CREATE_DA	0x02
+#define EXT3_GET_BLOCKS_CREATE_RESERVED	0x04	/* Internal flag of
+						ext3_get_blocks_handle() */
 int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
 	sector_t iblock, unsigned long maxblocks, struct buffer_head *bh_result,
-	int create);
+	int flags);
 
 extern struct inode *ext3_iget(struct super_block *, unsigned long);
 extern int  ext3_write_inode (struct inode *, struct writeback_control *);
@@ -919,6 +925,7 @@ extern void ext3_get_inode_flags(struct ext3_inode_info *);
 extern void ext3_set_aops(struct inode *inode);
 extern int ext3_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		       u64 start, u64 len);
+extern int ext3_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 
 /* ioctl.c */
 extern long ext3_ioctl(struct file *, unsigned int, unsigned long);
diff --git a/fs/ext3/ext3_fs_i.h b/fs/ext3/ext3_fs_i.h
index b0a3d8a..e87de74 100644
--- a/fs/ext3/ext3_fs_i.h
+++ b/fs/ext3/ext3_fs_i.h
@@ -64,6 +64,7 @@ struct ext3_block_alloc_info {
 #define rsv_start rsv_window._rsv_start
 #define rsv_end rsv_window._rsv_end
 
+
 /*
  * third extended file system inode data in memory
  */
@@ -125,6 +126,9 @@ struct ext3_inode_info {
 
 	/* on-disk additional length */
 	__u16 i_extra_isize;
+#ifdef CONFIG_QUOTA
+	qsize_t i_reserved_quota;
+#endif
 
 	/*
 	 * truncate_mutex is for serialising ext3_truncate() against
diff --git a/fs/ext3/ext3_fs_sb.h b/fs/ext3/ext3_fs_sb.h
index efa1c2f..bc9dc4c 100644
--- a/fs/ext3/ext3_fs_sb.h
+++ b/fs/ext3/ext3_fs_sb.h
@@ -21,6 +21,7 @@
 #include <linux/wait.h>
 #include <linux/blockgroup_lock.h>
 #include <linux/percpu_counter.h>
+#include "delalloc_counter.h"
 #endif
 #include <linux/rbtree.h>
 
@@ -58,7 +59,7 @@ struct ext3_sb_info {
 	u32 s_hash_seed[4];
 	int s_def_hash_version;
 	int s_hash_unsigned;	/* 3 if hash should be signed, 0 if not */
-	struct percpu_counter s_freeblocks_counter;
+	struct delalloc_counter s_alloc_counter;
 	struct percpu_counter s_freeinodes_counter;
 	struct percpu_counter s_dirs_counter;
 	struct blockgroup_lock *s_blockgroup_lock;
diff --git a/fs/ext3/file.c b/fs/ext3/file.c
index 22ad54b..843e4d0 100644
--- a/fs/ext3/file.c
+++ b/fs/ext3/file.c
@@ -52,6 +52,23 @@ static int ext3_release_file (struct inode * inode, struct file * filp)
 	return 0;
 }
 
+static const struct vm_operations_struct ext3_file_vm_ops = {
+	.fault		= filemap_fault,
+	.page_mkwrite	= ext3_page_mkwrite,
+};
+
+static int ext3_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct address_space *mapping = file->f_mapping;
+
+	if (!mapping->a_ops->readpage)
+		return -ENOEXEC;
+	file_accessed(file);
+	vma->vm_ops = &ext3_file_vm_ops;
+	vma->vm_flags |= VM_CAN_NONLINEAR;
+	return 0;
+}
+
 const struct file_operations ext3_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
@@ -62,7 +79,7 @@ const struct file_operations ext3_file_operations = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext3_compat_ioctl,
 #endif
-	.mmap		= generic_file_mmap,
+	.mmap		= ext3_file_mmap,
 	.open		= dquot_file_open,
 	.release	= ext3_release_file,
 	.fsync		= ext3_sync_file,
diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 3f56851..b7b982c 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -257,7 +257,7 @@ static int find_group_orlov(struct super_block *sb, struct inode *parent)
 
 	freei = percpu_counter_read_positive(&sbi->s_freeinodes_counter);
 	avefreei = freei / ngroups;
-	freeb = percpu_counter_read_positive(&sbi->s_freeblocks_counter);
+	freeb = dac_get_avail(&sbi->s_alloc_counter);
 	avefreeb = freeb / ngroups;
 	ndirs = percpu_counter_read_positive(&sbi->s_dirs_counter);
 
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 2cf0439..7f10405 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -37,6 +37,7 @@
 #include <linux/bio.h>
 #include <linux/fiemap.h>
 #include <linux/namei.h>
+#include <linux/mount.h>
 #include "ext3_jbd.h"
 #include "xattr.h"
 #include "acl.h"
@@ -195,6 +196,7 @@ static int truncate_restart_transaction(handle_t *handle, struct inode *inode)
 void ext3_evict_inode (struct inode *inode)
 {
 	struct ext3_block_alloc_info *rsv;
+	struct ext3_inode_info *ei;
 	handle_t *handle;
 	int want_delete = 0;
 
@@ -205,9 +207,10 @@ void ext3_evict_inode (struct inode *inode)
 
 	truncate_inode_pages(&inode->i_data, 0);
 
+	ei = EXT3_I(inode);
 	ext3_discard_reservation(inode);
-	rsv = EXT3_I(inode)->i_block_alloc_info;
-	EXT3_I(inode)->i_block_alloc_info = NULL;
+	rsv = ei->i_block_alloc_info;
+	ei->i_block_alloc_info = NULL;
 	if (unlikely(rsv))
 		kfree(rsv);
 
@@ -239,7 +242,7 @@ void ext3_evict_inode (struct inode *inode)
 	 * (Well, we could do this if we need to, but heck - it works)
 	 */
 	ext3_orphan_del(handle, inode);
-	EXT3_I(inode)->i_dtime	= get_seconds();
+	ei->i_dtime	= get_seconds();
 
 	/*
 	 * One subtle ordering requirement: if anything has gone wrong
@@ -260,10 +263,43 @@ void ext3_evict_inode (struct inode *inode)
 		ext3_free_inode(handle, inode);
 	}
 	ext3_journal_stop(handle);
+out_check:
+	if (ei->i_reserved_quota)
+		ext3_warning(inode->i_sb, __func__, "Releasing inode %lu with "
+			"%lu reserved blocks.\n", inode->i_ino,
+			(unsigned long)ei->i_reserved_quota);
 	return;
 no_delete:
 	end_writeback(inode);
 	dquot_drop(inode);
+	goto out_check;
+}
+
+/*
+ * Reserve appropriate amount of space (and quota) for future allocation.
+ */
+static int ext3_rsv_blocks(struct inode *inode, int num)
+{
+	int ret;
+
+	if (dquot_reserve_block(inode, num))
+		return -EDQUOT;
+	ret = dac_reserve(&EXT3_SB(inode->i_sb)->s_alloc_counter, num,
+			  ext3_free_blocks_limit(inode->i_sb));
+	if (ret < 0) {
+		dquot_release_reservation_block(inode, num);
+		return ret;
+	}
+	return 0;
+}
+
+/*
+ * Cancel reservation of delayed allocated block
+ */
+static void ext3_cancel_rsv_blocks(struct inode *inode, int num)
+{
+	dac_cancel_reserved(&EXT3_SB(inode->i_sb)->s_alloc_counter, num);
+	dquot_release_reservation_block(inode, num);
 }
 
 typedef struct {
@@ -545,13 +581,14 @@ static int ext3_blks_to_allocate(Indirect *branch, int k, unsigned long blks,
  *	@blks:	number of blocks need to allocated for direct blocks
  *	@new_blocks: on return it will store the new block numbers for
  *	the indirect blocks(if needed) and the first direct block,
+ *	@flags: allocation flags
  *	@err: here we store the error value
  *
  *	return the number of direct blocks allocated
  */
 static int ext3_alloc_blocks(handle_t *handle, struct inode *inode,
 			ext3_fsblk_t goal, int indirect_blks, int blks,
-			ext3_fsblk_t new_blocks[4], int *err)
+			ext3_fsblk_t new_blocks[4], int flags, int *err)
 {
 	int target, i;
 	unsigned long count = 0;
@@ -567,12 +604,15 @@ static int ext3_alloc_blocks(handle_t *handle, struct inode *inode,
 	 * the first direct block of this branch.  That's the
 	 * minimum number of blocks need to allocate(required)
 	 */
-	target = blks + indirect_blks;
+	target = indirect_blks;
+	if (!(flags & EXT3_GET_BLOCKS_CREATE_DA))
+		target += blks;
 
 	while (1) {
 		count = target;
 		/* allocating blocks for indirect blocks and direct blocks */
-		current_block = ext3_new_blocks(handle,inode,goal,&count,err);
+		current_block = ext3_new_blocks(handle, inode, goal, &count,
+				flags & EXT3_GET_BLOCKS_CREATE_RESERVED, err);
 		if (*err)
 			goto failed_out;
 
@@ -583,15 +623,28 @@ static int ext3_alloc_blocks(handle_t *handle, struct inode *inode,
 			count--;
 		}
 
-		if (count > 0)
+		/*
+		 * Do we have at least one block for data or we allocated
+		 * everything we wanted (e.g. all indirect blocks)?
+		 */
+		if (count > 0 || target == 0)
 			break;
 	}
 
-	/* save the new block number for the first direct block */
-	new_blocks[index] = current_block;
+	if (flags & EXT3_GET_BLOCKS_CREATE_DA) {
+		*err = ext3_rsv_blocks(inode, blks);
+		if (*err)
+			goto failed_out;
+		/* Set to hole so that we catch if somebody uses the number */
+		new_blocks[index] = 0;
+		ret = blks;
+	} else {
+		/* save the new block number for the first direct block */
+		new_blocks[index] = current_block;
+		/* total number of blocks allocated for direct blocks */
+		ret = count;
+	}
 
-	/* total number of blocks allocated for direct blocks */
-	ret = count;
 	*err = 0;
 	return ret;
 failed_out:
@@ -606,9 +659,10 @@ failed_out:
  *	@inode: owner
  *	@indirect_blks: number of allocated indirect blocks
  *	@blks: number of allocated direct blocks
- *	@goal: preferred place for allocation
+ *	@goal: goal block for the allocation
  *	@offsets: offsets (in the blocks) to store the pointers to next.
  *	@branch: place to store the chain in.
+ *	@flags: allocation details
  *
  *	This function allocates blocks, zeroes out all but the last one,
  *	links them into chain and (if we are synchronous) writes them to disk.
@@ -629,7 +683,7 @@ failed_out:
  */
 static int ext3_alloc_branch(handle_t *handle, struct inode *inode,
 			int indirect_blks, int *blks, ext3_fsblk_t goal,
-			int *offsets, Indirect *branch)
+			int *offsets, Indirect *branch, int flags)
 {
 	int blocksize = inode->i_sb->s_blocksize;
 	int i, n = 0;
@@ -637,10 +691,9 @@ static int ext3_alloc_branch(handle_t *handle, struct inode *inode,
 	struct buffer_head *bh;
 	int num;
 	ext3_fsblk_t new_blocks[4];
-	ext3_fsblk_t current_block;
 
 	num = ext3_alloc_blocks(handle, inode, goal, indirect_blks,
-				*blks, new_blocks, &err);
+				*blks, new_blocks, flags, &err);
 	if (err)
 		return err;
 
@@ -668,16 +721,17 @@ static int ext3_alloc_branch(handle_t *handle, struct inode *inode,
 		memset(bh->b_data, 0, blocksize);
 		branch[n].p = (__le32 *) bh->b_data + offsets[n];
 		branch[n].key = cpu_to_le32(new_blocks[n]);
-		*branch[n].p = branch[n].key;
-		if ( n == indirect_blks) {
-			current_block = new_blocks[n];
+		if (n < indirect_blks)
+			*branch[n].p = branch[n].key;
+		else if (!(flags & EXT3_GET_BLOCKS_CREATE_DA)) {
 			/*
 			 * End of chain, update the last new metablock of
 			 * the chain to point to the new allocated
 			 * data blocks numbers
 			 */
-			for (i=1; i < num; i++)
-				*(branch[n].p + i) = cpu_to_le32(++current_block);
+			for (i = 0; i < num; i++)
+				*(branch[n].p + i) =
+						cpu_to_le32(new_blocks[n] + i);
 		}
 		BUFFER_TRACE(bh, "marking uptodate");
 		set_buffer_uptodate(bh);
@@ -696,10 +750,13 @@ failed:
 		BUFFER_TRACE(branch[i].bh, "call journal_forget");
 		ext3_journal_forget(handle, branch[i].bh);
 	}
-	for (i = 0; i <indirect_blks; i++)
+	for (i = 0; i < indirect_blks; i++)
 		ext3_free_blocks(handle, inode, new_blocks[i], 1);
 
-	ext3_free_blocks(handle, inode, new_blocks[i], num);
+	if (!(flags & EXT3_GET_BLOCKS_CREATE_DA))
+		ext3_free_blocks(handle, inode, new_blocks[i], num);
+	else
+		ext3_cancel_rsv_blocks(inode, num);
 
 	return err;
 }
@@ -718,7 +775,8 @@ failed:
  * chain to new block and return 0.
  */
 static int ext3_splice_branch(handle_t *handle, struct inode *inode,
-			long block, Indirect *where, int num, int blks)
+			long block, Indirect *where, int num, int blks,
+			int flags)
 {
 	int i;
 	int err = 0;
@@ -800,7 +858,11 @@ err_out:
 		ext3_journal_forget(handle, where[i].bh);
 		ext3_free_blocks(handle,inode,le32_to_cpu(where[i-1].key),1);
 	}
-	ext3_free_blocks(handle, inode, le32_to_cpu(where[num].key), blks);
+	if (!(flags & EXT3_GET_BLOCKS_CREATE_DA)) {
+		ext3_free_blocks(handle, inode, le32_to_cpu(where[num].key),
+				 blks);
+	} else
+		ext3_cancel_rsv_blocks(inode, blks);
 
 	return err;
 }
@@ -827,7 +889,7 @@ err_out:
 int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
 		sector_t iblock, unsigned long maxblocks,
 		struct buffer_head *bh_result,
-		int create)
+		int flags)
 {
 	int err = -EIO;
 	int offsets[4];
@@ -841,8 +903,7 @@ int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
 	int count = 0;
 	ext3_fsblk_t first_block = 0;
 
-
-	J_ASSERT(handle != NULL || create == 0);
+	J_ASSERT(handle != NULL || flags == 0);
 	depth = ext3_block_to_path(inode,iblock,offsets,&blocks_to_boundary);
 
 	if (depth == 0)
@@ -883,7 +944,7 @@ int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
 	}
 
 	/* Next simple case - plain lookup or failed read of indirect block */
-	if (!create || err == -EIO)
+	if (!flags || err == -EIO)
 		goto cleanup;
 
 	mutex_lock(&ei->truncate_mutex);
@@ -915,11 +976,33 @@ int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
 			goto got_it;
 		}
 	}
+	/*
+	 * Another simple case - all indirect blocks present and delayed
+	 * allocation requested.
+	 */
+	if (flags & EXT3_GET_BLOCKS_CREATE_DA && partial - chain == depth - 1) {
+		/* Should be called only for a single buffer head */
+		WARN_ON(maxblocks != 1);
+		err = ext3_rsv_blocks(inode, 1);
+		if (!err) {
+			/*
+			 * We must update delay bits under truncate_mutex
+			 * to avoid races with ext3_find_da_in_indirect()
+			 */
+			set_buffer_new(bh_result);
+			set_buffer_delay(bh_result);
+		}
+		mutex_unlock(&ei->truncate_mutex);
+		if (err)
+			goto cleanup;
+		err = 1;
+		goto cleanup;
+	}
 
 	/*
 	 * Okay, we need to do block allocation.  Lazily initialize the block
 	 * allocation info here if necessary
-	*/
+	 */
 	if (S_ISREG(inode->i_mode) && (!ei->i_block_alloc_info))
 		ext3_init_block_alloc_info(inode);
 
@@ -927,19 +1010,35 @@ int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
 
 	/* the number of blocks need to allocate for [d,t]indirect blocks */
 	indirect_blks = (chain + depth) - partial - 1;
+	if (buffer_delay(bh_result)) {
+		if (indirect_blks) {
+			ext3_warning(inode->i_sb, __func__, "Block %lu of "
+				"inode %lu needs allocating %d indirect blocks"
+				" but all should be already allocated.",
+				(unsigned long)iblock, inode->i_ino,
+				indirect_blks);
+			ext3_cancel_rsv_blocks(inode, 1);
+			clear_buffer_delay(bh_result);
+		} else {
+			/*
+			 * We expect to allocate blocks for only a single
+			 * delayed buffer head attached to a page
+			 */
+			WARN_ON(maxblocks != 1 || !bh_result->b_page);
+			WARN_ON(!(flags & EXT3_GET_BLOCKS_CREATE));
+			flags |= EXT3_GET_BLOCKS_CREATE_RESERVED;
+		}
+	}
 
 	/*
-	 * Next look up the indirect map to count the totoal number of
+	 * Next look up the indirect map to count the total number of
 	 * direct blocks to allocate for this branch.
 	 */
 	count = ext3_blks_to_allocate(partial, indirect_blks,
 					maxblocks, blocks_to_boundary);
-	/*
-	 * Block out ext3_truncate while we alter the tree
-	 */
-	err = ext3_alloc_branch(handle, inode, indirect_blks, &count, goal,
-				offsets + (partial - chain), partial);
 
+	err = ext3_alloc_branch(handle, inode, indirect_blks, &count, goal,
+			offsets + (partial - chain), partial, flags);
 	/*
 	 * The ext3_splice_branch call will free and forget any buffers
 	 * on the new chain if there is a failure, but that risks using
@@ -947,16 +1046,29 @@ int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
 	 * credits cannot be returned.  Can we handle this somehow?  We
 	 * may need to return -EAGAIN upwards in the worst case.  --sct
 	 */
-	if (!err)
-		err = ext3_splice_branch(handle, inode, iblock,
-					partial, indirect_blks, count);
+	if (!err) {
+		err = ext3_splice_branch(handle, inode, iblock, partial,
+					 indirect_blks, count, flags);
+		if (!err) {
+			/*
+			 * We must update delay bits under truncate_mutex
+			 * to avoid races with ext3_find_da_in_indirect()
+			 */
+			if (buffer_delay(bh_result))
+				clear_buffer_delay(bh_result);
+			else {
+				set_buffer_new(bh_result);
+				if (flags & EXT3_GET_BLOCKS_CREATE_DA)
+					set_buffer_delay(bh_result);
+			}
+		}
+	}
 	mutex_unlock(&ei->truncate_mutex);
 	if (err)
 		goto cleanup;
-
-	set_buffer_new(bh_result);
 got_it:
-	map_bh(bh_result, inode->i_sb, le32_to_cpu(chain[depth-1].key));
+	if (!buffer_delay(bh_result))
+		map_bh(bh_result, inode->i_sb, le32_to_cpu(chain[depth-1].key));
 	if (count > blocks_to_boundary)
 		set_buffer_boundary(bh_result);
 	err = count;
@@ -1004,7 +1116,8 @@ static int ext3_get_block(struct inode *inode, sector_t iblock,
 	}
 
 	ret = ext3_get_blocks_handle(handle, inode, iblock,
-					max_blocks, bh_result, create);
+				max_blocks, bh_result,
+				create ? EXT3_GET_BLOCKS_CREATE : 0);
 	if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
 		ret = 0;
@@ -1036,8 +1149,8 @@ struct buffer_head *ext3_getblk(handle_t *handle, struct inode *inode,
 	dummy.b_state = 0;
 	dummy.b_blocknr = -1000;
 	buffer_trace_init(&dummy.b_history);
-	err = ext3_get_blocks_handle(handle, inode, block, 1,
-					&dummy, create);
+	err = ext3_get_blocks_handle(handle, inode, block, 1, &dummy,
+				create ? EXT3_GET_BLOCKS_CREATE : 0);
 	/*
 	 * ext3_get_blocks_handle() returns number of blocks
 	 * mapped. 0 in case of a HOLE.
@@ -1503,6 +1616,22 @@ static int bput_one(handle_t *handle, struct buffer_head *bh)
 
 static int buffer_unmapped(handle_t *handle, struct buffer_head *bh)
 {
+	/* Unmapped and unreserved data blocks should not reach writepage() */
+#if 0
+	/* This isn't true yet because of following:
+	 * Assume blocksize == 1024, PAGE_CACHE_SIZE = 4096,
+	 * inode->i_size ==  1024
+	 *  ->page_mkwrite(page with index 0)
+	 *      reserves 1 block for page 0
+	 *  truncate(inode, 4096)
+	 *  write something to page 0
+	 *  ->writepage(page with index 0)
+	 *    - buffers which used to be beyond i_size are not reserved
+	 * Changes into MM are needed to solve the issue so just ignore
+	 * the problem for now...
+	 */
+	WARN_ON(!buffer_mapped(bh) && !buffer_delay(bh));
+#endif
 	return !buffer_mapped(bh);
 }
 
@@ -1578,6 +1707,11 @@ static int ext3_ordered_writepage(struct page *page,
 		goto out_fail;
 
 	if (!page_has_buffers(page)) {
+		/*
+		 * Dirty pages should not come without buffers - they should
+		 * either have buffers mapped or delay-allocated
+		 */
+		WARN_ON(1);
 		create_empty_buffers(page, inode->i_sb->s_blocksize,
 				(1 << BH_Dirty)|(1 << BH_Uptodate));
 		page_bufs = page_buffers(page);
@@ -1749,15 +1883,33 @@ ext3_readpages(struct file *file, struct address_space *mapping,
 	return mpage_readpages(mapping, pages, nr_pages, ext3_get_block);
 }
 
+
+static int truncate_delayed_bh(handle_t *handle, struct buffer_head *bh)
+{
+	if (buffer_delay(bh)) {
+		struct inode *inode = bh->b_page->mapping->host;
+
+		ext3_cancel_rsv_blocks(inode, 1);
+		clear_buffer_delay(bh);
+	}
+	return 0;
+}
+
 static void ext3_invalidatepage(struct page *page, unsigned long offset)
 {
-	journal_t *journal = EXT3_JOURNAL(page->mapping->host);
+	struct inode *inode = page->mapping->host;
+	journal_t *journal = EXT3_JOURNAL(inode);
+	int bsize = 1 << inode->i_blkbits;
 
 	/*
 	 * If it's a full truncate we just forget about the pending dirtying
 	 */
 	if (offset == 0)
 		ClearPageChecked(page);
+	if (page_has_buffers(page)) {
+		walk_page_buffers(NULL, page_buffers(page), offset + bsize - 1,
+				  PAGE_CACHE_SIZE, NULL, truncate_delayed_bh);
+	}
 
 	journal_invalidatepage(journal, page, offset);
 }
@@ -2030,6 +2182,64 @@ unlock:
 	return err;
 }
 
+static int ext3_buffer_delay(handle_t *handle, struct buffer_head *bh)
+{
+	return buffer_delay(bh);
+}
+
+/*
+ * Find whether there's some delayed allocated block in an indirect block
+ * for iblock.
+ */
+static int ext3_find_da_in_indirect(struct inode *inode, sector_t iblock)
+{
+	sector_t mask = ~((1 << EXT3_ADDR_PER_BLOCK_BITS(inode->i_sb)) - 1);
+	int bshift = PAGE_CACHE_SHIFT - inode->i_blkbits;
+	pgoff_t end = iblock >> bshift;
+	pgoff_t start;
+	struct page *page;
+	int ret = 0;
+	sector_t boundary;
+
+	if (iblock < EXT3_NDIR_BLOCKS)
+		return 0;
+	boundary = (((iblock - EXT3_NDIR_BLOCKS) & mask) + EXT3_NDIR_BLOCKS);
+	start = boundary >> bshift;
+check:
+	if (!find_get_pages_tag(inode->i_mapping, &start, PAGECACHE_TAG_DIRTY,
+				1, &page))
+		return 0;
+	if (page->index > end)
+		goto out;
+	/* Page straddles indirect block boundary? Can happen for 64k pages. */
+	if (((sector_t)page->index) << bshift < boundary) {
+		lock_page(page);
+		if (page->mapping == inode->i_mapping &&
+		    page_has_buffers(page)) {
+			loff_t from = (((loff_t)boundary) << inode->i_blkbits) -
+				page_offset(page);
+			ret = walk_page_buffers(NULL, page_buffers(page),
+				from, PAGE_CACHE_SIZE, NULL, ext3_buffer_delay);
+		}
+		unlock_page(page);
+		if (ret)
+			goto out;
+		/*
+		 * OK, current page does not need the indirect block. Check
+		 * whether there are some further pages which may need it.
+		 */
+		if (start == end)
+			goto out;
+		page_cache_release(page);
+		start++;
+		goto check;
+	}
+	ret = 1;
+out:
+	page_cache_release(page);
+	return ret;
+}
+
 /*
  * Probably it should be a library function... search for first non-zero word
  * or memcmp with zero_page, whatever is better for particular architecture.
@@ -2046,6 +2256,7 @@ static inline int all_zeroes(__le32 *p, __le32 *q)
 /**
  *	ext3_find_shared - find the indirect blocks for partial truncation.
  *	@inode:	  inode in question
+ *	@iblock:  number of the first truncated block
  *	@depth:	  depth of the affected branch
  *	@offsets: offsets of pointers in that branch (see ext3_block_to_path)
  *	@chain:	  place to store the pointers to partial indirect blocks
@@ -2078,8 +2289,8 @@ static inline int all_zeroes(__le32 *p, __le32 *q)
  *		c) free the subtrees growing from the inode past the @chain[0].
  *			(no partially truncated stuff there).  */
 
-static Indirect *ext3_find_shared(struct inode *inode, int depth,
-			int offsets[4], Indirect chain[4], __le32 *top)
+static Indirect *ext3_find_shared(struct inode *inode, sector_t iblock,
+		int depth, int offsets[4], Indirect chain[4], __le32 *top)
 {
 	Indirect *partial, *p;
 	int k, err;
@@ -2099,8 +2310,22 @@ static Indirect *ext3_find_shared(struct inode *inode, int depth,
 	if (!partial->key && *partial->p)
 		/* Writer: end */
 		goto no_top;
+	/*
+	 * If we don't truncate the whole indirect block and there are some
+	 * delay allocated blocks in it (must be before the truncation point
+	 * as ext3_invalidatepage() has been already run for others), we must
+	 * keep the indirect block as delayed allocated blocks need indirect
+	 * blocks allocated.
+	 */
+	if (partial == chain + depth - 1 &&
+	    ext3_find_da_in_indirect(inode, iblock)) {
+		p = partial;
+		goto shared_ind_found;
+	}
+
 	for (p=partial; p>chain && all_zeroes((__le32*)p->bh->b_data,p->p); p--)
 		;
+shared_ind_found:
 	/*
 	 * OK, we've found the last block that must survive. The rest of our
 	 * branch should be detached before unlocking. However, if that rest
@@ -2520,7 +2745,7 @@ void ext3_truncate(struct inode *inode)
 		goto do_indirects;
 	}
 
-	partial = ext3_find_shared(inode, n, offsets, chain, &nr);
+	partial = ext3_find_shared(inode, last_block, n, offsets, chain, &nr);
 	/* Kill the top of shared branch (not detached) */
 	if (nr) {
 		if (partial == chain) {
@@ -3496,3 +3721,39 @@ int ext3_change_inode_journal_flag(struct inode *inode, int val)
 
 	return err;
 }
+
+/*
+ * Reserve block writes instead of allocation. Called only on buffer heads
+ * attached to a page (and thus for 1 block).
+ */
+static int ext3_da_get_block(struct inode *inode, sector_t iblock,
+			     struct buffer_head *bh, int create)
+{
+	int ret;
+	handle_t *handle;
+
+	/* Buffer has already blocks reserved? */
+	if (buffer_delay(bh))
+		return 0;
+
+	handle = ext3_journal_start(inode, ext3_writepage_trans_blocks(inode));
+	ret = ext3_get_blocks_handle(handle, inode, iblock, 1, bh,
+					EXT3_GET_BLOCKS_CREATE_DA);
+	ext3_journal_stop(handle);
+	if (ret < 0)
+		return ret;
+	return 0;
+}
+
+int ext3_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	int retry = 0;
+	int ret;
+	struct super_block *sb = vma->vm_file->f_path.mnt->mnt_sb;
+
+	do {
+		ret = block_page_mkwrite(vma, vmf, ext3_da_get_block);
+	} while (ret == VM_FAULT_SIGBUS &&
+		 ext3_should_retry_alloc(sb, &retry));
+	return ret;
+}
diff --git a/fs/ext3/resize.c b/fs/ext3/resize.c
index eb10e6f..302d896 100644
--- a/fs/ext3/resize.c
+++ b/fs/ext3/resize.c
@@ -958,7 +958,7 @@ int ext3_group_add(struct super_block *sb, struct ext3_new_group_data *input)
 	le32_add_cpu(&es->s_r_blocks_count, input->reserved_blocks);
 
 	/* Update the free space counts */
-	percpu_counter_add(&sbi->s_freeblocks_counter,
+	percpu_counter_add(&sbi->s_alloc_counter.free,
 			   input->free_blocks_count);
 	percpu_counter_add(&sbi->s_freeinodes_counter,
 			   EXT3_INODES_PER_GROUP(sb));
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 5be257b..df08c68 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -444,7 +444,7 @@ static void ext3_put_super (struct super_block * sb)
 	for (i = 0; i < sbi->s_gdb_count; i++)
 		brelse(sbi->s_group_desc[i]);
 	kfree(sbi->s_group_desc);
-	percpu_counter_destroy(&sbi->s_freeblocks_counter);
+	dac_destroy(&sbi->s_alloc_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
 	brelse(sbi->s_sbh);
@@ -493,6 +493,10 @@ static struct inode *ext3_alloc_inode(struct super_block *sb)
 	ei->vfs_inode.i_version = 1;
 	atomic_set(&ei->i_datasync_tid, 0);
 	atomic_set(&ei->i_sync_tid, 0);
+#ifdef CONFIG_QUOTA
+	ei->i_reserved_quota = 0;
+#endif
+
 	return &ei->vfs_inode;
 }
 
@@ -760,8 +764,17 @@ static ssize_t ext3_quota_read(struct super_block *sb, int type, char *data,
 			       size_t len, loff_t off);
 static ssize_t ext3_quota_write(struct super_block *sb, int type,
 				const char *data, size_t len, loff_t off);
+#ifdef CONFIG_QUOTA
+qsize_t *ext3_get_reserved_space(struct inode *inode)
+{
+	return &EXT3_I(inode)->i_reserved_quota;
+}
+#endif
 
 static const struct dquot_operations ext3_quota_operations = {
+#ifdef CONFIG_QUOTA
+	.get_reserved_space = ext3_get_reserved_space,
+#endif
 	.write_dquot	= ext3_write_dquot,
 	.acquire_dquot	= ext3_acquire_dquot,
 	.release_dquot	= ext3_release_dquot,
@@ -1972,8 +1985,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 				"mounting ext3 over ext2?");
 		goto failed_mount2;
 	}
-	err = percpu_counter_init(&sbi->s_freeblocks_counter,
-			ext3_count_free_blocks(sb));
+	err = dac_init(&sbi->s_alloc_counter, ext3_count_free_blocks(sb));
 	if (!err) {
 		err = percpu_counter_init(&sbi->s_freeinodes_counter,
 				ext3_count_free_inodes(sb));
@@ -2062,7 +2074,7 @@ cantfind_ext3:
 	goto failed_mount;
 
 failed_mount3:
-	percpu_counter_destroy(&sbi->s_freeblocks_counter);
+	dac_destroy(&sbi->s_alloc_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
 	journal_destroy(sbi->s_journal);
@@ -2759,7 +2771,7 @@ static int ext3_statfs (struct dentry * dentry, struct kstatfs * buf)
 	buf->f_type = EXT3_SUPER_MAGIC;
 	buf->f_bsize = sb->s_blocksize;
 	buf->f_blocks = le32_to_cpu(es->s_blocks_count) - sbi->s_overhead_last;
-	buf->f_bfree = percpu_counter_sum_positive(&sbi->s_freeblocks_counter);
+	buf->f_bfree = dac_get_avail_sum(&sbi->s_alloc_counter);
 	buf->f_bavail = buf->f_bfree - le32_to_cpu(es->s_r_blocks_count);
 	if (buf->f_bfree < le32_to_cpu(es->s_r_blocks_count))
 		buf->f_bavail = 0;
-- 
1.7.1

