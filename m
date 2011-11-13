From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 1/2] jbd: allocate transacion from special cache
Date: Sun, 13 Nov 2011 19:29:31 +0800
Message-ID: <1321183772-6181-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36043 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab1KMNwZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Nov 2011 08:52:25 -0500
Received: by iage36 with SMTP id e36so6145576iag.19
        for <linux-ext4@vger.kernel.org>; Sun, 13 Nov 2011 05:52:25 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

transaction_t is 100 bytes under 32-bit systems. Transactions
allocated from general cache comsume 128 bytes. This patch
lets jbd allocates transacion from special cache.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/jbd/checkpoint.c  |    2 +-
 fs/jbd/journal.c     |    3 +++
 fs/jbd/transaction.c |   31 +++++++++++++++++++++++++++++--
 include/linux/jbd.h  |    5 +++++
 4 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
index f94fc48..4d98046 100644
--- a/fs/jbd/checkpoint.c
+++ b/fs/jbd/checkpoint.c
@@ -764,5 +764,5 @@ void __journal_drop_transaction(journal_t *journal, transaction_t *transaction)
 
 	trace_jbd_drop_transaction(journal, transaction);
 	jbd_debug(1, "Dropping transaction %d, all done\n", transaction->t_tid);
-	kfree(transaction);
+	journal_free_transaction(transaction);
 }
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 9fe061f..45ca982 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -2004,6 +2004,8 @@ static int __init journal_init_caches(void)
 		ret = journal_init_journal_head_cache();
 	if (ret == 0)
 		ret = journal_init_handle_cache();
+	if (ret == 0)
+		ret = journal_init_transaction_cache();
 	return ret;
 }
 
@@ -2012,6 +2014,7 @@ static void journal_destroy_caches(void)
 	journal_destroy_revoke_caches();
 	journal_destroy_journal_head_cache();
 	journal_destroy_handle_cache();
+	journal_destroy_transaction_cache();
 }
 
 static int __init journal_init(void)
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index 7e59c6e..20d76f1 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -30,6 +30,32 @@
 
 static void __journal_temp_unlink_buffer(struct journal_head *jh);
 
+static struct kmem_cache *transaction_cache;
+int __init journal_init_transaction_cache(void)
+{
+	J_ASSERT(!transaction_cache);
+	transaction_cache = KMEM_CACHE(transaction_s,
+				       SLAB_HWCACHE_ALIGN|SLAB_TEMPORARY);
+	if (transaction_cache)
+		return 0;
+	return -ENOMEM;
+}
+
+void __init journal_destroy_transaction_cache(void)
+{
+	if (transaction_cache) {
+		kmem_cache_destroy(transaction_cache);
+		transaction_cache = NULL;
+	}
+}
+
+void journal_free_transaction(transaction_t *transaction)
+{
+	if (unlikely(ZERO_OR_NULL_PTR(transaction)))
+		return;
+	kmem_cache_free(transaction_cache, transaction);
+}
+
 /*
  * get_transaction: obtain a new transaction_t object.
  *
@@ -100,11 +126,12 @@ static int start_this_handle(journal_t *journal, handle_t *handle)
 
 alloc_transaction:
 	if (!journal->j_running_transaction) {
-		new_transaction = kzalloc(sizeof(*new_transaction), GFP_NOFS);
+		new_transaction = kmem_cache_alloc(transaction_cache, GFP_NOFS);
 		if (!new_transaction) {
 			congestion_wait(BLK_RW_ASYNC, HZ/50);
 			goto alloc_transaction;
 		}
+		memset(new_transaction, 0, sizeof(*new_transaction));
 	}
 
 	jbd_debug(3, "New handle %p going live.\n", handle);
@@ -233,7 +260,7 @@ repeat_locked:
 	lock_map_acquire(&handle->h_lockdep_map);
 out:
 	if (unlikely(new_transaction))		/* It's usually NULL */
-		kfree(new_transaction);
+		journal_free_transaction(new_transaction);
 	return ret;
 }
 
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index c7acdde..0f9f0b6 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -807,6 +807,11 @@ journal_write_metadata_buffer(transaction_t	  *transaction,
 /* Transaction locking */
 extern void		__wait_on_journal (journal_t *);
 
+/* Transaction cache support */
+extern void journal_destroy_transaction_cache(void);
+extern int  journal_init_transaction_cache(void);
+extern void journal_free_transaction(transaction_t *);
+
 /*
  * Journal locking.
  *
-- 
1.7.5.1

