From: Dave Chinner <david@fromorbit.com>
Subject: Re: ext4: journal has aborted
Date: Sat, 5 Jul 2014 08:46:45 +1000
Message-ID: <20140704224645.GN9508@dastard>
References: <CAFnufp2TPSyZe4NUSTVeSWuSDwsCLHDogBvAWV4_+JaQFRrw-w@mail.gmail.com>
 <20140703134338.GE2374@thunk.org>
 <20140703161551.5fd13245@archvile>
 <87tx6yzdxz.fsf@openvz.org>
 <20140704114031.2915161a@archvile>
 <87r421zavi.fsf@openvz.org>
 <20140704132802.0d43b1fc@archvile>
 <20140704122022.GC10514@thunk.org>
 <20140704154559.026331ec@archvile>
 <20140704184539.GA11103@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Jander <david@protonic.nl>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Matteo Croce <technoboy85@gmail.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:65440 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031056AbaGDWqt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Jul 2014 18:46:49 -0400
Content-Disposition: inline
In-Reply-To: <20140704184539.GA11103@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 04, 2014 at 02:45:39PM -0400, Theodore Ts'o wrote:
> On Fri, Jul 04, 2014 at 03:45:59PM +0200, David Jander wrote:
> > > 1) Some kind of eMMC driver bug, which is possibly causing the CACHE
> > > FLUSH command not to be sent.
> > 
> > How can I investigate this? According to the fio tests I ran and the
> > explanation Dmitry gave, I conclude that incorrectly sending of CACHE-FLUSH
> > commands is the only thing left to be discarded on the eMMC driver front,
> > right?
> 
> Can you try using an older kernel?  The report that that I quoted from
> John Stultz (https://lkml.org/lkml/2014/6/12/19) indicated that it was
> a problem that showed up in "recent kernels", and a bisection search
> seemed to point towards an unknown problem in the eMMC driver.
> Quoting from https://lkml.org/lkml/2014/6/12/762:
> 
>     "However, despite many many reboots the last good commit in my
>     branch - bb5cba40dc7f079ea7ee3ae760b7c388b6eb5fc3 (mmc: block:
>     Fixup busy detection while...) doesn't ever show the issue. While
>     the immediately following commit which bisect found -
>     e7f3d22289e4307b3071cc18b1d8ecc6598c0be4 (mmc: mmci: Handle CMD
>     irq before DATA irq) always does.
> 
>     The immensely frustrating part is while backing that single change off
>     from its commit sha always makes the issue go away, reverting that
>     change from on top of v3.15 doesn't. The issue persists....."
> 
> > > 2) Some kind of hardware problem involving flash translation layers
> > > not having durable transactions of their flash metadata across power
> > > failures.
> > 
> > That would be like blaming Micron (the eMMC part manufacturer) for faulty
> > firmware... could be, but how can we test this?
> 
> The problem is that people who write these programs end up doing
> one-offs, as opposed to something that is well packaged and stands the
> test of time.  But basically what we want is a program that writes to
> sequential blocks in a block device with the following information:
> 
> *) a timestamp (seconds and microseconds from gettimeofday)
> *) a 64-bit generation number (which is randomly
>    generated and the same for each run of the progam)
> *) a 32-bit sequence number (starts at zero and
>    increments once per block
> *) a 32-bit "sync" number which is written after each time
>    fsync(2) is called while writing to the disk
> *) the sector number where the data was written
> *) a CRC of the above information
> *) some random pattern to fill the rest of the 512 or 4k block,
>    depending on the physical sector size

genstream + checkstream.

http://oss.sgi.com/projects/nfs/testtools/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
