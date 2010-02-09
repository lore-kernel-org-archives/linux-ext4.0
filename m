From: tytso@mit.edu
Subject: Re: Help on Implementation of EXT3 type Ordered Mode in EXT4
Date: Tue, 9 Feb 2010 12:41:45 -0500
Message-ID: <20100209174145.GU4494@thunk.org>
References: <loom.20100204T064311-880@post.gmane.org>
 <20100209160522.GE15318@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kailas Joshi <kailas.joshi@gmail.com>,
	Jiaying Zhang <jiayingz@google.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42358 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124Ab0BIRlv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Feb 2010 12:41:51 -0500
Content-Disposition: inline
In-Reply-To: <20100209160522.GE15318@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 09, 2010 at 05:05:22PM +0100, Jan Kara wrote:
>   Hi,
> 
> > I recently found that in EXT4 with delayed block the Ordered mode does not
> > bahave same as in EXT3.
> > I found a patch for this at http://lwn.net/Articles/324023/, but it has some
> > journal block estimation problem resulting into deadlock.
> > 
> > I would like to know if it has been solved.
> > If not, is it possible to solve it? What are the complexities involved?
>
> It has not been solved. The problem is that to commit data on
> transaction commit (which is what data=ordered mode has historically
> done), you have to allocate space for these blocks. But that
> allocation needs to modify a filesystem and thus journal more
> blocks... And that is tricky - we would have to reserve space in the
> current transaction for allocation of delayed data.  So it gets a
> bit messy...

The dioread_nolock patches from Jiaying, which are currently in the
unstable portion of the tree, is a partial solution to the
data=ordered problem, although it solves it in a slightly different
way.

As a side effect of trying to avoid locking on the direct I/O read
path, on the buffered I/O write path it changes things so the extent
tree is first changed so the blocks are allocated with the "extent
uninitialized" bit, and then only after the blocks hit the disk, via
the bh completion callback, do we set the extent so that it is marked
as containing initialized data.

As a result, if you crash before the extent tree is updated, when you
read from the file, you will get all zero's, instead of the data, thus
preventing the security leak.

It does mean that fsync() is slightly slower, since we now have to
flush the data blocks out, wait for the completion handler to fire and
update the extent in the same jbd2 transaction, and only then wait for
the barrier in the jbd2 transaction.  (And in fact, I'm not sure
fsync() is completely working correctly in the current patch in the
unstable patch stream, and there aren't race conditions where the
extent tree update slips into the next transaction.)  But it does
solve the problem.

The other downside with this solution is that it only works for files
that are extent-mapped, and if you do this with a converted ext3 file
system, and there are files that are still mapped using
direct/indirect blocks, when you change the mount option to be
data=writeback,dioread_nolock, the block allocating writes to these
legacy files could result in data getting exposed after a crash.

Depending on the workload the upside is that by using data=writeback
instead of data=ordered could far outweigh the downside of needing to
do an extra block I/O queue flush before the fsync, since it reduces
the number of entangled writes to only the metadata blocks, where
previously the entagled write problem affected metadata blocks plus
all freshly allocated blocks.

Kalias, this is something that I plan to look in the near future; if
you are interested in helping to benchmark and characterize this
solution, I'd be very interested in working with you.  Can you tell me
a little more about your use case and requirements?

  	      	    	     	      - Ted

