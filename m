From: Greg KH <gregkh@suse.de>
Subject: [patch 07/30] jbd: fix race in buffer processing in commit code
Date: Tue, 30 Jun 2009 16:59:51 -0700
Message-ID: <20090701000357.276381426@mini.kroah.org>
References: <20090630235944.868879272@mini.kroah.org>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
	Jan Kara <jack@suse.cz>, <linux-ext4@vger.kernel.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:34316 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759341AbZGAAaA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Jun 2009 20:30:00 -0400
Content-Disposition: inline; filename=jbd-fix-race-in-buffer-processing-in-commit-code.patch
In-Reply-To: <20090701002817.GA6156@kroah.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Kara <jack@suse.cz>

commit a61d90d75d0f9e86432c45b496b4b0fbf0fd03dc upstream.

In commit code, we scan buffers attached to a transaction.  During this
scan, we sometimes have to drop j_list_lock and then we recheck whether
the journal buffer head didn't get freed by journal_try_to_free_buffers().
 But checking for buffer_jbd(bh) isn't enough because a new journal head
could get attached to our buffer head.  So add a check whether the journal
head remained the same and whether it's still at the same transaction and
list.

This is a nasty bug and can cause problems like memory corruption (use after
free) or trigger various assertions in JBD code (observed).

Signed-off-by: Jan Kara <jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/jbd/commit.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -238,7 +238,7 @@ write_out_data:
 			spin_lock(&journal->j_list_lock);
 		}
 		/* Someone already cleaned up the buffer? */
-		if (!buffer_jbd(bh)
+		if (!buffer_jbd(bh) || bh2jh(bh) != jh
 			|| jh->b_transaction != commit_transaction
 			|| jh->b_jlist != BJ_SyncData) {
 			jbd_unlock_bh_state(bh);
@@ -463,7 +463,9 @@ void journal_commit_transaction(journal_
 			spin_lock(&journal->j_list_lock);
 			continue;
 		}
-		if (buffer_jbd(bh) && jh->b_jlist == BJ_Locked) {
+		if (buffer_jbd(bh) && bh2jh(bh) == jh &&
+		    jh->b_transaction == commit_transaction &&
+		    jh->b_jlist == BJ_Locked) {
 			__journal_unfile_buffer(jh);
 			jbd_unlock_bh_state(bh);
 			journal_remove_journal_head(bh);


