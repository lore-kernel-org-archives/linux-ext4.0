From: amir73il@users.sourceforge.net
Subject: [PATCH RFC 04/30] ext4: snapshot hooks - block bitmap access
Date: Mon,  9 May 2011 19:41:22 +0300
Message-ID: <1304959308-11122-5-git-send-email-amir73il@users.sourceforge.net>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33538 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab1EIQmu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 12:42:50 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so4026020wya.19
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2011 09:42:49 -0700 (PDT)
In-Reply-To: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
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
 3 files changed, 17 insertions(+), 10 deletions(-)

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
index 75662f7..707b810 100644
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
index 42961bf..e8bfd8d 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2747,7 +2747,8 @@ ext4_mb_mark_diskspace_used(struct ext4_allocation_context *ac,
 	if (!bitmap_bh)
 		goto out_err;
 
-	err = ext4_journal_get_write_access(handle, bitmap_bh);
+	err = ext4_handle_get_bitmap_access(handle, sb, ac->ac_b_ex.fe_group,
+			bitmap_bh);
 	if (err)
 		goto out_err;
 
@@ -4543,7 +4544,7 @@ do_more:
 	}
 
 	BUFFER_TRACE(bitmap_bh, "getting write access");
-	err = ext4_journal_get_write_access(handle, bitmap_bh);
+	err = ext4_handle_get_bitmap_access(handle, sb, block_group, bitmap_bh);
 	if (err)
 		goto error_return;
 
@@ -4692,7 +4693,7 @@ void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 	}
 
 	BUFFER_TRACE(bitmap_bh, "getting write access");
-	err = ext4_journal_get_write_access(handle, bitmap_bh);
+	err = ext4_handle_get_bitmap_access(handle, sb, block_group, bitmap_bh);
 	if (err)
 		goto error_return;
 
-- 
1.7.0.4

