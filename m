From: amir73il@users.sourceforge.net
Subject: [PATCH v1 25/36] ext4: snapshot journaled - cache last COW tid in journal_head
Date: Tue,  7 Jun 2011 18:07:52 +0300
Message-ID: <1307459283-22130-26-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41767 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab1FGPKG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:10:06 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so5035787wwa.1
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:10:05 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Cache last COW transaction id in buffer's journal_head.
The cache suppresses COW tests until the transaction in committed.
By default, the running transaction is committed every 5 seconds
which implies an average COW cache expiry of 2.5 seconds.
Before taking a new snapshot, the journal is flushed to disk
and the current transaction in committed, so the COW cache is
invalidated (as it should be).


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/snapshot.c       |   93 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/snapshot.h       |    2 +
 fs/ext4/snapshot_debug.c |    7 +++
 3 files changed, 102 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/snapshot.c b/fs/ext4/snapshot.c
index e86dc42..2724381 100644
--- a/fs/ext4/snapshot.c
+++ b/fs/ext4/snapshot.c
@@ -400,6 +400,90 @@ __ext4_snapshot_trace_cow(const char *where, handle_t *handle,
 #define ext4_snapshot_trace_cow(where, handle, sb, inode, bh, blk, cnt, cmd)
 #endif
 /*
+ * The last transaction ID during which the buffer has been COWed is stored in
+ * the b_cow_tid field of the journal_head struct.  If we know that the buffer
+ * was COWed during the current transaction, we don't need to COW it again.
+ * [jbd_lock_bh_state()]
+ */
+
+void init_ext4_snapshot_cow_cache(void)
+{
+#ifdef CONFIG_EXT4_DEBUG
+	cow_cache_enabled = 1;
+#endif
+}
+
+#ifdef CONFIG_EXT4_DEBUG
+#define cow_cache_enabled()	(cow_cache_enabled)
+#else
+#define cow_cache_enabled()	(1)
+#endif
+
+#define test_cow_tid(jh, handle)	\
+	((jh)->b_cow_tid == (handle)->h_transaction->t_tid)
+#define set_cow_tid(jh, handle)		\
+	((jh)->b_cow_tid = (handle)->h_transaction->t_tid)
+
+/*
+ * Journal COW cache functions.
+ * a block can only be COWed once per snapshot,
+ * so a block can only be COWed once per transaction,
+ * so a buffer that was COWed in the current transaction,
+ * doesn't need to be COWed.
+ *
+ * Return values:
+ * 1 - block was COWed in current transaction
+ * 0 - block wasn't COWed in current transaction
+ */
+static int
+ext4_snapshot_test_cowed(handle_t *handle, struct buffer_head *bh)
+{
+	struct journal_head *jh;
+
+	if (!cow_cache_enabled())
+		return 0;
+
+	/* check the COW tid in the journal head */
+	if (bh && buffer_jbd(bh)) {
+		jbd_lock_bh_state(bh);
+		jh = bh2jh(bh);
+		if (jh && !test_cow_tid(jh, handle))
+			jh = NULL;
+		jbd_unlock_bh_state(bh);
+		if (jh)
+			/*
+			 * Block was already COWed in the running transaction,
+			 * so we don't need to COW it again.
+			 */
+			return 1;
+	}
+	return 0;
+}
+
+static void
+ext4_snapshot_mark_cowed(handle_t *handle, struct buffer_head *bh)
+{
+	struct journal_head *jh;
+
+	if (!cow_cache_enabled())
+		return;
+
+	if (bh && buffer_jbd(bh)) {
+		jbd_lock_bh_state(bh);
+		jh = bh2jh(bh);
+		if (jh && !test_cow_tid(jh, handle))
+			/*
+			 * this is the first time this block was COWed
+			 * in the running transaction.
+			 * update the COW tid in the journal head
+			 * to mark that this block doesn't need to be COWed.
+			 */
+			set_cow_tid(jh, handle);
+		jbd_unlock_bh_state(bh);
+	}
+}
+
+/*
  * Begin COW or move operation.
  * No locks needed here, because @handle is a per-task struct.
  */
@@ -479,6 +563,13 @@ int ext4_snapshot_test_and_cow(const char *where, handle_t *handle,
 		snapshot_debug_hl(4, "active snapshot access denied!\n");
 		return -EPERM;
 	}
+	/* check if the buffer was COWed in the current transaction */
+	if (ext4_snapshot_test_cowed(handle, bh)) {
+		snapshot_debug_hl(4, "buffer found in COW cache - "
+				  "skip block cow!\n");
+		trace_cow_inc(handle, ok_jh);
+		return 0;
+	}
 
 	/* BEGIN COWing */
 	ext4_snapshot_cow_begin(handle);
@@ -572,6 +663,8 @@ int ext4_snapshot_test_and_cow(const char *where, handle_t *handle,
 test_pending_cow:
 
 cowed:
+	/* mark the buffer COWed in the current transaction */
+	ext4_snapshot_mark_cowed(handle, bh);
 out:
 	brelse(sbh);
 	/* END COWing */
diff --git a/fs/ext4/snapshot.h b/fs/ext4/snapshot.h
index 007fec0..44bac96 100644
--- a/fs/ext4/snapshot.h
+++ b/fs/ext4/snapshot.h
@@ -342,6 +342,7 @@ static inline int ext4_snapshot_get_delete_access(handle_t *handle,
 	return ext4_snapshot_move(handle, inode, block, pcount, 1);
 }
 
+extern void init_ext4_snapshot_cow_cache(void);
 
 /* snapshot_ctl.c */
 
@@ -364,6 +365,7 @@ extern void ext4_snapshot_destroy(struct super_block *sb);
 
 static inline int init_ext4_snapshot(void)
 {
+	init_ext4_snapshot_cow_cache();
 	return 0;
 }
 
diff --git a/fs/ext4/snapshot_debug.c b/fs/ext4/snapshot_debug.c
index 35f552a..265ee2c 100644
--- a/fs/ext4/snapshot_debug.c
+++ b/fs/ext4/snapshot_debug.c
@@ -47,10 +47,12 @@ static const char *snapshot_test_names[SNAPSHOT_TESTS_NUM] = {
 
 u16 snapshot_enable_test[SNAPSHOT_TESTS_NUM] __read_mostly = {0};
 u8 snapshot_enable_debug __read_mostly = 1;
+u8 cow_cache_enabled __read_mostly = 1;
 
 static struct dentry *snapshot_debug;
 static struct dentry *snapshot_version;
 static struct dentry *snapshot_test[SNAPSHOT_TESTS_NUM];
+static struct dentry *cow_cache;
 
 static char snapshot_version_str[] = EXT4_SNAPSHOT_VERSION;
 static struct debugfs_blob_wrapper snapshot_version_blob = {
@@ -79,6 +81,9 @@ void ext4_snapshot_create_debugfs_entry(struct dentry *debugfs_dir)
 					      S_IRUGO|S_IWUSR,
 					      debugfs_dir,
 					      &snapshot_enable_test[i]);
+	cow_cache = debugfs_create_u8("cow-cache", S_IRUGO|S_IWUSR,
+					   debugfs_dir,
+					   &cow_cache_enabled);
 }
 
 /*
@@ -89,6 +94,8 @@ void ext4_snapshot_remove_debugfs_entry(void)
 {
 	int i;
 
+	if (cow_cache)
+		debugfs_remove(cow_cache);
 	for (i = 0; i < SNAPSHOT_TESTS_NUM && i < SNAPSHOT_TEST_NAMES; i++)
 		if (snapshot_test[i])
 			debugfs_remove(snapshot_test[i]);
-- 
1.7.4.1

