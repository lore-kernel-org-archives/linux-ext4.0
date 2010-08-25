From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Wed, 25 Aug 2010 23:24:17 +1000
Message-ID: <20100825132417.GQ31488@dastard>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com>
 <1282656558.2605.2742.camel@laptop>
 <4C73CA24.3060707@fusionio.com>
 <alpine.DEB.2.00.1008241309170.21242@chino.kir.corp.google.com>
 <20100825112433.GB4453@thunk.org>
 <1282736132.2605.3563.camel@laptop>
 <20100825115709.GD4453@thunk.org>
 <1282740516.2605.3644.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Ts'o <tytso@mit.edu>, David Rientjes <rientjes@google.com>,
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
In-Reply-To: <1282740516.2605.3644.camel@laptop>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 25, 2010 at 02:48:36PM +0200, Peter Zijlstra wrote:
> On Wed, 2010-08-25 at 07:57 -0400, Ted Ts'o wrote:
> > On Wed, Aug 25, 2010 at 01:35:32PM +0200, Peter Zijlstra wrote:
> > > On Wed, 2010-08-25 at 07:24 -0400, Ted Ts'o wrote:
> > > > Part of the problem is that we have a few places in the kernel where
> > > > failure is really not an option --- or rather, if we're going to fail
> > > > while we're in the middle of doing a commit, our choices really are
> > > > (a) retry the loop in the jbd layer (which Andrew really doesn't
> > > > like), (b) keep our own private cache of free memory so we don't fail
> > > > and/or loop, (c) fail the file system and mark it read-only, or (d)
> > > > panic. 
> > > 
> > > d) do the allocation before you're committed to going fwd and can still
> > > fail and back out.
> > 
> > Sure in some cases that can be done, but the commit has to happen at
> > some point, or we run out of journal space, at which point we're back
> > to (c) or (d).
> 
> Well (b) sounds a lot saner than either of those. Simply revert to a
> state that is sub-optimal but has bounded memory use and reserve that
> memory up-front. That way you can always get out of a tight memory spot.
> 
> Its what the block layer has always done to avoid the memory deadlock
> situation, it has a private stash of BIOs that is big enough to always
> service some IO, and as long as IO is happening stuff keeps moving fwd
> and we don't deadlock.
> 
> Filesystems might have a slightly harder time creating such a bounded
> state because there might be more involved like journals and the like,
> but still it should be possible to create something like that (my swap
> over nfs patches created such a state for the network rx side of
> things).

Filesystems are way more complex than the block layer - the block
layer simply doesn't have to handle situations were thread X is
holding A, B and C, while thread Y needs C to complete the
transaction. thread Y is the user of the low memory pool, but has
almost depleted it and so even if we swith to thread X, the pool doe
snot have enouhg memory for X to complete and allow us to switch
back to Y and have it complete, freeing the memory from the pool
that it holds.

That is, the guarantee that we will always make progress simply does
not exist in filesystems, so a mempool-like concept seems to me to
be doomed from the start....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
