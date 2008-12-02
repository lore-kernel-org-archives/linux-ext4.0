From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [BUG][PATCH 3/4] jbd: fix a cause of __schedule_bug via
 blkdev_releasepage
Date: Tue, 2 Dec 2008 20:16:18 +0900
Message-ID: <20081202201618.48c53c19.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
	tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57099 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbYLBL3s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Dec 2008 06:29:48 -0500
Received: from m5.gw.fujitsu.co.jp ([10.0.50.75])
	by fgwmail6.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id mB2BTj2Q009705
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Tue, 2 Dec 2008 20:29:46 +0900
Received: from smail (m5 [127.0.0.1])
	by outgoing.m5.gw.fujitsu.co.jp (Postfix) with ESMTP id B09E545DE52
	for <linux-ext4@vger.kernel.org>; Tue,  2 Dec 2008 20:29:45 +0900 (JST)
Received: from s5.gw.fujitsu.co.jp (s5.gw.fujitsu.co.jp [10.0.50.95])
	by m5.gw.fujitsu.co.jp (Postfix) with ESMTP id 8FD0445DE3A
	for <linux-ext4@vger.kernel.org>; Tue,  2 Dec 2008 20:29:45 +0900 (JST)
Received: from s5.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s5.gw.fujitsu.co.jp (Postfix) with ESMTP id 736C21DB8041
	for <linux-ext4@vger.kernel.org>; Tue,  2 Dec 2008 20:29:45 +0900 (JST)
Received: from m108.s.css.fujitsu.com (m108.s.css.fujitsu.com [10.249.87.108])
	by s5.gw.fujitsu.co.jp (Postfix) with ESMTP id 23F9E1DB803F
	for <linux-ext4@vger.kernel.org>; Tue,  2 Dec 2008 20:29:45 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

jbd: fix a cause of __schedule_bug via blkdev_releasepage
From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>

A cause of this problem is calling log_wait_commit() on 
journal_try_to_free_buffers() with a read-lock via blkdev_releasepage(). This 
logic is for uncommitted data buffers. And a read/write-lock is required for a 
client usage of blkdev_releasepage.

By the way, we want to release only metadata buffers on ext3_release_metadata().
Because a page which binds to blkdev is used as metadata for ext3.

Therefore we don't need to wait for a commit on journal_try_to_free_buffers() 
via ext3_release_matadata().
As a result, we add a journal_try_to_free_metadata_buffers() almost same 
as journal_try_to_free_buffers() except not calling log_wait_commit.

This issue was reported by Aneesh Kumar K.V.
http://marc.info/?l=linux-ext4&m=122814568309893&w=2

Reported-by: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com> 
Cc: "Theodore Ts'o" <tytso@mit.edu>
--
 fs/jbd/journal.c     |    1 +
 fs/jbd/transaction.c |   34 ++++++++++++++++++++++++++++++----
 include/linux/jbd.h  |    1 +
 3 files changed, 32 insertions(+), 4 deletions(-)

diff -Nurp linux-2.6.28-rc6/fs/jbd/journal.c linux-2.6.28-rc6.2/fs/jbd/journal.c
--- linux-2.6.28-rc6/fs/jbd/journal.c	2008-11-21 08:19:22.000000000 +0900
+++ linux-2.6.28-rc6.2/fs/jbd/journal.c	2008-12-02 09:54:26.000000000 +0900
@@ -79,6 +79,7 @@ EXPORT_SYMBOL(journal_wipe);
 EXPORT_SYMBOL(journal_blocks_per_page);
 EXPORT_SYMBOL(journal_invalidatepage);
 EXPORT_SYMBOL(journal_try_to_free_buffers);
+EXPORT_SYMBOL(journal_try_to_free_metadata_buffers);
 EXPORT_SYMBOL(journal_force_commit);
 
 static int journal_convert_superblock_v1(journal_t *, journal_superblock_t *);
diff -Nurp linux-2.6.28-rc6/fs/jbd/transaction.c linux-2.6.28-rc6.2/fs/jbd/transaction.c
--- linux-2.6.28-rc6/fs/jbd/transaction.c	2008-11-21 08:19:22.000000000 +0900
+++ linux-2.6.28-rc6.2/fs/jbd/transaction.c	2008-12-02 10:21:45.000000000 +0900
@@ -1687,12 +1687,14 @@ static void journal_wait_for_transaction
 }
 
 /**
- * int journal_try_to_free_buffers() - try to free page buffers.
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
@@ -1718,14 +1720,14 @@ static void journal_wait_for_transaction
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
-int journal_try_to_free_buffers(journal_t *journal,
-				struct page *page, gfp_t gfp_mask)
+static int __journal_try_to_free_buffers(journal_t *journal,
+			struct page *page, gfp_t gfp_mask, bool is_metadata)
 {
 	struct buffer_head *head;
 	struct buffer_head *bh;
@@ -1756,6 +1758,8 @@ int journal_try_to_free_buffers(journal_
 	} while ((bh = bh->b_this_page) != head);
 
 	ret = try_to_free_buffers(page);
+	if (is_metadata)
+		return ret;
 
 	/*
 	 * There are a number of places where journal_try_to_free_buffers()
@@ -1781,6 +1785,28 @@ busy:
 }
 
 /*
+ * journal_try_to_free_buffers:
+ * This is a wrapper function for __journal_try_to_free_buffers to try to 
+ * release data.
+ */
+int journal_try_to_free_buffers(journal_t *journal,
+				struct page *page, gfp_t gfp_mask)
+{
+	return __journal_try_to_free_buffers(journal, page, gfp_mask, false);
+}
+
+/*
+ * journal_try_to_free_metadata_buffers:
+ * This is a wrapper function for __journal_try_to_free_buffers to try to 
+ * release metadata.
+ */
+int journal_try_to_free_metadata_buffers(journal_t *journal,
+				struct page *page, gfp_t gfp_mask)
+{
+	return __journal_try_to_free_buffers(journal, page, gfp_mask, true);
+}
+
+/*
  * This buffer is no longer needed.  If it is on an older transaction's
  * checkpoint list we need to record it on this transaction's forget list
  * to pin this buffer (and hence its checkpointing transaction) down until
diff -Nurp linux-2.6.28-rc6/include/linux/jbd.h linux-2.6.28-rc6.2/include/linux/jbd.h
--- linux-2.6.28-rc6/include/linux/jbd.h	2008-11-21 08:19:22.000000000 +0900
+++ linux-2.6.28-rc6.2/include/linux/jbd.h	2008-12-02 09:58:59.000000000 +0900
@@ -893,6 +893,7 @@ extern void	 journal_sync_buffer (struct
 extern void	 journal_invalidatepage(journal_t *,
 				struct page *, unsigned long);
 extern int	 journal_try_to_free_buffers(journal_t *, struct page *, gfp_t);
+extern int	 journal_try_to_free_metadata_buffers(journal_t *, struct page *, gfp_t);
 extern int	 journal_stop(handle_t *);
 extern int	 journal_flush (journal_t *);
 extern void	 journal_lock_updates (journal_t *);
