From: tytso@mit.edu
Subject: Re: EXT4 is ~2X as slow as XFS (593MB/s vs 304MB/s) for writes?
Date: Sun, 28 Feb 2010 00:42:40 -0500
Message-ID: <20100228054240.GE14646@thunk.org>
References: <alpine.DEB.2.00.1002261922010.8247@p34.internal.lan>
 <4B886CA1.9050906@redhat.com>
 <alpine.DEB.2.00.1002262006000.8247@p34.internal.lan>
 <4B887160.2090606@redhat.com>
 <4B887548.50508@redhat.com>
 <alpine.DEB.2.00.1002270513280.17433@p34.internal.lan>
 <alpine.DEB.2.00.1002270550330.17433@p34.internal.lan>
 <alpine.DEB.2.00.1002270607020.17433@p34.internal.lan>
 <alpine.DEB.2.00.1002270634200.17433@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:58585 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab0B1Fm4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 28 Feb 2010 00:42:56 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002270634200.17433@p34.internal.lan>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Feb 27, 2010 at 06:36:37AM -0500, Justin Piszcz wrote:
> 
> I still would like to know however, why 350MiB/s seems to be the maximum
> performance I can get from two different md raids (that easily do 600MiB/s
> with XFS).

Can you run "filefrag -v <filename>" on the large file you created
using dd?  Part of the problem may be the block allocator simply not
being well optimized super large writes.  To be honest, that's not
something we've tried (at all) to optimize, mainly because for most
users of ext4 they're more interested in much more reasonable sized
files, and we only have so many hours in a day to hack on ext4.  :-)
XFS in contrast has in the past had plenty of paying customers
interested in writing really large scientific data sets, so this is
something Irix *has* spent time optimizing.

As far as I know none of the ext4 developers' day jobs are currently
focused on really large files using ext4.  Some of us do use ext4 to
support really large files, but it's via some kind of cluster or
parallel file system layered on top of ext4 (i.e., Sun/Clusterfs
Lustre File Systems, or Google's GFS) --- and so what gets actually
stored in ext4 isn't a single 10-20 gigabyte file.

I'm saying this not as an excuse; but it's an explanation for why no
one has really noticed this performance problem until you brought it
up.  I'd like to see ext4 be a good general purpose file system, which
includes handling the really big files stored in a single system.  But
it's just not something we've tried optimizing yet.

So if you can gather some data, such as the filefrag information, that
would be a great first step.  Something else that would be useful is
gathering blktrace information, so we can see how we are scheduling
the writes and whether we have something bad going on there.  I
wouldn't be surprised if there is some stupidity going on in the
generic FS/MM writeback code which is throttling us, and which XFS has
worked around.  Ext4 has worked around some writeback brain-damage
already, but I've been focused on much smaller files (files in the
tens or hundreds megabytes) since that's what I tend to use much more
frequently.

It's great to see that you're really interested in this; if you're
willing to do some investigative work, hopefully it's something we can
address.

Best Regards,

						- Ted

P.S.  I'm a bit unclear regarding your comment about "-o nodelalloc"
in one of your earlier threads.  Does using nodelalloc actually speeds
things up?  There were a bunch of numbers being thrown around, and in
some configurations I thought you were getting around 300 MB/s without
using nodelalloc?  Or am I misunderstanding your numbers and what
configuratoins you used with each test run?

If nodelalloc is actually speeding things up, then we almost certainly
have some kind of writeback problem.  So filefrag and blktrace are
definitely the tools we need to look at to understand what is going
on.
