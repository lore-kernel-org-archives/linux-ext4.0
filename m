From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [BUG][PATCH 4/4] jbd2: fix a cause of __schedule_bug via
 blkdev_releasepage
Date: Tue, 2 Dec 2008 20:18:03 +0900
Message-ID: <20081202201803.5719e617.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
	tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34683 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbYLBLbd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Dec 2008 06:31:33 -0500
Received: from m5.gw.fujitsu.co.jp ([10.0.50.75])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id mB2BVVTJ006908
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Tue, 2 Dec 2008 20:31:31 +0900
Received: from smail (m5 [127.0.0.1])
	by outgoing.m5.gw.fujitsu.co.jp (Postfix) with ESMTP id 03A3445DE52
	for <linux-ext4@vger.kernel.org>; Tue,  2 Dec 2008 20:31:31 +0900 (JST)
Received: from s5.gw.fujitsu.co.jp (s5.gw.fujitsu.co.jp [10.0.50.95])
	by m5.gw.fujitsu.co.jp (Postfix) with ESMTP id D310845DE51
	for <linux-ext4@vger.kernel.org>; Tue,  2 Dec 2008 20:31:30 +0900 (JST)
Received: from s5.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s5.gw.fujitsu.co.jp (Postfix) with ESMTP id B17D4E08003
	for <linux-ext4@vger.kernel.org>; Tue,  2 Dec 2008 20:31:30 +0900 (JST)
Received: from m105.s.css.fujitsu.com (m105.s.css.fujitsu.com [10.249.87.105])
	by s5.gw.fujitsu.co.jp (Postfix) with ESMTP id 594771DB8040
	for <linux-ext4@vger.kernel.org>; Tue,  2 Dec 2008 20:31:30 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

jbd2: fix a cause of __schedule_bug via blkdev_releasepage
From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

A cause of this problem is calling jbd2_log_wait_commit() on 
jbd2_journal_try_to_free_buffers() with a read-lock via blkdev_releasepage(). 
This logic is for uncommitted data buffers. And a read/write-lock is required 
for a client usage of blkdev_releasepage.

By the way, we want to release only metadata buffers on ext4_release_metadata().
Because a page which binds to blkdev is used as metadata for ext4.

Therefore we don't need to wait for a commit on 
jbd2_journal_try_to_free_buffers() via ext4_release_matadata().
As a result, we add a jbd2_journal_try_to_free_metadata_buffers() almost same 
as jbd2_journal_try_to_free_buffers() except not calling jbd2_log_wait_commit().

This issue was reported by Aneesh Kumar K.V.
http://marc.info/?l=linux-ext4&m=122814568309893&w=2

Reported-by: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com> 
Cc: "Theodore Ts'o" <tytso@mit.edu>
--
 fs/jbd2/journal.c     |    1 +
 fs/jbd2/transaction.c |   34 ++++++++++++++++++++++++++++++----
 include/linux/jbd2.h  |    1 +
 3 files changed, 32 insertions(+), 4 deletions(-)

diff -Nurp linux-2.6.28-rc6/fs/jbd2/journal.c linux-2.6.28-rc6.2/fs/jbd2/journal.c
--- linux-2.6.28-rc6/fs/jbd2/journal.c	2008-11-21 08:19:22.000000000 +0900
+++ linux-2.6.28-rc6.2/fs/jbd2/journal.c	2008-12-02 09:54:42.000000000 +0900
@@ -79,6 +79,7 @@ EXPORT_SYMBOL(jbd2_journal_wipe);
 EXPORT_SYMBOL(jbd2_journal_blocks_per_page);
 EXPORT_SYMBOL(jbd2_journal_invalidatepage);
 EXPORT_SYMBOL(jbd2_journal_try_to_free_buffers);
+EXPORT_SYMBOL(jbd2_journal_try_to_free_metadata_buffers);
 EXPORT_SYMBOL(jbd2_journal_force_commit);
 EXPORT_SYMBOL(jbd2_journal_file_inode);
 EXPORT_SYMBOL(jbd2_journal_init_jbd_inode);
diff -Nurp linux-2.6.28-rc6/fs/jbd2/transaction.c linux-2.6.28-rc6.2/fs/jbd2/transaction.c
--- linux-2.6.28-rc6/fs/jbd2/transaction.c	2008-11-21 08:19:22.000000000 +0900
+++ linux-2.6.28-rc6.2/fs/jbd2/transaction.c	2008-12-02 10:21:53.000000000 +0900
@@ -1497,12 +1497,14 @@ static void jbd2_journal_wait_for_transa
 }
 
 /**
- * int jbd2_journal_try_to_free_buffers() - try to free page buffers.
+ * int __journal_try_to_free_buffers() - try to free page buffers.
  * @journal: journal for operation
  * @page: to try and free
  * @gfp_mask: we use the mask to detect how hard should we try to release
  * buffers. If __GFP_WAIT and __GFP_FS is set, we wait for commit code to
  * release the buffers.
+ * @is_metadata: If true, we won't wait for commit though __GFP_WAIT
+ *               and __GFP_FS is set.
  *
  *
  * For all the buffers on this page,
@@ -1528,14 +1530,14 @@ static void jbd2_journal_wait_for_transa
  *
  * Who else is affected by this?  hmm...  Really the only contender
  * is do_get_write_access() - it could be looking at the buffer while
- * journal_try_to_free_buffer() is changing its state.  But that
+ * __journal_try_to_free_buffer() is changing its state.  But that
  * cannot happen because we never reallocate freed data as metadata
  * while the data is part of a transaction.  Yes?
  *
  * Return 0 on failure, 1 on success
  */
-int jbd2_journal_try_to_free_buffers(journal_t *journal,
-				struct page *page, gfp_t gfp_mask)
+static int __journal_try_to_free_buffers(journal_t *journal,
+			struct page *page, gfp_t gfp_mask, bool is_metadata)
 {
 	struct buffer_head *head;
 	struct buffer_head *bh;
@@ -1567,6 +1569,8 @@ int jbd2_journal_try_to_free_buffers(jou
 	} while ((bh = bh->b_this_page) != head);
 
 	ret = try_to_free_buffers(page);
+	if (is_metadata)
+		return ret;
 
 	/*
 	 * There are a number of places where jbd2_journal_try_to_free_buffers()
@@ -1592,6 +1596,28 @@ busy:
 }
 
 /*
+ * jbd2_journal_try_to_free_buffers:
+ * This is a wrapper function for __journal_try_to_free_buffers to try to 
+ * release data.
+ */
+int jbd2_journal_try_to_free_buffers(journal_t *journal,
+				struct page *page, gfp_t gfp_mask)
+{
+	return __journal_try_to_free_buffers(journal, page, gfp_mask, false);
+}
+
+/*
+ * jbd2_journal_try_to_free_metadata_buffers:
+ * This is a wrapper function for __journal_try_to_free_buffers to try to 
+ * release metadata.
+ */
+int jbd2_journal_try_to_free_metadata_buffers(journal_t *journal,
+				struct page *page, gfp_t gfp_mask)
+{
+	return __journal_try_to_free_buffers(journal, page, gfp_mask, true);
+}
+
+/*
  * This buffer is no longer needed.  If it is on an older transaction's
  * checkpoint list we need to record it on this transaction's forget list
  * to pin this buffer (and hence its checkpointing transaction) down until
diff -Nurp linux-2.6.28-rc6/include/linux/jbd2.h linux-2.6.28-rc6.2/include/linux/jbd2.h
--- linux-2.6.28-rc6/include/linux/jbd2.h	2008-11-21 08:19:22.000000000 +0900
+++ linux-2.6.28-rc6.2/include/linux/jbd2.h	2008-12-02 09:59:18.000000000 +0900
@@ -1052,6 +1052,7 @@ extern void	 journal_sync_buffer (struct
 extern void	 jbd2_journal_invalidatepage(journal_t *,
 				struct page *, unsigned long);
 extern int	 jbd2_journal_try_to_free_buffers(journal_t *, struct page *, gfp_t);
+extern int	 jbd2_journal_try_to_free_metadata_buffers(journal_t *, struct page *, gfp_t);
 extern int	 jbd2_journal_stop(handle_t *);
 extern int	 jbd2_journal_flush (journal_t *);
 extern void	 jbd2_journal_lock_updates (journal_t *);
