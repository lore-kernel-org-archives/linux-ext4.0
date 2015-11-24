From: Jan Kara <jack@suse.cz>
Subject: [PATCH] jbd2: Fix unreclaimed pages after truncate in data=journal mode
Date: Tue, 24 Nov 2015 09:47:31 +0100
Message-ID: <1448354851-25405-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59410 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbbKXIrh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Nov 2015 03:47:37 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ted and Namjae have reported that truncated pages don't get timely
reclaimed after being truncated in data=journal mode. The following test
triggers the issue easily:

for (i = 0; i < 1000; i++) {
	pwrite(fd, buf, 1024*1024, 0);
	fsync(fd);
	fsync(fd);
	ftruncate(fd, 0);
}

The reason is that journal_unmap_buffer() finds that truncated buffers
are not journalled (jh->b_transaction == NULL), they are part of
checkpoint list of a transaction (jh->b_cp_transaction != NULL) and have
been already written out (!buffer_dirty(bh)). We clean such buffers but
we leave them in the checkpoint list. Since checkpoint transaction holds
a reference to the journal head, these buffers cannot be released until
the checkpoint transaction is cleaned up. And at that point we don't
call release_buffer_page() anymore so pages detached from mapping are
lingering in the system waiting for reclaim to find them and free them.

Fix the problem by removing buffers from transaction checkpoint lists
when journal_unmap_buffer() finds out they don't have to be there
anymore.

Reported-and-tested-by: Namjae Jeon <namjae.jeon@samsung.com>
Fixes: de1b794130b130e77ffa975bb58cb843744f9ae5
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/transaction.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 89463eee6791..daa1514259e0 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -2152,6 +2152,7 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh,
 
 		if (!buffer_dirty(bh)) {
 			/* bdflush has written it.  We can drop it now */
+			__jbd2_journal_remove_checkpoint(jh);
 			goto zap_buffer;
 		}
 
@@ -2181,6 +2182,7 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh,
 				/* The orphan record's transaction has
 				 * committed.  We can cleanse this buffer */
 				clear_buffer_jbddirty(bh);
+				__jbd2_journal_remove_checkpoint(jh);
 				goto zap_buffer;
 			}
 		}
-- 
2.1.4

