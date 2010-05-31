From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH v2.6.32.y 41/53] ext4: clean up inode bitmaps manipulation in ext4_free_inode
Date: Sun, 30 May 2010 22:49:54 -0400
Message-ID: <1275274206-3900-41-git-send-email-tytso@mit.edu>
References: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	"Theodore Ts'o" <tytso@mit.edu>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:44587 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755487Ab0EaCuQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 30 May 2010 22:50:16 -0400
In-Reply-To: <1275274206-3900-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Dmitry Monakhov <dmonakhov@openvz.org>

commit d17413c08cd2b1dd2bf2cfdbb0f7b736b2b2b15c upstrea (as of v2..34-git13)

- Reorganize locking scheme to batch two atomic operation in to one.
  This also allow us to state what healthy group must obey following rule
  ext4_free_inodes_count(sb, gdp) == ext4_count_free(inode_bitmap, NUM);
- Fix possible undefined pointer dereference.
- Even if group descriptor stats aren't accessible we have to update
  inode bitmaps.
- Move non-group members update out of group_lock.

Note: this commit has been observed to fix fs corruption problems
under heavy fs load

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ialloc.c |   83 ++++++++++++++++++++++++-----------------------------
 1 files changed, 38 insertions(+), 45 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 8b4bb11..c55275a 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -244,57 +244,50 @@ void ext4_free_inode(handle_t *handle, struct inode *inode)
 	if (fatal)
 		goto error_return;
 
-	/* Ok, now we can actually update the inode bitmaps.. */
-	cleared = ext4_clear_bit_atomic(ext4_group_lock_ptr(sb, block_group),
-					bit, bitmap_bh->b_data);
-	if (!cleared)
-		ext4_error(sb, "ext4_free_inode",
-			   "bit already cleared for inode %lu", ino);
-	else {
-		gdp = ext4_get_group_desc(sb, block_group, &bh2);
-
+	fatal = -ESRCH;
+	gdp = ext4_get_group_desc(sb, block_group, &bh2);
+	if (gdp) {
 		BUFFER_TRACE(bh2, "get_write_access");
 		fatal = ext4_journal_get_write_access(handle, bh2);
-		if (fatal) goto error_return;
-
-		if (gdp) {
-			ext4_lock_group(sb, block_group);
-			count = ext4_free_inodes_count(sb, gdp) + 1;
-			ext4_free_inodes_set(sb, gdp, count);
-			if (is_directory) {
-				count = ext4_used_dirs_count(sb, gdp) - 1;
-				ext4_used_dirs_set(sb, gdp, count);
-				if (sbi->s_log_groups_per_flex) {
-					ext4_group_t f;
-
-					f = ext4_flex_group(sbi, block_group);
-					atomic_dec(&sbi->s_flex_groups[f].used_dirs);
-				}
+	}
+	ext4_lock_group(sb, block_group);
+	cleared = ext4_clear_bit(bit, bitmap_bh->b_data);
+	if (fatal || !cleared) {
+		ext4_unlock_group(sb, block_group);
+		goto out;
+	}
 
-			}
-			gdp->bg_checksum = ext4_group_desc_csum(sbi,
-							block_group, gdp);
-			ext4_unlock_group(sb, block_group);
-			percpu_counter_inc(&sbi->s_freeinodes_counter);
-			if (is_directory)
-				percpu_counter_dec(&sbi->s_dirs_counter);
-
-			if (sbi->s_log_groups_per_flex) {
-				ext4_group_t f;
-
-				f = ext4_flex_group(sbi, block_group);
-				atomic_inc(&sbi->s_flex_groups[f].free_inodes);
-			}
-		}
-		BUFFER_TRACE(bh2, "call ext4_handle_dirty_metadata");
-		err = ext4_handle_dirty_metadata(handle, NULL, bh2);
-		if (!fatal) fatal = err;
+	count = ext4_free_inodes_count(sb, gdp) + 1;
+	ext4_free_inodes_set(sb, gdp, count);
+	if (is_directory) {
+		count = ext4_used_dirs_count(sb, gdp) - 1;
+		ext4_used_dirs_set(sb, gdp, count);
+		percpu_counter_dec(&sbi->s_dirs_counter);
 	}
-	BUFFER_TRACE(bitmap_bh, "call ext4_handle_dirty_metadata");
-	err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
-	if (!fatal)
-		fatal = err;
-	sb->s_dirt = 1;
+	gdp->bg_checksum = ext4_group_desc_csum(sbi, block_group, gdp);
+	ext4_unlock_group(sb, block_group);
+
+	percpu_counter_inc(&sbi->s_freeinodes_counter);
+	if (sbi->s_log_groups_per_flex) {
+		ext4_group_t f = ext4_flex_group(sbi, block_group);
+
+		atomic_inc(&sbi->s_flex_groups[f].free_inodes);
+		if (is_directory)
+			atomic_dec(&sbi->s_flex_groups[f].used_dirs);
+	}
+	BUFFER_TRACE(bh2, "call ext4_handle_dirty_metadata");
+	fatal = ext4_handle_dirty_metadata(handle, NULL, bh2);
+out:
+	if (cleared) {
+		BUFFER_TRACE(bitmap_bh, "call ext4_handle_dirty_metadata");
+		err = ext4_handle_dirty_metadata(handle, NULL, bitmap_bh);
+		if (!fatal)
+			fatal = err;
+		sb->s_dirt = 1;
+	} else
+		ext4_error(sb, "ext4_free_inode",
+			   "bit already cleared for inode %lu", ino);
+
 error_return:
 	brelse(bitmap_bh);
 	ext4_std_error(sb, fatal);
-- 
1.6.6.1.1.g974db.dirty

