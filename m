From: Joe Perches <joe@perches.com>
Subject: [PATCH] - [5/15] - remove defconfig ptr comparisons to 0 - fs/jbd2
Date: Tue, 13 Nov 2007 18:05:09 -0800
Message-ID: <1195005909.5163.91.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Stephen Tweedie <sct@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:4755 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758432AbXKNCFJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 13 Nov 2007 21:05:09 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Remove defconfig ptr comparison to 0

Remove sparse warning: Using plain integer as NULL pointer

Signed-off-by: Joe Perches <joe@perches.com>

---

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 6ddc553..ca74850 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -218,7 +218,7 @@ static int jbd2_journal_start_thread(journal_t *journal)
 	if (IS_ERR(t))
 		return PTR_ERR(t);
 
-	wait_event(journal->j_wait_done_commit, journal->j_task != 0);
+	wait_event(journal->j_wait_done_commit, journal->j_task);
 	return 0;
 }
 
@@ -230,7 +230,7 @@ static void journal_kill_thread(journal_t *journal)
 	while (journal->j_task) {
 		wake_up(&journal->j_wait_commit);
 		spin_unlock(&journal->j_state_lock);
-		wait_event(journal->j_wait_done_commit, journal->j_task == 0);
+		wait_event(journal->j_wait_done_commit, !journal->j_task);
 		spin_lock(&journal->j_state_lock);
 	}
 	spin_unlock(&journal->j_state_lock);
@@ -1629,14 +1629,14 @@ static int journal_init_jbd2_journal_head_cache(void)
 {
 	int retval;
 
-	J_ASSERT(jbd2_journal_head_cache == 0);
+	J_ASSERT(!jbd2_journal_head_cache);
 	jbd2_journal_head_cache = kmem_cache_create("jbd2_journal_head",
 				sizeof(struct journal_head),
 				0,		/* offset */
 				0,		/* flags */
 				NULL);		/* ctor */
 	retval = 0;
-	if (jbd2_journal_head_cache == 0) {
+	if (!jbd2_journal_head_cache) {
 		retval = -ENOMEM;
 		printk(KERN_EMERG "JBD: no memory for journal_head cache\n");
 	}
@@ -1662,14 +1662,14 @@ static struct journal_head *journal_alloc_journal_head(void)
 	atomic_inc(&nr_journal_heads);
 #endif
 	ret = kmem_cache_alloc(jbd2_journal_head_cache, GFP_NOFS);
-	if (ret == 0) {
+	if (!ret) {
 		jbd_debug(1, "out of memory for journal_head\n");
 		if (time_after(jiffies, last_warning + 5*HZ)) {
 			printk(KERN_NOTICE "ENOMEM in %s, retrying.\n",
 			       __FUNCTION__);
 			last_warning = jiffies;
 		}
-		while (ret == 0) {
+		while (!ret) {
 			yield();
 			ret = kmem_cache_alloc(jbd2_journal_head_cache, GFP_NOFS);
 		}
diff --git a/fs/jbd2/revoke.c b/fs/jbd2/revoke.c
index 3595fd4..ec81511 100644
--- a/fs/jbd2/revoke.c
+++ b/fs/jbd2/revoke.c
@@ -172,13 +172,13 @@ int __init jbd2_journal_init_revoke_caches(void)
 	jbd2_revoke_record_cache = kmem_cache_create("jbd2_revoke_record",
 					   sizeof(struct jbd2_revoke_record_s),
 					   0, SLAB_HWCACHE_ALIGN, NULL);
-	if (jbd2_revoke_record_cache == 0)
+	if (!jbd2_revoke_record_cache)
 		return -ENOMEM;
 
 	jbd2_revoke_table_cache = kmem_cache_create("jbd2_revoke_table",
 					   sizeof(struct jbd2_revoke_table_s),
 					   0, 0, NULL);
-	if (jbd2_revoke_table_cache == 0) {
+	if (!jbd2_revoke_table_cache) {
 		kmem_cache_destroy(jbd2_revoke_record_cache);
 		jbd2_revoke_record_cache = NULL;
 		return -ENOMEM;
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index b1fcf2b..036e7ef 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1164,7 +1164,7 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 	}
 
 	/* That test should have eliminated the following case: */
-	J_ASSERT_JH(jh, jh->b_frozen_data == 0);
+	J_ASSERT_JH(jh, !jh->b_frozen_data);
 
 	JBUFFER_TRACE(jh, "file as BJ_Metadata");
 	spin_lock(&journal->j_list_lock);
@@ -1512,7 +1512,7 @@ void __jbd2_journal_temp_unlink_buffer(struct journal_head *jh)
 
 	J_ASSERT_JH(jh, jh->b_jlist < BJ_Types);
 	if (jh->b_jlist != BJ_None)
-		J_ASSERT_JH(jh, transaction != 0);
+		J_ASSERT_JH(jh, transaction);
 
 	switch (jh->b_jlist) {
 	case BJ_None:
@@ -1581,11 +1581,11 @@ __journal_try_to_free_buffer(journal_t *journal, struct buffer_head *bh)
 	if (buffer_locked(bh) || buffer_dirty(bh))
 		goto out;
 
-	if (jh->b_next_transaction != 0)
+	if (jh->b_next_transaction)
 		goto out;
 
 	spin_lock(&journal->j_list_lock);
-	if (jh->b_transaction != 0 && jh->b_cp_transaction == 0) {
+	if (jh->b_transaction && !jh->b_cp_transaction) {
 		if (jh->b_jlist == BJ_SyncData || jh->b_jlist == BJ_Locked) {
 			/* A written-back ordered data buffer */
 			JBUFFER_TRACE(jh, "release data");
@@ -1593,7 +1593,7 @@ __journal_try_to_free_buffer(journal_t *journal, struct buffer_head *bh)
 			jbd2_journal_remove_journal_head(bh);
 			__brelse(bh);
 		}
-	} else if (jh->b_cp_transaction != 0 && jh->b_transaction == 0) {
+	} else if (jh->b_cp_transaction && !jh->b_transaction) {
 		/* written-back checkpointed metadata buffer */
 		if (jh->b_jlist == BJ_None) {
 			JBUFFER_TRACE(jh, "remove from checkpoint list");
@@ -1953,7 +1953,7 @@ void __jbd2_journal_file_buffer(struct journal_head *jh,
 
 	J_ASSERT_JH(jh, jh->b_jlist < BJ_Types);
 	J_ASSERT_JH(jh, jh->b_transaction == transaction ||
-				jh->b_transaction == 0);
+				!jh->b_transaction);
 
 	if (jh->b_transaction && jh->b_jlist == jlist)
 		return;
