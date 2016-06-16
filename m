From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/4] jbd2: Move lockdep instrumentation for jbd2 handles
Date: Thu, 16 Jun 2016 12:42:14 +0200
Message-ID: <1466073736-30447-3-git-send-email-jack@suse.cz>
References: <1466073736-30447-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Eryu Guan <eguan@redhat.com>,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43326 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779AbcFPKmX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jun 2016 06:42:23 -0400
In-Reply-To: <1466073736-30447-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The transaction the handle references is free to commit once we've
decremented t_updates counter. Move the lockdep instrumentation to that
place. Currently it was a bit later which did not really matter but
subsequent improvements to lockdep instrumentation would cause false
positives with it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/transaction.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 1749519b362f..41249538c047 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1750,11 +1750,11 @@ int jbd2_journal_stop(handle_t *handle)
 			wake_up(&journal->j_wait_transaction_locked);
 	}
 
+	lock_map_release(&handle->h_lockdep_map);
+
 	if (wait_for_commit)
 		err = jbd2_log_wait_commit(journal, tid);
 
-	lock_map_release(&handle->h_lockdep_map);
