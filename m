From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Date: Sun, 18 May 2008 21:11:40 -0700
Message-ID: <20080518211140.b29bee30.akpm@linux-foundation.org>
References: <482DDA56.6000301@redhat.com>
	<20080516130545.845a3be9.akpm@linux-foundation.org>
	<482DF44B.50204@redhat.com>
	<20080516220315.GB15334@shareable.org>
	<482E08E6.4030507@redhat.com>
	<8763tbcrbo.fsf@basil.nowhere.org>
	<20080519004325.GC8335@mit.edu>
	<4830E60A.2010809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4830E60A.2010809@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 18 May 2008 21:29:30 -0500 Eric Sandeen <sandeen@redhat.com> wrote:

> Theodore Tso wrote:
> ...
> 
> > Given how rarely people have reported problems, I think it's a really
> > good idea to understand what exactly our exposure is for
> > $COMMON_HARDWARE. 
> 
> I'll propose that very close to 0% of users will ever report "having
> barriers off seems to have corrupted my disk on power loss!" even if
> that's exactly what happened.  And it'd be very tricky to identify in a
> post-mortem.  Instead we'd probably see other weird things caught down
> the road during some later fsck or during filesystem use, and then
> suggest that they go check their cables, run memtest86 or something...
> 
> Perhaps it's not the intent of this reply, Ted, but various other bits
> of this thread have struck me as trying to rationalize away the problem.

Not really.  It's a matter of understanding how big the problem is.  We
know what the cost of the solution is, and it's really large.

It's a tradeoff, and it is unobvious where the ideal answer lies,
especially when not all the information is available.

>  If the discussion were about proper locking to avoid corruption, would
> we really be  saying well, gosh, it's a *really* small window, and
> *most* people won't hit it very often, and proper locking would slow
> things down....

If it slowed really really important workloads by 30% then we'd be
running around with our hair on fire fixing that up.

But fixing this one is nowhere near as easy as fixing some locking
thing.

> So I think that as you suggest, looking for ways to make barriers less
> painful is the far better route, rather than sacrificing correctness for
> speed by turning them off by default when we know there is a chance for
> problems.  People running journaling filesystems most likely expect to
> be safe from this sort of thing, not most of the time, but all of the time.

Well.  Reducing the cost would of course make the decision easy.
