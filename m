From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4: ratelimit the file system mounted message
Date: Tue, 18 Aug 2015 09:07:52 +1000
Message-ID: <20150817230752.GB3902@dastard>
References: <1439665197-10766-1-git-send-email-tytso@mit.edu>
 <20150817011215.GA714@dastard>
 <20150817145056.GC27202@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150817145056.GC27202@thunk.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

[cc fstests@vger.kernel.org as we are talking about the test rather
than the kernel behaviour. ]

On Mon, Aug 17, 2015 at 10:50:56AM -0400, Theodore Ts'o wrote:
> On Mon, Aug 17, 2015 at 11:12:15AM +1000, Dave Chinner wrote:
> > On Sat, Aug 15, 2015 at 02:59:57PM -0400, Theodore Ts'o wrote:
> > > The xfstests ext4/305 will mount and unmount the same file system over
> > > 4,000 times, and each one of these will cause a system log message.
> > > Ratelimit this message since if we are getting more than a few dozen
> > > of these messages, they probably aren't going to be helpful.
> > 
> > Perhaps you should look at fixing the test or making it a more
> > targetted reproducer. Tests that do "loop doing something basic
> > while looping doing something else basic for X minutes to try to
> > trip a race condition" aren't very good regression tests....
> 
> The problem what we are specifically testing is a race where one
> process is reading from a proc fs file while the file system is being
> unmounted:

*nod*. It's like trying to swat a fly with a sledge hammer: if you
get lucky you might shave the fly, but most of the time you're going
to miss.

> I don't see a better way of doing the test off the top of my head,
> though.... and to be honest I'm not sure how much value the test
> really has, since it's the sort of thing that can easily be checked by
> inspection, and it seems rather unlikely we would regress here.

Yup. A lot of regression tests get written to tick a process box
(i.e. did we fix regression X?), not because they provide on-going
value to prevent future regressions. I try to push back against
tests that won't provide us with useful protection against future
regressions....

FWIW, if we need to trigger a specific race in XFS for testing
purposes we've historically added debug code to add a delay in the
kernel code to allow the race condition to trigger. e.g.
tests/xfs/051 pokes a sysfs entry that only exists on
CONFIG_XFS_DEBUG=y builds to delay log recovery so that we can
trigger IO errors via dm-flakey while log recovery is being
performed.

> BTW, out of curiosity I reverted 9559996 and tried running ext4/305
> many times, on a variety of different VM's ranging from 1 to 8 CPU's,
> and using both a SSD and a laptop HDD.
> 
> In all cases, ext3/305 reliably reproduced the failure within 30
> mount/unmount cycles, and in most cases, under a dozen cycles.  (i.e.,
> under two seconds, and usually in a fraction of a second).  So I'm not
> entirely sure why the test was written to run the loop for 3 minutes
> and thousands of mount/unmount cycles.

There were lots of tests being written at the time that used a 3
minute timeout. It's another of those red flags that I tend to
push back on these days, and this is an example of why - usually the
problem can be hit very quickly, or the test is extremely unreliable
and long runtime is the only way to trigger the race. Hence
running for X minutes doesn't really prove anything....

> Eryu, you wrote the test; any thoughts?  At the very least I'd suggest
> cutting the test down so that it runs for at most 2 seconds, if for no
> other reason than to speed up regression test runs.

Rather than time limiting, how about bounding the number of
mount/unmount cycles?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
