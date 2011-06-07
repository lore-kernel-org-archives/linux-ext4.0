From: amir73il@users.sourceforge.net
Subject: [PATCH v1 04/36] ext4: snapshot hooks - block bitmap access
Date: Tue,  7 Jun 2011 18:07:31 +0300
Message-ID: <1307459283-22130-5-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41767 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab1FGPJG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:09:06 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so5035787wwa.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:09:05 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

The API ext4_handle_get_bitmap_access() is used instead of
ext4_journal_get_write_access(), before modifying a block bitmap
while allocating or deleting blocks.  The bitmap access API is
used to initialize the COW bitmap for that group.
The old ext4_journal_get_undo_access() API was removed because it
is not being used in the code.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4_jbd2.c |   10 +++++++---
 fs/ext4/ext4_jbd2.h |   10 ++++++----
 fs/ext4/mballoc.c   |    7 ++++---
 fs/ext4/snapshot.h  |   31 +++++++++++++++++++++++++++++++
 4 files changed, 48 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 833969b..c44c362 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -9,13 +9,17 @@
 
 #include <trace/events/ext4.h>
 
-int __ext4_journal_get_undo_access(const char *where, unsigned int line,
-				   handle_t *handle, struct buffer_head *bh)
+int __ext4_handle_get_bitmap_access(const char *where, unsigned int line,
+				    handle_t *handle, struct super_block *sb,
+				    ext4_group_t group, struct buffer_head *bh)
 {
 	int err = 0;
 
 	if (ext4_handle_valid(handle)) {
-		err = jbd2_journal_get_undo_access(handle, bh);
+		err = jbd2_journal_get_write_access(handle, bh);
+		if (!err)
+			err = ext4_snapshot_get_bitmap_access(handle, sb,
+							      group, bh);
 		if (err)
 			ext4_journal_abort_handle(where, line, __func__, bh,
 						  handle, err);
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index ca6e135..be3b8b3 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -129,8 +129,9 @@ void ext4_journal_abort_handle(const char *caller, unsigned int line,
 			       const char *err_fn,
 		struct buffer_head *bh, handle_t *handle, int err);
 
-int __ext4_journal_get_undo_access(const char *where, unsigned int line,
-				   handle_t *handle, struct buffer_head *bh);
+int __ext4_handle_get_bitmap_access(const char *where, unsigned int line,
+				    handle_t *handle, struct super_block *sb,
+				    ext4_group_t group, struct buffer_head *bh);
 
 int __ext4_journal_get_write_access_inode(const char *where, unsigned int line,
 					 handle_t *handle, struct inode *inode,
@@ -149,8 +150,9 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 int __ext4_handle_dirty_super(const char *where, unsigned int line,
 			      handle_t *handle, struct super_block *sb);
 
-#define ext4_journal_get_undo_access(handle, bh) \
-	__ext4_journal_get_undo_access(__func__, __LINE__, (handle), (bh))
+#define ext4_handle_get_bitmap_access(handle, sb, group, bh) \
+	__ext4_handle_get_bitmap_access(__func__, __LINE__, \
+					(handle), (sb), (group), (bh))
 #define ext4_journal_get_write_access_exclude(handle, bh) \
 	__ext4_journal_get_write_access_inode(__func__, __LINE__, \
 						 (handle), NULL, (bh), 1)
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 54ea8c8..6b400f2 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2749,7 +2749,8 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	if (!bitmap_bh)
 		goto out_err;
 
-	err = ext4_journal_get_write_access(handle, bitmap_bh);
+	err = ext4_handle_get_bitmap_access(handle, sb, ac->ac_b_ex.fe_group,
+			bitmap_bh);
 	if (err)
 		goto out_err;
 
@@ -4549,7 +4550,7 @@ do_more:
 	}
 
 	BUFFER_TRACE(bitmap_bh, "getting write access");
-	err = ext4_journal_get_write_access(handle, bitmap_bh);
+	err = ext4_handle_get_bitmap_access(handle, sb, block_group, bitmap_bh);
 	if (err)
 		goto error_return;
 
@@ -4698,7 +4699,7 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 	}
 
 	BUFFER_TRACE(bitmap_bh, "getting write access");
-	err = ext4_journal_get_write_access(handle, bitmap_bh);
+	err = ext4_handle_get_bitmap_access(handle, sb, block_group, bitmap_bh);
 	if (err)
 		goto error_return;
 
diff --git a/fs/ext4/snapshot.h b/fs/ext4/snapshot.h
index 54241b9..008f4a9 100644
--- a/fs/ext4/snapshot.h
+++ b/fs/ext4/snapshot.h
@@ -196,6 +196,37 @@ static inline int ext4_snapshot_get_create_access(handle_t *handle,
 	return err;
 }
 
+/*
+ * get_bitmap_access() is called before modifying a block bitmap.
+ * this call initializes the COW bitmap for @group.
+ *
+ * Return values:
+ * = 0 - COW bitmap is initialized
+ * < 0 - error
+ */
+static inline int ext4_snapshot_get_bitmap_access(handle_t *handle,
+		struct super_block *sb, ext4_group_t group,
+		struct buffer_head *bh)
+{
+	if (!EXT4_SNAPSHOTS(sb))
+		return 0;
+	/*
+	 * With flex_bg, block bitmap may reside in a different group than
+	 * the group it describes, so we need to init both COW bitmaps:
+	 * 1. init the COW bitmap for @group by testing
+	 *    if the first block in the group should be COWed
+	 */
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+		int err = ext4_snapshot_cow(handle, NULL,
+				ext4_group_first_block_no(sb, group),
+				NULL, 0);
+		if (err < 0)
+			return err;
+	}
+	/* 2. COW the block bitmap itself, which may be in another group */
+	return ext4_snapshot_cow(handle, NULL, bh->b_blocknr, bh, 1);
+}
+
 
 
 /* snapshot_ctl.c */
-- 
1.7.4.1

