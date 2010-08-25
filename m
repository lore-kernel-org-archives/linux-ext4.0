From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [patch 1/5] mm: add nofail variants of kmalloc kcalloc and
 kzalloc
Date: Wed, 25 Aug 2010 07:24:33 -0400
Message-ID: <20100825112433.GB4453@thunk.org>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com>
 <1282656558.2605.2742.camel@laptop>
 <4C73CA24.3060707@fusionio.com>
 <alpine.DEB.2.00.1008241309170.21242@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jens Axboe <jaxboe@fusionio.com>,
	Peter Zijlstra <peterz@infradead.org>,
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
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008241309170.21242@chino.kir.corp.google.com>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Aug 24, 2010 at 01:11:26PM -0700, David Rientjes wrote:
> On Tue, 24 Aug 2010, Jens Axboe wrote:
> 
> > Should be possible to warn at build time for anyone using __GFP_NOFAIL
> > without wrapping it in a function.
> > 
> 
> We could make this __deprecated functions as Peter suggested if you think 
> build time warnings for existing users would be helpful.

Let me take a few steps backwards and look at the problem from a
somewhat higher level.

Part of the problem is that we have a few places in the kernel where
failure is really not an option --- or rather, if we're going to fail
while we're in the middle of doing a commit, our choices really are
(a) retry the loop in the jbd layer (which Andrew really doesn't
like), (b) keep our own private cache of free memory so we don't fail
and/or loop, (c) fail the file system and mark it read-only, or (d)
panic.

There are other places where we can fail safely (for example, in jbd's
start_this_handle, although that just pushes the layer up the stack,
and ultimately, to userspace where most userspace programs don't
really expect ENOMEM to get returned by a random disk write --- how
much do _you_ trust a random GNOME or KDE developer to do correct
error checking and do something sane at the application?)

So we can mark the retry loop helper function as deprecated, and that
will make some of these cases go away, but ultimately if we're going
to fail the memory allocation, something bad is going to happen, and
the only question is whether we want to have something bad happen by
looping in the memory allocator, or to force the file system to
panic/oops the system, or have random application die and/or lose user
data because they don't expect write() to return ENOMEM.

So at some level it would be nice if we had a few different levels of
"we *really* need this memory".  Level 0 might be, "if we can't get
it, no biggie, we'll figure out some other way around it.  I doubt
there is much at level 0, but in theory, we could have some good
citizens that fall in that camp and who simply will bypass some
optimization if they can't get the memory.  Level 1 might be, if you
can't get the memory, we will propagate a failure up to userspace, but
it's probably a relatively "safe" place to fail (i.e., when the user
is opening a file).  Level 2 might be, "if you can't get the memory,
we will propgate a failure up to userspace, but it's at a space where
most applications are lazy f*ckers, and this may lead to serious
application errors" (example: close(2), and this is a file system that
only pushes the file to the server at close time, e.g. AFS).  Level 3
might be, "if you can't get the memory, I'm going to fail the file
system, or some other global subsystem, that will probably result in
the system crashing or needing to be rebooted".

We can ignore this problem and pretend it doesn't exist at the memory
allocator level, but that means the callers are going to be doing
their own thing to try to avoid having really bad things happening at
really-low-memory occasions.  And this may mean looping, whether we
mark the function as deprecated or not.

This is becoming even more of an issue now given that with
containerization, we have jokers who are forcing tasks to run in very
small memory containers, which means that failures can happen far more
frequently --- and in some cases, just because the process running the
task happens to be in an extremely constrained memory cgroup, doesn't
mean that failing the entire system is really such a great idea.  Or
maybe that means memory cgroups are kinda busted.  :-)

      	   	 		    	  	   - Ted
