From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: How to handle TIF_MEMDIE stalls?
Date: Sat, 21 Feb 2015 21:00:05 +0900
Message-ID: <201502212100.IBG78151.QLHSOMJFVOtFFO@I-love.SAKURA.ne.jp>
References: <20150219102431.GA15569@phnom.home.cmpxchg.org>
	<20150219225217.GY12722@dastard>
	<201502201936.HBH34799.SOLFFFQtHOMOJV@I-love.SAKURA.ne.jp>
	<20150220231511.GH12722@dastard>
	<20150221032000.GC7922@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: david@fromorbit.com, hannes@cmpxchg.org, mhocko@suse.cz,
	dchinner@redhat.com, linux-mm@kvack.org, rientjes@google.com,
	oleg@redhat.com, akpm@linux-foundation.org, mgorman@suse.de,
	torvalds@linux-foundation.org, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:39869 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbbBUMAN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 21 Feb 2015 07:00:13 -0500
In-Reply-To: <20150221032000.GC7922@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> So at this point, it seems we have two choices.  We can either revert
> 9879de7373fc, or I can add a whole lot more GFP_FAIL flags to ext4's
> memory allocations and submit them as stable bug fixes.

Can you absorb this side effect by simply adding GFP_NOFAIL to only
ext4's memory allocations? Don't you also depend on lower layers which
use GFP_NOIO?

BTW, while you are using open-coded GFP_NOFAIL retry loop for GFP_NOFS
allocation in jbd2, you are already using GFP_NOFAIL for GFP_NOFS
allocation in jbd. Failure check being there for GFP_NOFAIL seems
redundant.

---------- linux-3.19/fs/jbd2/transaction.c ----------
257 static int start_this_handle(journal_t *journal, handle_t *handle,
258                              gfp_t gfp_mask)
259 {
260         transaction_t   *transaction, *new_transaction = NULL;
261         int             blocks = handle->h_buffer_credits;
262         int             rsv_blocks = 0;
263         unsigned long ts = jiffies;
264 
265         /*
266          * 1/2 of transaction can be reserved so we can practically handle
267          * only 1/2 of maximum transaction size per operation
268          */
269         if (WARN_ON(blocks > journal->j_max_transaction_buffers / 2)) {
270                 printk(KERN_ERR "JBD2: %s wants too many credits (%d > %d)\n",
271                        current->comm, blocks,
272                        journal->j_max_transaction_buffers / 2);
273                 return -ENOSPC;
274         }
275 
276         if (handle->h_rsv_handle)
277                 rsv_blocks = handle->h_rsv_handle->h_buffer_credits;
278 
279 alloc_transaction:
280         if (!journal->j_running_transaction) {
281                 new_transaction = kmem_cache_zalloc(transaction_cache,
282                                                     gfp_mask);
283                 if (!new_transaction) {
284                         /*
285                          * If __GFP_FS is not present, then we may be
286                          * being called from inside the fs writeback
287                          * layer, so we MUST NOT fail.  Since
288                          * __GFP_NOFAIL is going away, we will arrange
289                          * to retry the allocation ourselves.
290                          */
291                         if ((gfp_mask & __GFP_FS) == 0) {
292                                 congestion_wait(BLK_RW_ASYNC, HZ/50);
293                                 goto alloc_transaction;
294                         }
295                         return -ENOMEM;
296                 }
297         }
298 
299         jbd_debug(3, "New handle %p going live.\n", handle);
---------- linux-3.19/fs/jbd2/transaction.c ----------

---------- linux-3.19/fs/jbd/transaction.c ----------
 84 static int start_this_handle(journal_t *journal, handle_t *handle)
 85 {
 86         transaction_t *transaction;
 87         int needed;
 88         int nblocks = handle->h_buffer_credits;
 89         transaction_t *new_transaction = NULL;
 90         int ret = 0;
 91 
 92         if (nblocks > journal->j_max_transaction_buffers) {
 93                 printk(KERN_ERR "JBD: %s wants too many credits (%d > %d)\n",
 94                        current->comm, nblocks,
 95                        journal->j_max_transaction_buffers);
 96                 ret = -ENOSPC;
 97                 goto out;
 98         }
 99 
100 alloc_transaction:
101         if (!journal->j_running_transaction) {
102                 new_transaction = kzalloc(sizeof(*new_transaction),
103                                                 GFP_NOFS|__GFP_NOFAIL);
104                 if (!new_transaction) {
105                         ret = -ENOMEM;
106                         goto out;
107                 }
108         }
109 
110         jbd_debug(3, "New handle %p going live.\n", handle);
---------- linux-3.19/fs/jbd/transaction.c ----------
