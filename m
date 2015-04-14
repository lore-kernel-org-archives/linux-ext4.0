From: akpm@linux-foundation.org
Subject: [patch 2/2] jbd2: revert must-not-fail allocation loops back to
 GFP_NOFAIL
Date: Tue, 14 Apr 2015 13:25:33 -0700
Message-ID: <552d77bd.OzRN9bJ+CtfnkY+N%akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: tytso@mit.edu, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org, mhocko@suse.cz, davem@davemloft.net,
	david@fromorbit.com, hannes@cmpxchg.org, jack@suse.cz,
	mgorman@suse.de, penguin-kernel@I-love.SAKURA.ne.jp,
	rientjes@google.com, vipul@chelsio.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbbDNUZf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Apr 2015 16:25:35 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Michal Hocko <mhocko@suse.cz>
Subject: jbd2: revert must-not-fail allocation loops back to GFP_NOFAIL

This basically reverts 47def82672b3 ("jbd2: Remove __GFP_NOFAIL from jbd2
layer").  The deprecation of __GFP_NOFAIL was a bad choice because it led
to open coding the endless loop around the allocator rather than removing
the dependency on the non failing allocation.  So the deprecation was a
clear failure and the reality tells us that __GFP_NOFAIL is not even close
to go away.

It is still true that __GFP_NOFAIL allocations are generally discouraged
and new uses should be evaluated and an alternative (pre-allocations or
reservations) should be considered but it doesn't make any sense to lie
the allocator about the requirements.  Allocator can take steps to help
making a progress if it knows the requirements.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Vipul Pandya <vipul@chelsio.com>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/journal.c     |   11 +----------
 fs/jbd2/transaction.c |   20 +++++++-------------
 2 files changed, 8 insertions(+), 23 deletions(-)

diff -puN fs/jbd2/journal.c~jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail fs/jbd2/journal.c
--- a/fs/jbd2/journal.c~jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail
+++ a/fs/jbd2/journal.c
@@ -371,16 +371,7 @@ int jbd2_journal_write_metadata_buffer(t
 	 */
 	J_ASSERT_BH(bh_in, buffer_jbddirty(bh_in));
 
-retry_alloc:
-	new_bh = alloc_buffer_head(GFP_NOFS);
-	if (!new_bh) {
-		/*
-		 * Failure is not an option, but __GFP_NOFAIL is going
-		 * away; so we retry ourselves here.
-		 */
-		congestion_wait(BLK_RW_ASYNC, HZ/50);
-		goto retry_alloc;
-	}
+	new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
 
 	/* keep subsequent assertions sane */
 	atomic_set(&new_bh->b_count, 1);
diff -puN fs/jbd2/transaction.c~jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail fs/jbd2/transaction.c
--- a/fs/jbd2/transaction.c~jbd2-revert-must-not-fail-allocation-loops-back-to-gfp_nofail
+++ a/fs/jbd2/transaction.c
@@ -278,22 +278,16 @@ static int start_this_handle(journal_t *
 
 alloc_transaction:
 	if (!journal->j_running_transaction) {
+		/*
+		 * If __GFP_FS is not present, then we may be being called from
+		 * inside the fs writeback layer, so we MUST NOT fail.
+		 */
+		if ((gfp_mask & __GFP_FS) == 0)
+			gfp_mask |= __GFP_NOFAIL;
 		new_transaction = kmem_cache_zalloc(transaction_cache,
 						    gfp_mask);
-		if (!new_transaction) {
-			/*
-			 * If __GFP_FS is not present, then we may be
-			 * being called from inside the fs writeback
-			 * layer, so we MUST NOT fail.  Since
-			 * __GFP_NOFAIL is going away, we will arrange
-			 * to retry the allocation ourselves.
-			 */
-			if ((gfp_mask & __GFP_FS) == 0) {
-				congestion_wait(BLK_RW_ASYNC, HZ/50);
-				goto alloc_transaction;
-			}
+		if (!new_transaction)
 			return -ENOMEM;
-		}
 	}
 
 	jbd_debug(3, "New handle %p going live.\n", handle);
_
