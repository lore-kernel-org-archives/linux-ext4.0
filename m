From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH v3]Ext4: journal credits reservation fixes for DIO,
	fallocate and delalloc writepages
Date: Fri, 1 Aug 2008 01:49:32 -0400
Message-ID: <20080801054932.GF8736@mit.edu>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker> <1216774311.6505.4.camel@mingming-laptop> <20080723074226.GA15091@skywalker> <1217032947.6394.2.camel@mingming-laptop> <1217383118.27664.14.camel@mingming-laptop> <1217417361.3373.15.camel@localhost> <1217527631.6317.6.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>,
	Shehjar Tikoo <shehjart@cse.unsw.edu.au>,
	linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@sun.com>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:48328 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751144AbYHAFtl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2008 01:49:41 -0400
Content-Disposition: inline
In-Reply-To: <1217527631.6317.6.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jul 31, 2008 at 11:07:11AM -0700, Mingming Cao wrote:
> 
> Looks like a 1k blocksize ext4, I have tested 1k briefly it seems okay
> for single test. I will try bonnie myself. The stack shows there isn't
> enought credit to delete an file.  But the journal credit fix mostly fix
> the code path on writepages(), so it should not affact the unlink case.

Yep, different bug.  I think this patch should fix things.

There's a larger question here which is should the extents code really
be requesting only a tiny amount of transaction credits at a time; the
advantage is that by doing so, it reduces the chance of provoking a
transaction commit before its time.  On the other hand, for a very
fragmented file with lots of extents, this will cause lots of extra
calls jbd2_journal_extend(), which does end up taking a bit more cpu
time as well as grabbing both the journal and the transaction spin
locks.

The original non-extents truncate code massively overestimates the
number of credits needed to complete the truncate (to the point where
it is probably needlessly causing transactions to close early) but it
means many fewer calls to jbd2_journal_extend().

     	       	       	     	  	       - Ted

commit 0e71ff5fc4cf98c44014a1d3c8ccffed846e7ee1
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Aug 1 01:40:08 2008 -0400

    ext4: Fix lack of credits BUG() when deleting a badly fragmented inode
    
    The extents codepath for ext4_truncate() requests journal transaction
    credits in very small chunks, requesting only what is needed.  This
    means there may not be enough credits left on the transaction handle
    after ext4_truncate() returns and then when ext4_delete_inode() tries
    finish up its work, it may not have enough transaction credits,
    causing a BUG() oops in the jbd2 core.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c7fb647..6d27e78 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -215,6 +215,18 @@ void ext4_delete_inode (struct inode * inode)
 	inode->i_size = 0;
 	if (inode->i_blocks)
 		ext4_truncate(inode);
+
+	/*
+	 * ext4_ext_truncate() doesn't reserve any slop when it
+	 * restarts journal transactions; therefore there may not be
+	 * enough credits left in the handle to remove the inode from
+	 * the orphan list and set the dtime field.
+	 */
+	if (ext4_ext_journal_restart(handle, 3)) {
+		ext4_journal_stop(handle);
+		goto no_delete;
+	}
+
 	/*
 	 * Kill off the orphan record which ext4_truncate created.
 	 * AKPM: I think this can be inside the above `if'.
