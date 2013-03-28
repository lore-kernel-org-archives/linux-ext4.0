From: Dave Chinner <david@fromorbit.com>
Subject: Re: Eric Whitney's ext4 scaling data
Date: Thu, 28 Mar 2013 16:14:27 +1100
Message-ID: <20130328051427.GE6369@dastard>
References: <nsxhajyzu6n.fsf@closure.thunk.org>
 <20130327033322.GB9887@gmail.com>
 <20130327033554.GE5861@thunk.org>
 <20130327072101.GA10346@gmail.com>
 <20130327151011.GD14900@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:46499 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750911Ab3C1FO3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Mar 2013 01:14:29 -0400
Content-Disposition: inline
In-Reply-To: <20130327151011.GD14900@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 27, 2013 at 11:10:11AM -0400, Theodore Ts'o wrote:
> On Wed, Mar 27, 2013 at 03:21:02PM +0800, Zheng Liu wrote:
> > 
> > The key issue that we add test case into xfstests is that we need to
> > handle some filesystem-specific feature.  Just like we had discussed
> > with Dave, what is an extent?  IMHO now xfstests gets more compliated
> > because it needs to handle this problem. e.g. punch hole for
> > indirect-based file in ext4.
> 
> Yes, that means among other things the test framework needs to keep
> track of which file system features was being used when we run a
> particular test, as well as the hardware configuration.
> 
> I suspect that what this means is that we're better off trying to
> create a new test framework that does what we want, and automates as
> much of this as possible.

Well, tracking the hardware, configuration, results over time, etc
is really orthogonal to the benchmarking harness. We're already
modifying xfstests to make it easier to do this sort of thing (like
user specified results directories, configurable expunged files,
etc) so that you can control and archive individual xfstests from a
higher level automated harness.

So I don't see this a problem that a low level benchmarking
framework needs to concern itself directly with - what you seem to
be wanting is a better automation and archiving framework on top of
the low level harness that runs the specific tests/benchmarks....

> It would probably be a good idea to bring in Eric Whitney into this
> discussion, since he has a huge amount of expertise about what sort of
> things need to be done in order to get good results.  He was doing a
> number of things by hand, including re-running the tests multiple
> times to make sure the results were stable.  I could imagine that if
> the framework could keep track of what the standard deviation was for
> a particular test, it could try to do this automatically, and then we
> could also throw up a flag if the average result hadn't changed, but
> the standard deviation had increased, since that might be an
> indication that some change had caused a lot more variability.

Yup, you need to have result archives and post-process them to do
this sort of thing, which is why I think it's a separate problem to
that of actually defining and running the benchmarks...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
