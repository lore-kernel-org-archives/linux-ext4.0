From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] fix race bwtween write_metadata_buffer and
	get_write_access
Date: Mon, 13 Jul 2009 10:41:29 -0400
Message-ID: <20090713144128.GA28970@mit.edu>
References: <1247132827-29614-1-git-send-email-dingdinghua85@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: dingdinghua <dingdinghua85@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42747 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756051AbZGMOlc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jul 2009 10:41:32 -0400
Content-Disposition: inline
In-Reply-To: <1247132827-29614-1-git-send-email-dingdinghua85@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 09, 2009 at 05:47:07PM +0800, dingdinghua wrote:
> At committing phase, we call jbd2_journal_write_metadata_buffer to
> prepare log block's buffer_head, in this function, new_bh->b_data is set
> to b_frozen_data or bh_in->b_data. We call "jbd_unlock_bh_state(bh_in)"
> too early, since at this point , we haven't file bh_in to BJ_shadow
> list, and we may set new_bh->b_data to bh_in->b_data, at this time,
> another thread may call get write access of bh_in, modify bh_in->b_data
> and dirty it. So , if new_bh->b_data is set to bh_in->b_data, the
> committing transaction may flush the newly modified buffer content to
> disk, preserve work done in jbd2_journal_get_write_access is useless.
> jbd also has this problem.

Hi Dingding,

I split your patch into two pieces; one for jbd2 (which is in the ext4
patch queue), and one for jbd (which is attached here).  The jbd2
patch (along with recently added patches to the ext4 patch queue) is
undergoing testing as we speak.

Both patches look good to me, but for the ext3/jbd one, it should
probably get a second opinion.  Andrew, can take a quick peek?

							- Ted

jbd: fix race bwtween write_metadata_buffer and get_write_access

From: dingdinghua <dingdinghua85@gmail.com>

The function journal_write_metadata_buffer() calls
jbd_unlock_bh_state(bh_in) too early; this could potentially allow
another thread to call get_write_access on the buffer head, modify the
data, and dirty it, and allowing the wrong data to be written into the
journal.  Fortunately, if we lose this race, the only time this will
actually cause filesystem corruption is if there is a system crash or
other unclean shutdown of the system before the next commit can take
place.

Signed-off-by: dingdinghua <dingdinghua85@gmail.com>
Acked-by: "Theodore Ts'o" <tytso@mit.edu>
---

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 737f724..ff5dcb5 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -287,6 +287,7 @@ int journal_write_metadata_buffer(transaction_t *transaction,
 	struct page *new_page;
 	unsigned int new_offset;
 	struct buffer_head *bh_in = jh2bh(jh_in);
+	journal_t *journal = transaction->t_journal;
 
 	/*
 	 * The buffer really shouldn't be locked: only the current committing
@@ -300,6 +301,11 @@ int journal_write_metadata_buffer(transaction_t *transaction,
 	J_ASSERT_BH(bh_in, buffer_jbddirty(bh_in));
 
 	new_bh = alloc_buffer_head(GFP_NOFS|__GFP_NOFAIL);
+	/* keep subsequent assertions sane */
+	new_bh->b_state = 0;
+	init_buffer(new_bh, NULL, NULL);
+	atomic_set(&new_bh->b_count, 1);
+	new_jh = journal_add_journal_head(new_bh);	/* This sleeps */
 
 	/*
 	 * If a new transaction has already done a buffer copy-out, then
@@ -361,14 +367,6 @@ repeat:
 		kunmap_atomic(mapped_data, KM_USER0);
 	}
 
-	/* keep subsequent assertions sane */
-	new_bh->b_state = 0;
-	init_buffer(new_bh, NULL, NULL);
-	atomic_set(&new_bh->b_count, 1);
-	jbd_unlock_bh_state(bh_in);
-
-	new_jh = journal_add_journal_head(new_bh);	/* This sleeps */
