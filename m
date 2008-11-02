From: Sami Liedes <sliedes@cc.hut.fi>
Subject: [PATCH] jbd2: deregister proc on failure in jbd2_journal_init_inode
Date: Sun, 2 Nov 2008 21:58:57 +0200
Message-ID: <20081102195857.GM5994@lh.kyla.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: sct@redhat.com, akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-1.hut.fi ([130.233.228.91]:59928 "EHLO smtp-1.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722AbYKBUAP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 2 Nov 2008 15:00:15 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

jbd2_journal_init_inode() does not call jbd2_stats_proc_exit() on all
failure paths after calling jbd2_stats_proc_init(). This leaves
dangling references to the fs in proc.

This patch fixes bug #11493.

Signed-off-by: Sami Liedes <sliedes@cc.hut.fi>

---

I hope this is correct. I don't understand the code very well, but I
did test my patch and it seems to fix the problem. Please don't hit me
too hard, this is the first kernel patch I have ever submitted.

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 783de11..e70d657 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1089,6 +1089,7 @@ journal_t * jbd2_journal_init_inode (struct inode *inode)
 	if (!journal->j_wbuf) {
 		printk(KERN_ERR "%s: Cant allocate bhs for commit thread\n",
 			__func__);
+		jbd2_stats_proc_exit(journal);
 		kfree(journal);
 		return NULL;
 	}
@@ -1098,6 +1099,7 @@ journal_t * jbd2_journal_init_inode (struct inode *inode)
 	if (err) {
 		printk(KERN_ERR "%s: Cannnot locate journal superblock\n",
 		       __func__);
+		jbd2_stats_proc_exit(journal);
 		kfree(journal);
 		return NULL;
 	}
