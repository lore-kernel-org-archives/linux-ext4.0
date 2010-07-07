From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2] Add batched discard support for ext4
Date: Wed,  7 Jul 2010 09:53:32 +0200
Message-ID: <1278489212-12110-3-git-send-email-lczerner@redhat.com>
References: <1278489212-12110-1-git-send-email-lczerner@redhat.com>
Cc: lczerner@redhat.com, jmoyer@redhat.com, rwheeler@redhat.com,
	linux-ext4@vger.kernel.org, sandeen@redhat.com
To: eshishki@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923Ab0GGHyE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Jul 2010 03:54:04 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o677s4vJ031569
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 7 Jul 2010 03:54:04 -0400
In-Reply-To: <1278489212-12110-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Walk through each allocation group and trim all free extents. It can be
invoked through TRIM ioctl on the file system. The main idea is to
provide a way to trim the whole file system if needed, since some SSD's
may suffer from performance loss after the whole device was filled (it
does not mean that fs is full!).

It search fro free extents in each allocation group. When the free
extent is found, blocks are marked as used and then trimmed. Afterwards
these blocks are marked as free in per-group bitmap.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/ext4.h    |    2 +
 fs/ext4/mballoc.c |  126 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/ext4/super.c   |    1 +
 3 files changed, 118 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index bf938cf..ba0fff0 100644
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
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index b423a36..c7b541c 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2535,17 +2535,6 @@ static void release_blocks_on_commit(journal_t *journal, transaction_t *txn)
 		mb_debug(1, "gonna free %u blocks in group %u (0x%p):",
 			 entry->count, entry->group, entry);
 
-		if (test_opt(sb, DISCARD)) {
-			ext4_fsblk_t discard_block;
-
-			discard_block = entry->start_blk +
-				ext4_group_first_block_no(sb, entry->group);
-			trace_ext4_discard_blocks(sb,
-					(unsigned long long)discard_block,
-					entry->count);
-			sb_issue_discard(sb, discard_block, entry->count);
-		}
-
 		err = ext4_mb_load_buddy(sb, entry->group, &e4b);
 		/* we expect to find existing buddy because it's pinned */
 		BUG_ON(err != 0);
@@ -4640,3 +4629,118 @@ error_return:
 		kmem_cache_free(ext4_ac_cachep, ac);
 	return;
 }
+
+/**
+ * Trim "count" blocks starting at "start" in "group"
+ * This must be called under group lock
+ */
+static void ext4_trim_extent(struct super_block *sb, int start, int count,
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
+	/**
+	 * Mark blocks used, so no one can reuse them while
+	 * being trimmed.
+	 */
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
+/**
+ * Trim all free extents in group at least minblocks long
+ */
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
+	start = e4b->bd_info->bb_first_free;
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
+			count += next - start;
+			ext4_trim_extent(sb, start,
+				next - start, group, e4b);
+		}
+		start = next + 1;
+
+		if ((e4b->bd_info->bb_free - count) < minblocks)
+			break;
+	}
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
+
+		if (e4b.bd_info->bb_free >= minblocks) {
+			ext4_trim_all_free(sb, &e4b, minblocks);
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

