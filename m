From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH, RFC 3/3] ext4: use the O_HOT and O_COLD open flags to
 influence inode allocation
Date: Sat, 21 Apr 2012 10:57:15 +1000
Message-ID: <20120421005715.GJ9541@dastard>
References: <1334863211-19504-1-git-send-email-tytso@mit.edu>
 <1334863211-19504-4-git-send-email-tytso@mit.edu>
 <20120419232757.GC9541@dastard>
 <20120420022606.GA24486@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:54667 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751375Ab2DUA5T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Apr 2012 20:57:19 -0400
Content-Disposition: inline
In-Reply-To: <20120420022606.GA24486@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 19, 2012 at 10:26:06PM -0400, Ted Ts'o wrote:
> On Fri, Apr 20, 2012 at 09:27:57AM +1000, Dave Chinner wrote:
> > So you're assuming that locating the inodes somewhere "hot" is going
> > to improve performance. So say an application has a "hot" file (say
> > an index file) but still has a lot of other files it creates and
> > reads, and they are all in the same directory.
> > 
> > If the index file is created "hot", then it is going to be placed a
> > long way away from all the other files that applciation is using,
> > and every time you access the hot file you now seek away to a
> > different location on disk. The net result: the application goes
> > slower because average seek times have increased.
> 
> Well, let's assume the application is using all or most of the disk,
> so the objects it is fetching from the 2T disk are randomly
> distributed throughout the disk.

Which is so far from most people's reality that it is not worth
considering. 

> Short seeks are faster, yes, but the
> seek time as a function of the seek distance is decidedly non-linear,
> with a sharp "knee" in the curve at around 10-15% of a full-stroke
> seek.  (Ref:
> http://static.usenix.org/event/fast05/tech/schlosser/schlosser.pdf)
> 
> So most of the time, as you seek back and forth fetching data objects,
> most of the time you will be incurring 75-85% of the cost of a
> worst-case seek anyway.  So seeking *is* going to be a fact of life
> that we can't run away from that.
> 
> Given that, the question then is whether we are better off (a) putting
> the index files in the exact middle of the disk, trying to minimize
> seeks, (b) scattering the index files all over the disk randomly, or
> (c) concentrating the index files near the beginning of the disk?
> Given the non-linear seek times, it seems to suggest that (c) would
> probably be the best case for this use case.

I disagree - based on that paper, you're better off putting all the
related application data in the same place, and hoping it all fits
in that 10-15% minimal seek time region....

Besides, you missed my point - that it is trivial to come up with
examples of what application writers think are their hot/cold/normal
data whose optimal layout bears no resemblence to your proposed
hot/cold/normal inode layout.  That's the fundamental problem here,
there is no obvious definition of HOT/COLD, and that the best
implementation depends on how the application uses those flags
combined with the characteristics of the underlying storage. IOws,
however you optimise it for a single spindle, a large percentage of
the time it is going to be detrimental to performance, not improve
it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
