From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/6] libext2fs/e2fsck: provide routines to read-ahead
 metadata
Date: Mon, 11 Aug 2014 13:50:19 -0700
Message-ID: <20140811205019.GB1695@birch.djwong.org>
References: <20140809042610.2441.6868.stgit@birch.djwong.org>
 <20140809042643.2441.79312.stgit@birch.djwong.org>
 <20140811052151.GA2808@birch.djwong.org>
 <20140811062415.GG15431@thunk.org>
 <20140811063120.GB2808@birch.djwong.org>
 <20140811143423.GB3506@thunk.org>
 <20140811180509.GE2808@birch.djwong.org>
 <20140811183258.GF6553@thunk.org>
 <20140811185532.GA1695@birch.djwong.org>
 <20140811201030.GH6553@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17926 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692AbaHKUuZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Aug 2014 16:50:25 -0400
Content-Disposition: inline
In-Reply-To: <20140811201030.GH6553@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 11, 2014 at 04:10:30PM -0400, Theodore Ts'o wrote:
> On Mon, Aug 11, 2014 at 11:55:32AM -0700, Darrick J. Wong wrote:
> > I was expecting 16 groups (32M readahead) to win, but as the observations in my
> > spreadsheet show, 2MB tends to win.  I _think_ the reason is that if we
> > encounter indirect map blocks or ETB blocks, they tend to be fairly close to
> > the file blocks in the block group, and if we're trying to do a large readahead
> > at the same time, we end up with a largeish seek penalty (half the flexbg on
> > average) for every ETB/map block.
> 
> Hmm, that might be an argument for not trying to increase the flex_bg
> size, since we want to keep seek distances within a flex_bg to be
> dominated by settling time, and not by the track-to-track
> accelleration/coasting/deaccelleration time.

It might not be too horrible of a regression, since the distance between tracks
has gotten shorter and cylinders themselves have gotten bigger.  I suppose
you'd have to test a variety of flexbg sizes against a disk from, say, 5 years
ago.  If you know the size of the files you'll be storing at mkfs time (such as
with the mk_hugefiles.c options) then increasing flexbg size is probably ok to
avoid fragmenting.

But yes, I was sort of enjoying how stuff within a flexbg gets (sort of) faster
as disks get bigger. :)

> > I figured out what was going on with the 1TB SSD -- it has a huge RAM cache big
> > enough to store most of the metadata.  At that point, reads are essentially
> > free, but readahead costs us ~1ms per fadvise call. 
> 
> Do we understand why fadvise() takes 1ms?   Is that something we can fix?
> 
> And readahead(2) was even worse, right?

>From the readahead(2) manpage:

"readahead() blocks until the specified data has been read."

The fadvise time is pretty consistently 1ms, but with readahead you have to
wait for it to read everything off the disk.  That's fine for threaded
readahead, but for our single-thread readahead it's not much better than
regular blocking reads.  Letting the kernel do the readahead in the background
is way faster.

I don't know why fadvise takes so long.  I'll ftrace it to see where it goes.

--D
> 
> 							- Ted
