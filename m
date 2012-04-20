From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH, RFC 3/3] ext4: use the O_HOT and O_COLD open flags to
 influence inode allocation
Date: Thu, 19 Apr 2012 22:26:06 -0400
Message-ID: <20120420022606.GA24486@thunk.org>
References: <1334863211-19504-1-git-send-email-tytso@mit.edu>
 <1334863211-19504-4-git-send-email-tytso@mit.edu>
 <20120419232757.GC9541@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:42438 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab2DTC0M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Apr 2012 22:26:12 -0400
Content-Disposition: inline
In-Reply-To: <20120419232757.GC9541@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 20, 2012 at 09:27:57AM +1000, Dave Chinner wrote:
> So you're assuming that locating the inodes somewhere "hot" is going
> to improve performance. So say an application has a "hot" file (say
> an index file) but still has a lot of other files it creates and
> reads, and they are all in the same directory.
> 
> If the index file is created "hot", then it is going to be placed a
> long way away from all the other files that applciation is using,
> and every time you access the hot file you now seek away to a
> different location on disk. The net result: the application goes
> slower because average seek times have increased.

Well, let's assume the application is using all or most of the disk,
so the objects it is fetching from the 2T disk are randomly
distributed throughout the disk.  Short seeks are faster, yes, but the
seek time as a function of the seek distance is decidedly non-linear,
with a sharp "knee" in the curve at around 10-15% of a full-stroke
seek.  (Ref:
http://static.usenix.org/event/fast05/tech/schlosser/schlosser.pdf)

So most of the time, as you seek back and forth fetching data objects,
most of the time you will be incurring 75-85% of the cost of a
worst-case seek anyway.  So seeking *is* going to be a fact of life
that we can't run away from that.

Given that, the question then is whether we are better off (a) putting
the index files in the exact middle of the disk, trying to minimize
seeks, (b) scattering the index files all over the disk randomly, or
(c) concentrating the index files near the beginning of the disk?
Given the non-linear seek times, it seems to suggest that (c) would
probably be the best case for this use case.

Note that when we short-stroke, it's not just a matter of minimizing
seek distances; if it were, then it wouldn't matter if we used the
first third of the disk closest to the outer edge, or the last third
of the disk closer to the inner part of the disk.

Granted this may be a relatively small effect compared to the huge
wins of placing your data according to its usage frequency on tiered
storage.  But the effect should still be there.

Cheers,

						- Ted
