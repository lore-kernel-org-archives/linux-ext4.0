From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Wed, 25 Aug 2010 21:48:47 -0400
Message-ID: <20100826014847.GQ4453@thunk.org>
References: <1282740778.2605.3652.camel@laptop>
 <E25A6DCB-3188-4CF9-9DC4-631192B2F0E2@mit.edu>
 <1282743090.2605.3696.camel@laptop>
 <alpine.DEB.2.00.1008251340420.16484@chino.kir.corp.google.com>
 <1282769729.1975.96.camel@laptop>
 <alpine.DEB.2.00.1008251406260.20253@chino.kir.corp.google.com>
 <1282771677.1975.138.camel@laptop>
 <alpine.DEB.2.00.1008251606450.31521@chino.kir.corp.google.com>
 <20100826001901.GL4453@thunk.org>
 <alpine.DEB.2.00.1008251724360.25783@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>,
	Jens Axboe <jaxboe@fusionio.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"cluster-devel@redhat.com" <cluster-devel@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"reiserfs-devel@vger.kernel.org" <reiserfs-devel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: David Rientjes <rientjes@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008251724360.25783@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 25, 2010 at 05:30:42PM -0700, David Rientjes wrote:
> 
> We certainly hope that nobody will reimplement the same function without 
> the __deprecated warning, especially for order < PAGE_ALLOC_COSTLY_ORDER 
> where there's no looping at a higher level.  So perhaps the best 
> alternative is to implement the same _nofail() functions but do a 
> WARN_ON(get_order(size) > PAGE_ALLOC_COSTLY_ORDER) instead?

Yeah, that sounds better.

> I think it's really sad that the caller can't know what the upper bounds 
> of its memory requirement are ahead of time or at least be able to 
> implement a memory freeing function when kmalloc() returns NULL.

Oh, we can determine an upper bound.  You might just not like it.
Actually ext3/ext4 shouldn't be as bad as XFS, which Dave estimated to
be around 400k for a transaction.  My guess is that the worst case for
ext3/ext4 is probably around 256k or so; like XFS, most of the time,
it would be a lot less.  (At least, if data != journalled; if we are
doing data journalling and every single data block begins with
0xc03b3998U, we'll need to allocate a 4k page for every single data
block written.)  We could dynamically calculate an upper bound if we
had to.  Of course, if ext3/ext4 is attached to a network block
device, then it could get a lot worse than 256k, of course.

	      	      	      	    	- Ted
