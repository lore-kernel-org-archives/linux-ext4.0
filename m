From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Thu, 26 Aug 2010 10:29:21 +0200
Message-ID: <1282811361.1975.273.camel@laptop>
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
	 <20100826014847.GQ4453@thunk.org>
	 <alpine.DEB.2.00.1008251951230.7034@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: Ted Ts'o <tytso@mit.edu>, Jens Axboe <jaxboe@fusionio.com>,
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
Return-path: <reiserfs-devel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1008251951230.7034@chino.kir.corp.google.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2010-08-25 at 20:09 -0700, David Rientjes wrote:
> > Oh, we can determine an upper bound.  You might just not like it.
> > Actually ext3/ext4 shouldn't be as bad as XFS, which Dave estimated to
> > be around 400k for a transaction.  My guess is that the worst case for
> > ext3/ext4 is probably around 256k or so; like XFS, most of the time,
> > it would be a lot less.  (At least, if data != journalled; if we are
> > doing data journalling and every single data block begins with
> > 0xc03b3998U, we'll need to allocate a 4k page for every single data
> > block written.)  We could dynamically calculate an upper bound if we
> > had to.  Of course, if ext3/ext4 is attached to a network block
> > device, then it could get a lot worse than 256k, of course.
> > 
> On my 8GB machine, /proc/zoneinfo says the min watermark for ZONE_NORMAL 
> is 5086 pages, or ~20MB.  GFP_ATOMIC would allow access to ~12MB of that, 
> so perhaps we should consider this is an acceptable abuse of GFP_ATOMIC as 
> a fallback behavior when GFP_NOFS or GFP_NOIO fails? 

Agreed with the fact that 400k isn't much to worry about.

Not agreed with the GFP_ATOMIC stmt.

Direct reclaim already has PF_MEMALLOC, but then we also need a
concurrency limit on that, otherwise you can still easily blow though
your reserves by having 100 concurrency users of it, resulting in an
upper bound of 40000k instead, which will be too much.

There were patches to limit the direct reclaim contexts, not sure they
ever got anywhere..

It is something to consider in the re-design of the whole
direct-reclaim/writeback paths though..
