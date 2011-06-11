From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PATCH] jbd: Make jbd transactions come from its own cache.
Date: Sat, 11 Jun 2011 02:36:01 -0700
Message-ID: <1307784961-1485-1-git-send-email-mkatiyar@gmail.com>
Cc: Manish Katiyar <mkatiyar@gmail.com>
To: akpm@linux-foundation.org, jack@suse.cz, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35933 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab1FKJgK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 11 Jun 2011 05:36:10 -0400
Received: by pwi15 with SMTP id 15so1543467pwi.19
        for <linux-ext4@vger.kernel.org>; Sat, 11 Jun 2011 02:36:09 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Allocate a slab cache for jbd transaction allocations. It may help to test
various memory failure scenarios.

Signed-off-by: Manish Katiyar <mkatiyar@gmail.com>
---
 fs/jbd/checkpoint.c  |    2 +-
 fs/jbd/journal.c     |   25 +++++++++++++++++++++++++
 fs/jbd/transaction.c |    6 ++----
 include/linux/jbd.h  |   16 ++++++++++++++++
 4 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
index e4b87bc..94c428c 100644
--- a/fs/jbd/checkpoint.c
+++ b/fs/jbd/checkpoint.c
@@ -753,5 +753,5 @@ void __journal_drop_transaction(journal_t *journal, transaction_t *transaction)
 	J_ASSERT(journal->j_running_transaction != transaction);
 
 	jbd_debug(1, "Dropping transaction %d, all done\n", transaction->t_tid);
-	kfree(transaction);
+	jbd_free_transaction(transaction);
 }
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index e2d4285..9e0ddb8 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -82,6 +82,7 @@ EXPORT_SYMBOL(journal_blocks_per_page);
 EXPORT_SYMBOL(journal_invalidatepage);
 EXPORT_SYMBOL(journal_try_to_free_buffers);
 EXPORT_SYMBOL(journal_force_commit);
+EXPORT_SYMBOL(jbd_transaction_cache);
 
 static int journal_convert_superblock_v1(journal_t *, journal_superblock_t *);
 static void __journal_abort_soft (journal_t *journal, int errno);
@@ -1752,6 +1753,27 @@ static void journal_destroy_journal_head_cache(void)
 	}
 }
 
+struct kmem_cache *jbd_transaction_cache;
+
+static int journal_init_transaction_cache(void)
+{
+	J_ASSERT(jbd_transaction_cache == NULL);
+	jbd_transaction_cache = kmem_cache_create("jbd_transaction",
+			sizeof(transaction_t),
+			0, 0, NULL);
+	if (jbd_transaction_cache == NULL) {
+		printk(KERN_EMERG "JBD: failed to create transaction cache\n");
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static void journal_destroy_transaction_cache(void)
+{
+	if (jbd_transaction_cache)
+		kmem_cache_destroy(jbd_transaction_cache);
+}
+
 /*
  * journal_head splicing and dicing
  */
@@ -2033,6 +2055,8 @@ static int __init journal_init_caches(void)
 		ret = journal_init_journal_head_cache();
 	if (ret == 0)
 		ret = journal_init_handle_cache();
+	if (ret == 0)
+		ret = journal_init_transaction_cache();
 	return ret;
 }
 
@@ -2041,6 +2065,7 @@ static void journal_destroy_caches(void)
 	journal_destroy_revoke_caches();
 	journal_destroy_journal_head_cache();
 	journal_destroy_handle_cache();
+	journal_destroy_transaction_cache();
 }
 
 static int __init journal_init(void)
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index f7ee81a..64069dd 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -99,8 +99,7 @@ static int start_this_handle(journal_t *journal, handle_t *handle)
 
 alloc_transaction:
 	if (!journal->j_running_transaction) {
-		new_transaction = kzalloc(sizeof(*new_transaction),
-						GFP_NOFS|__GFP_NOFAIL);
+		new_transaction = jbd_alloc_transaction(GFP_NOFS|__GFP_NOFAIL);
 		if (!new_transaction) {
 			ret = -ENOMEM;
 			goto out;
@@ -232,8 +231,7 @@ repeat_locked:
 
 	lock_map_acquire(&handle->h_lockdep_map);
 out:
-	if (unlikely(new_transaction))		/* It's usually NULL */
-		kfree(new_transaction);
+	jbd_free_transaction(new_transaction);
 	return ret;
 }
 
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index e069650..9d7c35e 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -958,6 +958,22 @@ static inline void jbd_free_handle(handle_t *handle)
 	kmem_cache_free(jbd_handle_cache, handle);
 }
 
+/*
+ * transaction management
+ */
+extern struct kmem_cache *jbd_transaction_cache;
+
+static inline transaction_t *jbd_alloc_transaction(gfp_t gfp_flags)
+{
+	return kmem_cache_zalloc(jbd_transaction_cache, gfp_flags);
+}
+
+static inline void jbd_free_transaction(transaction_t *transaction)
+{
+	if (transaction)
+		kmem_cache_free(jbd_transaction_cache, transaction);
+}
+
 /* Primary revoke support */
 #define JOURNAL_REVOKE_DEFAULT_HASH 256
 extern int	   journal_init_revoke(journal_t *, int);
-- 
1.7.4.1

