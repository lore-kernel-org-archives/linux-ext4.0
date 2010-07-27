From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/3] Add batched discard support for ext4
Date: Tue, 27 Jul 2010 14:41:54 +0200
Message-ID: <1280234514-10287-4-git-send-email-lczerner@redhat.com>
References: <1280234514-10287-1-git-send-email-lczerner@redhat.com>
Cc: jmoyer@redhat.com, rwheeler@redhat.com, eshishki@redhat.com,
	sandeen@redhat.com, jack@suse.cz, tytso@mit.edu,
	Lukas Czerner <lczerner@redhat.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084Ab0G0Mnd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Jul 2010 08:43:33 -0400
In-Reply-To: <1280234514-10287-1-git-send-email-lczerner@redhat.com>
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

Since fstrim is a long operation it is good to have an ability to interrupt
it by a signal. This was added by Dmitry Monakhov. Thanks Dimitry.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h    |    2 +
 fs/ext4/mballoc.c |  103 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/super.c   |    1 +
 3 files changed, 106 insertions(+), 0 deletions(-)

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
index b423a36..f00b7dd 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4640,3 +4640,106 @@ error_return:
 		kmem_cache_free(ext4_ac_cachep, ac);
 	return;
 }
+
+/**
+ * Trim "count" blocks starting at "start" in "group"
+ * This must be called under group lock
+ */
+static void ext4_trim_extent(struct super_block *sb, int start, int count,
+		ext4_group_t group)
+{
+	ext4_fsblk_t discard_block;
+	struct ext4_super_block *es = EXT4_SB(sb)->s_es;
+
+	discard_block = (ext4_fsblk_t)group *
+			EXT4_BLOCKS_PER_GROUP(sb)
+			+ start
+			+ le32_to_cpu(es->s_first_data_block);
+	trace_ext4_discard_blocks(sb,
+			(unsigned long long)discard_block,
+			count);
+	sb_issue_discard(sb, discard_block, count);
+	cond_resched();
+}
+
+/**
+ * Trim all free extents in group at least minblocks long
+ */
+ext4_grpblk_t ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
+		ext4_grpblk_t minblocks)
+{
+	struct buffer_head *bitmap_bh = NULL;
+	ext4_grpblk_t max = EXT4_BLOCKS_PER_GROUP(sb);
+	ext4_grpblk_t start, next, count = 0;
+	struct ext4_group_info *grp;
+	int err = 0;
+
+	err = -EIO;
+	bitmap_bh = ext4_read_block_bitmap(sb, group);
+	if (!bitmap_bh)
+		return 0;
+
+	grp = ext4_get_group_info(sb, group);
+	start = grp->bb_first_free;
+
+	down_write(&grp->alloc_sem);
+	while (start < max) {
+
+		start = mb_find_next_zero_bit(bitmap_bh->b_data, max, start);
+		if (start >= max)
+			break;
+		next = mb_find_next_bit(bitmap_bh->b_data, max, start);
+
+		if ((next - start) >= minblocks) {
+			count += next - start;
+			ext4_trim_extent(sb, start,
+				next - start, group);
+		}
+		start = next + 1;
+		if (signal_pending(current)) {
+			count = -ERESTARTSYS;
+			break;
+		}
+		if ((grp->bb_free - count) < minblocks)
+			break;
+	}
+	up_write(&grp->alloc_sem);
+
+	ext4_debug("trimmed %d blocks in the group %d\n",
+		count, group);
+
+	brelse(bitmap_bh);
+	return count;
+}
+
+/**
+ * ext4_trim_fs goes through all allocation groups searching for group with
+ * more free space than minlen. For such a group ext4_trim_all_free function
+ * is invoked to trim all free space.
+ */
+int ext4_trim_fs(unsigned int minlen, struct super_block *sb)
+{
+	ext4_group_t group;
+	ext4_group_t ngroups = ext4_get_groups_count(sb);
+	ext4_grpblk_t minblocks, cnt;
+	struct ext4_group_info *grp;
+	int ret = 0;
+
+	minblocks = DIV_ROUND_UP(minlen, sb->s_blocksize);
+	if (unlikely(minblocks > EXT4_BLOCKS_PER_GROUP(sb)))
+		return -EINVAL;
+
+	for (group = 0; group < ngroups; group++) {
+
+		grp = ext4_get_group_info(sb, group);
+
+		if (grp->bb_free >= minblocks) {
+			cnt = ext4_trim_all_free(sb, group, minblocks);
+			if (cnt < 0) {
+				ret = cnt;
+				break;
+			}
+		}
+	}
+	return ret;
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
1.7.1.1

