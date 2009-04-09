From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Thu, 09 Apr 2009 14:10:03 -0400
Message-ID: <1239300603.31257.26.camel@think.oraclecorp.com>
References: <E1LrhNF-0002zd-BG@closure.thunk.org>
	 <alpine.LFD.2.00.0904090836060.4583@localhost.localdomain>
	 <1239294219.31257.10.camel@think.oraclecorp.com>
	 <20090409174932.GD26552@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:33106 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441AbZDISLW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Apr 2009 14:11:22 -0400
In-Reply-To: <20090409174932.GD26552@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2009-04-09 at 19:49 +0200, Jan Kara wrote:
> > On Thu, 2009-04-09 at 08:49 -0700, Linus Torvalds wrote:
> > > 
> > > On Wed, 8 Apr 2009, Theodore Ts'o wrote:
> > > > 
> > > > One of these patches fixes a performance regression caused by a64c8610,
> > > > which unplugged the write queue after every page write.  Now that Jens
> > > > added WRITE_SYNC_PLUG.the patch causes us to use it instead of
> > > > WRITE_SYNC, to avoid the implicit unplugging.  These patches also seem
> > > > to further improbve ext3 latency, especially during the "sync" command
> > > > in Linus's write-big-file-and-sync workload.
> > > 
> > > So here's a question and a untested _conceptual_ patch. 
> > > 
> > > The kind of writeback mode I'd personally prefer would be more of a 
> > > mixture of the current "data=writeback" and "data=ordered" modes, with 
> > > something of the best of both worlds. I'd like the data writeback to get 
> > > _started_ when the journal is written to disk, but I'd like it to not 
> > > block journal updates.
> > > 
> > > IOW, it wouldn't be "strictly ordered", but at the same time it wouldn't 
> > > be totally unordered either.
> > > 
> > 
> > I started working on the xfs style i_size updates last night, and here's
> > my current (most definitely broken) proof of concept.  I call it
> > data=guarded.
> > 
> > In guarded mode the on disk i_size is not updated until after the data
> > writes are complete.  I've got a per FS work queue and I'm abusing
> > bh->b_private as a list pointer.  So, what happens is:
> > 
> > * writepage sets up the buffer with the guarded end_io handler
> > 
> > * The end_io handler puts the buffer onto the per-sb list of guarded
> > buffers and then it kicks the work queue
> > 
> > * The workqueue updates the on disk i_size to the min of the end of the
> > buffer or the in-memory i_size, and then it logs the inode.
> > 
> > * Then the regular async bh end_io handler is called to end writeback on
> > the page.
> > 
> > One big gotcha is that we starting a transaction while a page is
> > writeback.  It means that anyone who waits for writeback to finish on
> > the datapage with a transaction running could deadlock against the work
> > queue func trying to start a transaction.
>   For ext3 I don't think anyone waits for PageWriteback with a
> transaction open. We definitely don't do it from ext3 code and generic
> code does usually sequence like:
>   lock_page(page);
>   ...
>   wait_on_page_writeback(page)
> 
>   and because lock ordering is page_lock < transaction start, we
> shouldn't have transaction open at that point.
>   But with ext4 it may be different - there, the lock ordering is
> transaction start > page_lock and so above code could well have
> transaction started.
>   Wouldn't it actually be better to update i_size when the page is
> fully written out after we clear PG_writeback as you write below?

It would, but then we have to take a ref on the inode and risk iput
leading to inode deletion in the handler that is supposed to be doing IO
completion.  It's icky either way ;)

The nice part with doing it before writeback is that we know that when
we wait for page writeback, we don't also have to wait for i_size update
to be finished.

If we go this route and it gets copied to ext4, we can weigh our options
I guess.

>   One thing which does not seem to be handled is that your code can
> happily race with truncate. So IO completion could reset i_size which
> has been just set by truncate. And I'm not sure how to handle this
> effectively. Generally I'm not sure how much this is going to cost...
> 

Yeah, I was worried about that.  What ends up happening is the setattr
call sets the disk i_size and then calls inode_setattr, who calls
vmtruncate who actually waits on the writeback.

Then, we wander into the ext3 truncate who resets disk i_size down
again.  It's a pretty strange window of updates, but I was thinking it
would work to cut down i_size, wait on IO, then cut it down again in
setattr.

Once we wait on all IO past the new in-memory i_size, writepage won't
send any more down.  So updating disk i_size after the wait should be
enough.

-chris


