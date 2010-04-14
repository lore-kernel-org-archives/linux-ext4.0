From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] ext3: fix inode bitmaps manipulation in free_inode
Date: Wed, 14 Apr 2010 15:23:03 +0400
Message-ID: <1271244184-8693-1-git-send-email-dmonakhov@openvz.org>
References: <87pr2246y4.fsf@openvz.org>
Cc: jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:47378 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab0DNLXL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Apr 2010 07:23:11 -0400
Received: by bwz25 with SMTP id 25so6781341bwz.28
        for <linux-ext4@vger.kernel.org>; Wed, 14 Apr 2010 04:23:10 -0700 (PDT)
In-Reply-To: <87pr2246y4.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

- Reorganize locking scheme to batch two atomic operation in to one.
- Fix possible undefined pointer deference.
- Even if group descriptor stats aren't assessable we have to update
  inode bitmaps.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext3/ialloc.c |   62 +++++++++++++++++++++++++++--------------------------
 1 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index ef9008b..8352a68 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -98,7 +98,7 @@ void ext3_free_inode (handle_t *handle, struct inode * inode)
 	struct ext3_group_desc * gdp;
 	struct ext3_super_block * es;
 	struct ext3_sb_info *sbi;
-	int fatal = 0, err;
+	int fatal = 0, err, cleared = 0;
 
 	if (atomic_read(&inode->i_count) > 1) {
 		printk ("ext3_free_inode: inode has count=%d\n",
@@ -150,38 +150,40 @@ void ext3_free_inode (handle_t *handle, struct inode * inode)
 	if (fatal)
 		goto error_return;
 
-	/* Ok, now we can actually update the inode bitmaps.. */
-	if (!ext3_clear_bit_atomic(sb_bgl_lock(sbi, block_group),
-					bit, bitmap_bh->b_data))
-		ext3_error (sb, "ext3_free_inode",
-			      "bit already cleared for inode %lu", ino);
-	else {
-		gdp = ext3_get_group_desc (sb, block_group, &bh2);
-
+	fatal = -ESRCH;
+	gdp = ext3_get_group_desc (sb, block_group, &bh2);
+	if (gdp) {
 		BUFFER_TRACE(bh2, "get_write_access");
 		fatal = ext3_journal_get_write_access(handle, bh2);
-		if (fatal) goto error_return;
-
-		if (gdp) {
-			spin_lock(sb_bgl_lock(sbi, block_group));
-			le16_add_cpu(&gdp->bg_free_inodes_count, 1);
-			if (is_directory)
-				le16_add_cpu(&gdp->bg_used_dirs_count, -1);
-			spin_unlock(sb_bgl_lock(sbi, block_group));
-			percpu_counter_inc(&sbi->s_freeinodes_counter);
-			if (is_directory)
-				percpu_counter_dec(&sbi->s_dirs_counter);
-
-		}
-		BUFFER_TRACE(bh2, "call ext3_journal_dirty_metadata");
-		err = ext3_journal_dirty_metadata(handle, bh2);
-		if (!fatal) fatal = err;
 	}
-	BUFFER_TRACE(bitmap_bh, "call ext3_journal_dirty_metadata");
-	err = ext3_journal_dirty_metadata(handle, bitmap_bh);
-	if (!fatal)
-		fatal = err;
+	spin_lock(sb_bgl_lock(sbi, block_group));
+	if (fatal) {
+		/* Skip group descriptor update, update only inode bitmaps */
+		cleared = ext3_clear_bit(bit, bitmap_bh->b_data);
+		spin_unlock(sb_bgl_lock(sbi, block_group));
+		goto out;
+	}
+	/* Ok, now we can actually update the inode bitmaps.. */
+	cleared = ext3_clear_bit(bit, bitmap_bh->b_data);
+	if (!cleared) {
+		spin_unlock(sb_bgl_lock(sbi, block_group));
+		goto out;
+	}
+	le16_add_cpu(&gdp->bg_free_inodes_count, 1);
+	if (is_directory)
+		le16_add_cpu(&gdp->bg_used_dirs_count, -1);
+	spin_unlock(sb_bgl_lock(sbi, block_group));
+	percpu_counter_inc(&sbi->s_freeinodes_counter);
+	if (is_directory)
+		percpu_counter_dec(&sbi->s_dirs_counter);
 
+	BUFFER_TRACE(bh2, "call ext3_journal_dirty_metadata");
+	err = ext3_journal_dirty_metadata(handle, bh2);
+out:
+	if (cleared) {
+		BUFFER_TRACE(bitmap_bh, "call ext3_journal_dirty_metadata");
+		fatal = ext3_journal_dirty_metadata(handle, bitmap_bh);
+	}
 error_return:
 	brelse(bitmap_bh);
 	ext3_std_error(sb, fatal);
-- 
1.6.6.1

