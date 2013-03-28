From: Dave Chinner <david@fromorbit.com>
Subject: Re: Eric Whitney's ext4 scaling data
Date: Thu, 28 Mar 2013 16:07:38 +1100
Message-ID: <20130328050738.GD6369@dastard>
References: <nsxhajyzu6n.fsf@closure.thunk.org>
 <20130327033322.GB9887@gmail.com>
 <20130327033554.GE5861@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:44223 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751338Ab3C1FHm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Mar 2013 01:07:42 -0400
Content-Disposition: inline
In-Reply-To: <20130327033554.GE5861@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 26, 2013 at 11:35:54PM -0400, Theodore Ts'o wrote:
> On Wed, Mar 27, 2013 at 11:33:23AM +0800, Zheng Liu wrote:
> > 
> > Thanks for sharing this with us.  I have an rough idea that we can create
> > a project, which have some test cases to test the performance of file
> > system.....
> 
> There is bitrotted benchmarking support into xfstests.  I know some of
> the folks at SGI have wished that it could be nursed back to health,
> but having not looked at it, it's not clear to me whether it's better
> to try to add benchmarking capabilities into xfstests, or as a
> separate project.

The stuff that was in xfstests was useless. It was some simple
wrappers around dbench, metaperf, dirperf and dd, and not much else.

SGI are looking to reintroduce a framework into xfstests, but we
have no information on what that may contain so I can't tell you
anything about it.

> The real challenge with doing this is that it tends to be very system
> specific; if you change the amount of memory, number of CPU's, type of
> storage, etc., you'll get very different results.  So any kind of
> system which is trying to detect performance regression really needs
> to be run on a specific system, and what's important is the delta from
> previous kernel versions.

Right, and the other important thing is that you know what the
expected variance of each benchmark is going to be so you can tell
if the difference between kernels is statistically significant or
not.

This was the real problem with the old xfstests stuff - I could
never get results that were consistent from run to run. Sometimes it
would be fine, but it wasn't reliable. That's where most
benchmarking efforts fail - they do unable to provide consistent,
deterministic results.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
