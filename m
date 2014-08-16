From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 09/27] e2fsck: resync jbd2 revoke code from Linux 3.16
Date: Sat, 16 Aug 2014 16:46:48 -0700
Message-ID: <20140816234648.11171.8811.stgit@birch.djwong.org>
References: <20140816234550.11171.61585.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43444 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbaHPXqz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Aug 2014 19:46:55 -0400
In-Reply-To: <20140816234550.11171.61585.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Synchronize e2fsck's copy of revoke.c with the kernel's copy in
fs/jbd2.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/jfs_user.h       |    2 
 e2fsck/revoke.c         |  477 ++++++++++++++++++++++++++++++-----------------
 lib/ext2fs/jfs_compat.h |   15 +
 lib/ext2fs/kernel-jbd.h |    5 
 4 files changed, 320 insertions(+), 179 deletions(-)


diff --git a/e2fsck/jfs_user.h b/e2fsck/jfs_user.h
index 799c6da..9405e47 100644
--- a/e2fsck/jfs_user.h
+++ b/e2fsck/jfs_user.h
@@ -54,7 +54,7 @@ typedef struct {
 
 #define kmem_cache_alloc(cache,flags) malloc((cache)->object_length)
 #define kmem_cache_free(cache,obj) free(obj)
-#define kmem_cache_create(name,len,a,b,c,d) do_cache_create(len)
+#define kmem_cache_create(name,len,a,b,c) do_cache_create(len)
 #define kmem_cache_destroy(cache) do_cache_destroy(cache)
 #define kmalloc(len,flags) malloc(len)
 #define kfree(p) free(p)
diff --git a/e2fsck/revoke.c b/e2fsck/revoke.c
index 38c265e..383164e 100644
--- a/e2fsck/revoke.c
+++ b/e2fsck/revoke.c
@@ -1,5 +1,5 @@
 /*
- * linux/fs/revoke.c
+ * linux/fs/jbd2/revoke.c
  *
  * Written by Stephen C. Tweedie <sct@redhat.com>, 2000
  *
@@ -47,6 +47,10 @@
  *   overwriting the new data.  We don't even need to clear the revoke
  *   bit here.
  *
+ * We cache revoke status of a buffer in the current transaction in b_states
+ * bits.  As the name says, revokevalid flag indicates that the cached revoke
+ * status of a buffer is valid and we can rely on the cached status.
+ *
  * Revoke information on buffers is a tri-state value:
  *
  * RevokeValid clear:	no cached revoke status, need to look it up
@@ -55,40 +59,58 @@
  *			need do nothing.
  * RevokeValid set, Revoked set:
  *			buffer has been revoked.
+ *
+ * Locking rules:
+ * We keep two hash tables of revoke records. One hashtable belongs to the
+ * running transaction (is pointed to by journal->j_revoke), the other one
+ * belongs to the committing transaction. Accesses to the second hash table
+ * happen only from the kjournald and no other thread touches this table.  Also
+ * journal_switch_revoke_table() which switches which hashtable belongs to the
+ * running and which to the committing transaction is called only from
+ * kjournald. Therefore we need no locks when accessing the hashtable belonging
+ * to the committing transaction.
+ *
+ * All users operating on the hash table belonging to the running transaction
+ * have a handle to the transaction. Therefore they are safe from kjournald
+ * switching hash tables under them. For operations on the lists of entries in
+ * the hash table j_revoke_lock is used.
+ *
+ * Finally, also replay code uses the hash tables but at this moment no one else
+ * can touch them (filesystem isn't mounted yet) and hence no locking is
+ * needed.
  */
 
 #ifndef __KERNEL__
-#include "config.h"
 #include "jfs_user.h"
 #else
-#include <linux/sched.h>
+#include <linux/time.h>
 #include <linux/fs.h>
-#include <linux/jbd.h>
+#include <linux/jbd2.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
-#include <linux/locks.h>
 #include <linux/list.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
+#include <linux/bio.h>
+#include <linux/log2.h>
 #endif
 
-static lkmem_cache_t *revoke_record_cache;
-static lkmem_cache_t *revoke_table_cache;
+static lkmem_cache_t *jbd2_revoke_record_cache;
+static lkmem_cache_t *jbd2_revoke_table_cache;
 
 /* Each revoke record represents one single revoked block.  During
    journal replay, this involves recording the transaction ID of the
    last transaction to revoke this block. */
 
-struct jbd_revoke_record_s
+struct jbd2_revoke_record_s
 {
 	struct list_head  hash;
 	tid_t		  sequence;	/* Used for recovery only */
-	unsigned long	  blocknr;
+	unsigned long long	  blocknr;
 };
 
 
 /* The revoke table is just a simple hash table of revoke records. */
-struct jbd_revoke_table_s
+struct jbd2_revoke_table_s
 {
 	/* It is conceivable that we might want a larger hash table
 	 * for recovery.  Must be a power of two. */
@@ -100,159 +122,187 @@ struct jbd_revoke_table_s
 
 #ifdef __KERNEL__
 static void write_one_revoke_record(journal_t *, transaction_t *,
-				    struct journal_head **, int *,
-				    struct jbd_revoke_record_s *);
-static void flush_descriptor(journal_t *, struct journal_head *, int);
+				    struct list_head *,
+				    struct buffer_head **, int *,
+				    struct jbd2_revoke_record_s *, int);
+static void flush_descriptor(journal_t *, struct buffer_head *, int, int);
 #endif
 
 /* Utility functions to maintain the revoke table */
 
 /* Borrowed from buffer.c: this is a tried and tested block hash function */
-static inline int hash(journal_t *journal, unsigned long block)
+static inline int hash(journal_t *journal, unsigned long long block)
 {
-	struct jbd_revoke_table_s *table = journal->j_revoke;
+	struct jbd2_revoke_table_s *table = journal->j_revoke;
 	int hash_shift = table->hash_shift;
+	int hash = (int)block ^ (int)((block >> 31) >> 1);
 
-	return ((block << (hash_shift - 6)) ^
-		(block >> 13) ^
-		(block << (hash_shift - 12))) & (table->hash_size - 1);
+	return ((hash << (hash_shift - 6)) ^
+		(hash >> 13) ^
+		(hash << (hash_shift - 12))) & (table->hash_size - 1);
 }
 
-static int insert_revoke_hash(journal_t *journal, unsigned long blocknr,
+static int insert_revoke_hash(journal_t *journal, unsigned long long blocknr,
 			      tid_t seq)
 {
 	struct list_head *hash_list;
-	struct jbd_revoke_record_s *record;
+	struct jbd2_revoke_record_s *record;
 
-#ifdef __KERNEL__
 repeat:
-#endif
-	record = kmem_cache_alloc(revoke_record_cache, GFP_NOFS);
+	record = kmem_cache_alloc(jbd2_revoke_record_cache, GFP_NOFS);
 	if (!record)
 		goto oom;
 
 	record->sequence = seq;
 	record->blocknr = blocknr;
 	hash_list = &journal->j_revoke->hash_table[hash(journal, blocknr)];
+	spin_lock(&journal->j_revoke_lock);
 	list_add(&record->hash, hash_list);
+	spin_unlock(&journal->j_revoke_lock);
 	return 0;
 
 oom:
-#ifdef __KERNEL__
 	if (!journal_oom_retry)
 		return -ENOMEM;
-	jbd_debug(1, "ENOMEM in " __FUNCTION__ ", retrying.\n");
-	current->policy |= SCHED_YIELD;
-	schedule();
+	jbd_debug(1, "ENOMEM in %s, retrying\n", __func__);
+	yield();
 	goto repeat;
-#else
-	return -ENOMEM;
-#endif
 }
 
 /* Find a revoke record in the journal's hash table. */
 
-static struct jbd_revoke_record_s *find_revoke_record(journal_t *journal,
-						      unsigned long blocknr)
+static struct jbd2_revoke_record_s *find_revoke_record(journal_t *journal,
+						      unsigned long long blocknr)
 {
 	struct list_head *hash_list;
-	struct jbd_revoke_record_s *record;
+	struct jbd2_revoke_record_s *record;
 
 	hash_list = &journal->j_revoke->hash_table[hash(journal, blocknr)];
 
-	record = (struct jbd_revoke_record_s *) hash_list->next;
+	spin_lock(&journal->j_revoke_lock);
+	record = (struct jbd2_revoke_record_s *) hash_list->next;
 	while (&(record->hash) != hash_list) {
-		if (record->blocknr == blocknr)
+		if (record->blocknr == blocknr) {
+			spin_unlock(&journal->j_revoke_lock);
 			return record;
-		record = (struct jbd_revoke_record_s *) record->hash.next;
+		}
+		record = (struct jbd2_revoke_record_s *) record->hash.next;
 	}
+	spin_unlock(&journal->j_revoke_lock);
 	return NULL;
 }
 
-int __init journal_init_revoke_caches(void)
+void journal_destroy_revoke_caches(void)
 {
-	revoke_record_cache = kmem_cache_create("revoke_record",
-					   sizeof(struct jbd_revoke_record_s),
-					   0, SLAB_HWCACHE_ALIGN, NULL, NULL);
-	if (revoke_record_cache == 0)
-		return -ENOMEM;
-
-	revoke_table_cache = kmem_cache_create("revoke_table",
-					   sizeof(struct jbd_revoke_table_s),
-					   0, 0, NULL, NULL);
-	if (revoke_table_cache == 0) {
-		kmem_cache_destroy(revoke_record_cache);
-		revoke_record_cache = NULL;
-		return -ENOMEM;
+	if (jbd2_revoke_record_cache) {
+		kmem_cache_destroy(jbd2_revoke_record_cache);
+		jbd2_revoke_record_cache = NULL;
+	}
+	if (jbd2_revoke_table_cache) {
+		kmem_cache_destroy(jbd2_revoke_table_cache);
+		jbd2_revoke_table_cache = NULL;
 	}
-	return 0;
 }
 
-void journal_destroy_revoke_caches(void)
+int __init journal_init_revoke_caches(void)
 {
-	kmem_cache_destroy(revoke_record_cache);
-	revoke_record_cache = 0;
-	kmem_cache_destroy(revoke_table_cache);
-	revoke_table_cache = 0;
+	J_ASSERT(!jbd2_revoke_record_cache);
+	J_ASSERT(!jbd2_revoke_table_cache);
+
+	jbd2_revoke_record_cache = KMEM_CACHE(jbd2_revoke_record_s,
+					SLAB_HWCACHE_ALIGN|SLAB_TEMPORARY);
+	if (!jbd2_revoke_record_cache)
+		goto record_cache_failure;
+
+	jbd2_revoke_table_cache = KMEM_CACHE(jbd2_revoke_table_s,
+					     SLAB_TEMPORARY);
+	if (!jbd2_revoke_table_cache)
+		goto table_cache_failure;
+	return 0;
+table_cache_failure:
+	journal_destroy_revoke_caches();
+record_cache_failure:
+		return -ENOMEM;
 }
 
-/* Initialise the revoke table for a given journal to a given size. */
-
-int journal_init_revoke(journal_t *journal, int hash_size)
+static struct jbd2_revoke_table_s *journal_init_revoke_table(int hash_size)
 {
-	int shift, tmp;
+	int shift = 0;
+	int tmp = hash_size;
+	struct jbd2_revoke_table_s *table;
 
-	J_ASSERT (journal->j_revoke == NULL);
-
-	journal->j_revoke = kmem_cache_alloc(revoke_table_cache, GFP_KERNEL);
-	if (!journal->j_revoke)
-		return -ENOMEM;
-
-	/* Check that the hash_size is a power of two */
-	J_ASSERT ((hash_size & (hash_size-1)) == 0);
-
-	journal->j_revoke->hash_size = hash_size;
+	table = kmem_cache_alloc(jbd2_revoke_table_cache, GFP_KERNEL);
+	if (!table)
+		goto out;
 
-	shift = 0;
-	tmp = hash_size;
 	while((tmp >>= 1UL) != 0UL)
 		shift++;
-	journal->j_revoke->hash_shift = shift;
 
-	journal->j_revoke->hash_table =
+	table->hash_size = hash_size;
+	table->hash_shift = shift;
+	table->hash_table =
 		kmalloc(hash_size * sizeof(struct list_head), GFP_KERNEL);
-	if (!journal->j_revoke->hash_table) {
-		kmem_cache_free(revoke_table_cache, journal->j_revoke);
-		journal->j_revoke = NULL;
-		return -ENOMEM;
+	if (!table->hash_table) {
+		kmem_cache_free(jbd2_revoke_table_cache, table);
+		table = NULL;
+		goto out;
 	}
 
 	for (tmp = 0; tmp < hash_size; tmp++)
-		INIT_LIST_HEAD(&journal->j_revoke->hash_table[tmp]);
+		INIT_LIST_HEAD(&table->hash_table[tmp]);
 
-	return 0;
+out:
+	return table;
 }
 
-/* Destoy a journal's revoke table.  The table must already be empty! */
-
-void journal_destroy_revoke(journal_t *journal)
+static void journal_destroy_revoke_table(struct jbd2_revoke_table_s *table)
 {
-	struct jbd_revoke_table_s *table;
-	struct list_head *hash_list;
 	int i;
+	struct list_head *hash_list;
 
-	table = journal->j_revoke;
-	if (!table)
-		return;
-
-	for (i=0; i<table->hash_size; i++) {
+	for (i = 0; i < table->hash_size; i++) {
 		hash_list = &table->hash_table[i];
-		J_ASSERT (list_empty(hash_list));
+		J_ASSERT(list_empty(hash_list));
 	}
 
 	kfree(table->hash_table);
-	kmem_cache_free(revoke_table_cache, table);
+	kmem_cache_free(jbd2_revoke_table_cache, table);
+}
+
+/* Initialise the revoke table for a given journal to a given size. */
+int journal_init_revoke(journal_t *journal, int hash_size)
+{
+	J_ASSERT(journal->j_revoke_table[0] == NULL);
+	J_ASSERT(is_power_of_2(hash_size));
+
+	journal->j_revoke_table[0] = journal_init_revoke_table(hash_size);
+	if (!journal->j_revoke_table[0])
+		goto fail0;
+
+	journal->j_revoke_table[1] = journal_init_revoke_table(hash_size);
+	if (!journal->j_revoke_table[1])
+		goto fail1;
+
+	journal->j_revoke = journal->j_revoke_table[1];
+
+	spin_lock_init(&journal->j_revoke_lock);
+
+	return 0;
+
+fail1:
+	journal_destroy_revoke_table(journal->j_revoke_table[0]);
+fail0:
+	return -ENOMEM;
+}
+
+/* Destroy a journal's revoke table.  The table must already be empty! */
+void journal_destroy_revoke(journal_t *journal)
+{
 	journal->j_revoke = NULL;
+	if (journal->j_revoke_table[0])
+		journal_destroy_revoke_table(journal->j_revoke_table[0]);
+	if (journal->j_revoke_table[1])
+		journal_destroy_revoke_table(journal->j_revoke_table[1]);
 }
 
 
@@ -282,14 +332,15 @@ void journal_destroy_revoke(journal_t *journal)
  * by one.
  */
 
-int journal_revoke(handle_t *handle, unsigned long blocknr,
+int journal_revoke(handle_t *handle, unsigned long long blocknr,
 		   struct buffer_head *bh_in)
 {
 	struct buffer_head *bh = NULL;
 	journal_t *journal;
-	kdev_t dev;
+	struct block_device *bdev;
 	int err;
 
+	might_sleep();
 	if (bh_in)
 		BUFFER_TRACE(bh_in, "enter");
 
@@ -299,34 +350,32 @@ int journal_revoke(handle_t *handle, unsigned long blocknr,
 		return -EINVAL;
 	}
 
-	dev = journal->j_fs_dev;
+	bdev = journal->j_fs_dev;
 	bh = bh_in;
 
 	if (!bh) {
-		bh = get_hash_table(dev, blocknr, journal->j_blocksize);
+		bh = __find_get_block(bdev, blocknr, journal->j_blocksize);
 		if (bh)
 			BUFFER_TRACE(bh, "found on hash");
 	}
-#ifdef JBD_EXPENSIVE_CHECKING
+#ifdef JFS_EXPENSIVE_CHECKING
 	else {
 		struct buffer_head *bh2;
 
 		/* If there is a different buffer_head lying around in
 		 * memory anywhere... */
-		bh2 = get_hash_table(dev, blocknr, journal->j_blocksize);
+		bh2 = __find_get_block(bdev, blocknr, journal->j_blocksize);
 		if (bh2) {
 			/* ... and it has RevokeValid status... */
-			if ((bh2 != bh) &&
-			    test_bit(BH_RevokeValid, &bh2->b_state))
+			if (bh2 != bh && buffer_revokevalid(bh2))
 				/* ...then it better be revoked too,
 				 * since it's illegal to create a revoke
 				 * record against a buffer_head which is
 				 * not marked revoked --- that would
 				 * risk missing a subsequent revoke
 				 * cancel. */
-				J_ASSERT_BH(bh2, test_bit(BH_Revoked, &
-							  bh2->b_state));
-			__brelse(bh2);
+				J_ASSERT_BH(bh2, buffer_revoked(bh2));
+			put_bh(bh2);
 		}
 	}
 #endif
@@ -335,9 +384,14 @@ int journal_revoke(handle_t *handle, unsigned long blocknr,
            first having the revoke cancelled: it's illegal to free a
            block twice without allocating it in between! */
 	if (bh) {
-		J_ASSERT_BH(bh, !test_bit(BH_Revoked, &bh->b_state));
-		set_bit(BH_Revoked, &bh->b_state);
-		set_bit(BH_RevokeValid, &bh->b_state);
+		if (!J_EXPECT_BH(bh, !buffer_revoked(bh),
+				 "inconsistent data on disk")) {
+			if (!bh_in)
+				brelse(bh);
+			return -EIO;
+		}
+		set_buffer_revoked(bh);
+		set_buffer_revokevalid(bh);
 		if (bh_in) {
 			BUFFER_TRACE(bh_in, "call journal_forget");
 			journal_forget(handle, bh_in);
@@ -347,11 +401,9 @@ int journal_revoke(handle_t *handle, unsigned long blocknr,
 		}
 	}
 
-	lock_journal(journal);
-	jbd_debug(2, "insert revoke for block %lu, bh_in=%p\n", blocknr, bh_in);
+	jbd_debug(2, "insert revoke for block %llu, bh_in=%p\n",blocknr, bh_in);
 	err = insert_revoke_hash(journal, blocknr,
 				handle->h_transaction->t_tid);
-	unlock_journal(journal);
 	BUFFER_TRACE(bh_in, "exit");
 	return err;
 }
@@ -360,7 +412,7 @@ int journal_revoke(handle_t *handle, unsigned long blocknr,
  * Cancel an outstanding revoke.  For use only internally by the
  * journaling code (called from journal_get_write_access).
  *
- * We trust the BH_Revoked bit on the buffer if the buffer is already
+ * We trust buffer_revoked() on the buffer if the buffer is already
  * being journaled: if there is no revoke pending on the buffer, then we
  * don't do anything here.
  *
@@ -370,12 +422,10 @@ int journal_revoke(handle_t *handle, unsigned long blocknr,
  * the second time we would still have a pending revoke to cancel.  So,
  * do not trust the Revoked bit on buffers unless RevokeValid is also
  * set.
- *
- * The caller must have the journal locked.
  */
 int journal_cancel_revoke(handle_t *handle, struct journal_head *jh)
 {
-	struct jbd_revoke_record_s *record;
+	struct jbd2_revoke_record_s *record;
 	journal_t *journal = handle->h_transaction->t_journal;
 	int need_cancel;
 	int did_revoke = 0;	/* akpm: debug */
@@ -387,25 +437,27 @@ int journal_cancel_revoke(handle_t *handle, struct journal_head *jh)
 	 * only perform the full cancel if the revoke bit is set.  If
 	 * not, we can't trust the revoke bit, and we need to do the
 	 * full search for a revoke record. */
-	if (test_and_set_bit(BH_RevokeValid, &bh->b_state))
-		need_cancel = (test_and_clear_bit(BH_Revoked, &bh->b_state));
-	else {
+	if (test_set_buffer_revokevalid(bh)) {
+		need_cancel = test_clear_buffer_revoked(bh);
+	} else {
 		need_cancel = 1;
-		clear_bit(BH_Revoked, &bh->b_state);
+		clear_buffer_revoked(bh);
 	}
 
 	if (need_cancel) {
 		record = find_revoke_record(journal, bh->b_blocknr);
 		if (record) {
 			jbd_debug(4, "cancelled existing revoke on "
-				  "blocknr %lu\n", bh->b_blocknr);
+				  "blocknr %llu\n", (unsigned long long)bh->b_blocknr);
+			spin_lock(&journal->j_revoke_lock);
 			list_del(&record->hash);
-			kmem_cache_free(revoke_record_cache, record);
+			spin_unlock(&journal->j_revoke_lock);
+			kmem_cache_free(jbd2_revoke_record_cache, record);
 			did_revoke = 1;
 		}
 	}
 
-#ifdef JBD_EXPENSIVE_CHECKING
+#ifdef JFS_EXPENSIVE_CHECKING
 	/* There better not be one left behind by now! */
 	record = find_revoke_record(journal, bh->b_blocknr);
 	J_ASSERT_JH(jh, record == NULL);
@@ -415,56 +467,104 @@ int journal_cancel_revoke(handle_t *handle, struct journal_head *jh)
 	 * buffer_head?  If so, we'd better make sure we clear the
 	 * revoked status on any hashed alias too, otherwise the revoke
 	 * state machine will get very upset later on. */
-	if (need_cancel && !bh->b_pprev) {
+	if (need_cancel) {
 		struct buffer_head *bh2;
-		bh2 = get_hash_table(bh->b_dev, bh->b_blocknr, bh->b_size);
+		bh2 = __find_get_block(bh->b_bdev, bh->b_blocknr, bh->b_size);
 		if (bh2) {
-			clear_bit(BH_Revoked, &bh2->b_state);
+			if (bh2 != bh)
+				clear_buffer_revoked(bh2);
 			__brelse(bh2);
 		}
 	}
-
 	return did_revoke;
 }
 
+/*
+ * journal_clear_revoked_flag clears revoked flag of buffers in
+ * revoke table to reflect there is no revoked buffers in the next
+ * transaction which is going to be started.
+ */
+void jbd2_clear_buffer_revoked_flags(journal_t *journal)
+{
+	struct jbd2_revoke_table_s *revoke = journal->j_revoke;
+	int i = 0;
+
+	for (i = 0; i < revoke->hash_size; i++) {
+		struct list_head *hash_list;
+		struct list_head *list_entry;
+		hash_list = &revoke->hash_table[i];
+
+		list_for_each(list_entry, hash_list) {
+			struct jbd2_revoke_record_s *record;
+			struct buffer_head *bh;
+			record = (struct jbd2_revoke_record_s *)list_entry;
+			bh = __find_get_block(journal->j_fs_dev,
+					      record->blocknr,
+					      journal->j_blocksize);
+			if (bh) {
+				clear_buffer_revoked(bh);
+				__brelse(bh);
+			}
+		}
+	}
+}
+
+/* journal_switch_revoke table select j_revoke for next transaction
+ * we do not want to suspend any processing until all revokes are
+ * written -bzzz
+ */
+void journal_switch_revoke_table(journal_t *journal)
+{
+	int i;
+
+	if (journal->j_revoke == journal->j_revoke_table[0])
+		journal->j_revoke = journal->j_revoke_table[1];
+	else
+		journal->j_revoke = journal->j_revoke_table[0];
+
+	for (i = 0; i < journal->j_revoke->hash_size; i++)
+		INIT_LIST_HEAD(&journal->j_revoke->hash_table[i]);
+}
 
 /*
  * Write revoke records to the journal for all entries in the current
  * revoke hash, deleting the entries as we go.
- *
- * Called with the journal lock held.
  */
-
 void journal_write_revoke_records(journal_t *journal,
-				  transaction_t *transaction)
+				       transaction_t *transaction,
+				       struct list_head *log_bufs,
+				       int write_op)
 {
-	struct journal_head *descriptor;
-	struct jbd_revoke_record_s *record;
-	struct jbd_revoke_table_s *revoke;
+	struct buffer_head *descriptor;
+	struct jbd2_revoke_record_s *record;
+	struct jbd2_revoke_table_s *revoke;
 	struct list_head *hash_list;
 	int i, offset, count;
 
 	descriptor = NULL;
 	offset = 0;
 	count = 0;
-	revoke = journal->j_revoke;
+
+	/* select revoke table for committing transaction */
+	revoke = journal->j_revoke == journal->j_revoke_table[0] ?
+		journal->j_revoke_table[1] : journal->j_revoke_table[0];
 
 	for (i = 0; i < revoke->hash_size; i++) {
 		hash_list = &revoke->hash_table[i];
 
 		while (!list_empty(hash_list)) {
-			record = (struct jbd_revoke_record_s *)
+			record = (struct jbd2_revoke_record_s *)
 				hash_list->next;
-			write_one_revoke_record(journal, transaction,
+			write_one_revoke_record(journal, transaction, log_bufs,
 						&descriptor, &offset,
-						record);
+						record, write_op);
 			count++;
 			list_del(&record->hash);
-			kmem_cache_free(revoke_record_cache, record);
+			kmem_cache_free(jbd2_revoke_record_cache, record);
 		}
 	}
 	if (descriptor)
-		flush_descriptor(journal, descriptor, offset);
+		flush_descriptor(journal, descriptor, offset, write_op);
 	jbd_debug(1, "Wrote %d revoke records\n", count);
 }
 
@@ -475,11 +575,14 @@ void journal_write_revoke_records(journal_t *journal,
 
 static void write_one_revoke_record(journal_t *journal,
 				    transaction_t *transaction,
-				    struct journal_head **descriptorp,
+				    struct list_head *log_bufs,
+				    struct buffer_head **descriptorp,
 				    int *offsetp,
-				    struct jbd_revoke_record_s *record)
+				    struct jbd2_revoke_record_s *record,
+				    int write_op)
 {
-	struct journal_head *descriptor;
+	int csum_size = 0;
+	struct buffer_head *descriptor;
 	int offset;
 	journal_header_t *header;
 
@@ -493,10 +596,14 @@ static void write_one_revoke_record(journal_t *journal,
 	descriptor = *descriptorp;
 	offset = *offsetp;
 
+	/* Do we need to leave space at the end for a checksum? */
+	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_CSUM_V2))
+		csum_size = sizeof(struct journal_revoke_tail);
+
 	/* Make sure we have a descriptor with space left for the record */
 	if (descriptor) {
-		if (offset == journal->j_blocksize) {
-			flush_descriptor(journal, descriptor, offset);
+		if (offset >= journal->j_blocksize - csum_size) {
+			flush_descriptor(journal, descriptor, offset, write_op);
 			descriptor = NULL;
 		}
 	}
@@ -505,25 +612,48 @@ static void write_one_revoke_record(journal_t *journal,
 		descriptor = journal_get_descriptor_buffer(journal);
 		if (!descriptor)
 			return;
-		header = (journal_header_t *) &jh2bh(descriptor)->b_data[0];
-		header->h_magic     = htonl(JFS_MAGIC_NUMBER);
-		header->h_blocktype = htonl(JFS_REVOKE_BLOCK);
-		header->h_sequence  = htonl(transaction->t_tid);
+		header = (journal_header_t *)descriptor->b_data;
+		header->h_magic     = ext2fs_cpu_to_be32(JFS_MAGIC_NUMBER);
+		header->h_blocktype = ext2fs_cpu_to_be32(JFS_REVOKE_BLOCK);
+		header->h_sequence  = ext2fs_cpu_to_be32(transaction->t_tid);
 
 		/* Record it so that we can wait for IO completion later */
-		JBUFFER_TRACE(descriptor, "file as BJ_LogCtl");
-		journal_file_buffer(descriptor, transaction, BJ_LogCtl);
+		BUFFER_TRACE(descriptor, "file in log_bufs");
+		jbd2_file_log_bh(log_bufs, descriptor);
 
 		offset = sizeof(journal_revoke_header_t);
 		*descriptorp = descriptor;
 	}
 
-	* ((unsigned int *)(&jh2bh(descriptor)->b_data[offset])) =
-		htonl(record->blocknr);
-	offset += 4;
+	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_64BIT)) {
+		* ((__u64 *)(&descriptor->b_data[offset])) =
+			ext2fs_cpu_to_be64(record->blocknr);
+		offset += 8;
+
+	} else {
+		* ((__u32 *)(&descriptor->b_data[offset])) =
+			ext2fs_cpu_to_be32(record->blocknr);
+		offset += 4;
+	}
+
 	*offsetp = offset;
 }
 
+static void jbd2_revoke_csum_set(journal_t *j, struct buffer_head *bh)
+{
+	struct journal_revoke_tail *tail;
+	__u32 csum;
+
+	if (!JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V2))
+		return;
+
+	tail = (struct journal_revoke_tail *)(bh->b_data + j->j_blocksize -
+			sizeof(struct journal_revoke_tail));
+	tail->r_checksum = 0;
+	csum = jbd2_chksum(j, j->j_csum_seed, bh->b_data, j->j_blocksize);
+	tail->r_checksum = ext2fs_cpu_to_be32(csum);
+}
+
 /*
  * Flush a revoke descriptor out to the journal.  If we are aborting,
  * this is a noop; otherwise we are generating a buffer which needs to
@@ -532,27 +662,25 @@ static void write_one_revoke_record(journal_t *journal,
  */
 
 static void flush_descriptor(journal_t *journal,
-			     struct journal_head *descriptor,
-			     int offset)
+			     struct buffer_head *descriptor,
+			     int offset, int write_op)
 {
 	journal_revoke_header_t *header;
 
 	if (is_journal_aborted(journal)) {
-		JBUFFER_TRACE(descriptor, "brelse");
-		__brelse(jh2bh(descriptor));
+		put_bh(descriptor);
 		return;
 	}
 
-	header = (journal_revoke_header_t *) jh2bh(descriptor)->b_data;
-	header->r_count = htonl(offset);
-	set_bit(BH_JWrite, &jh2bh(descriptor)->b_state);
-	{
-		struct buffer_head *bh = jh2bh(descriptor);
-		BUFFER_TRACE(bh, "write");
-		ll_rw_block (WRITE, 1, &bh);
-	}
-}
+	header = (journal_revoke_header_t *)descriptor->b_data;
+	header->r_count = ext2fs_cpu_to_be32(offset);
+	jbd2_revoke_csum_set(journal, descriptor);
 
+	set_buffer_jwrite(descriptor);
+	BUFFER_TRACE(descriptor, "write");
+	set_buffer_dirty(descriptor);
+	write_dirty_buffer(descriptor, write_op);
+}
 #endif
 
 /*
@@ -578,14 +706,14 @@ static void flush_descriptor(journal_t *journal,
  */
 
 int journal_set_revoke(journal_t *journal,
-		       unsigned long blocknr,
+		       unsigned long long blocknr,
 		       tid_t sequence)
 {
-	struct jbd_revoke_record_s *record;
+	struct jbd2_revoke_record_s *record;
 
 	record = find_revoke_record(journal, blocknr);
 	if (record) {
-		/* If we have multiple occurences, only record the
+		/* If we have multiple occurrences, only record the
 		 * latest sequence number in the hashed record */
 		if (tid_gt(sequence, record->sequence))
 			record->sequence = sequence;
@@ -602,10 +730,10 @@ int journal_set_revoke(journal_t *journal,
  */
 
 int journal_test_revoke(journal_t *journal,
-			unsigned long blocknr,
+			unsigned long long blocknr,
 			tid_t sequence)
 {
-	struct jbd_revoke_record_s *record;
+	struct jbd2_revoke_record_s *record;
 
 	record = find_revoke_record(journal, blocknr);
 	if (!record)
@@ -624,18 +752,17 @@ void journal_clear_revoke(journal_t *journal)
 {
 	int i;
 	struct list_head *hash_list;
-	struct jbd_revoke_record_s *record;
-	struct jbd_revoke_table_s *revoke;
+	struct jbd2_revoke_record_s *record;
+	struct jbd2_revoke_table_s *revoke;
 
 	revoke = journal->j_revoke;
 
 	for (i = 0; i < revoke->hash_size; i++) {
 		hash_list = &revoke->hash_table[i];
 		while (!list_empty(hash_list)) {
-			record = (struct jbd_revoke_record_s*) hash_list->next;
+			record = (struct jbd2_revoke_record_s*) hash_list->next;
 			list_del(&record->hash);
-			kmem_cache_free(revoke_record_cache, record);
+			kmem_cache_free(jbd2_revoke_record_cache, record);
 		}
 	}
 }
-
diff --git a/lib/ext2fs/jfs_compat.h b/lib/ext2fs/jfs_compat.h
index 2638c31..d92f931 100644
--- a/lib/ext2fs/jfs_compat.h
+++ b/lib/ext2fs/jfs_compat.h
@@ -42,6 +42,18 @@ static inline __u32 jbd2_chksum(journal_t *j, __u32 crc, const void *address,
 	return ext2fs_crc32c_le(crc, address, length);
 }
 #define crc32_be(x, y, z)	ext2fs_crc32_be((x), (y), (z))
+#define spin_lock_init(x)
+#define spin_lock(x)
+#define spin_unlock(x)
+#define yield()
+#define SLAB_HWCACHE_ALIGN	0
+#define SLAB_TEMPORARY		0
+#define KMEM_CACHE(__struct, __flags) kmem_cache_create(#__struct,\
+                sizeof(struct __struct), __alignof__(struct __struct),\
+                (__flags), NULL)
+
+#define blkdev_issue_flush(kdev, a, b)	sync_blockdev(kdev)
+#define is_power_of_2(x)	((x) != 0 && (((x) & ((x) - 1)) == 0))
 
 struct journal_s
 {
@@ -63,7 +75,8 @@ struct journal_s
 	tid_t			j_tail_sequence;
 	tid_t			j_transaction_sequence;
 	__u8			j_uuid[16];
-	struct jbd_revoke_table_s *j_revoke;
+	struct jbd2_revoke_table_s *j_revoke;
+	struct jbd2_revoke_table_s *j_revoke_table[2];
 	tid_t			j_failed_commit;
 	__u32			j_csum_seed;
 };
diff --git a/lib/ext2fs/kernel-jbd.h b/lib/ext2fs/kernel-jbd.h
index a9cdc30..407f4a5 100644
--- a/lib/ext2fs/kernel-jbd.h
+++ b/lib/ext2fs/kernel-jbd.h
@@ -365,6 +365,7 @@ static inline struct journal_head *bh2jh(struct buffer_head *bh)
 }
 
 struct jbd_revoke_table_s;
+struct jbd2_revoke_table_s;
 
 /* The handle_t type represents a single atomic update being performed
  * by some process.  All filesystem modifications made by the process go
@@ -892,8 +893,8 @@ extern void	   journal_destroy_revoke_caches(void);
 extern int	   journal_init_revoke_caches(void);
 
 /* Recovery revoke support */
-extern int	   journal_set_revoke(journal_t *, unsigned long, tid_t);
-extern int	   journal_test_revoke(journal_t *, unsigned long, tid_t);
+extern int	   journal_set_revoke(journal_t *, unsigned long long, tid_t);
+extern int	   journal_test_revoke(journal_t *, unsigned long long, tid_t);
 extern void	   journal_clear_revoke(journal_t *);
 extern void	   journal_brelse_array(struct buffer_head *b[], int n);
 

