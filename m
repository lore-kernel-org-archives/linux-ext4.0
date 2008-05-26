From: Theodore Tso <tytso@mit.edu>
Subject: Re: What to do when the journal checksum is incorrect
Date: Mon, 26 May 2008 10:54:44 -0400
Message-ID: <20080526145440.GA9893@mit.edu>
References: <E1K02Jh-0002wf-2e@closure.thunk.org> <20080525063024.GG3516@webber.adilger.int> <20080525113842.GE5970@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Girish Shilamkar <Girish.Shilamkar@sun.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:41502 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752233AbYEZQaH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 May 2008 12:30:07 -0400
Content-Disposition: inline
In-Reply-To: <20080525113842.GE5970@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, May 25, 2008 at 07:38:42AM -0400, Theodore Tso wrote:
> So the other alternative I seriously considered was not replaying the
> journal at all, and bailing out after seeing the bad checksum --- but
> that just defers the problem to e2fsck, and e2fsck can't really do
> anything much different, and the tools to allow a human to make a
> decision on a block by block basis in the journal don't exist, and
> even if they did would make more system administrators run screaming.
> 
> I suspect the *best* approach is to change the journal format one more
> time, and include a CRC on a per-block basis in the descriptor blocks,
> and a CRC for the entire descriptor block.  That way, we can decide
> what to replay or not on a per-block basis.

One other alternative I forgot to mention is that e2fsck (or the
kernel) could skip the bad (non-terminal) commit, and continue
replaying the rest of the good commits.  That's a much coarser grain
alternative to the above, given that there could be hundred or more
blocks in a particular commit that we would be skipping.

E2fsck could also save the journal to an external file which could
allow an expert to paw over the results and try to do something sane
with the results.  Given that *very* few experts would know what to
do, I'm not entirely sure it's worth the effort --- although perhaps
some of the folks who are working on ext3grep might be interested
writing some journal forensic tools.

> Nope, right now the mount will silently succeed, even though part of
> the journal (include the commit with the bad CRC, but no commits
> beyond that) have been replayed, and then the entire journal is
> truncated and thrown away.

BTW, here's the patch that will cause fs/jbd2/recovery.c to terminate
upon finding the non-terminal commit with the failed CRC.  It's not a
complete fix, since apparently fs/jbd2/recovery.c is also currently
noting the in the journal-async-commit, terminal-commit with bad CRC
case, fs/jbd2/recovery.c is noting the bad CRC --- and then replaying
it, which means that journal-async-commit is currently NOT safe.  (Not
yet fixed with my current patch; I had been so focused on the
non-terminal bad CRC case, that I only recently noticed that the
terminal async journal case was also busted.)

All of this was found by porting over the fs/jbd2/recovery.c changes
into e2fsck/recovery.c, compiling e2fsprogs with --enable-jbd-debug,
and then setting the JBD_DEBUG environment variable, then watching
journal recoveries with selectively corrupted journals using lde.
That's also how I found the buffer head memory leak which sent to
linux-ext4 a few days ago --- and why I try hard to keep
e2fsck/recover.c in sync with fs/jbd[2]/recovery.c.

The Lesson of the Week is that running tests in userspace is easier
and faster, which encourages more testing --- which means bugs get
found faster.  :-)

      		      	      	  	      	   - Ted

commit 78c061f21271968e24c434bb8a5ec41602ad0b99
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat May 24 15:45:31 2008 -0400

    jbd2: Fix handling of a bad checksum of a non-terminal commit
    
    If there is a checksum problem in transaction n, and it is not the
    last transaction, the problem isn't until the commit block for
    transaction n+1 is found. So we need to decrement the commit_ID
    counter so the right transaction is marked as the troublemaker, and we
    don't replay the corrupted transaction.
    
    Cc: Andreas Dilger <adilger@clusterfs.com>
    Cc: Girish Shilamkar <girish@clusterfs.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 7199db5..2d48448 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -611,6 +611,7 @@ static int do_one_pass(journal_t *journal,
 				chksum_err = chksum_seen = 0;
 
 				if (info->end_transaction) {
+					next_commit_ID--;
 					printk(KERN_ERR "JBD: Transaction %u "
 						"found to be corrupt.\n",
 						next_commit_ID - 1);
