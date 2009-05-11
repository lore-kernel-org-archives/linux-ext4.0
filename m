From: Theodore Tso <tytso@mit.edu>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Mon, 11 May 2009 15:19:57 -0400
Message-ID: <20090511191957.GD21518@mit.edu>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org> <20090511081216.GK4694@kernel.dk> <20090511084121.GB29082@mit.edu> <1242062325.9647.4.camel@localhost.localdomain> <20090511184323.GA16885@linux.intel.com> <1242067995.13509.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <willy@linux.intel.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1242067995.13509.1.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 11, 2009 at 02:53:15PM -0400, Chris Mason wrote:
> > Actually, that's the exact opposite of what you want.  You want to try
> > to reuse blocks that are scheduled for trimming so that we never have to
> > send the command at all.
> 
> Regardless of the optimal way to reuse blocks, we need some way of
> knowing the discard is done, or at least sent down to the device in such
> a way that any writes will happen after the discard and not before.

An easy way of solving this is simply to have a way for the block
allocator to inform the discard management layer that a particular
block is now in use again.  That will prevent the discard from
happening.  If the discard is in flight, then the interface won't be
able to return until the discard is done.  (This is where real
OS-controlled ordering via dependency --- which NCQ doesn't provide
--- combined with discard/trim as a queuable operation --- would be
really handy.)

One of the things which I worry about is the discard allocation layer
could be an SMP contention point, since the filesystem will need to
call it before every block allocation or deallocation.

Hmm... maybe the better approach is let the filesystem keep the
authoratative list of what's free and not free, and only keep a range
of blocks where some deallocation has taken place.  Then when the
filesystem is quiscent, we can lock out block allocations and scan the
block bitmaps, and then send a trim request for anything that's not in
use in a particular region (i.e. allocation group) of the filesystem.  

After all, quiescing the block I/O queues is what is expensive;
sending a large number of block ranges attached to a single ATA TRIM
command looks cheap by comparison.  So maybe we just lock out the
block group, and send a TRIM for all the unused blocks in that block
group, and only keep track of which block groups should be scanned via
flag in the block group descriptors.  That might be a much simpler
approach.

	  	    	    	  	   	  - Ted

