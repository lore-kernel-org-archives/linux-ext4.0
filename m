From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/6] libext2fs/e2fsck: provide routines to read-ahead
 metadata
Date: Mon, 11 Aug 2014 11:55:32 -0700
Message-ID: <20140811185532.GA1695@birch.djwong.org>
References: <20140809042610.2441.6868.stgit@birch.djwong.org>
 <20140809042643.2441.79312.stgit@birch.djwong.org>
 <20140811052151.GA2808@birch.djwong.org>
 <20140811062415.GG15431@thunk.org>
 <20140811063120.GB2808@birch.djwong.org>
 <20140811143423.GB3506@thunk.org>
 <20140811180509.GE2808@birch.djwong.org>
 <20140811183258.GF6553@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31079 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570AbaHKSzi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Aug 2014 14:55:38 -0400
Content-Disposition: inline
In-Reply-To: <20140811183258.GF6553@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 11, 2014 at 02:32:58PM -0400, Theodore Ts'o wrote:
> On Mon, Aug 11, 2014 at 11:05:09AM -0700, Darrick J. Wong wrote:
> > 
> > Using the bitmap turns out to be pretty quick (~130us to start RA for 4 groups
> > vs. ~70us per group if I issue the RA directly).  Each fadvise call seems to
> > cost us ~1ms, so I'll keep using the bitmap to minimize the number of fadvise
> > calls, since it's also a lot less code.
> 
> 4 groups?  Since the default flex_bg size is 16 block groups, I would
> have expected that you would want to start RA every 16 groups.

I was expecting 16 groups (32M readahead) to win, but as the observations in my
spreadsheet show, 2MB tends to win.  I _think_ the reason is that if we
encounter indirect map blocks or ETB blocks, they tend to be fairly close to
the file blocks in the block group, and if we're trying to do a large readahead
at the same time, we end up with a largeish seek penalty (half the flexbg on
average) for every ETB/map block.

I figured out what was going on with the 1TB SSD -- it has a huge RAM cache big
enough to store most of the metadata.  At that point, reads are essentially
free, but readahead costs us ~1ms per fadvise call.  If you use a RA buffer
that's big enough that there aren't many fadvise calls then you still come out
ahead (ditto if you shove the RA into a separate thread) but otherwise the
fadvise calls add up, badly.

Actually, I'd considered using a default of flexbg_size * itable_size, but (a)
the USB results are pretty bad for 32M v. 2M, and (b) I was thinking that 2MB
of readahead might be small enough that we could enable it by default without
having to worry about the mal-effects of parallel e2fsck runs.

A logical next step might be to do ETB/block map readahead, but let's keep it
simple for now.  I should have time to update the spreadsheet to reflect
performance of the new bitmap code while I go mess with fixing the jbd2
problems.

> (And BTW, I've been wondering whether we should increase the flex_bg
> size for bigger file systems.  By the time we get to 4TB disks, Having
> a flex_bg every 2GB seems a little small.)

:)

--D
> 
> 						- Ted
