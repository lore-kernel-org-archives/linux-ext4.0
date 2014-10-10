From: Jan Kara <jack@suse.cz>
Subject: [PATCH] jbd2: Optimize jbd2_log_do_checkpoint() a bit
Date: Fri, 10 Oct 2014 16:23:24 +0200
Message-ID: <1412951028-4085-20-git-send-email-jack@suse.cz>
References: <1412951028-4085-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	xfs@oss.sgi.com, cluster-devel@redhat.com,
	Steven Whitehouse <swhiteho@redhat.com>,
	Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
	reiserfs-devel@vger.kernel.org, Jeff Mahoney <jeffm@suse.de>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net, tytso@mit.edu,
	viro@zeniv.linux.org.uk, Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <1412951028-4085-1-git-send-email-jack@suse.cz>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When we discover written out buffer in transaction checkpoint list we
don't have to recheck validity of a transaction. Either this is the last
buffer in a transaction - and then we are done - or this isn't and then
we can just take another buffer from the checkpoint list without
dropping j_list_lock.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/checkpoint.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 993a187527f3..3722e2e53638 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -343,12 +343,15 @@ restart:
 		if (!buffer_dirty(bh)) {
 			if (unlikely(buffer_write_io_error(bh)) && !result)
 				result = -EIO;
-			get_bh(bh);
 			BUFFER_TRACE(bh, "remove from checkpoint");
-			__jbd2_journal_remove_checkpoint(jh);
-			spin_unlock(&journal->j_list_lock);
-			__brelse(bh);
-			goto retry;
+			if (__jbd2_journal_remove_checkpoint(jh)) {
+				/*
+				 * This was the last buffer attached to the
+				 * transaction. We are done.
+				 */
+				goto out;
+			}
+			continue;
 		}
 		/*
 		 * Important: we are about to write the buffer, and
-- 
1.8.1.4

