From: Theodore Tso <tytso@mit.edu>
Subject: Re: [BUG][PATCH 1/4] ext3: fix a cause of __schedule_bug via
	blkdev_releasepage
Date: Mon, 8 Dec 2008 09:01:38 -0500
Message-ID: <20081208140138.GA17700@mit.edu>
References: <20081202200647.72cc5807.toshi.okajima@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: aneesh.kumar@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
	linux-ext4@vger.kernel.org
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:47327 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751775AbYLHOBq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Dec 2008 09:01:46 -0500
Content-Disposition: inline
In-Reply-To: <20081202200647.72cc5807.toshi.okajima@jp.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Toshiyuki-san,

My apologies for not having a chance to review your patches; things
have been rather busy for me.  There were a couple of shortcomings in
your patch series, and I think there is a better way of solving the
issue at hand.  First of all, patches #1 and #2 use a new function
which is not actually defined until patches #3 and #4, respectively.
This can make it difficult for people who are trying to use "git
bisect" to try to localize the root cause of a problem.

Secondly, the introduction of a large number of wrapper functions
increases stack utilization, and makes the call depth deeper (and in
the long run, each increase in call depth makes the code that much
harder to trace through and understand), and so it should be done only
as last resort.  Fortunately, there is a simpler way of fixing this
problem.  I include the inter-diff below, but I will fold this into
the current blkdev_releasepage() patches that are in the ext4 patch
queue.

Best regards,

					- Ted

P.S.  Note that this patch is functionally identical to what you
proposed in your patch series, but since the gfp_wait mask already
controlls whether or not log_wait_commit() is called, instead of
introducing a new functional parameter, we just mask off __GFP_WAIT
before calling jbd2_journal_try_to_free_buffers.  I'll make a similar
change to the ext3 patch, and attach the two revised patches to this
mail thread.

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e77a059..543f3d0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3049,6 +3049,12 @@ static int ext4_releasepage(struct page *page, gfp_t wait)
  * mapped via the block device.  Since these pages could have journal heads
  * which would prevent try_to_free_buffers() from freeing them, we must use
  * jbd2 layer's try_to_free_buffers() function to release them.
+ *
+ * Note: we have to strip the __GFP_WAIT flag before calling
+ * jbd2_journal_try_to_free_buffers because blkdev_releasepage is
+ * called while holding a spinlock (bdev_inode.client_lock).
+ * Fortunately the metadata buffers we are interested are freed right
+ * away and do not require calling journal_wait_for_transaction_sync_data().
  */
 int ext4_release_metadata(void *client, struct page *page, gfp_t wait)
 {
@@ -3061,7 +3067,8 @@ int ext4_release_metadata(void *client, struct page *page, gfp_t wait)
 	BUG_ON(EXT4_SB(sb) == NULL);
 	journal = EXT4_SB(sb)->s_journal;
 	if (journal != NULL)
-		return jbd2_journal_try_to_free_buffers(journal, page, wait);
+		return jbd2_journal_try_to_free_buffers(journal, page,
+							wait & ~__GFP_WAIT);
 	else
 		return try_to_free_buffers(page);
 }
