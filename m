From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] ext4: Speedup ext4 orphan inode handling
Date: Mon, 20 Apr 2015 11:32:00 +0200
Message-ID: <20150420093200.GC3117@quack.suse.cz>
References: <1429198977-5637-1-git-send-email-jack@suse.cz>
 <1429198977-5637-3-git-send-email-jack@suse.cz>
 <20150418235341.GF25265@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41528 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008AbbDTJcG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Apr 2015 05:32:06 -0400
Content-Disposition: inline
In-Reply-To: <20150418235341.GF25265@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 18-04-15 19:53:41, Ted Tso wrote:
> On Thu, Apr 16, 2015 at 05:42:56PM +0200, Jan Kara wrote:
> > Ext4 orphan inode handling is a bottleneck for workloads which heavily
> > truncate / unlink small files since it contends on the global
> > s_orphan_mutex lock (and generally it's difficult to improve scalability
> > of the ondisk linked list of orphaned inodes).
> > 
> > This patch implements new way of handling orphan inodes. Instead of
> > linking orphaned inode into a linked list, we store it's inode number in
> > a new special file which we call "orphan file". Currently we still
> > protect the orphan file with a spinlock for simplicity but even in this
> > setting we can substantially reduce the length of the critical section
> > and thus speedup some workloads.
> 
> Do we need to store the inode number of the orphan inodes in a file?
> We only need to deal with orphaned inode if the journal exists --- so
> why not just define a new journal block type, and simply dump all of
> the orphaned inodes into one or more journal blocks, which get written
> out as part of the commit process?
>
> We can track the orphaned inodes using an in-memory RCU linked list,
> so it can be completely lockless, and then in the transaction commit,
> we can simply traverse the linked list and write out all of orphaned
> inodes to the journal.  I think this would be faster and simpler, and
> the only real issue is that we'll need to plumb this interface down
> into the jbd2 layer.  But I don't think that would be too difficult.
> 
> What do you think?
  Good question. That's actually what I tried in the initial version of the
patch set. I didn't submit it in the end because it ended up being quite
messy.

1) One problem is that inode can be cleaned up & freed in the running
transaction before committing transaction finishes commit. So you either
have to attach to a transaction special structure carrying just the inode
number or you have to copy inode numbers from inodes early before the
actual commit starts and before we allow a new transaction to start. Both
is doable but neither is too elegant.

2) Another problem I've spotted is that e.g. after fs freeze you expect
journal to be clean but you cannot really clean the last transaction while
there are orphan inodes (you'd lose track of them). Similarly you have to
be careful in the checkpointing code not to clean up the last transaction
carrying orphan inodes. Basically to allow forward progress, you need to
write orphan inode number into each transaction during which it is orphaned
but still you cannot clean up the last committed transaction which breaks
expectation in quite a few places in the fs.

3) Finally, journal replay gets somewhat tricky because you cannot cleanup
the journal until you cleanup all orphan inodes (think of a crash during
journal recovery) but you need to make fs up and running to do orphan
cleanup. Again, this is solvable (you keep the last committed transaction
in the journal, otherwise clean it up and set up all orphan inodes in
memory so that they get written in the next committed transaction) but it
complicates such core things in the fs that I didn't find it worth the
trouble in the end.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
