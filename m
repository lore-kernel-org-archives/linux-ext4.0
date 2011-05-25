From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH 2/3] jbd2 : Fix journal start by passing a parameter to specify
 if the caller can deal with ENOMEM
Date: Wed, 25 May 2011 00:26:16 -0700
Message-ID: <4DDCAF18.8030809@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51600 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab1EYH0T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 May 2011 03:26:19 -0400
Received: by pwi15 with SMTP id 15so3331717pwi.19
        for <linux-ext4@vger.kernel.org>; Wed, 25 May 2011 00:26:18 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Pass extra bool parameter in journal routines to specify if its ok to
fail in the journal start. Passing true means caller is
ok with journal start failures and can handle ENOMEM. Update ocfs2 and ext4
routines to pass false for the updated journal interface by default to
retain the existing behavior.

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
Acked-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4_jbd2.h   |    2 +-
 fs/ext4/super.c       |    2 +-
 fs/jbd2/transaction.c |   26 +++++++-------------------
 fs/ocfs2/journal.c    |    6 +++---
 include/linux/jbd2.h  |    6 ++----
 5 files changed, 14 insertions(+), 28 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.h b/fs/ext4/ext4_jbd2.h
index d0f5353..0abee1b 100644
--- a/fs/ext4/ext4_jbd2.h
+++ b/fs/ext4/ext4_jbd2.h
@@ -225,7 +225,7 @@ static inline int ext4_journal_extend(handle_t *handle, int nblocks)
 static inline int ext4_journal_restart(handle_t *handle, int nblocks)
 {
 	if (ext4_handle_valid(handle))
-		return jbd2_journal_restart(handle, nblocks);
+		return jbd2_journal_restart(handle, nblocks, false);
 	return 0;
 }

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8553dfb..4e4c17f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -279,7 +279,7 @@ handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
 		ext4_abort(sb, "Detected aborted journal");
 		return ERR_PTR(-EROFS);
 	}
-	return jbd2_journal_start(journal, nblocks);
+	return jbd2_journal_start(journal, nblocks, false);
 }

 /*
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 05fa77a..248a7b6 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -308,6 +308,8 @@ static handle_t *new_handle(int nblocks)
  * handle_t *jbd2_journal_start() - Obtain a new handle.
  * @journal: Journal to start transaction on.
  * @nblocks: number of block buffer we might modify
+ * @errok:  True if the callers can handle ENOMEM failures from
+ *	    this routine, false otherwise
  *
  * We make sure that the transaction can guarantee at least nblocks of
  * modified buffers in the log.  We block until the log can guarantee
@@ -318,7 +320,7 @@ static handle_t *new_handle(int nblocks)
  *
  * Return a pointer to a newly allocated handle, or NULL on failure
  */
-handle_t *jbd2__journal_start(journal_t *journal, int nblocks, int gfp_mask)
+handle_t *jbd2_journal_start(journal_t *journal, int nblocks, bool errok)
 {
 	handle_t *handle = journal_current_handle();
 	int err;
@@ -338,7 +340,7 @@ handle_t *jbd2__journal_start(journal_t *journal, int nblocks, int gfp_mask)

 	current->journal_info = handle;

-	err = start_this_handle(journal, handle, gfp_mask);
+	err = start_this_handle(journal, handle, GFP_NOFS);
 	if (err < 0) {
 		jbd2_free_handle(handle);
 		current->journal_info = NULL;
@@ -346,13 +348,6 @@ handle_t *jbd2__journal_start(journal_t *journal, int nblocks, int gfp_mask)
 	}
 	return handle;
 }
-EXPORT_SYMBOL(jbd2__journal_start);
-
-
-handle_t *jbd2_journal_start(journal_t *journal, int nblocks)
-{
-	return jbd2__journal_start(journal, nblocks, GFP_NOFS);
-}
 EXPORT_SYMBOL(jbd2_journal_start);


@@ -441,7 +436,7 @@ out:
  * transaction capabable of guaranteeing the requested number of
  * credits.
  */
-int jbd2__journal_restart(handle_t *handle, int nblocks, int gfp_mask)
+int jbd2_journal_restart(handle_t *handle, int nblocks, bool errok)
 {
 	transaction_t *transaction = handle->h_transaction;
 	journal_t *journal = transaction->t_journal;
@@ -477,16 +472,9 @@ int jbd2__journal_restart(handle_t *handle, int nblocks, int gfp_mask)

 	lock_map_release(&handle->h_lockdep_map);
 	handle->h_buffer_credits = nblocks;
-	ret = start_this_handle(journal, handle, gfp_mask);
+	ret = start_this_handle(journal, handle, GFP_NOFS);
 	return ret;
 }
-EXPORT_SYMBOL(jbd2__journal_restart);
-
-
-int jbd2_journal_restart(handle_t *handle, int nblocks)
-{
-	return jbd2__journal_restart(handle, nblocks, GFP_NOFS);
-}
 EXPORT_SYMBOL(jbd2_journal_restart);

 /**
@@ -1436,7 +1424,7 @@ int jbd2_journal_force_commit(journal_t *journal)
 	handle_t *handle;
 	int ret;

-	handle = jbd2_journal_start(journal, 1);
+	handle = jbd2_journal_start(journal, 1, false);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 	} else {
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index 295d564..bff51c0 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -353,11 +353,11 @@ handle_t *ocfs2_start_trans(struct ocfs2_super *osb, int max_buffs)

 	/* Nested transaction? Just return the handle... */
 	if (journal_current_handle())
-		return jbd2_journal_start(journal, max_buffs);
+		return jbd2_journal_start(journal, max_buffs, false);

 	down_read(&osb->journal->j_trans_barrier);

-	handle = jbd2_journal_start(journal, max_buffs);
+	handle = jbd2_journal_start(journal, max_buffs, false);
 	if (IS_ERR(handle)) {
 		up_read(&osb->journal->j_trans_barrier);

@@ -438,7 +438,7 @@ int ocfs2_extend_trans(handle_t *handle, int nblocks)
 	if (status > 0) {
 		trace_ocfs2_extend_trans_restart(old_nblocks + nblocks);
 		status = jbd2_journal_restart(handle,
-					      old_nblocks + nblocks);
+					      old_nblocks + nblocks, false);
 		if (status < 0) {
 			mlog_errno(status);
 			goto bail;
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index a32dcae..67f0f4f 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1103,10 +1103,8 @@ static inline handle_t *journal_current_handle(void)
  * Register buffer modifications against the current transaction.
  */

-extern handle_t *jbd2_journal_start(journal_t *, int nblocks);
-extern handle_t *jbd2__journal_start(journal_t *, int nblocks, int gfp_mask);
-extern int	 jbd2_journal_restart(handle_t *, int nblocks);
-extern int	 jbd2__journal_restart(handle_t *, int nblocks, int gfp_mask);
+extern handle_t *jbd2_journal_start(journal_t *, int nblocks, bool errok);
+extern int	 jbd2_journal_restart(handle_t *, int nblocks, bool errok);
 extern int	 jbd2_journal_extend (handle_t *, int nblocks);
 extern int	 jbd2_journal_get_write_access(handle_t *, struct buffer_head *);
 extern int	 jbd2_journal_get_create_access (handle_t *, struct buffer_head *);
-- 
1.7.4.1

-- 
Thanks -
Manish
