From: Dave Chinner <david@fromorbit.com>
Subject: Re: semi-stable page writes
Date: Wed, 31 Oct 2012 10:30:21 +1100
Message-ID: <20121030233021.GG29378@dastard>
References: <20121026101909.GB19617@blackbox.djwong.org>
 <20121029220122.GT29378@dastard>
 <20121030010027.GA4508@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:17199 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751190Ab2J3XbP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 30 Oct 2012 19:31:15 -0400
Content-Disposition: inline
In-Reply-To: <20121030010027.GA4508@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 29, 2012 at 09:00:27PM -0400, Theodore Ts'o wrote:
> On Tue, Oct 30, 2012 at 09:01:22AM +1100, Dave Chinner wrote:
> > On Fri, Oct 26, 2012 at 03:19:09AM -0700, Darrick J. Wong wrote:
> > > Hi everyone,
> > > 
> > > Are people still annoyed about writes taking unexpectedly long amounts of tme
> > > due to the stable page write patchset?  I'm guessing yes...
> > 
> > I haven't heard anyone except th elunatic fringe complain
> > recently...
> 
> We are currently carrying a patch in the Google kernel which
> unconditionally disables stable page writes specifically because it
> introduced significant latencies that were unacceptable for some of
> our (internal) customers of said production kernel.
> 
> I'll leave it to others to decide whether the Google production kernel
> is part of the lunatic fringe or not.  :-)

Google is, and has the resources to maintain a lunatic fringe kernel
;)

Besides, we've discussed google's problem before, and it came down
to bad application design (i.e. no buffering to protect against
variable filesystem/storage latency) and not stable pages being the
source of the problem. Turning off stable pages was a hack to work
around a badly designed application stack....

....

> IMO, it would be better to have the system automatically do the right
> thing, though.  If there is no need for stable page writes, why pay
> the performance penalty for it?

Yes, and the right thing to do is to put correctness before
performance. Stable pages are needed for correctness in a lot of
cases, so that shoul dbe the default. If the user has performance
problems, then they can turn it off. At no time should the default
require tuning to get correct behaviour. case in point: filesystems
default to "barriers = on".

Safe should *always* be the default choice, even if it is sometimes
slow.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
