From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] Fix commit code to properly abort journal
Date: Tue, 25 Sep 2007 16:18:07 +0200
Message-ID: <20070925141807.GF412@duck.suse.cz>
References: <20070925140113.GE412@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:59080 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754046AbXIYN4v (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Sep 2007 09:56:51 -0400
Content-Disposition: inline
In-Reply-To: <20070925140113.GE412@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  And a similar patch for JBD2...

									Honza
-----

We should really call journal_abort() and not __journal_abort_hard() in case
of errors. The latter call does not record the error in the journal superblock and
thus filesystem won't be marked as with errors later (and user could happily mount
it without any warning).

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-rc6-1-jbd_abort_fix/fs/jbd2/commit.c linux-2.6.23-rc6-2-jbd2_abort_fix/fs/jbd2/commit.c
--- linux-2.6.23-rc6-1-jbd_abort_fix/fs/jbd2/commit.c	2007-09-18 19:22:28.000000000 +0200
+++ linux-2.6.23-rc6-2-jbd2_abort_fix/fs/jbd2/commit.c	2007-09-25 16:14:09.000000000 +0200
@@ -475,7 +475,7 @@ void jbd2_journal_commit_transaction(jou
 	spin_unlock(&journal->j_list_lock);
 
 	if (err)
-		__jbd2_journal_abort_hard(journal);
+		jbd2_journal_abort(journal, err);
 
 	jbd2_journal_write_revoke_records(journal, commit_transaction);
 
@@ -533,7 +533,7 @@ void jbd2_journal_commit_transaction(jou
 
 			descriptor = jbd2_journal_get_descriptor_buffer(journal);
 			if (!descriptor) {
-				__jbd2_journal_abort_hard(journal);
+				jbd2_journal_abort(journal, -EIO);
 				continue;
 			}
 
@@ -566,7 +566,7 @@ void jbd2_journal_commit_transaction(jou
 		   and repeat this loop: we'll fall into the
 		   refile-on-abort condition above. */
 		if (err) {
-			__jbd2_journal_abort_hard(journal);
+			jbd2_journal_abort(journal, err);
 			continue;
 		}
 
@@ -757,7 +757,7 @@ wait_for_iobuf:
 		err = -EIO;
 
 	if (err)
-		__jbd2_journal_abort_hard(journal);
+		jbd2_journal_abort(journal, err);
 
 	/* End of a transaction!  Finally, we can do checkpoint
            processing: any buffers committed as a result of this
