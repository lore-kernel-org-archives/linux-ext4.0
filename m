From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] ext4: remove ext4_handle_release_buffer()
Date: Tue, 30 Oct 2012 12:05:10 -0500
Message-ID: <509008C6.3070700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759908Ab2J3RFN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Oct 2012 13:05:13 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9UH5C1Y026873
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 30 Oct 2012 13:05:12 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id q9UH5API014179
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 30 Oct 2012 13:05:11 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_handle_release_buffer() was intended to remove journal
write access from a buffer, but it doesn't actually do anything
at all other than add a BUFFER_TRACE point, but it's not reliably
used for that either.  Remove all the associated dead code.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

If this flies, I can do the same for ext3.

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index 56d258c..7177f9b 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -254,13 +254,6 @@ static inline void ext4_handle_sync(handle_t *handle)
 		handle->h_sync = 1;
 }
 
-static inline void ext4_handle_release_buffer(handle_t *handle,
-						struct buffer_head *bh)
-{
-	if (ext4_handle_valid(handle))
-		jbd2_journal_release_buffer(handle, bh);
-}
-
 static inline int ext4_handle_is_aborted(handle_t *handle)
 {
 	if (ext4_handle_valid(handle))
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 47bf06a..d99387b 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -783,7 +783,7 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 
 	err = ext4_journal_get_write_access(handle, gdb_bh);
 	if (unlikely(err))
-		goto exit_sbh;
+		goto exit_dind;
 
 	err = ext4_journal_get_write_access(handle, dind);
 	if (unlikely(err))
@@ -792,7 +792,7 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 	/* ext4_reserve_inode_write() gets a reference on the iloc */
 	err = ext4_reserve_inode_write(handle, inode, &iloc);
 	if (unlikely(err))
-		goto exit_dindj;
+		goto exit_dind;
 
 	n_group_desc = ext4_kvmalloc((gdb_num + 1) *
 				     sizeof(struct buffer_head *),
@@ -846,12 +846,7 @@ static int add_new_gdb(handle_t *handle, struct inode *inode,
 
 exit_inode:
 	ext4_kvfree(n_group_desc);
-	/* ext4_handle_release_buffer(handle, iloc.bh); */
 	brelse(iloc.bh);
-exit_dindj:
-	/* ext4_handle_release_buffer(handle, dind); */
-exit_sbh:
-	/* ext4_handle_release_buffer(handle, EXT4_SB(sb)->s_sbh); */
 exit_dind:
 	brelse(dind);
 exit_bh:
@@ -969,14 +964,8 @@ static int reserve_backup_gdb(handle_t *handle, struct inode *inode,
 	}
 
 	for (i = 0; i < reserved_gdb; i++) {
-		if ((err = ext4_journal_get_write_access(handle, primary[i]))) {
-			/*
-			int j;
-			for (j = 0; j < i; j++)
-				ext4_handle_release_buffer(handle, primary[j]);
-			 */
+		if ((err = ext4_journal_get_write_access(handle, primary[i])))
 			goto exit_bh;
-		}
 	}
 
 	if ((err = ext4_reserve_inode_write(handle, inode, &iloc)))
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 2cdb98d..b1adda1 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -794,7 +794,6 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			int offset = (char *)s->here - bs->bh->b_data;
 
 			unlock_buffer(bs->bh);
-			ext4_handle_release_buffer(handle, bs->bh);
 			if (ce) {
 				mb_cache_entry_release(ce);
 				ce = NULL;
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 484b8d1..dbf41f9 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -60,7 +60,6 @@ EXPORT_SYMBOL(jbd2_journal_get_create_access);
 EXPORT_SYMBOL(jbd2_journal_get_undo_access);
 EXPORT_SYMBOL(jbd2_journal_set_triggers);
 EXPORT_SYMBOL(jbd2_journal_dirty_metadata);
-EXPORT_SYMBOL(jbd2_journal_release_buffer);
 EXPORT_SYMBOL(jbd2_journal_forget);
 #if 0
 EXPORT_SYMBOL(journal_sync_buffer);
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index a74ba46..deffd94 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1207,17 +1207,6 @@ out:
 	return ret;
 }
 
-/*
- * jbd2_journal_release_buffer: undo a get_write_access without any buffer
- * updates, if the update decided in the end that it didn't need access.
- *
- */
-void
-jbd2_journal_release_buffer(handle_t *handle, struct buffer_head *bh)
-{
-	BUFFER_TRACE(bh, "entry");
-}
