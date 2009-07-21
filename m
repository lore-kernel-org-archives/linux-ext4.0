From: Jan Kara <jack@suse.cz>
Subject: [PATCH 5/5] jbd: fix race between write_metadata_buffer and get_write_access
Date: Tue, 21 Jul 2009 12:04:19 +0200
Message-ID: <1248170659-11771-6-git-send-email-jack@suse.cz>
References: <1248170659-11771-1-git-send-email-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	dingdinghua <dingdinghua85@gmail.com>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37164 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754578AbZGUKEV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Jul 2009 06:04:21 -0400
In-Reply-To: <1248170659-11771-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: dingdinghua <dingdinghua85@gmail.com>

The function journal_write_metadata_buffer() calls jbd_unlock_bh_state(bh_in)
too early; this could potentially allow another thread to call get_write_access
on the buffer head, modify the data, and dirty it, and allowing the wrong data
to be written into the journal.  Fortunately, if we lose this race, the only
time this will actually cause filesystem corruption is if there is a system
crash or other unclean shutdown of the system before the next commit can take
place.

Signed-off-by: dingdinghua <dingdinghua85@gmail.com>
Acked-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd/journal.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 94a64a1..f96f850 100644
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
