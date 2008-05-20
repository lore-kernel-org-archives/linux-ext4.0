From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Tue, 20 May 2008 23:26:09 +0100
Message-ID: <20080520222609.GC27853@shareable.org>
References: <482DDA56.6000301@redhat.com> <200805201202.54420.chris.mason@oracle.com> <20080520162710.GM16676@shareable.org> <200805201308.03956.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200805201308.03956.chris.mason@oracle.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Chris Mason wrote:
> Jens and I talked about tossing the barriers completely and just
> doing FUA for all metadata writes.  For drives with NCQ, we'll get
> something close to optimal because the higher layer elevators are
> already doing most of the hard work.

Will need benchmarking, but might just work.

Still need barriers for reasonable performance + integrity on systems
without NCQ, like the kit on my desk.  Without barriers I have to turn
write-cache off (I do see those power-off errors).  But that's too slow.

> Either way, you do want the flush to cover all the data=ordered writes, at 
> least all the ordered writes from the transaction you're about to commit.  
> Telling the difference between data=ordered from an old transaction or from 
> the running transaction gets into pushing ordering down to the lower levels 
> (see below)

I grant you, it is all about pushing ordering down as far as reasonable.

> > > But, it complicates the decision about when you're allowed to dirty
> > > a metadata block for writeback.  It used to be dirty-after-commit
> > > and it would change to dirty-after-barrier.  I suspect that is some
> > > significant surgery into jbd.
> >
> > Rather than tracking when it's "allowed" to dirty a metadata block, it
> > will be simpler to keep a flag saying "barrier needed", and just issue
> > the barrier prior to writing a metadata block, if the flag is set.
> 
> Adding explicit ordering into the IO path is really interesting.  We
> toss a bunch of IO down to the lower layers with information about
> dependencies and let the lower layers figure it out.

That's right.  You can keep it quite simple: just distinguish barriers
from flushes.  Or make it more detailed, distinguishing different
block sets and partial barriers between them.

> James had a bunch of ideas here, but I'm afraid the only people that
> understood it were James and the whiteboard he was scribbling on.

I think simply distinguishing barrier from flush is relatively
understandable, isn't it?

> The trick is to code the ordering in such a way that an IO failure breaks the 
> chain, and that the filesystem has some sensible chance to deal with all 
> these requests that have failed because an earlier write failed.

Yeah, if you're going to do it _properly_ that's the way :-)

But the I/O failure strategy is really a different problem, and shouldn't
necessarily distract from barrier I/O elevator scheduling.

The I/O failure strategy applies just the same even with no barriers
and no disk cache at all.  Even there, you want a failed write to
block subsequent dependent writes.

> Also, once we go down the ordering road, it is really tempting to forget that 
> ordering does ensure consistency but doesn't tell us the write actually 
> happened.  fsync and friends need to hook into the dependency chain to wait 
> for the barrier instead of waiting for the commit.

True, but fortunately it's quite a simple thing.  fsync et al need to
ask for flush, nothing else does.  You simply don't need consistency
from journalling writes without fsync.  Journal writes without fsync
happen at times determined by arcane kernel daemons.  Applications and
even users don't have any say, and therefore no particular
expectation.

> My test prog is definitely a worst case, but I'm pretty confident that most 
> mail server workloads end up doing similar IO.

Mail servers seem like the most vulnerable systems to me too.

They are often designed to relay a successful fsync() result across
the network.  RAID doesn't protect against power-fails with flushless
fsync, and SMTP does not redundantly hold the same email at different
locations for recovery.  (The most solid email services will use a
distributed database which is not vulnerable to these problems.  But
the most common mail systems are).

> A 16MB or 32MB disk cache is common these days, and that is a very sizable 
> percentage of the jbd log size.  I think the potential for corruptions on 
> power failure is only growing over time.

That depends on the disk implementation.  Another use of the 32MB is
to hold write-through NCQ commands in flight while they are sorted.
If the trend is towards that, perhaps it's quite resistant to power
failure.

Still, I'm on the side of safety - having witnessed these power-fail
corruptions myself.  The type I've seen will get more common, as the
trend in home "appliances" is towards pulling the plug to turn them
off, and to have these larger storage devices in them.

-- Jamie
