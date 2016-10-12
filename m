From: Dave Chinner <david@fromorbit.com>
Subject: Re: Test generic/299 stalling forever
Date: Thu, 13 Oct 2016 08:14:07 +1100
Message-ID: <20161012211407.GL23194@dastard>
References: <20150618155337.GA10439@thunk.org>
 <20150618233430.GK20262@dastard>
 <20160929043722.ypf3tnxsl6ovt653@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org,
        tarasov@vasily.name, axboe@fb.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160929043722.ypf3tnxsl6ovt653@thunk.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 29, 2016 at 12:37:22AM -0400, Theodore Ts'o wrote:
> On Fri, Jun 19, 2015 at 09:34:30AM +1000, Dave Chinner wrote:
> > On Thu, Jun 18, 2015 at 11:53:37AM -0400, Theodore Ts'o wrote:
> > > I've been trying to figure out why generic/299 has occasionally been
> > > stalling forever.  After taking a closer look, it appears the problem
> > > is that the fio process is stalling in userspace.  Looking at the ps
> > > listing, the fio process hasn't run in over six hours, and using
> > > attaching strace to the fio process, it's stalled in a FUTUEX_WAIT.
> > > 
> > > Has anyone else seen this?  I'm using fio 2.2.6, and I have a feeling
> > > that I started seeing this when I started using a newer version of
> > > fio.  So I'm going to try roll back to an older version of fio and see
> > > if that causes the problem to go away.
> > 
> > I'm running on fio 2.1.3 at the moment and I havne't seen any
> > problems like this for months. Keep in mind that fio does tend to
> > break in strange ways fairly regularly, so I'd suggest an
> > upgrade/downgrade of fio as your first move.
> 
> Out of curiosity, Dave, are you still using fio 2.1.3?  I had upgraded

No.

$ fio -v
fio-2.1.11
$

> to the latest fio to fix other test breaks, and I'm stil seeing the
> occasional generic/299 test failure.  In fact, it's been happening
> often enough on one of my test platforms[1] that I decided to really
> dig down and investigate it, and all of the threads were blocking on
> td->verify_cond in fio's verify.c.
> 
> It bisected down to this commit:
> 
> commit e5437a073e658e8154b9e87bab5c7b3b06ed4255
> Author: Vasily Tarasov <tarasov@vasily.name>
> Date:   Sun Nov 9 20:22:24 2014 -0700
> 
>     Fix for a race when fio prints I/O statistics periodically
> 
>     Below is the demonstration for the latest code in git:
>     ...
> 
> So generic/299 passes reliably with this commits parent, and it fails
> on this commit within a dozen tries or so.  The commit first landed in
> fio 2.1.14, so it's consistent with Dave's report a year ago he was
> still using fio 2.1.3.

But I'm still not using a fio recent enough to hit this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
