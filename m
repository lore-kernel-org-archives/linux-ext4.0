From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 1/3] jbd2: allocate transaction from special cache
Date: Sun, 13 Nov 2011 19:21:29 +0800
Message-ID: <1321183291-4589-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37654 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab1KMNoX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Nov 2011 08:44:23 -0500
Received: by iage36 with SMTP id e36so6140161iag.19
        for <linux-ext4@vger.kernel.org>; Sun, 13 Nov 2011 05:44:23 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

transaction_t is 136 byes under 32-bit systems. If we allocate
it from general cache, it comsumes 256 bytes.  So let jbd2 allocate
it from special cache to reduce memory consumption.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/jbd2/checkpoint.c  |    2 +-
 fs/jbd2/commit.c      |    2 +-
 fs/jbd2/journal.c     |    3 +++
 fs/jbd2/transaction.c |   36 +++++++++++++++++++++++++++++++++---
 include/linux/jbd2.h  |    5 +++++
 5 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 16a698b..7fcffbb 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -722,7 +722,7 @@ int __jbd2_journal_remove_checkpoint(struct journal_head *jh)
 				    transaction->t_tid, stats);
 
 	__jbd2_journal_drop_transaction(journal, transaction);
-	kfree(transaction);
+	jbd2_journal_free_transaction(transaction);
 
 	/* Just in case anybody was waiting for more transactions to be
            checkpointed... */
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index eef6979..264f0bb 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -1042,7 +1042,7 @@ restart_loop:
 	jbd_debug(1, "JBD: commit %d complete, head %d\n",
 		  journal->j_commit_sequence, journal->j_tail_sequence);
 	if (to_free)
-		kfree(commit_transaction);
+		jbd2_journal_free_transaction(commit_transaction);
 
 	wake_up(&journal->j_wait_done_commit);
 }
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index f24df13..56b8a1a 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2351,6 +2351,8 @@ static int __init journal_init_caches(void)
 		ret = journal_init_jbd2_journal_head_cache();
 	if (ret == 0)
 		ret = journal_init_handle_cache();
+	if (ret == 0)
+		ret = jbd2_journal_init_transaction_cache();
 	return ret;
 }
 
@@ -2359,6 +2361,7 @@ static void jbd2_journal_destroy_caches(void)
 	jbd2_journal_destroy_revoke_caches();
 	jbd2_journal_destroy_jbd2_journal_head_cache();
 	jbd2_journal_destroy_handle_cache();
+	jbd2_journal_destroy_transaction_cache();
 	jbd2_journal_destroy_slabs();
 }
 
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 1e5c5ea..f394a13 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -33,6 +33,35 @@
 static void __jbd2_journal_temp_unlink_buffer(struct journal_head *jh);
 static void __jbd2_journal_unfile_buffer(struct journal_head *jh);
 
+static struct kmem_cache *transaction_cache;
+int __init jbd2_journal_init_transaction_cache(void)
+{
+	J_ASSERT(!transaction_cache);
+	transaction_cache = kmem_cache_create("jbd2_transaction_s",
+					sizeof(transaction_t),
+					0,
+					SLAB_HWCACHE_ALIGN|SLAB_TEMPORARY,
+					NULL);
+	if (transaction_cache)
+		return 0;
+	return -ENOMEM;
+}
+
+void jbd2_journal_destroy_transaction_cache(void)
+{
+	if (transaction_cache) {
+		kmem_cache_destroy(transaction_cache);
+		transaction_cache = NULL;
+	}
+}
+
+void jbd2_journal_free_transaction(transaction_t *transaction)
+{
+	if (unlikely(ZERO_OR_NULL_PTR(transaction)))
+		return;
+	kmem_cache_free(transaction_cache, transaction);
+}
+
 /*
  * jbd2_get_transaction: obtain a new transaction_t object.
  *
@@ -133,7 +162,7 @@ static int start_this_handle(journal_t *journal, handle_t *handle,
 
 alloc_transaction:
 	if (!journal->j_running_transaction) {
-		new_transaction = kzalloc(sizeof(*new_transaction), gfp_mask);
+		new_transaction = kmem_cache_alloc(transaction_cache, gfp_mask);
 		if (!new_transaction) {
 			/*
 			 * If __GFP_FS is not present, then we may be
@@ -148,6 +177,7 @@ alloc_transaction:
 			}
 			return -ENOMEM;
 		}
+		memset(new_transaction, 0, sizeof(*new_transaction));
 	}
 
 	jbd_debug(3, "New handle %p going live.\n", handle);
@@ -162,7 +192,7 @@ repeat:
 	if (is_journal_aborted(journal) ||
 	    (journal->j_errno != 0 && !(journal->j_flags & JBD2_ACK_ERR))) {
 		read_unlock(&journal->j_state_lock);
-		kfree(new_transaction);
+		jbd2_journal_free_transaction(new_transaction);
 		return -EROFS;
 	}
 
@@ -284,7 +314,7 @@ repeat:
 	read_unlock(&journal->j_state_lock);
 
 	lock_map_acquire(&handle->h_lockdep_map);
-	kfree(new_transaction);
+	jbd2_journal_free_transaction(new_transaction);
 	return 0;
 }
 
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 2092ea2..e44d114 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1020,6 +1020,11 @@ jbd2_journal_write_metadata_buffer(transaction_t	  *transaction,
 /* Transaction locking */
 extern void		__wait_on_journal (journal_t *);
 
+/* Transaction cache support */
+extern void jbd2_journal_destroy_transaction_cache(void);
+extern int  jbd2_journal_init_transaction_cache(void);
+extern void jbd2_journal_free_transaction(transaction_t *);
+
 /*
  * Journal locking.
  *
-- 
1.7.5.1

