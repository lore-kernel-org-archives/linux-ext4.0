From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, RFC] jbd2: don't write non-commit blocks synchronously
Date: Thu, 6 Mar 2014 08:56:42 -0500
Message-ID: <20140306135642.GA22136@thunk.org>
References: <20140305141343.GA26225@xanadu.blop.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Emmanuel Jeanvoine <emmanuel.jeanvoine@inria.fr>
To: Lucas Nussbaum <lucas.nussbaum@loria.fr>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37922 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbaCFN4r (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Mar 2014 08:56:47 -0500
Content-Disposition: inline
In-Reply-To: <20140305141343.GA26225@xanadu.blop.info>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 05, 2014 at 03:13:43PM +0100, Lucas Nussbaum wrote:
> TL;DR: we experience long temporary hangs when doing multiple mount -o
> remount at the same time as other I/O on an ext4 filesystem.

Hi Lukas,

Thanks for this report.  Are you willing to try a kernel patch?  If
so, could you try and see if this fixes your issue.  From looking at
your block trace, I saw a large number of suspicious 4k writes from
the jbd2 layer.

					- Ted

commit 137d7cea675fd7d8ff98b7e035fb6516dc4ab220
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Mar 6 08:56:11 2014 -0500

    jbd2: don't write non-commit blocks synchronously
    
    We don't need to write the revoke blocks and descriptor blocks using
    WRITE_SYNC, since when we issue the commit block, thos blocks will get
    pushed out via REQ_FLUSH.  This will allow the journal blocks to be
    written in fewer i/o operations (otherwise we end up issuing a whole
    series of 4k writes unnecessarily).
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index cf2fc05..fb64629 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -554,7 +554,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 
 	blk_start_plug(&plug);
 	jbd2_journal_write_revoke_records(journal, commit_transaction,
-					  &log_bufs, WRITE_SYNC);
+					  &log_bufs, WRITE);
 	blk_finish_plug(&plug);
 
 	jbd_debug(3, "JBD2: commit phase 2b\n");
@@ -739,7 +739,7 @@ start_journal_io:
 				clear_buffer_dirty(bh);
 				set_buffer_uptodate(bh);
 				bh->b_end_io = journal_end_buffer_io_sync;
-				submit_bh(WRITE_SYNC, bh);
+				submit_bh(WRITE, bh);
 			}
 			cond_resched();
 			stats.run.rs_blocks_logged += bufs;

