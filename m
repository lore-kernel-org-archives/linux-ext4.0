From: Dave Chinner <david@fromorbit.com>
Subject: Re: Test generic/299 stalling forever
Date: Fri, 19 Jun 2015 09:34:30 +1000
Message-ID: <20150618233430.GK20262@dastard>
References: <20150618155337.GA10439@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150618155337.GA10439@thunk.org>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 18, 2015 at 11:53:37AM -0400, Theodore Ts'o wrote:
> I've been trying to figure out why generic/299 has occasionally been
> stalling forever.  After taking a closer look, it appears the problem
> is that the fio process is stalling in userspace.  Looking at the ps
> listing, the fio process hasn't run in over six hours, and using
> attaching strace to the fio process, it's stalled in a FUTUEX_WAIT.
> 
> Has anyone else seen this?  I'm using fio 2.2.6, and I have a feeling
> that I started seeing this when I started using a newer version of
> fio.  So I'm going to try roll back to an older version of fio and see
> if that causes the problem to go away.

I'm running on fio 2.1.3 at the moment and I havne't seen any
problems like this for months. Keep in mind that fio does tend to
break in strange ways fairly regularly, so I'd suggest an
upgrade/downgrade of fio as your first move.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
