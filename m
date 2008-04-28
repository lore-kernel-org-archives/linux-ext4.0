From: akpm@linux-foundation.org
Subject: [patch 282/307] jbd: replace remaining __FUNCTION__ occurrences
Date: Mon, 28 Apr 2008 02:16:16 -0700
Message-ID: <200804280916.m3S9GGuQ019188@imap1.linux-foundation.org>
Cc: akpm@linux-foundation.org, harvey.harrison@gmail.com,
	linux-ext4@vger.kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079AbYD1JQp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Apr 2008 05:16:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd/journal.c     |   18 +++++++++---------
 fs/jbd/revoke.c      |    2 +-
 fs/jbd/transaction.c |    4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff -puN fs/jbd/journal.c~jbd-replace-remaining-__function__-occurrences fs/jbd/journal.c
--- a/fs/jbd/journal.c~jbd-replace-remaining-__function__-occurrences
+++ a/fs/jbd/journal.c
@@ -534,7 +534,7 @@ int log_wait_commit(journal_t *journal, 
 	if (!tid_geq(journal->j_commit_request, tid)) {
 		printk(KERN_EMERG
 		       "%s: error: j_commit_request=%d, tid=%d\n",
-		       __FUNCTION__, journal->j_commit_request, tid);
+		       __func__, journal->j_commit_request, tid);
 	}
 	spin_unlock(&journal->j_state_lock);
 #endif
@@ -599,7 +599,7 @@ int journal_bmap(journal_t *journal, uns
 
 			printk(KERN_ALERT "%s: journal block not found "
 					"at offset %lu on %s\n",
-				__FUNCTION__,
+				__func__,
 				blocknr,
 				bdevname(journal->j_dev, b));
 			err = -EIO;
@@ -728,7 +728,7 @@ journal_t * journal_init_dev(struct bloc
 	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_KERNEL);
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
-			__FUNCTION__);
+			__func__);
 		kfree(journal);
 		journal = NULL;
 		goto out;
@@ -782,7 +782,7 @@ journal_t * journal_init_inode (struct i
 	journal->j_wbuf = kmalloc(n * sizeof(struct buffer_head*), GFP_KERNEL);
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
-			__FUNCTION__);
+			__func__);
 		kfree(journal);
 		return NULL;
 	}
@@ -791,7 +791,7 @@ journal_t * journal_init_inode (struct i
 	/* If that failed, give up */
 	if (err) {
 		printk(KERN_ERR "%s: Cannnot locate journal superblock\n",
-		       __FUNCTION__);
+		       __func__);
 		kfree(journal);
 		return NULL;
 	}
@@ -877,7 +877,7 @@ int journal_create(journal_t *journal)
 		 */
 		printk(KERN_EMERG
 		       "%s: creation of journal on external device!\n",
-		       __FUNCTION__);
+		       __func__);
 		BUG();
 	}
 
@@ -1657,7 +1657,7 @@ static struct journal_head *journal_allo
 		jbd_debug(1, "out of memory for journal_head\n");
 		if (time_after(jiffies, last_warning + 5*HZ)) {
 			printk(KERN_NOTICE "ENOMEM in %s, retrying.\n",
-			       __FUNCTION__);
+			       __func__);
 			last_warning = jiffies;
 		}
 		while (ret == NULL) {
@@ -1794,13 +1794,13 @@ static void __journal_remove_journal_hea
 			if (jh->b_frozen_data) {
 				printk(KERN_WARNING "%s: freeing "
 						"b_frozen_data\n",
-						__FUNCTION__);
+						__func__);
 				jbd_free(jh->b_frozen_data, bh->b_size);
 			}
 			if (jh->b_committed_data) {
 				printk(KERN_WARNING "%s: freeing "
 						"b_committed_data\n",
-						__FUNCTION__);
+						__func__);
 				jbd_free(jh->b_committed_data, bh->b_size);
 			}
 			bh->b_private = NULL;
diff -puN fs/jbd/revoke.c~jbd-replace-remaining-__function__-occurrences fs/jbd/revoke.c
--- a/fs/jbd/revoke.c~jbd-replace-remaining-__function__-occurrences
+++ a/fs/jbd/revoke.c
@@ -138,7 +138,7 @@ repeat:
 oom:
 	if (!journal_oom_retry)
 		return -ENOMEM;
-	jbd_debug(1, "ENOMEM in %s, retrying\n", __FUNCTION__);
+	jbd_debug(1, "ENOMEM in %s, retrying\n", __func__);
 	yield();
 	goto repeat;
 }
diff -puN fs/jbd/transaction.c~jbd-replace-remaining-__function__-occurrences fs/jbd/transaction.c
--- a/fs/jbd/transaction.c~jbd-replace-remaining-__function__-occurrences
+++ a/fs/jbd/transaction.c
@@ -687,7 +687,7 @@ repeat:
 				if (!frozen_buffer) {
 					printk(KERN_EMERG
 					       "%s: OOM for frozen_buffer\n",
-					       __FUNCTION__);
+					       __func__);
 					JBUFFER_TRACE(jh, "oom!");
 					error = -ENOMEM;
 					jbd_lock_bh_state(bh);
@@ -904,7 +904,7 @@ repeat:
 		committed_data = jbd_alloc(jh2bh(jh)->b_size, GFP_NOFS);
 		if (!committed_data) {
 			printk(KERN_EMERG "%s: No memory for committed data\n",
-				__FUNCTION__);
+				__func__);
 			err = -ENOMEM;
 			goto out;
 		}
_
