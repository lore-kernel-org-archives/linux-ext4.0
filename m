From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] jbd2: optimize jbd2_log_do_checkpoint() a bit
Date: Tue,  2 Sep 2014 18:46:40 -0400
Message-ID: <1409698000-18126-2-git-send-email-tytso@mit.edu>
References: <20140902215930.GJ6232@thunk.org>
 <1409698000-18126-1-git-send-email-tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33758 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274AbaIBWrD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Sep 2014 18:47:03 -0400
In-Reply-To: <1409698000-18126-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jan Kara <jack@suse.cz>

When we discover written out buffer in transaction checkpoint list we
don't have to recheck validity of a transaction. Either this is the
last buffer in a transaction - and then we are done - or this isn't
and then we can just take another buffer from the checkpoint list
without dropping j_list_lock.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/jbd2/checkpoint.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index cb6e17c..7713f94 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -289,9 +289,10 @@ restart:
 			if (unlikely(buffer_write_io_error(bh)) && !result)
 				result = -EIO;
 			BUFFER_TRACE(bh, "remove from checkpoint");
-			__jbd2_journal_remove_checkpoint(jh);
-			spin_unlock(&journal->j_list_lock);
-			goto retry;
+			if (__jbd2_journal_remove_checkpoint(jh))
+				/* The transaction was released; we're done */
+				goto out;
+			continue;
 		}
 		/*
 		 * Important: we are about to write the buffer, and
-- 
2.1.0

