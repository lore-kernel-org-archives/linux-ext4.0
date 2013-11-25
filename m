From: Jan Kara <jack@suse.cz>
Subject: [PATCH] jbd: Revise KERN_EMERG error messages
Date: Mon, 25 Nov 2013 23:59:16 +0100
Message-ID: <1385420357-30944-1-git-send-email-jack@suse.cz>
Cc: Lubomir Rintel <lkundrak@v3.sk>, Ted Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab3KYW7d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Nov 2013 17:59:33 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Some of KERN_EMERG printk messages do not really deserve this log level
and the one in log_wait_commit() is even rather useless (the journal has
been previously aborted and *that* is where we should have been
complaining). So make some messages just KERN_ERR and remove the useless
message.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd/journal.c     | 8 +++-----
 fs/jbd/transaction.c | 4 ++--
 2 files changed, 5 insertions(+), 7 deletions(-)

 I plan to add this patch to my tree unless someone objects.

								Honza

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 2d04f9afafd7..06fe11e0abfa 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -573,7 +573,7 @@ int log_wait_commit(journal_t *journal, tid_t tid)
 #ifdef CONFIG_JBD_DEBUG
 	spin_lock(&journal->j_state_lock);
 	if (!tid_geq(journal->j_commit_request, tid)) {
-		printk(KERN_EMERG
+		printk(KERN_ERR
 		       "%s: error: j_commit_request=%d, tid=%d\n",
 		       __func__, journal->j_commit_request, tid);
 	}
@@ -604,10 +604,8 @@ int log_wait_commit(journal_t *journal, tid_t tid)
 out_unlock:
 	spin_unlock(&journal->j_state_lock);
 
-	if (unlikely(is_journal_aborted(journal))) {
-		printk(KERN_EMERG "journal commit I/O error\n");
+	if (unlikely(is_journal_aborted(journal)))
 		err = -EIO;
-	}
 	return err;
 }
 
@@ -2136,7 +2134,7 @@ static void __exit journal_exit(void)
 #ifdef CONFIG_JBD_DEBUG
 	int n = atomic_read(&nr_journal_heads);
 	if (n)
-		printk(KERN_EMERG "JBD: leaked %d journal_heads!\n", n);
+		printk(KERN_ERR "JBD: leaked %d journal_heads!\n", n);
 #endif
 	jbd_remove_debugfs_entry();
 	journal_destroy_caches();
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index aa603e017d22..1695ba8334a2 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -675,7 +675,7 @@ repeat:
 					jbd_alloc(jh2bh(jh)->b_size,
 							 GFP_NOFS);
 				if (!frozen_buffer) {
-					printk(KERN_EMERG
+					printk(KERN_ERR
 					       "%s: OOM for frozen_buffer\n",
 					       __func__);
 					JBUFFER_TRACE(jh, "oom!");
@@ -898,7 +898,7 @@ repeat:
 	if (!jh->b_committed_data) {
 		committed_data = jbd_alloc(jh2bh(jh)->b_size, GFP_NOFS);
 		if (!committed_data) {
-			printk(KERN_EMERG "%s: No memory for committed data\n",
+			printk(KERN_ERR "%s: No memory for committed data\n",
 				__func__);
 			err = -ENOMEM;
 			goto out;
-- 
1.8.1.4

