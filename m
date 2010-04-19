From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2] Add batched discard support for ext4.
Date: Mon, 19 Apr 2010 12:55:27 +0200
Message-ID: <1271674527-2977-3-git-send-email-lczerner@redhat.com>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com>
 <1271674527-2977-2-git-send-email-lczerner@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250Ab0DSK4L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Apr 2010 06:56:11 -0400
Received: from int-mx03.intmail.prod.int.phx2.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o3JAuBdt007134
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 19 Apr 2010 06:56:11 -0400
In-Reply-To: <1271674527-2977-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Create an ioctl which walks through all the free extents in each
allocating group and discard those extents. As an addition to improve
its performance one can specify minimum free extent length, so ioctl
will not bother with shorter extents.

This of course means, that with each invocation the ioctl must walk
through whole file system, checking and discarding free extents, which
is not very efficient. The best way to avoid this is to keep track of
deleted (freed) blocks. Then the ioctl have to trim just those free
extents which were recently freed.

In order to implement this I have added new bitmap into ext4_group_info
(bb_bitmap_deleted) which stores recently freed blocks. The ioctl then
walk through bb_bitmap_deleted, compare deleted extents with free
extents trim them and then removes it from the bb_bitmap_deleted. 

But you may notice, that there is one problem. bb_bitmap_deleted does
not survive umount. To bypass the problem the first ioctl call have to
walk through whole file system trimming all free extents.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/ext4.h    |    4 +
 fs/ext4/mballoc.c |  207 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/ext4/super.c   |    1 +
 3 files changed, 202 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bf938cf..e25f672 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1437,6 +1437,8 @@ extern int ext4_mb_add_groupinfo(struct super_block *sb,
 extern int ext4_mb_get_buddy_cache_lock(struct super_block *, ext4_group_t);
 extern void ext4_mb_put_buddy_cache_lock(struct super_block *,
 						ext4_group_t, int);
+extern int ext4_trim_fs(unsigned int, struct super_block *);
+
 /* inode.c */
 struct buffer_head *ext4_getblk(handle_t *, struct inode *,
 						ext4_lblk_t, int, int *);
@@ -1682,6 +1684,8 @@ struct ext4_group_info {
 #ifdef DOUBLE_CHECK
 	void            *bb_bitmap;
 #endif
+	void		*bb_bitmap_deleted;
+	ext4_grpblk_t	bb_deleted;
 	struct rw_semaphore alloc_sem;
 	ext4_grpblk_t	bb_counters[];	/* Nr of free power-of-two-block
 					 * regions, index is order.
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index bde9d0b..fbc83fe 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2255,6 +2255,9 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 	INIT_LIST_HEAD(&meta_group_info[i]->bb_prealloc_list);
 	init_rwsem(&meta_group_info[i]->alloc_sem);
 	meta_group_info[i]->bb_free_root = RB_ROOT;
+	meta_group_info[i]->bb_deleted = -1;
+
+
 
 #ifdef DOUBLE_CHECK
 	{
@@ -2469,6 +2472,7 @@ int ext4_mb_release(struct super_block *sb)
 #ifdef DOUBLE_CHECK
 			kfree(grinfo->bb_bitmap);
 #endif
+			kfree(grinfo->bb_bitmap_deleted);
 			ext4_lock_group(sb, i);
 			ext4_mb_cleanup_pa(grinfo);
 			ext4_unlock_group(sb, i);
@@ -2528,6 +2532,7 @@ static void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
 	int err, count = 0, count2 = 0;
 	struct ext4_free_data *entry;
 	struct list_head *l, *ltmp;
+	void *bitmap_deleted = NULL;
 
 	list_for_each_safe(l, ltmp, &txn->t_private_list) {
 		entry = list_entry(l, struct ext4_free_data, list);
@@ -2543,6 +2548,14 @@ static void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
 		/* there are blocks to put in buddy to make them really free */
 		count += entry->count;
 		count2++;
+
+		if (test_opt(sb, DISCARD) &&
+			(db->bb_bitmap_deleted == NULL) &&
+			(db->bb_deleted >= 0)) {
+			bitmap_deleted =
+				kmalloc(sb->s_blocksize, GFP_KERNEL);
+		}
+
 		ext4_lock_group(sb, entry->group);
 		/* Take it out of per group rb tree */
 		rb_erase(&entry->node, &(db->bb_free_root));
@@ -2555,17 +2568,24 @@ static void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
 			page_cache_release(e4b.bd_buddy_page);
 			page_cache_release(e4b.bd_bitmap_page);
 		}
-		ext4_unlock_group(sb, entry->group);
-		if (test_opt(sb, DISCARD)) {
-			ext4_fsblk_t discard_block;
-
-			discard_block = entry->start_blk +
-				ext4_group_first_block_no(sb, entry->group);
-			trace_ext4_discard_blocks(sb,
-					(unsigned long long)discard_block,
-					entry->count);
-			sb_issue_discard(sb, discard_block, entry->count);
+		if (test_opt(sb, DISCARD) && (db->bb_deleted >= 0)) {
+			if (db->bb_bitmap_deleted == NULL) {
+				db->bb_bitmap_deleted = bitmap_deleted;
+				BUG_ON(db->bb_bitmap_deleted == NULL);
+
+				bitmap_deleted = NULL;
+				mb_clear_bits(db->bb_bitmap_deleted,
+					0, EXT4_BLOCKS_PER_GROUP(sb));
+			}
+
+			db->bb_deleted += entry->count;
+			mb_set_bits(db->bb_bitmap_deleted, entry->start_blk,
+				 entry->count);
 		}
+		ext4_unlock_group(sb, entry->group);
+
+		kfree(bitmap_deleted);
+
 		kmem_cache_free(ext4_free_ext_cachep, entry);
 		ext4_mb_release_desc(&e4b);
 	}
@@ -4639,3 +4659,170 @@ error_return:
 		kmem_cache_free(ext4_ac_cachep, ac);
 	return;
 }
+
+/* Trim "count" blocks starting at "start" in "group"
+ * This must be called under group lock
+ */
+void ext4_trim_extent(struct super_block *sb, int start, int count,
+		ext4_group_t group, struct ext4_buddy *e4b)
+{
+	ext4_fsblk_t discard_block;
+	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
+	struct ext4_free_extent ex;
+
+	assert_spin_locked(ext4_group_lock_ptr(sb, group));
+
+	ex.fe_start = start;
+	ex.fe_group = group;
+	ex.fe_len = count;
+
+	mb_mark_used(e4b, &ex);
+	ext4_unlock_group(sb, group);
+
+	discard_block = (ext4_fsblk_t)group *
+			EXT4_BLOCKS_PER_GROUP(sb)
+			+ start
+			+ le32_to_cpu(es->s_first_data_block);
+	trace_ext4_discard_blocks(sb,
+			(unsigned long long)discard_block,
+			count);
+	sb_issue_discard(sb, discard_block, count);
+
+	ext4_lock_group(sb, group);
+	mb_free_blocks(NULL, e4b, start, ex.fe_len);
+}
+
+/* Trim all free blocks, which have at least minlen length */
+ext4_grpblk_t ext4_trim_all_free(struct super_block *sb, struct ext4_buddy *e4b,
+		ext4_grpblk_t minblocks)
+{
+	void *bitmap;
+	ext4_grpblk_t max = EXT4_BLOCKS_PER_GROUP(sb);
+	ext4_grpblk_t start, next, count = 0;
+	ext4_group_t group;
+
+	BUG_ON(e4b == NULL);
+
+	bitmap = e4b->bd_bitmap;
+	group = e4b->bd_group;
+	start = 0;
+	ext4_lock_group(sb, group);
+
+	while (start < max) {
+
+		start = mb_find_next_zero_bit(bitmap, max, start);
+		if (start >= max)
+			break;
+		next = mb_find_next_bit(bitmap, max, start);
+
+		if ((next - start) >= minblocks) {
+
+			count += next - start;
+			ext4_trim_extent(sb, start,
+				next - start, group, e4b);
+
+		}
+		start = next + 1;
+	}
+
+	e4b->bd_info->bb_deleted = 0;
+	ext4_unlock_group(sb, group);
+
+	return count;
+}
+
+/* Trim only blocks which is free and in bb_bitmap_deleted */
+ext4_grpblk_t ext4_trim_deleted(struct super_block *sb, struct ext4_buddy *e4b,
+		ext4_grpblk_t minblocks)
+{
+	void *bitmap;
+	struct ext4_group_info *grp;
+	ext4_group_t group;
+	ext4_grpblk_t max, next, count = 0, start = 0;
+
+	BUG_ON(e4b == NULL);
+
+	bitmap = e4b->bd_bitmap;
+	group = e4b->bd_group;
+	grp = ext4_get_group_info(sb, group);
+
+	if (grp->bb_deleted < minblocks)
+		return 0;
+
+	ext4_lock_group(sb, group);
+
+	while (start < EXT4_BLOCKS_PER_GROUP(sb)) {
+		start = mb_find_next_bit(grp->bb_bitmap_deleted,
+			EXT4_BLOCKS_PER_GROUP(sb), start);
+		max = mb_find_next_zero_bit(grp->bb_bitmap_deleted,
+			EXT4_BLOCKS_PER_GROUP(sb), start);
+
+		while (start < max) {
+			start = mb_find_next_zero_bit(bitmap, max, start);
+			if (start >= max)
+				break;
+			next = mb_find_next_bit(bitmap, max, start);
+			if (next > max)
+				next = max;
+
+			if ((next - start) >= minblocks) {
+				count += next - start;
+
+				ext4_trim_extent(sb, start,
+					next - start, group, e4b);
+
+				mb_clear_bits(grp->bb_bitmap_deleted,
+					start, next - start);
+			}
+			start = next + 1;
+		}
+	}
+	grp->bb_deleted -= count;
+
+	ext4_unlock_group(sb, group);
+
+	ext4_debug("trimmed %d blocks in the group %d\n",
+		count, group);
+
+	return count;
+}
+
+int ext4_trim_fs(unsigned int minlen, struct super_block *sb)
+{
+	struct ext4_buddy e4b;
+	struct ext4_group_info *grp;
+	ext4_group_t group;
+	ext4_group_t ngroups = ext4_get_groups_count(sb);
+	ext4_grpblk_t minblocks;
+
+	if (!test_opt(sb, DISCARD))
+		return 0;
+
+	minblocks = DIV_ROUND_UP(minlen, sb->s_blocksize);
+	if (unlikely(minblocks > EXT4_BLOCKS_PER_GROUP(sb)))
+		return -EINVAL;
+
+	for (group = 0; group < ngroups; group++) {
+		int err;
+
+		err = ext4_mb_load_buddy(sb, group, &e4b);
+		if (err) {
+			ext4_error(sb, "Error in loading buddy "
+					"information for %u", group);
+			continue;
+		}
+		grp = ext4_get_group_info(sb, group);
+
+		if (grp->bb_deleted < 0) {
+			/* First run after mount */
+			ext4_trim_all_free(sb, &e4b, minblocks);
+		} else if (grp->bb_deleted >= minblocks) {
+			/* Trim only blocks deleted since first run */
+			ext4_trim_deleted(sb, &e4b, minblocks);
+		}
+
+		ext4_mb_release_desc(&e4b);
+	}
+
+	return 0;
+}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index e14d22c..253eb98 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1109,6 +1109,7 @@ static const struct super_operations ext4_sops = {
 	.quota_write	= ext4_quota_write,
 #endif
 	.bdev_try_to_free_page = bdev_try_to_free_page,
+	.trim_fs	= ext4_trim_fs
 };
 
 static const struct super_operations ext4_nojournal_sops = {
-- 
1.6.6.1

