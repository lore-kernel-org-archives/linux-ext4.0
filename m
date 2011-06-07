From: amir73il@users.sourceforge.net
Subject: [PATCH v1 23/36] ext4: snapshot journaled - implement journal_release_buffer()
Date: Tue,  7 Jun 2011 18:07:50 +0300
Message-ID: <1307459283-22130-24-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41767 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab1FGPKA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:10:00 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so5035787wwa.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:10:00 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

The API journal_release_buffer() is called to cancel a previous call
to journal_get_write_access() and to recall the used buffer credit.
Current implementation of journal_release_buffer() in JBD is empty,
since no buffer credits are used until the buffer is marked dirty.
However, since the resulting snapshot COW operation cannot be undone,
we try to extend the current transaction to compensate for the used
credits of the extra COW operation, so we don't run out of buffer
credits too soon.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/ext4_jbd2.c |   39 +++++++++++++++++++++++++++++++++++++++
 fs/ext4/ext4_jbd2.h |   11 +++++------
 fs/ext4/ialloc.c    |   10 ++++++++--
 fs/ext4/xattr.c     |    4 +++-
 4 files changed, 55 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 015f727..e8287f4 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -127,6 +127,45 @@ int __ext4_journal_get_create_access(const char *where, unsigned int line,
 	return err;
 }
 
+int __ext4_handle_release_buffer(const char *where, handle_t *handle,
+				struct buffer_head *bh)
+{
+	struct super_block *sb;
+	int err = 0;
+
+	if (!ext4_handle_valid(handle))
+		return 0;
+
+	sb = handle->h_transaction->t_journal->j_private;
+	if (!EXT4_SNAPSHOTS(sb) || IS_COWING(handle))
+		goto out;
+
+	/*
+	 * Trying to cancel a previous call to get_write_access(), which may
+	 * have resulted in a single COW operation.  We don't need to add
+	 * user credits, but if COW credits are too low we will try to
+	 * extend the transaction to compensate for the buffer credits used
+	 * by the extra COW operation.
+	 */
+	err = ext4_journal_extend(handle, 0);
+	if (err > 0) {
+		/* well, we can't say we didn't try - now lets hope
+		 * we have enough buffer credits to spare */
+		snapshot_debug(handle->h_buffer_credits < EXT4_MAX_TRANS_DATA
+				? 1 : 2,
+				"%s: warning: couldn't extend transaction "
+				"from %s (credits=%d/%d)\n", __func__,
+				where, handle->h_buffer_credits,
+				handle->h_user_credits);
+		err = 0;
+	}
+	ext4_journal_trace(SNAP_WARN, where, handle, -1);
+out:
+	if (!err)
+		jbd2_journal_release_buffer(handle, bh);
+	return err;
+}
+
 int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 				 handle_t *handle, struct inode *inode,
 				 struct buffer_head *bh)
diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 2b0e1bd..cee6f2a 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -264,12 +264,11 @@ static inline void ext4_handle_sync(handle_t *handle)
 		handle->h_sync = 1;
 }
 
-static inline void ext4_handle_release_buffer(handle_t *handle,
-						struct buffer_head *bh)
-{
-	if (ext4_handle_valid(handle))
-		jbd2_journal_release_buffer(handle, bh);
-}
+int __ext4_handle_release_buffer(const char *where, handle_t *handle,
+				struct buffer_head *bh);
+
+#define ext4_handle_release_buffer(handle, bh) \
+	__ext4_handle_release_buffer(__func__, (handle), (bh))
 
 static inline int ext4_handle_is_aborted(handle_t *handle)
 {
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index b0e5749..fdb6b12 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -917,8 +917,14 @@ repeat_in_this_group:
 				goto got;
 			}
 			/* we lost it */
-			ext4_handle_release_buffer(handle, inode_bitmap_bh);
-			ext4_handle_release_buffer(handle, group_desc_bh);
+			err = ext4_handle_release_buffer(handle,
+					inode_bitmap_bh);
+			if (err)
+				goto fail;
+			err = ext4_handle_release_buffer(handle,
+					group_desc_bh);
+			if (err)
+				goto fail;
 
 			if (++ino < EXT4_INODES_PER_GROUP(sb))
 				goto repeat_in_this_group;
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index b545ca1..83f5f9d 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -735,7 +735,9 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			int offset = (char *)s->here - bs->bh->b_data;
 
 			unlock_buffer(bs->bh);
-			ext4_handle_release_buffer(handle, bs->bh);
+			error = ext4_handle_release_buffer(handle, bs->bh);
+			if (error)
+				goto cleanup;
 			if (ce) {
 				mb_cache_entry_release(ce);
 				ce = NULL;
-- 
1.7.4.1

