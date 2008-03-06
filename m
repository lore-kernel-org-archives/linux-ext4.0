From: "Duane Griffin" <duaneg@dghda.com>
Subject: [RFC, PATCH 5/6] jbd: add support for read-only log recovery
Date: Thu,  6 Mar 2008 01:59:13 +0000
Message-ID: <7f095bf2403465433796f2f7aab20f1c9a2e0f73.1204685366.git.duaneg__28277.4652158425$1204769422$gmane$org@dghda.com>
References: <1204768754-29655-1-git-send-email-duaneg@dghda.com>
 <1204768754-29655-2-git-send-email-duaneg@dghda.com>
 <1204768754-29655-3-git-send-email-duaneg@dghda.com>
 <1204768754-29655-4-git-send-email-duaneg@dghda.com>
 <1204768754-29655-5-git-send-email-duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
	sct@redhat.com, akpm@linux-foundation.org, adilger@clusterfs.com,
	Duane Griffin <duaneg@dghda.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933903AbYCFCJZ@vger.kernel.org>
In-Reply-To: <1204768754-29655-5-git-send-email-duaneg@dghda.com>
Message-Id: <7f095bf2403465433796f2f7aab20f1c9a2e0f73.1204685366.git.duaneg@dghda.com>
In-Reply-To: <a047dfbd7855d5f484ae8a3434f6a073302505be.1204685366.git.duaneg@dghda.com>
References: <a047dfbd7855d5f484ae8a3434f6a073302505be.1204685366.git.duaneg@dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Read-only log recovery allows a dirty journalled filesystem to be mounted and
provide a consistent view of its data without writing to the disk. Instead of
replaying the log a mapping is constructed between modified filesystem blocks
and the journal blocks containing their data.

The mapping is stored in a hashtable that is created and populated during
journal recovery. The hash function used is the same one used by the journal
revocation code. The size of the hashtable is currently being arbitrarily set
to 256 entries. Given that we know the number of block mappings when we create
the table it may be worth dynamically calculating an appropriate size instead
of hard-coding it.

Signed-off-by: Duane Griffin <duaneg@dghda.com>
---

I'm tempted to add warnings on attempts to modify a read-only journal, does
that sound useful? I'd also be grateful to anyone with suggestions for better
member names. :)

 fs/ext3/super.c     |    2 +-
 fs/jbd/checkpoint.c |    2 +-
 fs/jbd/commit.c     |    2 +-
 fs/jbd/journal.c    |   56 ++++++++++------
 fs/jbd/recovery.c   |  187 +++++++++++++++++++++++++++++++++++++++++++++------
 fs/jbd/revoke.c     |    7 +--
 fs/ocfs2/journal.c  |    4 +-
 include/linux/jbd.h |   41 ++++++++++-
 8 files changed, 246 insertions(+), 55 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 18769cc..4b9ff65 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -2168,7 +2168,7 @@ static int ext3_load_journal(struct super_block *sb,
 	if (!EXT3_HAS_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER))
 		err = journal_wipe(journal, !really_read_only);
 	if (!err)
-		err = journal_load(journal);
+		err = journal_load(journal, !really_read_only);
 
 	if (err) {
 		printk(KERN_ERR "EXT3-fs: error loading journal.\n");
diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
index a5432bb..84d4579 100644
--- a/fs/jbd/checkpoint.c
+++ b/fs/jbd/checkpoint.c
@@ -454,7 +454,7 @@ int cleanup_journal_tail(journal_t *journal)
 	journal->j_tail = blocknr;
 	spin_unlock(&journal->j_state_lock);
 	if (!(journal->j_flags & JFS_ABORT))
-		journal_update_superblock(journal, 1);
+		journal_update_superblock(journal, 1, 1);
 	return 0;
 }
 
diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index a38c718..c63598b 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -310,7 +310,7 @@ void journal_commit_transaction(journal_t *journal)
 	/* Do we need to erase the effects of a prior journal_flush? */
 	if (journal->j_flags & JFS_FLUSHED) {
 		jbd_debug(3, "super block updated\n");
-		journal_update_superblock(journal, 1);
+		journal_update_superblock(journal, 1, 1);
 	} else {
 		jbd_debug(3, "superblock not updated\n");
 	}
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index a868277..b2723a0 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -822,7 +822,7 @@ static void journal_fail_superblock (journal_t *journal)
  * subsequent use.
  */
 
-static int journal_reset(journal_t *journal)
+static int journal_reset(journal_t *journal, int write)
 {
 	journal_superblock_t *sb = journal->j_superblock;
 	unsigned long first, last;
@@ -843,8 +843,8 @@ static int journal_reset(journal_t *journal)
 
 	journal->j_max_transaction_buffers = journal->j_maxlen / 4;
 
-	/* Add the dynamic fields and write it to disk. */
-	journal_update_superblock(journal, 1);
+	/* Add the dynamic fields and write it to disk if not read-only. */
+	journal_update_superblock(journal, write, 1);
 	return journal_start_thread(journal);
 }
 
@@ -916,21 +916,21 @@ int journal_create(journal_t *journal)
 	journal->j_flags &= ~JFS_ABORT;
 	journal->j_format_version = 2;
 
-	return journal_reset(journal);
+	return journal_reset(journal, 1);
 }
 
 /**
- * void journal_update_superblock() - Update journal sb on disk.
+ * void journal_update_superblock() - Update journal sb in memory and on disk.
  * @journal: The journal to update.
+ * @write: Set to '0' if you don't want to write to the disk.
  * @wait: Set to '0' if you don't want to wait for IO completion.
  *
  * Update a journal's dynamic superblock fields and write it to disk,
  * optionally waiting for the IO to complete.
  */
-void journal_update_superblock(journal_t *journal, int wait)
+void journal_update_superblock(journal_t *journal, int write, int wait)
 {
 	journal_superblock_t *sb = journal->j_superblock;
-	struct buffer_head *bh = journal->j_sb_buffer;
 
 	/*
 	 * As a special case, if the on-disk copy is already marked as needing
@@ -957,12 +957,16 @@ void journal_update_superblock(journal_t *journal, int wait)
 	sb->s_errno    = cpu_to_be32(journal->j_errno);
 	spin_unlock(&journal->j_state_lock);
 
-	BUFFER_TRACE(bh, "marking dirty");
-	mark_buffer_dirty(bh);
-	if (wait)
-		sync_dirty_buffer(bh);
-	else
-		ll_rw_block(SWRITE, 1, &bh);
+	if (write) {
+		struct buffer_head *bh = journal->j_sb_buffer;
+
+		BUFFER_TRACE(bh, "marking dirty");
+		mark_buffer_dirty(bh);
+		if (wait)
+			sync_dirty_buffer(bh);
+		else
+			ll_rw_block(SWRITE, 1, &bh);
+	}
 
 out:
 	/* If we have just flushed the log (by marking s_start==0), then
@@ -1066,12 +1070,13 @@ static int load_superblock(journal_t *journal)
 /**
  * int journal_load() - Read journal from disk.
  * @journal: Journal to act on.
+ * @write: Whether the journal may be modified on-disk.
  *
  * Given a journal_t structure which tells us which disk blocks contain
  * a journal, read the journal from disk to initialise the in-memory
  * structures.
  */
-int journal_load(journal_t *journal)
+int journal_load(journal_t *journal, int write)
 {
 	int err;
 	journal_superblock_t *sb;
@@ -1097,13 +1102,13 @@ int journal_load(journal_t *journal)
 
 	/* Let the recovery code check whether it needs to recover any
 	 * data from the journal. */
-	if (journal_recover(journal))
+	if (journal_recover(journal, write))
 		goto recovery_error;
 
 	/* OK, we've finished with the dynamic journal bits:
 	 * reinitialise the dynamic contents of the superblock in memory
 	 * and reset them on disk. */
-	if (journal_reset(journal))
+	if (journal_reset(journal, write))
 		goto recovery_error;
 
 	journal->j_flags &= ~JFS_ABORT;
@@ -1150,7 +1155,12 @@ void journal_destroy(journal_t *journal)
 	journal->j_tail = 0;
 	journal->j_tail_sequence = ++journal->j_transaction_sequence;
 	if (journal->j_sb_buffer) {
-		journal_update_superblock(journal, 1);
+
+		/*
+		 * Ugly, but what to do?
+		 * We don't have a superblock to test for read-only.
+		 */
+		journal_update_superblock(journal, !journal->j_bt_hash, 1);
 		brelse(journal->j_sb_buffer);
 	}
 
@@ -1158,6 +1168,8 @@ void journal_destroy(journal_t *journal)
 		iput(journal->j_inode);
 	if (journal->j_revoke)
 		journal_destroy_revoke(journal);
+	if (journal->j_bt_hash)
+		journal_destroy_translations(journal);
 	kfree(journal->j_wbuf);
 	kfree(journal);
 }
@@ -1374,7 +1386,7 @@ int journal_flush(journal_t *journal)
 	old_tail = journal->j_tail;
 	journal->j_tail = 0;
 	spin_unlock(&journal->j_state_lock);
-	journal_update_superblock(journal, 1);
+	journal_update_superblock(journal, 1, 1);
 	spin_lock(&journal->j_state_lock);
 	journal->j_tail = old_tail;
 
@@ -1420,8 +1432,7 @@ int journal_wipe(journal_t *journal, int write)
 		write ? "Clearing" : "Ignoring");
 
 	err = journal_skip_recovery(journal);
-	if (write)
-		journal_update_superblock(journal, 1);
+	journal_update_superblock(journal, write, 1);
 
  no_recovery:
 	return err;
@@ -1489,7 +1500,7 @@ static void __journal_abort_soft (journal_t *journal, int errno)
 	__journal_abort_hard(journal);
 
 	if (errno)
-		journal_update_superblock(journal, 1);
+		journal_update_superblock(journal, !journal->j_bt_hash, 1);
 }
 
 /**
@@ -1922,6 +1933,8 @@ static int __init journal_init_caches(void)
 
 	ret = journal_init_revoke_caches();
 	if (ret == 0)
+		ret = journal_init_recover_cache();
+	if (ret == 0)
 		ret = journal_init_journal_head_cache();
 	if (ret == 0)
 		ret = journal_init_handle_cache();
@@ -1931,6 +1944,7 @@ static int __init journal_init_caches(void)
 static void journal_destroy_caches(void)
 {
 	journal_destroy_revoke_caches();
+	journal_destroy_recover_cache();
 	journal_destroy_journal_head_cache();
 	journal_destroy_handle_cache();
 }
diff --git a/fs/jbd/recovery.c b/fs/jbd/recovery.c
index e2ac78f..a73b062 100644
--- a/fs/jbd/recovery.c
+++ b/fs/jbd/recovery.c
@@ -17,12 +17,15 @@
 #include "jfs_user.h"
 #else
 #include <linux/time.h>
+#include <linux/cache.h>
 #include <linux/fs.h>
 #include <linux/jbd.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
 #endif
 
+static struct kmem_cache *bt_record_cache;
+
 /*
  * Maintain information about the progress of the recovery job, so that
  * the different passes can carry information between them.
@@ -123,6 +126,71 @@ failed:
 
 #endif /* __KERNEL__ */
 
+int __init journal_init_recover_cache(void)
+{
+	bt_record_cache = kmem_cache_create(
+		"block_translation_record",
+		sizeof(struct journal_block_translation),
+		0, 0, NULL);
+	if (bt_record_cache == NULL) {
+		printk(KERN_EMERG "JBD: failed to create recover cache\n");
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+void journal_destroy_recover_cache(void)
+{
+	if (bt_record_cache) {
+		kmem_cache_destroy(bt_record_cache);
+		bt_record_cache = NULL;
+	}
+}
+
+bool journal_translate_block(journal_t *journal, sector_t blocknr,
+	sector_t *retp)
+{
+	int hash;
+	struct journal_block_translation *jbt;
+	struct hlist_node *node;
+
+	if (!journal || !journal->j_bt_hash)
+		goto unmapped;
+
+	hash = jbd_hash(blocknr, journal->j_bt_hash_bits,
+		1 << journal->j_bt_hash_bits);
+	hlist_for_each_entry(jbt, node, journal->j_bt_hash + hash, jbt_list) {
+		if (jbt->original == blocknr) {
+			*retp = jbt->target;
+			return true;
+		}
+	}
+
+unmapped:
+	*retp = blocknr;
+	return false;
+}
+
+void journal_destroy_translations(journal_t *journal)
+{
+	int ii;
+	struct journal_block_translation *jbt;
+	struct hlist_node *tmp;
+	struct hlist_node *node;
+
+	if (!journal->j_bt_hash)
+		return;
+
+	for (ii = 0; ii < (1 << journal->j_bt_hash_bits); ii++) {
+		hlist_for_each_entry_safe(jbt, node, tmp,
+			journal->j_bt_hash + ii, jbt_list) {
+			kmem_cache_free(bt_record_cache, jbt);
+		}
+	}
+
+	kfree(journal->j_bt_hash);
+	journal->j_bt_hash = NULL;
+}
 
 /*
  * Read a block from the journal
@@ -173,6 +241,45 @@ static int jread(struct buffer_head **bhp, journal_t *journal,
 	return 0;
 }
 
+static int journal_record_bt(journal_t *journal, sector_t original,
+	sector_t target)
+{
+	int err;
+	int hash;
+	struct hlist_node *node;
+	struct journal_block_translation *jbt;
+	sector_t blocknr;
+
+	/* Store the physical block to avoid repeated lookups. */
+	err = journal_bmap(journal, target, &blocknr);
+	if (err)
+		return err;
+
+	/*
+	 * If the same block has been translated multiple times,
+	 * just use the last.
+	 */
+	hash = jbd_hash(original, journal->j_bt_hash_bits,
+		1 << journal->j_bt_hash_bits);
+	hlist_for_each_entry(jbt, node, journal->j_bt_hash + hash, jbt_list) {
+		if (jbt->original == original) {
+			jbt->target = blocknr;
+			return 0;
+		}
+	}
+
+	jbt = kmem_cache_alloc(bt_record_cache, GFP_NOFS);
+	if (!jbt)
+		return -ENOMEM;
+
+	INIT_HLIST_NODE(&jbt->jbt_list);
+	jbt->original = original;
+	jbt->target = blocknr;
+
+	hlist_add_head(&jbt->jbt_list, journal->j_bt_hash + hash);
+
+	return 0;
+}
 
 /*
  * Count the number of in-use tags in a journal descriptor block.
@@ -201,6 +308,24 @@ static int count_tags(struct buffer_head *bh, int size)
 	return nr;
 }
 
+#define JOURNAL_DEFAULT_BT_HASHBITS 8
+static int bt_hash_init(journal_t *journal)
+{
+	int ii;
+	BUG_ON(journal->j_bt_hash);
+
+	/* Vary size depending on the number of mappings/device size? */
+	journal->j_bt_hash_bits = JOURNAL_DEFAULT_BT_HASHBITS;
+	journal->j_bt_hash = kmalloc(sizeof(struct hlist_head) *
+		1 << journal->j_bt_hash_bits, GFP_NOFS);
+	if (!journal->j_bt_hash)
+		return -ENOMEM;
+
+	for (ii = 0; ii < (1 << journal->j_bt_hash_bits); ii++)
+		INIT_HLIST_HEAD(journal->j_bt_hash + ii);
+
+	return 0;
+}
 
 /* Make sure we wrap around the log correctly! */
 #define wrap(journal, var)						\
@@ -212,6 +337,7 @@ do {									\
 /**
  * journal_recover - recovers a on-disk journal
  * @journal: the journal to recover
+ * @write: whether to write to disk
  *
  * The primary function for recovering the log contents when mounting a
  * journaled device.
@@ -220,8 +346,11 @@ do {									\
  * end of the log.  In the second, we assemble the list of revoke
  * blocks.  In the third and final pass, we replay any un-revoked blocks
  * in the log.
+ *
+ * If the journal is read-only a translation table will be built up instead
+ * of the journal being replayed on disk.
  */
-int journal_recover(journal_t *journal)
+int journal_recover(journal_t *journal, int write)
 {
 	int			err;
 	journal_superblock_t *	sb;
@@ -244,6 +373,16 @@ int journal_recover(journal_t *journal)
 		return 0;
 	}
 
+	if (!write) {
+		err = bt_hash_init(journal);
+		if (err) {
+			printk(KERN_ERR
+				"JBD: out of memory allocating"
+				" journal block translation hash\n");
+			return err;
+		}
+	}
+
 	err = do_one_pass(journal, &info, PASS_SCAN);
 	if (!err)
 		err = do_one_pass(journal, &info, PASS_REVOKE);
@@ -256,12 +395,15 @@ int journal_recover(journal_t *journal)
 	jbd_debug(1, "JBD: Replayed %d and revoked %d/%d blocks\n",
 		  info.nr_replays, info.nr_revoke_hits, info.nr_revokes);
 
-	/* Restart the log at the next transaction ID, thus invalidating
-	 * any existing commit records in the log. */
-	journal->j_transaction_sequence = ++info.end_transaction;
+	if (write) {
+
+		/* Restart the log at the next transaction ID, thus invalidating
+		 * any existing commit records in the log. */
+		journal->j_transaction_sequence = ++info.end_transaction;
+		journal_clear_revoke(journal);
+		sync_blockdev(journal->j_fs_dev);
+	}
 
-	journal_clear_revoke(journal);
-	sync_blockdev(journal->j_fs_dev);
 	return err;
 }
 
@@ -345,7 +487,6 @@ static int replay_descriptor_block(
 	int success = 0;
 	char *tagp;
 	unsigned long io_block;
-	struct buffer_head *obh;
 	unsigned long next = *next_log_block;
 
 	tagp = &data[sizeof(journal_header_t)];
@@ -365,28 +506,34 @@ static int replay_descriptor_block(
 			goto skip_write;
 		}
 
-		err = jread(&obh, journal, io_block);
-		if (err) {
+		if (journal->j_bt_hash) {
+			err = journal_record_bt(journal, blocknr, io_block);
+		} else {
+			struct buffer_head *obh;
 
-			/* Recover what we can, but
-			 * report failure at the end. */
-			success = err;
-			printk(KERN_ERR "JBD: IO error %d recovering "
-			       "block %ld in log\n", err, io_block);
-			continue;
-		}
-		J_ASSERT(obh != NULL);
+			err = jread(&obh, journal, io_block);
+			if (err) {
 
-		err = replay_data_block(journal, obh, data, flags, blocknr);
-		if (err) {
+				/* Recover what we can, but
+				 * report failure at the end. */
+				success = err;
+				printk(KERN_ERR "JBD: IO error %d recovering "
+				       "block %ld in log\n", err, io_block);
+				continue;
+			}
+			J_ASSERT(obh != NULL);
+
+			err = replay_data_block(
+				journal, obh, data, flags, blocknr);
 			brelse(obh);
+		}
+		if (err) {
 			printk(KERN_ERR "JBD: Out of memory during recovery\n");
 			success = err;
 			goto failed;
 		}
 
 		++info->nr_replays;
-		brelse(obh);
 
 skip_write:
 		tagp += sizeof(journal_block_tag_t);
diff --git a/fs/jbd/revoke.c b/fs/jbd/revoke.c
index 5f64df4..7f57d03 100644
--- a/fs/jbd/revoke.c
+++ b/fs/jbd/revoke.c
@@ -105,15 +105,10 @@ static void flush_descriptor(journal_t *, struct journal_head *, int);
 
 /* Utility functions to maintain the revoke table */
 
-/* Borrowed from buffer.c: this is a tried and tested block hash function */
 static inline int hash(journal_t *journal, unsigned long block)
 {
 	struct jbd_revoke_table_s *table = journal->j_revoke;
-	int hash_shift = table->hash_shift;
-
-	return ((block << (hash_shift - 6)) ^
-		(block >> 13) ^
-		(block << (hash_shift - 12))) & (table->hash_size - 1);
+	return jbd_hash(block, table->hash_shift, table->hash_size);
 }
 
 static int insert_revoke_hash(journal_t *journal, unsigned long blocknr,
diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index f31c7e8..cbd53aa 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -591,7 +591,7 @@ int ocfs2_journal_load(struct ocfs2_journal *journal, int local)
 
 	osb = journal->j_osb;
 
-	status = journal_load(journal->j_journal);
+	status = journal_load(journal->j_journal, true);
 	if (status < 0) {
 		mlog(ML_ERROR, "Failed to load journal!\n");
 		goto done;
@@ -1014,7 +1014,7 @@ static int ocfs2_replay_journal(struct ocfs2_super *osb,
 		goto done;
 	}
 
-	status = journal_load(journal);
+	status = journal_load(journal, 1);
 	if (status < 0) {
 		mlog_errno(status);
 		if (!igrab(inode))
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index b18fd3b..6154082 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -558,6 +558,18 @@ struct transaction_s
 };
 
 /**
+ * struct journal_block_translation - hash bucket recording block translations.
+ * @jbt_list: list of translated blocks in this bucket.
+ * @original: the (logical?) filesystem block being translation.
+ * @target: the physical journal block holding the original's data.
+ */
+struct journal_block_translation {
+	struct hlist_node jbt_list;
+	sector_t original;
+	sector_t target;
+};
+
+/**
  * struct journal_s - The journal_s type is the concrete type associated with
  *     journal_t.
  * @j_flags:  General journaling state flags
@@ -618,6 +630,8 @@ struct transaction_s
  * @j_wbufsize: maximum number of buffer_heads allowed in j_wbuf, the
  *	number that will fit in j_blocksize
  * @j_last_sync_writer: most recent pid which did a synchronous write
+ * @j_bt_hash: hash table mapping uncommitted blocks to their targets
+ * @j_bt_hash_bits: number of bits in block translation hash table
  * @j_private: An opaque pointer to fs-private information.
  */
 
@@ -810,6 +824,12 @@ struct journal_s
 	pid_t			j_last_sync_writer;
 
 	/*
+	 * Remap uncommitted transactions in a read-only filesystem.
+	 */
+	struct hlist_head	*j_bt_hash;
+	int			j_bt_hash_bits;
+
+	/*
 	 * An opaque pointer to fs-private information.  ext3 puts its
 	 * superblock pointer here
 	 */
@@ -916,12 +936,12 @@ extern int	   journal_check_available_features
 extern int	   journal_set_features
 		   (journal_t *, unsigned long, unsigned long, unsigned long);
 extern int	   journal_create     (journal_t *);
-extern int	   journal_load       (journal_t *journal);
+extern int	   journal_load       (journal_t *journal, int);
 extern void	   journal_destroy    (journal_t *);
-extern int	   journal_recover    (journal_t *journal);
+extern int	   journal_recover    (journal_t *journal, int);
 extern int	   journal_wipe       (journal_t *, int);
 extern int	   journal_skip_recovery	(journal_t *);
-extern void	   journal_update_superblock	(journal_t *, int);
+extern void	   journal_update_superblock	(journal_t *, int, int);
 extern void	   journal_abort      (journal_t *, int);
 extern int	   journal_errno      (journal_t *);
 extern void	   journal_ack_err    (journal_t *);
@@ -970,6 +990,12 @@ extern int	journal_test_revoke(journal_t *, unsigned long, tid_t);
 extern void	journal_clear_revoke(journal_t *);
 extern void	journal_switch_revoke_table(journal_t *journal);
 
+extern bool	journal_translate_block(journal_t *journal, sector_t blocknr,
+					sector_t *retp);
+extern void	journal_destroy_translations(journal_t *journal);
+extern int	journal_init_recover_cache(void);
+extern void	journal_destroy_recover_cache(void);
+
 /*
  * The log thread user interface:
  *
@@ -989,6 +1015,15 @@ void __log_wait_for_space(journal_t *journal);
 extern void	__journal_drop_transaction(journal_t *, transaction_t *);
 extern int	cleanup_journal_tail(journal_t *);
 
+/* Borrowed from buffer.c: this is a tried and tested block hash function */
+static inline int jbd_hash(unsigned long block, int shift, int size)
+{
+    return ((block << (shift - 6)) ^
+	(block >> 13) ^
+	(block << (shift - 12))) &
+		(size - 1);
+}
+
 /* Debugging code only: */
 
 #define jbd_ENOSYS() \
-- 
1.5.3.7
