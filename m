From: Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 1/6] ext2 balloc: fix _with_rsv freeze
Date: Tue, 28 Nov 2006 20:07:57 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0611281940170.4516@blonde.wat.veritas.com>
References: <1164741967.3769.27.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andrew Morton <akpm@osdl.org>, Mel Gorman <mel@skynet.ie>,
	"Martin J. Bligh" <mbligh@mbligh.org>,
	linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:59343 "EHLO
	extu-mxob-1.symantec.com") by vger.kernel.org with ESMTP
	id S936092AbWK1UIo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Nov 2006 15:08:44 -0500
Received: from balaton.wat.veritas.com([10.10.97.7]) (6332 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1Gp9Eu-0000s4C@megami.veritas.com>
	for <linux-ext4@vger.kernel.org>; Tue, 28 Nov 2006 12:07:36 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
To: Mingming Cao <cmm@us.ibm.com>
In-Reply-To: <1164741967.3769.27.camel@dyn9047017103.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, 28 Nov 2006, Mingming Cao wrote:
> On Tue, 2006-11-28 at 17:40 +0000, Hugh Dickins wrote:
> > After several days of testing ext2 with reservations, it got caught inside
> > ext2_try_to_allocate_with_rsv: alloc_new_reservation repeatedly succeeding
> > on the window [12cff,12d0e], ext2_try_to_allocate repeatedly failing to
> > find the free block guaranteed to be included (unless there's contention).
> > 
> 
> Hmm, I suspect there is other issue: alloc_new_reservation should not
> repeatedly allocating the same window, if ext2_try_to_allocate
> repeatedly fails to find a free block in that window.
> find_next_reservable_window() takes my_rsv (the old window that he
> thinks there is no free block) as a guide to find a window "after" the
> end block of my_rsv, so how could this happen?

Hmmm.  I haven't studied that part of the code, but what you say sounds
sensible: that would leave more to be explained, yes.  I guess it would
happen if all the rest of the bitmap were either allocated or reserved,
but I don't believe that was the case here: I have noted that the map
was all 00s from offset 0x1ae onwards, plenty unallocated; I've not
recorded the following reservations, but it seems unlikely they covered
the remaining free area (and still covered it even when the remaining
tasks got to the point of just waiting for this one).

> 
> > Fix the range to find_next_usable_block's memscan: the scan from "here"
> > (0xcfe) up to (but excluding) "maxblocks" (0xd0e) needs to scan 3 bytes
> > not 2 (the relevant bytes of bitmap in this case being f7 df ff - none
> > 00, but the premature cutoff implying that the last was found 00).
> > 
> 
> alloc_new_reservation() reserved a window with free block, when come to
> the time to claim it, it scans the window again. So it seems that the
> range of the the scan is too small:

The range of the scan is 1 byte too small in this case, yes.

> 
>         p = ((char *)bh->b_data) + (here >> 3);
>         r = memscan(p, 0, (maxblocks - here + 7) >> 3);
>         next = (r - ((char *)bh->b_data)) << 3;
> 
> 		--------------------->   next is -1

I don't understand you: next was not -1, it was 0xd08.

>         if (next < maxblocks && next >= here)
>                 return next;
> 
> 		----------------------> falls to false branch

No, it passed the "next < maxblocks && next >= here" test
(maxblocks being 0xd0e and here being 0xcfe), so returned
pointing to an allocated block - then the caller finds it
cannot set the bit.

> 
>         here = bitmap_search_next_usable_block(here, bh, maxblocks);
>         return here;
> 
> So we failed to find a free byte in the range.  That's seems fine to me.
> It's only a nice thing to have -- try to allocate a block in a place
> where it's neighbors are all free also. If it fails, it will search the
> window bit by bit. So I don't understand why it is not being recovered
> by bitmap_search_next_usable_block(), which test the bitmap bit by bit? 

It already returned, it doesn't reach that line.

> 
> > Is this a problem for mainline ext2?  No, because the "size" in its memscan
> > is always EXT2_BLOCKS_PER_GROUP(sb), which mkfs.ext2 requires to be a
> > multiple of 8.  Is this a problem for ext3 or ext4?  No, because they have
> > an additional extN_test_allocatable test which rescues them from the error.
> > 
> Hmm, if the error is it prematurely think there is no free block in the
> range (bitmap on disk), then even in ext3/4, it will not bother checking
> the jbd copy of the bitmap. I am not sure this is the cause that ext3/4
> may not has the problem.

In the ext3/4 case, it indeed won't bother to check the jbd copy
(having found this bitmap bit set), it'll fall through to the
bitmap_search_next_usable_block you indicated above,
and that should do the right thing, finding the first
free bit in the area originally reserved.

> 
> > But the bigger question is, why does the my_rsv case come here to
> > find_next_usable_block at all? 
> 
> Because grp_goal is -1?

Well, yes, but my point is that we've got a reservation, and we're
hoping to allocate from it (even though we've given up on the "goal"),
but find_next_usable_block is not respecting it at all - liable to be
allocating out of others' reservations instead.

> 
> >  Doesn't its 64-bit boundary limit, and its
> > memscan, blithely ignore what the reservation prepared?
> 
> I agree with you that the double check is urgly. But it's necessary:( If
> there to prevent contention: other file make steal that free block we
> reserved for this file, in the case filesystem is full of reservation...

I agree it's necessary to recheck the allocation; I disagree that the
64-bit boundary limit and memscan are appropriate when my_rsv is set.

> 
> >   It's messy too,
> > the complement of the memscan being that "i < 7" loop over in
> > ext2_try_to_allocate.  I think this ought to be cleaned up,
> > in ext2+reservations and ext3 and ext4.
> > 
> The "i<7" loop there is for non reservation case. Since
> find_next_usable_block() could find a free byte, it's trying to avoid
> filesystem holes by shifting the start of the free block for at most 7
> times.

Yes, the "i<7" loop rightly has a !my_rsv check; my point it that it's
the "other end" of the memscan, which was operating 8-bits at a time,
which lacks any my_rsv check (doesn't even know my_rsv at that level).

Hugh
