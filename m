From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Livelock when running xfstests generic/127 on ext4 with 3.15
Date: Wed, 25 Jun 2014 10:45:14 -0400
Message-ID: <20140625144514.GA10397@thunk.org>
References: <20140620175322.GO12025@linux.intel.com>
 <20140625131224.GE21507@quack.suse.cz>
 <20140625141756.GS12025@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140625141756.GS12025@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 25, 2014 at 10:17:56AM -0400, Matthew Wilcox wrote:
> 
> Okay ... but why is it so much worse in 3.15 than 3.14?
> 
> And does ext4 think of "running out of space" as a percentage
> free, or an absolute number of blocks remaining?  From the code in
> ext4_nonda_switch(), it seems to be the former, although maybe excessive
> fragmentation has caused ext4 to think it's running out of space?

When the blocks that were allocated using delayed allocation exceeds
50% of the free space, we initiate writeback.  When delalloc blocks
exceeds 66% of the free space, we fall back to nodelalloc, which among
other things, means blocks are allocated for each write system call,
and we also have to add and remove the inode from on the orphan inode
list so that if we crash in the middle of the write system call, we
don't end up exposing stale data.

We did have a change to the orphan inode code to improve scalability,
so that could have been a possible cause; but that happened after
3.15, so that can't be it.  The other possibility is that there's
simply a chance in the writeback code that is changing how
aggressively we start writeback when we exceed the 50% threshold, so
that we end up switching into nonda mode more often.

Any chance you can run generic/127 under perf so we can see where
we're spending all of our CPU time?  The other thing I can imagine
doing is to add tracepoint when whenver we drop into nonda mode, so we
can see if that's happening more often under 3.15 versus 3.14.

    	   	  	    	       	     - Ted
