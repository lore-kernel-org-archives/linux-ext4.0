From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] JBD: release checkpoint journal heads through
 try_to_release_page when the memory is exhausted
Date: Thu, 23 Oct 2008 17:41:01 +0900
Message-ID: <20081023174101.85b59177.toshi.okajima@jp.fujitsu.com>
References: <20081017.223716.147444348.00960188@stratos.soft.fujitsu.com>
	<20081020160249.ff41f762.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, sct@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36040 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYJWIpV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Oct 2008 04:45:21 -0400
Received: from m5.gw.fujitsu.co.jp ([10.0.50.75])
	by fgwmail7.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id m9N8jJNc027465
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Thu, 23 Oct 2008 17:45:19 +0900
Received: from smail (m5 [127.0.0.1])
	by outgoing.m5.gw.fujitsu.co.jp (Postfix) with ESMTP id CF52E2AC02B
	for <linux-ext4@vger.kernel.org>; Thu, 23 Oct 2008 17:45:18 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m5.gw.fujitsu.co.jp (Postfix) with ESMTP id 97C3212C048
	for <linux-ext4@vger.kernel.org>; Thu, 23 Oct 2008 17:45:18 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 739D81DB8049
	for <linux-ext4@vger.kernel.org>; Thu, 23 Oct 2008 17:45:18 +0900 (JST)
Received: from ml13.s.css.fujitsu.com (ml13.s.css.fujitsu.com [10.249.87.103])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 1C84D1DB803F
	for <linux-ext4@vger.kernel.org>; Thu, 23 Oct 2008 17:45:18 +0900 (JST)
In-Reply-To: <20081020160249.ff41f762.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andrew.

> > rather costly.  An alternative might be to implement a shrinker
> > callback function for the journal_head slab cache.  Did you consider
> > this?
> Yes.
> But the unused-list and counters are required by managing the shrink targets("journal head") 
> if we implement a shrinker. 
> I thought that comparatively big code changes were necessary for jbd to accomplish it. 

> However I will try it. 

I managed to build a shrinker callback function for the journal_head slab cache.
This code size is less than before but the logic of it seems to be more complex
 than before.
However, I haven't got any troubles while I am testing some easy load operations
on the fixed kernel.
But I think a system may hang up if concurrently several journal_head shrinker 
are executed.
So, I will retry to build more appropriate fix.

Please give me comments if you have a nicer idea.

------------------------------------------------------------------------------
The direct data blocks can be released by the member function, releasepage()
of their mapping.
(They have the mapping of their filesystem i-node.)

On the other hand, the indirect data blocks (ext3) are attempted to be released 
by try_to_free_buffers().
Because its mapping is a block device, and a block device doesn't have 
own a member function to release a page. 

But try_to_free_buffers() is a generic function which releases a buffer_head, 
and no buffer_head can be released if a buffer_head has private data 
(like journal_head) because the buffer_head reference counter is bigger than 0.
Therefore, a buffer_head cannot be released by try_to_free_buffers() even if 
its private data can be released.
As a result, oom-killer may happen when a system memory is exhausted even if 
a lot of private data can be released.

To solve this situation, a shrinker of journal_heads is required.
A shrinker was made by referring to logics such as shrink_icache_memory. 
In order to shrink journal_heads, it is necessary to manage a list of 
journal_heads which are required to be checkpointed all over the filesystems
 with jbd. 

Timing from which the newly additional list is operated:
- when a journal_head is registered into a checkpoint list. It is also 
 registered into an overall checkpoint list (newly additional list).
- when a journal_head is removed from a checkpoint list. It is also removed 
 from an overall checkpoint list (newly additional list).
- while a shrinker is working.

A shrinker scans only a necessary number of journal_heads which are connected
 from a new list, and releases ones if possible.

Therefore it becomes difficult for oom-killer to happen than before.

Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/jbd/checkpoint.c          |   77 +++++++++++++++++++++++++++++++++++++++++++
 fs/jbd/journal.c             |    2 +
 include/linux/journal-head.h |    7 +++
 3 files changed, 86 insertions(+)

diff -Nurp linux-2.6.27.1.org/fs/jbd/checkpoint.c linux-2.6.27.1/fs/jbd/checkpoint.c
--- linux-2.6.27.1.org/fs/jbd/checkpoint.c	2008-10-16 08:02:53.000000000 +0900
+++ linux-2.6.27.1/fs/jbd/checkpoint.c	2008-10-23 15:07:14.000000000 +0900
@@ -24,6 +24,14 @@
 #include <linux/slab.h>
 
 /*
+ * Used for shrinking journal_heads whose I/O are completed
+ */
+static DEFINE_SPINLOCK(jbd_global_lock);
+static LIST_HEAD(jbd_checkpoint_list);
+static int jbd_jh_cache_pressure = 10;
+static int jbd_nr_checkpoint_jh = 0;
+
+/*
  * Unlink a buffer from a transaction checkpoint list.
  *
  * Called with j_list_lock held.
@@ -595,6 +603,10 @@ int __journal_remove_checkpoint(struct j
 
 	__buffer_unlink(jh);
 	jh->b_cp_transaction = NULL;
+	spin_lock(&jbd_global_lock);
+	list_del_init(&jh->b_checkpoint_list);
+	jbd_nr_checkpoint_jh--;
+	spin_unlock(&jbd_global_lock);
 
 	if (transaction->t_checkpoint_list != NULL ||
 	    transaction->t_checkpoint_io_list != NULL)
@@ -655,8 +667,73 @@ void __journal_insert_checkpoint(struct 
 		jh->b_cpnext->b_cpprev = jh;
 	}
 	transaction->t_checkpoint_list = jh;
+	spin_lock(&jbd_global_lock);
+	list_add(&jh->b_checkpoint_list, &jbd_checkpoint_list);
+	jbd_nr_checkpoint_jh++;
+	spin_unlock(&jbd_global_lock);
+}
+
+static void try_to_free_cp_buf(journal_t *journal, transaction_t *transaction, struct journal_head *jh)
+{
+	transaction_t *transaction2;
+
+	spin_lock(&journal->j_list_lock);
+	if (!list_empty(&jh->b_checkpoint_list)) {
+		transaction2 = jh->b_cp_transaction;
+		BUG_ON(transaction2 == NULL);
+		if (transaction == transaction2) {
+			jbd_lock_bh_state(jh2bh(jh));
+			__try_to_free_cp_buf(jh);
+		}
+	}
+	spin_unlock(&journal->j_list_lock);
 }
 
+static void prune_jbd_jhcache(int nr)
+{
+	struct journal_head *jh;
+	struct list_head *tmp;
+	journal_t *journal;
+	transaction_t *transaction;
+
+	BUG_ON(nr < 0);
+	for (; nr; nr--) {
+		spin_lock(&jbd_global_lock);
+		if ((tmp = jbd_checkpoint_list.prev) == &jbd_checkpoint_list) {
+			spin_unlock(&jbd_global_lock);
+			break;
+		}
+		list_move(tmp, &jbd_checkpoint_list);
+		jh = list_entry(tmp, struct journal_head, b_checkpoint_list);
+		/* Protect a jh from being removed while operating */
+		journal_grab_journal_head(jh2bh(jh));
+		transaction = jh->b_cp_transaction;
+		BUG_ON(transaction == NULL);
+		journal = transaction->t_journal;
+		spin_unlock(&jbd_global_lock);
+		/* Releasing a jh from checkpoint list if possible */
+		try_to_free_cp_buf(journal, transaction, jh);
+		/* For previous count up (actually releasing a jh here) */
+		journal_put_journal_head(jh);
+		cond_resched();
+	}
+}
+
+static int shrink_jbd_jhcache_memory(int nr, gfp_t gfp_mask)
+{
+	if (nr) {
+		if (!(gfp_mask & __GFP_FS))
+			return -1;
+                prune_jbd_jhcache(nr);
+	}
+        return (jbd_nr_checkpoint_jh*100)/jbd_jh_cache_pressure;
+}
+
+struct shrinker jbd_jh_shrinker = {
+        .shrink = shrink_jbd_jhcache_memory,
+        .seeks = DEFAULT_SEEKS,
+};
+
 /*
  * We've finished with this transaction structure: adios...
  *
diff -Nurp linux-2.6.27.1.org/fs/jbd/journal.c linux-2.6.27.1/fs/jbd/journal.c
--- linux-2.6.27.1.org/fs/jbd/journal.c	2008-10-16 08:02:53.000000000 +0900
+++ linux-2.6.27.1/fs/jbd/journal.c	2008-10-23 15:00:44.000000000 +0900
@@ -1890,6 +1890,7 @@ static inline void jbd_remove_debugfs_en
 
 #endif
 
+extern struct shrinker jbd_jh_shrinker;
 struct kmem_cache *jbd_handle_cache;
 
 static int __init journal_init_handle_cache(void)
@@ -1903,6 +1904,7 @@ static int __init journal_init_handle_ca
 		printk(KERN_EMERG "JBD: failed to create handle cache\n");
 		return -ENOMEM;
 	}
+	register_shrinker(&jbd_jh_shrinker);
 	return 0;
 }
 
diff -Nurp linux-2.6.27.1.org/include/linux/journal-head.h linux-2.6.27.1/include/linux/journal-head.h
--- linux-2.6.27.1.org/include/linux/journal-head.h	2008-10-16 08:02:53.000000000 +0900
+++ linux-2.6.27.1/include/linux/journal-head.h	2008-10-23 15:00:44.000000000 +0900
@@ -87,6 +87,13 @@ struct journal_head {
 	 * [j_list_lock]
 	 */
 	struct journal_head *b_cpnext, *b_cpprev;
+
+	/*
+	 * Checkpoint journal head list
+	 * all over filesystems with jbd in order to shrink.
+	 * [jbd_global_lock]
+	 */
+	struct list_head b_checkpoint_list;
 };
 
 #endif		/* JOURNAL_HEAD_H_INCLUDED */
