From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: [RFC][PATCH] JBD: release checkpoint journal heads through
 try_to_release_page when the memory is exhausted
Date: Fri, 17 Oct 2008 22:37:16 +0900 (JST)
Message-ID: <20081017.223716.147444348.00960188@stratos.soft.fujitsu.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, sct@redhat.com,
	akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58931 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbYJQNkF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Oct 2008 09:40:05 -0400
Received: from m5.gw.fujitsu.co.jp ([10.0.50.75])
	by fgwmail7.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id m9HDe34r015966
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Fri, 17 Oct 2008 22:40:03 +0900
Received: from smail (m5 [127.0.0.1])
	by outgoing.m5.gw.fujitsu.co.jp (Postfix) with ESMTP id 5761B2AC026
	for <linux-ext4@vger.kernel.org>; Fri, 17 Oct 2008 22:40:03 +0900 (JST)
Received: from s5.gw.fujitsu.co.jp (s5.gw.fujitsu.co.jp [10.0.50.95])
	by m5.gw.fujitsu.co.jp (Postfix) with ESMTP id 2E56A12C045
	for <linux-ext4@vger.kernel.org>; Fri, 17 Oct 2008 22:40:03 +0900 (JST)
Received: from s5.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s5.gw.fujitsu.co.jp (Postfix) with ESMTP id F33981DB8038
	for <linux-ext4@vger.kernel.org>; Fri, 17 Oct 2008 22:40:02 +0900 (JST)
Received: from ml12.s.css.fujitsu.com (ml12.s.css.fujitsu.com [10.249.87.102])
	by s5.gw.fujitsu.co.jp (Postfix) with ESMTP id 9AF811DB8043
	for <linux-ext4@vger.kernel.org>; Fri, 17 Oct 2008 22:40:02 +0900 (JST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi.

I found the situation where OOM-Killer happens easily.
I will inform you of it. 
I tried to fix this problem to make OOM-Killer not happen easily as much as 
possible.
As a result, I made a reference patch to fix it. 

Any comments are welcome.
(The comments for making much simpler or epoch-making approach are 
very welcome.)

------------------------------------------------------------------------------

If the following is satisfied, OOM-Killer happens easily.
(1) A quarter of a summation of each total log size of all filesystems which 
   use jbd exceeds the memory size of Normal Zone.
(2) We commit a huge number of data which include many metadata to each 
   filesystem and then we stop committing data to them. 
    For example, a process creates many files whose size are huge and 
   which have a huge number of indirect blocks. Then all processes stop I/O 
   to all filesystems which use jbd.
(3) After (2), we request to get a big size memory.
(NOTE: A oom-killer can happen easily on a system whose architecture is x86. 
Because a x86 system can have only a small Normal Zone of less than 1GB.)

The reason is that jbd does not positively release journal heads(jh-s)
  even if there are many jh-s which can be released.

Releasing jh-s is only executed at the following timing:
- if free log space becomes a quarter of the total log size 
  (log_do_checkpoint())
- if a transaction begins to commit (journal_cleanup_checkpoint_list() 
 which is called by journal_commit_transaction())
(NOTE: A jh-s which corresponds to buffer heads (bh-s) which is a direct block 
      can be released at journal_try_to_free_buffers() which is called 
      by try_to_release_page())   

Therefore,  if we let filesystems do above (2), jh-s remains because 
new transaction isn't generated. 
However, when the system memory is exhausted, try_to_release_page() can be 
called, but it cannot release bh-s which are metadata (indirect blocks 
and so on).  
Because the mapping to the page is owned by a block device not a filesystem 
(ext3).

If the mapping is owned by a block device, try_to_release_page() calls 
try_to_free_buffers(). It can release generic bh, but cannot release the bh 
which is referring by the jh. Because the reference counter of the bh is 
larger than 0.
Therefore it is necessary to release the jh before the bh is released.

To achieve it, I added a new member function into buffer head structure.
The function releases the bh which correspond to a page whose mapping
is block device. And the release target of the bh has private data 
(journal head).
The function resembles journal_try_to_free_buffers().
Then I changed try_to_release_page(), which calls try_to_free_buffers()
after the new function.

As a result, I think it becomes difficult for oom-killer to happen 
than before because try_to_free_buffers() via try_to_release_page() 
which is called when the system memory is exhausted can release bh-s. 

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/buffer.c                 |   23 ++++++++++++++++++++++-
 fs/jbd/journal.c            |    7 +++++++
 fs/jbd/transaction.c        |   39 +++++++++++++++++++++++++++++++++++++++
 include/linux/buffer_head.h |    7 +++++++
 include/linux/jbd.h         |    1 +
 5 files changed, 76 insertions(+), 1 deletion(-) 

diff -Nurp linux-2.6.27-rc8.org/fs/buffer.c linux-2.6.27-rc8/fs/buffer.c
--- linux-2.6.27-rc8.org/fs/buffer.c	2008-09-30 07:24:02.000000000 +0900
+++ linux-2.6.27-rc8/fs/buffer.c	2008-10-17 08:59:37.000000000 +0900
@@ -3111,7 +3111,7 @@ failed:
 	return 0;
 }
 
-int try_to_free_buffers(struct page *page)
+static int __try_to_free_buffers(struct page *page)
 {
 	struct address_space * const mapping = page->mapping;
 	struct buffer_head *buffers_to_free = NULL;
@@ -3158,6 +3158,26 @@ out:
 	}
 	return ret;
 }
+
+int try_to_free_buffers(struct page *page)
+{
+	struct address_space * const mapping = page->mapping;
+	struct buffer_head *head, *bh;
+	const struct buffer_head_operations *bops;
+		
+	if (mapping == NULL) 
+		return __try_to_free_buffers(page);
+	bh = head = page_buffers(page);
+	do {
+		if ((bops = bh->b_ops) != NULL
+			&& !(bh->b_state & ((1 << BH_Dirty) | (1 << BH_Lock)))
+			&& atomic_read(&bh->b_count) > 0)
+			if (bops->release_buffer != NULL)
+				bops->release_buffer(bh);
+		bh = bh->b_this_page;
+	} while (bh != head);
+	return __try_to_free_buffers(page);
+}
 EXPORT_SYMBOL(try_to_free_buffers);
 
 void block_sync_page(struct page *page)
@@ -3234,6 +3254,7 @@ struct buffer_head *alloc_buffer_head(gf
 {
 	struct buffer_head *ret = kmem_cache_alloc(bh_cachep, gfp_flags);
 	if (ret) {
+		ret->b_ops = NULL;
 		INIT_LIST_HEAD(&ret->b_assoc_buffers);
 		get_cpu_var(bh_accounting).nr++;
 		recalc_bh_state();
diff -Nurp linux-2.6.27-rc8.org/fs/jbd/journal.c linux-2.6.27-rc8/fs/jbd/journal.c
--- linux-2.6.27-rc8.org/fs/jbd/journal.c	2008-09-30 07:24:02.000000000 +0900
+++ linux-2.6.27-rc8/fs/jbd/journal.c	2008-10-17 08:59:37.000000000 +0900
@@ -79,11 +79,16 @@ EXPORT_SYMBOL(journal_wipe);
 EXPORT_SYMBOL(journal_blocks_per_page);
 EXPORT_SYMBOL(journal_invalidatepage);
 EXPORT_SYMBOL(journal_try_to_free_buffers);
+EXPORT_SYMBOL(journal_try_to_free_one_buffer);
 EXPORT_SYMBOL(journal_force_commit);
 
 static int journal_convert_superblock_v1(journal_t *, journal_superblock_t *);
 static void __journal_abort_soft (journal_t *journal, int errno);
 
+static const struct buffer_head_operations jbd_bh_ops = {
+	.release_buffer = journal_try_to_free_one_buffer
+};
+
 /*
  * Helper function used to manage commit timeouts
  */
@@ -1749,6 +1754,7 @@ repeat:
 		set_buffer_jbd(bh);
 		bh->b_private = jh;
 		jh->b_bh = bh;
+		bh->b_ops = &jbd_bh_ops;
 		get_bh(bh);
 		BUFFER_TRACE(bh, "added journal_head");
 	}
@@ -1803,6 +1809,7 @@ static void __journal_remove_journal_hea
 						__func__);
 				jbd_free(jh->b_committed_data, bh->b_size);
 			}
+			bh->b_ops = NULL;
 			bh->b_private = NULL;
 			jh->b_bh = NULL;	/* debug, really */
 			clear_buffer_jbd(bh);
diff -Nurp linux-2.6.27-rc8.org/fs/jbd/transaction.c linux-2.6.27-rc8/fs/jbd/transaction.c
--- linux-2.6.27-rc8.org/fs/jbd/transaction.c	2008-09-30 07:24:02.000000000 +0900
+++ linux-2.6.27-rc8/fs/jbd/transaction.c	2008-10-17 09:11:49.000000000 +0900
@@ -1648,6 +1648,45 @@ out:
 	return;
 }
 
+void journal_try_to_free_one_buffer(struct buffer_head *bh)
+{
+	journal_t *journal;
+	struct journal_head *jh;
+	const struct buffer_head_operations *bops;
+
+	jh = journal_grab_journal_head(bh);
+	if (!jh)
+		return;
+	if (!jbd_trylock_bh_state(bh)) {
+		journal_put_journal_head(jh);
+		return;	
+	}
+	if ((bops = bh->b_ops) == NULL || bops->release_buffer == NULL)
+		goto skip;
+	if (buffer_locked(bh) || buffer_dirty(bh))
+		goto skip;
+	if (jh->b_next_transaction != NULL)
+		goto skip;
+	journal = (jh->b_cp_transaction != NULL ? jh->b_cp_transaction->t_journal: NULL);
+	if (journal != NULL) {
+		if (spin_trylock(&journal->j_list_lock)) {
+			if (jh->b_cp_transaction != NULL && jh->b_transaction == NULL) {
+				/* written-back checkpointed metadata buffer */
+				if (jh->b_jlist == BJ_None) {
+					JBUFFER_TRACE(jh, "remove from checkpoint list");
+					__journal_remove_checkpoint(jh);
+					journal_remove_journal_head(bh);
+					__brelse(bh);
+				}
+			}
+			spin_unlock(&journal->j_list_lock);
+		}
+	}
+skip:
+	journal_put_journal_head(jh);
+	jbd_unlock_bh_state(bh);
+}
+
 /*
  * journal_try_to_free_buffers() could race with journal_commit_transaction()
  * The latter might still hold the a count on buffers when inspecting
diff -Nurp linux-2.6.27-rc8.org/include/linux/buffer_head.h linux-2.6.27-rc8/include/linux/buffer_head.h
--- linux-2.6.27-rc8.org/include/linux/buffer_head.h	2008-09-30 07:24:02.000000000 +0900
+++ linux-2.6.27-rc8/include/linux/buffer_head.h	2008-10-17 08:59:37.000000000 +0900
@@ -43,6 +43,10 @@ enum bh_state_bits {
 
 #define MAX_BUF_PER_PAGE (PAGE_CACHE_SIZE / 512)
 
+struct buffer_head_operations {
+	void (*release_buffer)(struct buffer_head*);
+};
+
 struct page;
 struct buffer_head;
 struct address_space;
@@ -73,6 +77,9 @@ struct buffer_head {
 	struct address_space *b_assoc_map;	/* mapping this buffer is
 						   associated with */
 	atomic_t b_count;		/* users using this buffer_head */
+	const struct buffer_head_operations *b_ops; 
+					/* for a private buffer head
+					   to do special work */
 };
 
 /*
diff -Nurp linux-2.6.27-rc8.org/include/linux/jbd.h linux-2.6.27-rc8/include/linux/jbd.h
--- linux-2.6.27-rc8.org/include/linux/jbd.h	2008-09-30 07:24:02.000000000 +0900
+++ linux-2.6.27-rc8/include/linux/jbd.h	2008-10-17 08:59:37.000000000 +0900
@@ -890,6 +890,7 @@ extern void	 journal_sync_buffer (struct
 extern void	 journal_invalidatepage(journal_t *,
 				struct page *, unsigned long);
 extern int	 journal_try_to_free_buffers(journal_t *, struct page *, gfp_t);
+extern void	 journal_try_to_free_one_buffer(struct buffer_head *);
 extern int	 journal_stop(handle_t *);
 extern int	 journal_flush (journal_t *);
 extern void	 journal_lock_updates (journal_t *);
