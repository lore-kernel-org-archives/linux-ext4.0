From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: fallocate support for bitmap-based files
Date: Sat, 30 Jun 2007 01:14:36 -0400
Message-ID: <20070630051436.GB5535@schatzie.adilger.int>
References: <20070629130120.ec0d1c75.akpm@linux-foundation.org> <20070629205525.GD32178@thunk.org> <20070629214615.GB5026@schatzie.adilger.int> <46858716.2050901@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sreenivasa Busam <sreenivasac@google.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Mike Waychison <mikew@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:59784 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbXF3FOi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jun 2007 01:14:38 -0400
Content-Disposition: inline
In-Reply-To: <46858716.2050901@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 29, 2007  18:26 -0400, Mike Waychison wrote:
> Andreas Dilger wrote:
> >I don't think ext2 is safe for > 8TB filesystems anyways, so this
> >isn't a huge loss.
> 
> This is reference to the idea of overloading the high-bit and not 
> related to the >PAGE_SIZE blocks correct?

Correct - just that the high-bit use wouldn't unduely impact the
already-existing 8TB limit of ext2.

The other thing to note is that Val Henson already ported the ext3
reservation code to ext2, so this is a pretty straight forward
option for you and also doesn't affect the on-disk format.

> >The other possibility is, assuming Google likes ext2 because they
> >don't care about e2fsck, is to patch ext4 to not use any
> >journaling (i.e. make all of the ext4_journal*() wrappers be
> >no-ops).  That way they would get extents, mballoc and other speedups.
> 
> We do care about the e2fsck problem, though the cost/benefit of e2fsck 
> times/memory problems vs the overhead of journalling doesn't weigh in 
> journalling's favour for a lot of our per-spindle-latency bound 
> applications.  These apps manage to get pretty good disk locality 
> guarantees and the journal overheads can induce undesired head movement.

You could push the journal to a separate spindle, but that may not be
practical.

> ext4 does look very promising, though I'm not certain it's ready for our 
> consumption.

FYI, the extents code (the most complex part of ext4) has been running for
a couple of years on many PB of storage at CFS, so it is by no means new
and untried code.  There are definitely less-well tested changes in ext4
but they are mostly straight forward.  I'm not saying you should jump right
into ext4, but it isn't as far away as you might think.

> What are people's thoughts on providing ext3 non-journal mode?  We could 
> benefit from several of the additions to ext3 that aren't available in 
> ext2 and disabling journalling there sounds much more feasible for us 
> instead of trying to backport each ext3 component to ext2.

This is something we've talked about for a long time, and I'd be happy to
have this possibility.  This would also allow you to take similar advantage
of extents, the improved allocator and other features.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
