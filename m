From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/4] Add batched discard support for ext4
Date: Wed,  4 Aug 2010 17:30:12 +0200
Message-ID: <1280935813-4478-3-git-send-email-lczerner@redhat.com>
References: <1280935813-4478-1-git-send-email-lczerner@redhat.com>
Cc: jmoyer@redhat.com, rwheeler@redhat.com, eshishki@redhat.com,
	sandeen@redhat.com, jack@suse.cz, tytso@mit.edu,
	lczerner@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039Ab0HDPa3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Aug 2010 11:30:29 -0400
In-Reply-To: <1280935813-4478-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Walk through each allocation group and trim all free extents. It can be
invoked through TRIM ioctl on the file system. The main idea is to
provide a way to trim the whole file system if needed, since some SSD's
may suffer from performance loss after the whole device was filled (it
does not mean that fs is full!).

It search fro free extents in each allocation group. When the free
extent is found, blocks are marked as used in the buddy bitmap and then
trimmed. Afterwards these blocks are marked as free in per-group buddy
bitmap.

Since fstrim is a long operation it is good to have an ability to interrupt
it by a signal. This was added by Dmitry Monakhov. Thanks Dimitry.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h    |    2 +
 fs/ext4/mballoc.c |  158 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/super.c   |    1 +
 3 files changed, 161 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 19a4de5..a3447d7 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1558,6 +1558,8 @@ extern int ext4_mb_add_groupinfo(struct super_block *sb,
 extern int ext4_mb_get_buddy_cache_lock(struct super_block *, ext4_group_t);
 extern void ext4_mb_put_buddy_cache_lock(struct super_block *,
 						ext4_group_t, int);
+extern int ext4_trim_fs(unsigned int, struct super_block *);
+
 /* inode.c */
 struct buffer_head *ext4_getblk(handle_t *, struct inode *,
 						ext4_lblk_t, int, int *);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 12b3bc0..a16a813 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4690,3 +4690,161 @@ error_return:
 		kmem_cache_free(ext4_ac_cachep, ac);
 	return;
 }
+
+/**
+ * ext4_trim_extent -- function to TRIM one single free extent in the group
+ * @sb:		super block for the file system
+ * @start:	starting block of the free extent in the alloc. group
+ * @count:	number of blocks to TRIM
+ * @group:	alloc. group we are working with
+ * @e4b:	ext4 buddy for the group
+ *
+ * Trim "count" blocks starting at "start" in the "group". To assure that no
+ * one will allocate those blocks, mark it as used in buddy bitmap. This must
+ * be called with under the group lock.
+ */
+static int ext4_trim_extent(struct super_block *sb, int start, int count,
+		ext4_group_t group, struct ext4_buddy *e4b)
+{
+	ext4_fsblk_t discard_block;
+	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
+	struct ext4_free_extent ex;
+	int ret = 0;
+
+	assert_spin_locked(ext4_group_lock_ptr(sb, group));
+
+	ex.fe_start = start;
+	ex.fe_group = group;
+	ex.fe_len = count;
+
+	/*
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
+	ret = sb_issue_discard(sb, discard_block, count);
+	if (ret == -EOPNOTSUPP) {
+		ext4_warning(sb,
+			"discard not supported!");
+	} else if (ret < 0) {
+		ext4_std_error(sb, ret);
+	}
+	cond_resched();
+
+	ext4_lock_group(sb, group);
+	mb_free_blocks(NULL, e4b, start, ex.fe_len);
+	return ret;
+}
+
+/**
+ * ext4_trim_all_free -- function to trim all free space in alloc. group
+ * @sb:			super block for file system
+ * @e4b:		ext4 buddy
+ * @minblocks:		minimum extent block count
+ *
+ * ext4_trim_all_free walks through group's buddy bitmap searching for free
+ * extents. When the free block is found, ext4_trim_extent is called to TRIM
+ * the extent.
+  */
+ext4_grpblk_t ext4_trim_all_free(struct super_block *sb, struct ext4_buddy *e4b,
+		ext4_grpblk_t minblocks)
+{
+	void *bitmap;
+	ext4_grpblk_t max = EXT4_BLOCKS_PER_GROUP(sb);
+	ext4_grpblk_t start, next, count = 0;
+	ext4_group_t group;
+	int ret = 0;
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
+			ret = ext4_trim_extent(sb, start,
+				next - start, group, e4b);
+			if (ret < 0)
+				break;
+			count += next - start;
+		}
+		start = next + 1;
+
+		if (signal_pending(current)) {
+			count = -ERESTARTSYS;
+			break;
+		}
+
+		if ((e4b->bd_info->bb_free - count) < minblocks)
+			break;
+	}
+	ext4_unlock_group(sb, group);
+
+	ext4_debug("trimmed %d blocks in the group %d\n",
+		count, group);
+
+	if (ret < 0)
+		count = ret;
+
+	return count;
+}
+
+/**
+ * ext4_trim_fs() -- trim ioctl handle function
+ * @minlen:		minimum extent length in Bytes
+ * @sb:			superblock for filesystem
+ *
+ * ext4_trim_fs goes through all allocation group searching for groups with more
+ * free space than minlen. For such a group ext4_trim_all_free function is
+ * invoked to trim all free space.
+ */
+int ext4_trim_fs(unsigned int minlen, struct super_block *sb)
+{
+	struct ext4_buddy e4b;
+	ext4_group_t group;
+	ext4_group_t ngroups = ext4_get_groups_count(sb);
+	ext4_grpblk_t minblocks, cnt;
+	int ret = 0;
+
+	minblocks = DIV_ROUND_UP(minlen, sb->s_blocksize);
+	if (unlikely(minblocks > EXT4_BLOCKS_PER_GROUP(sb)))
+		return -EINVAL;
+
+	for (group = 0; group < ngroups; group++) {
+
+		ret = ext4_mb_load_buddy(sb, group, &e4b);
+		if (ret) {
+			ext4_error(sb, "Error in loading buddy "
+					"information for %u", group);
+			break;
+		}
+
+		if (e4b.bd_info->bb_free >= minblocks) {
+			cnt = ext4_trim_all_free(sb, &e4b, minblocks);
+			if (cnt < 0) {
+				ret = cnt;
+				ext4_mb_unload_buddy(&e4b);
+				break;
+			}
+		}
+		ext4_mb_unload_buddy(&e4b);
+	}
+	return ret;
+}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4e8983a..995989b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1114,6 +1114,7 @@ static const struct super_operations ext4_sops = {
 	.quota_write	= ext4_quota_write,
 #endif
 	.bdev_try_to_free_page = bdev_try_to_free_page,
+	.trim_fs	= ext4_trim_fs
 };
 
 static const struct super_operations ext4_nojournal_sops = {
-- 
1.7.2

