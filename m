From: amir73il@users.sourceforge.net
Subject: [PATCH v1 05/36] ext4: snapshot hooks - delete blocks
Date: Tue,  7 Jun 2011 18:07:32 +0300
Message-ID: <1307459283-22130-6-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41767 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab1FGPJI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:09:08 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so5035787wwa.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:09:07 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Before deleting file blocks in ext4_free_blocks(),
we call the snapshot API ext4_snapshot_get_delete_access(),
to optionally move the block to the snapshot file instead of
freeing them.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4.h     |   10 +++++++---
 fs/ext4/mballoc.c  |   30 +++++++++++++++++++++++++++---
 fs/ext4/snapshot.h |   26 ++++++++++++++++++++++++++
 3 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 756848f..b910dcb 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1731,9 +1731,13 @@ extern int ext4_mb_reserve_blocks(struct super_block *, int);
 extern void ext4_discard_preallocations(struct inode *);
 extern int __init ext4_init_mballoc(void);
 extern void ext4_exit_mballoc(void);
-extern void ext4_free_blocks(handle_t *handle, struct inode *inode,
-			     struct buffer_head *bh, ext4_fsblk_t block,
-			     unsigned long count, int flags);
+extern void __ext4_free_blocks(const char *where, unsigned int line,
+			       handle_t *handle,  struct inode *inode,
+			       struct buffer_head *bh, ext4_fsblk_t block,
+			       unsigned long count, int flags);
+#define ext4_free_blocks(handle, inode, bh, block, count, flags) \
+	__ext4_free_blocks(__func__, __LINE__ , (handle), (inode), (bh), \
+			   (block), (count), (flags))
 extern int ext4_mb_add_groupinfo(struct super_block *sb,
 		ext4_group_t i, struct ext4_group_desc *desc);
 extern int ext4_trim_fs(struct super_block *, struct fstrim_range *);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 6b400f2..f878449 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4451,9 +4451,9 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
  * @count:		number of blocks to count
  * @metadata: 		Are these metadata blocks
  */
-void ext4_free_blocks(handle_t *handle, struct inode *inode,
-		      struct buffer_head *bh, ext4_fsblk_t block,
-		      unsigned long count, int flags)
+void __ext4_free_blocks(const char *where, unsigned int line, handle_t *handle,
+			struct inode *inode, struct buffer_head *bh,
+			ext4_fsblk_t block, unsigned long count, int flags)
 {
 	struct buffer_head *bitmap_bh = NULL;
 	struct super_block *sb = inode->i_sb;
@@ -4467,6 +4467,7 @@ void ext4_free_blocks(handle_t *handle, struct inode *inode,
 	struct ext4_buddy e4b;
 	int err = 0;
 	int ret;
+	int maxblocks;
 
 	if (bh) {
 		if (block)
@@ -4549,6 +4550,29 @@ do_more:
 		goto error_return;
 	}
 
+	maxblocks = count;
+	ret = ext4_snapshot_get_delete_access(handle, inode,
+					      block, &maxblocks);
+	if (ret < 0) {
+		ext4_journal_abort_handle(where, line, __func__,
+					  NULL, handle, ret);
+		err = ret;
+		goto error_return;
+	}
+	if (ret > 0) {
+		/* 'ret' blocks were moved to snapshot - skip them */
+		block += maxblocks;
+		count -= maxblocks;
+		count += overflow;
+		cond_resched();
+		if (count > 0)
+			goto do_more;
+		/* no more blocks to free/move to snapshot */
+		ext4_mark_super_dirty(sb);
+		goto error_return;
+	}
+	overflow += count - maxblocks;
+	count = maxblocks;
 	BUFFER_TRACE(bitmap_bh, "getting write access");
 	err = ext4_handle_get_bitmap_access(handle, sb, block_group, bitmap_bh);
 	if (err)
diff --git a/fs/ext4/snapshot.h b/fs/ext4/snapshot.h
index 008f4a9..504dfd5 100644
--- a/fs/ext4/snapshot.h
+++ b/fs/ext4/snapshot.h
@@ -227,6 +227,32 @@ static inline int ext4_snapshot_get_bitmap_access(handle_t *handle,
 	return ext4_snapshot_cow(handle, NULL, bh->b_blocknr, bh, 1);
 }
 
+/*
+ * get_delete_access() - move blocks to snapshot or approve to free them
+ * @handle:	JBD handle
+ * @inode:	owner of blocks if known (or NULL otherwise)
+ * @block:	address of start @block
+ * @pcount:	pointer to no. of blocks about to move or approve
+ *
+ * Called from ext4_free_blocks() before deleting blocks with
+ * i_data_sem held
+ *
+ * Return values:
+ * > 0 - blocks were moved to snapshot and may not be freed
+ * = 0 - blocks may be freed
+ * < 0 - error
+ */
+static inline int ext4_snapshot_get_delete_access(handle_t *handle,
+		struct inode *inode, ext4_fsblk_t block, int *pcount)
+{
+	struct super_block *sb;
+
+	sb = handle->h_transaction->t_journal->j_private;
+	if (!EXT4_SNAPSHOTS(sb))
+		return 0;
+
+	return ext4_snapshot_move(handle, inode, block, pcount, 1);
+}
 
 
 /* snapshot_ctl.c */
-- 
1.7.4.1

