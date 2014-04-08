From: Dave Chinner <david@fromorbit.com>
Subject: Re: ext4 performance falloff
Date: Tue, 8 Apr 2014 20:30:27 +1000
Message-ID: <20140408103027.GC22917@dastard>
References: <533EE547.3030504@numascale.com>
 <20140404205604.GC10275@thunk.org>
 <533F7851.30803@numascale.com>
 <20140407141935.GA22171@quack.suse.cz>
 <87bnwdjdoj.fsf@tassilo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Daniel J Blueman <daniel@numascale.com>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Steffen Persvold <sp@numascale.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87bnwdjdoj.fsf@tassilo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Apr 07, 2014 at 09:40:28AM -0700, Andi Kleen wrote:
> Jan Kara <jack@suse.cz> writes:
> >
> > What we really need is a counter where we can better estimate counts
> > accumulated in the percpu part of it. As the counter approaches zero, it's
> > CPU overhead will have to become that of a single locked variable but when
> > the value of counter is relatively high, we want it to be fast as the
> > percpu one.  Possibly, each CPU could "reserve" part of the value in the
> > counter (by just decrementing the total value; how large that part should
> > be really needs to depend to the total value of the counter and number of
> > CPUs - in this regard we really differ from classical percpu couters) and
> > allocate/free using that part. If CPU cannot reserve what it is asked for
> > anymore, it would go and steal from parts other CPUs have accumulated,
> > returning them to global pool until it can satisfy the allocation.

Yup, that's pretty much what the slow path/fast path breakdown of
the xfs_icsb_* (XFS In-Core Super Block) code in fs/xfs/xfs_mount.c
does. :)

It distributes free space across all the CPUs and
rebalances them when a per-CPu counter runs out. And to avoid lots
of rebalances when ENOSPC approaches (512 blocks per CPU, IIRC),
it disables the per-CPU counters completely and falls back to a
global counter protected by a mutex to avoid wasting hundreds of
CPUs spinning on a contended global lock. When the free space goes
back above that threshold, it returns to per-cpu mode (the fast
path code).

> That's a percpu_counter() isn't it? (or cookie jar)

No. percpu_counters do not guarantee accuracy nor can the counters
be externally serialised for things like concurrent ENOSPC detection
that require a guarantee that the counter never, ever goes below
zero.

> The MM uses similar techniques.

I haven't seen anything else that uses similar techniques to the XFS
code - I wrote it back in 2005 before there was generic per-cpu
counter infrastructure, and I've been keeping an eye out as
to whether it could be replaced with generic code ever since....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
