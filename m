From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Wed, 25 Aug 2010 16:53:42 -0400
Message-ID: <20100825205342.GG4453@thunk.org>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com>
 <1282656558.2605.2742.camel@laptop>
 <4C73CA24.3060707@fusionio.com>
 <alpine.DEB.2.00.1008241309170.21242@chino.kir.corp.google.com>
 <20100825112433.GB4453@thunk.org>
 <1282736132.2605.3563.camel@laptop>
 <20100825115709.GD4453@thunk.org>
 <1282740516.2605.3644.camel@laptop>
 <20100825132417.GQ31488@dastard>
 <1282743342.2605.3707.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>,
	David Rientjes <rientjes@google.com>,
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
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1282743342.2605.3707.camel@laptop>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 25, 2010 at 03:35:42PM +0200, Peter Zijlstra wrote:
> 
> While I appreciate that it might be somewhat (a lot) harder for a
> filesystem to provide that guarantee, I'd be deeply worried about your
> claim that its impossible.
> 
> It would render a system without swap very prone to deadlocks. Even with
> the very tight dirty page accounting we currently have you can fill all
> your memory with anonymous pages, at which point there's nothing free
> and you require writeout of dirty pages to succeed.

For file systems that do delayed allocation, the situation is very
similar to swapping over NFS.  Sometimes in order to make some free
memory, you need to spend some free memory...  which implies that for
these file systems, being more aggressive about triggering writeout,
and being more aggressive about throttling processes which are
creating too many dirty pages, especially dirty delayed allocaiton
pages (regardless of whether this is via write(2) or accessing mmapped
memory), is a really good idea.

A pool of free pages which is reserved for routines that are doing
page cleaning would probably also be a good idea.  Maybe that's just
retrying with GFP_ATOMIC if a normal allocation fails, or maybe we
need our own special pool, or maybe we need to dynamically resize the
GFP_ATOMIC pool based on how many subsystems might need to use it....

Just brainstorming here; what do people think?

							- Ted
