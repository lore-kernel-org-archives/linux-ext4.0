From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/5 v2] add extent status tree caching
Date: Fri, 16 Aug 2013 13:21:24 +1000
Message-ID: <20130816032124.GJ12779@dastard>
References: <20130719161930.GF17938@thunk.org>
 <20130722013831.GE11674@dastard>
 <20130722021742.GA24195@gmail.com>
 <20130722100255.GF11674@dastard>
 <20130722125745.GA2827@gmail.com>
 <20130730030807.GI21982@dastard>
 <20130804012740.GC19781@thunk.org>
 <20130813031057.GV12779@dastard>
 <5209A649.90406@redhat.com>
 <20130813130459.GD8902@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:49551 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753209Ab3HPDVa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Aug 2013 23:21:30 -0400
Content-Disposition: inline
In-Reply-To: <20130813130459.GD8902@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 13, 2013 at 09:04:59AM -0400, Theodore Ts'o wrote:
> On Mon, Aug 12, 2013 at 10:21:45PM -0500, Eric Sandeen wrote:
> > 
> > Reading extents via fiemap almost certainly moves that metadata into
> > kernel cache, simply by the act of reading the block device to get them.
> 
> Well, if the file system has an extent cache.  It certainly will end
> up reading the pages involved with the extents into the buffer and/or
> page cache (depending on how the file system does things).

Of course. ext4 has an extent cache, so you're agreeing that FIEMAP
will populate the extent cache for the use case google has, right?

> > I see Dave's point that we _do_ have an interface today to read
> > all file extents into cache.  We don't mark them as particularly sticky,
> > however.
> > 
> > This seems pretty clearly driven by a Google workload need; something you
> > can probably test.  Does FIEMAP do the job for you or not?  If not, why not?
> 
> If you are using memory containers the way we do, in practice every
> single process is going to be under memory pressure.  See previous
> comments I've made about why in a cloud environment, memory is your
> most precious resource.

<snip>

Sure, we know all that. But you haven't answered the question being
asked which was whether FIEMAP can acheive what you need. You've
already admitted it can populate the extent cache for ext4, so
there's little else that is needed to pin the extents is reads in a
range in the cache. Just one flag...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
