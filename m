From: Curt Wohlgemuth <curtw@google.com>
Subject: [PATCH 2/2] ext4: Handle nested ext4_journal_start/stop calls without
	a journal
Date: Thu, 17 Sep 2009 14:55:43 -0700
Message-ID: <6601abe90909171455g597fe672g1ca6d426e609f937@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:57666 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbZIQVzm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 17 Sep 2009 17:55:42 -0400
Received: from zps35.corp.google.com (zps35.corp.google.com [172.25.146.35])
	by smtp-out.google.com with ESMTP id n8HLtjmW019033
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2009 14:55:45 -0700
Received: from pzk28 (pzk28.prod.google.com [10.243.19.156])
	by zps35.corp.google.com with ESMTP id n8HLthJG032315
	for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2009 14:55:43 -0700
Received: by pzk28 with SMTP id 28so349539pzk.5
        for <linux-ext4@vger.kernel.org>; Thu, 17 Sep 2009 14:55:43 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch fixes a problem with handling nested calls to
ext4_journal_start/ext4_journal_stop, when there is no journal present.

	Signed-off-by: Curt Wohlgemuth <curtw@google.com>
---

Instead of using the special value of

        (handle_t *)0x1

to represent a handle when there is no journal present, we now use a real
handle_t, so we can use its ref counting.  The h_transaction field now
determines if there is a journal present or not.

Note that ext4_handle_valid() previously returned 1 if a NULL handle was
sent in -- which is a bad use of this routine.  Instead now, we'll get a
NULL pointer dereference...


diff -uprN orig/fs/ext4/ext4_jbd2.h new/fs/ext4/ext4_jbd2.h
--- orig/fs/ext4/ext4_jbd2.h	2009-09-17 14:32:13.000000000 -0700
+++ new/fs/ext4/ext4_jbd2.h	2009-09-17 14:31:01.000000000 -0700
@@ -161,11 +161,11 @@ int __ext4_handle_dirty_metadata(const c
 handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks);
 int __ext4_journal_stop(const char *where, handle_t *handle);

-#define EXT4_NOJOURNAL_HANDLE	((handle_t *) 0x1)
+#define EXT4_NOJOURNAL_TRANSACTION ((transaction_t *) 0x1)

 static inline int ext4_handle_valid(handle_t *handle)
 {
--	if (handle == EXT4_NOJOURNAL_HANDLE)
+	if (handle->h_transaction == EXT4_NOJOURNAL_TRANSACTION)
 		return 0;
 	return 1;
 }
diff -uprN orig/fs/ext4/inode.c new/fs/ext4/inode.c
--- orig/fs/ext4/inode.c	2009-09-17 14:14:43.000000000 -0700
+++ new/fs/ext4/inode.c	2009-09-17 14:32:58.000000000 -0700
@@ -4931,12 +4931,14 @@ int ext4_write_inode(struct inode *inode
 		err = ext4_force_commit(inode->i_sb);
 	} else {
 		struct ext4_iloc iloc;
+		handle_t *handle = ext4_journal_start(inode, 1);

 		err = ext4_get_inode_loc(inode, &iloc);
 		if (err)
 			return err;
-		err = ext4_do_update_inode(EXT4_NOJOURNAL_HANDLE,
-					   inode, &iloc, wait);
+		err = ext4_do_update_inode(handle, inode, &iloc, wait);
+
+		ext4_journal_stop(handle);
 	}
 	return err;
 }
diff -uprN orig/fs/ext4/namei.c new/fs/ext4/namei.c
--- orig/fs/ext4/namei.c	2009-09-17 14:29:57.000000000 -0700
+++ new/fs/ext4/namei.c	2009-09-17 14:33:06.000000000 -0700
@@ -2076,7 +2076,8 @@ int ext4_orphan_del(handle_t *handle, st
 	struct ext4_iloc iloc;
 	int err = 0;

-	if (!ext4_handle_valid(handle))
+	/* ext4_handle_valid() assumes a valid handle_t pointer */
+	if (handle && !ext4_handle_valid(handle))
 		return 0;

 	mutex_lock(&EXT4_SB(inode->i_sb)->s_orphan_lock);
diff -uprN orig/fs/ext4/super.c new/fs/ext4/super.c
--- orig/fs/ext4/super.c	2009-09-17 14:30:02.000000000 -0700
+++ new/fs/ext4/super.c	2009-09-17 14:33:06.000000000 -0700
@@ -198,6 +198,43 @@ void ext4_itable_unused_set(struct super
 		bg->bg_itable_unused_hi = cpu_to_le16(count >> 16);
 }

+
+/* If the current tasks journal_info is NULL, create a new one, else
+ * bump its ref count */
+static handle_t *ext4_get_nojournal(void)
+{
+	handle_t *handle = current->journal_info;
+
+	if (handle) {
+		BUG_ON(handle->h_transaction != EXT4_NOJOURNAL_TRANSACTION);
+		handle->h_ref++;
+		return handle;
+	}
+
+	handle = jbd2_alloc_handle(GFP_NOFS);
+	if (!handle)
+		return NULL;
+
+	memset(handle, 0, sizeof(*handle));
+	handle->h_ref = 1;
+	handle->h_transaction = EXT4_NOJOURNAL_TRANSACTION;
+
+	current->journal_info = handle;
+	return handle;
+}
+
+
+/* Decrement the ref count, delete if now 0. */
+static void ext4_put_nojournal(handle_t *handle)
+{
+	BUG_ON(handle->h_transaction != EXT4_NOJOURNAL_TRANSACTION);
+	if (--handle->h_ref > 0)
+		return;
+
+	jbd2_free_handle(handle);
+	current->journal_info = NULL;
+}
+
 /*
  * Wrappers for jbd2_journal_start/end.
  *
@@ -224,11 +261,7 @@ handle_t *ext4_journal_start_sb(struct s
 		}
 		return jbd2_journal_start(journal, nblocks);
 	}
-	/*
-	 * We're not journaling, return the appropriate indication.
-	 */
-	current->journal_info = EXT4_NOJOURNAL_HANDLE;
-	return current->journal_info;
+	return ext4_get_nojournal();
 }

 /*
@@ -244,11 +277,7 @@ int __ext4_journal_stop(const char *wher
 	int rc;

 	if (!ext4_handle_valid(handle)) {
-		/*
-		 * Do this here since we don't call jbd2_journal_stop() in
-		 * no-journal mode.
-		 */
-		current->journal_info = NULL;
+		ext4_put_nojournal(handle);
 		return 0;
 	}
 	sb = handle->h_transaction->t_journal->j_private;
