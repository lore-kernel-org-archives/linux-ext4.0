From: Nick Piggin <npiggin@kernel.dk>
Subject: Re: [patch] fs: fix deadlocks in writeback_if_idle
Date: Tue, 30 Nov 2010 11:01:18 +1100
Message-ID: <20101130000118.GA3255@amd>
References: <20101123100239.GA4232@amd>
 <1290515274-sup-3895@think>
 <20101123125223.GA4946@amd>
 <1290538347-sup-7669@think>
 <20101124010343.GD3168@amd>
 <20101124131028.GQ6113@quack.suse.cz>
 <20101125035356.GC3359@amd>
 <20101129142603.ebbcbc7e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nick Piggin <npiggin@kernel.dk>, Jan Kara <jack@suse.cz>,
	Chris Mason <chris.mason@oracle.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101129142603.ebbcbc7e.akpm@linux-foundation.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 29, 2010 at 02:26:03PM -0800, Andrew Morton wrote:
> 	On Thu, 25 Nov 2010 14:53:56 +1100
> Nick Piggin <npiggin@kernel.dk> wrote:
> > On Wed, Nov 24, 2010 at 02:10:28PM +0100, Jan Kara wrote:
> > Well, for now, the easiest and simplest fix is my patch, I think. The
> > objection is that we may not write out anything for the specified sb,
> > but the current implementation provides no such guarantees at all
> > anyway, so I don't think it's a big issue.
> 
> Well yes.  We take something which will fail occasionally and with your
> patch replace it with something which will fail a bit more often.  Why
> don't we go all the way and do something which will fail *even more
> often*.  Namely, just delete the damn function in the hope that the
> resulting failures will provoke the ext4 crew into doing something sane
> this time?

I just need it fixed because the deadlocks are constantly hanging my
tests and/or switching off lockdep.

 
> Guys, this delalloc thing *sucks*.  And here we are just sticking new
> bandaids on top of the old bandaids.  And the btrfs approach isn't
> exactly a thing of glory, either.
> 
> So...  nope.  I won't be applying Nick's patch.  Please fix this thing
> properly - you have a whole month!

Testers have less. It would be better to fix it now and rip it out at
the start of the next merge window if you're that way inclined :)

