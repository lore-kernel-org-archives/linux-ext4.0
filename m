From: Theodore Tso <tytso@mit.edu>
Subject: Re: Enable asynchronous commits by default patch revoked?
Date: Mon, 24 Aug 2009 19:28:04 -0400
Message-ID: <20090824232804.GJ17684@mit.edu>
References: <200908241033.10527.Christian.Fischer@easterngraphics.com> <20090824133447.GH23677@mit.edu> <20090824183119.GI5931@webber.adilger.int> <20090824201027.GC17684@mit.edu> <4A92F7E0.9010001@redhat.com> <20090824220738.GG17684@mit.edu> <4A93103B.2000909@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	Christian Fischer <Christian.Fischer@easterngraphics.com>,
	linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55466 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658AbZHXX2Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Aug 2009 19:28:24 -0400
Content-Disposition: inline
In-Reply-To: <4A93103B.2000909@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 24, 2009 at 06:12:11PM -0400, Ric Wheeler wrote:
> I see that this might be slightly faster, but would be very interested  
> in seeing that the gain is big enough to warrant the complexity :-)

This simple enough?  :-)

commit 5127a5da28fc12a219474c96e59fd178629436fe
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Mon Aug 24 19:18:31 2009 -0400

    ext4: Fix async commit mode by writing the commit record using a barrier
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 7b4088b..a7fe81d 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -132,9 +132,7 @@ static int journal_submit_commit_record(journal_t *journal,
 	set_buffer_uptodate(bh);
 	bh->b_end_io = journal_end_buffer_io_sync;
 
-	if (journal->j_flags & JBD2_BARRIER &&
-		!JBD2_HAS_INCOMPAT_FEATURE(journal,
-					 JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
+	if (journal->j_flags & JBD2_BARRIER) {
 		set_buffer_ordered(bh);
 		barrier_done = 1;
 	}


Ok, to be fair, most of the complexity was already in the code
already; but it the main complexity was simply separating
journal_write_commit_record() into journal_submit_commit_record() and
journal_wait_on_commit_record().    

We can clean up the patch by recombining these two functions, since
there was never any point in separate submitting the commit record
from where we waited for it.  I think who ever implemented thought we
could add a bit more paralisms, but in reality all of the code between
line 709 of commit.c and 834 of commit.c (i.e., commit phases 3-5) is
waiting for the various journal data blocks to be written.  So we
might as well wait for the commit block, which will save a bit of
scheduling overhead, using the same rationale listed in the commit
found in line 740 of commit.c:

      /*
         Wait for the buffers in reverse order.  That way we are
	 less likely to be woken up until all IOs have completed, and
	 so we incur less scheduling load.
       */

But in terms of a simple patch to test things, the above patch is all
we need.  At this point, we can try benchmarking with and without
async commit, and see if it makes a significant difference or not.

            	      	      	    	    - Ted


