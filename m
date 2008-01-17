From: Mel Gorman <mel@csn.ul.ie>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Thu, 17 Jan 2008 20:23:57 +0000
Message-ID: <20080117202356.GA25975@csn.ul.ie>
References: <411558.92960.qm@web32601.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>,
	Mike Snitzer <snitzer@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>, jplatte@naasa.net,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	James.Bottomley@steeleye.com
To: Martin Knoblauch <spamtrap@knobisoft.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gir.skynet.ie ([193.1.99.77]:56262 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbYAQUYB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Jan 2008 15:24:01 -0500
Content-Disposition: inline
In-Reply-To: <411558.92960.qm@web32601.mail.mud.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On (17/01/08 09:44), Martin Knoblauch didst pronounce:
> > > > > > > On Wed, Jan 16, 2008 at 01:26:41AM -0800, Martin Knoblauch wrote:
> > > > > > For those interested in using your writeback improvements in
> > > > > > production sooner rather than later (primarily with ext3); what
> > > > > > recommendations do you have?  Just heavily test our own 2.6.24
> > > > > > evolving "close, but not ready for merge" -mm writeback patchset?
> > > > > > 
> > > > > 
> > > > >  I can add myself to Mikes question. It would be good to know a
> > > > 
> > > > "roadmap" for the writeback changes. Testing 2.6.24-rcX so far has
> > > > been showing quite nice improvement of the overall writeback situation and
> > > > it would be sad to see this [partially] gone in 2.6.24-final.
> > > > Linus apparently already has reverted  "...2250b". I will definitely
> > > > repeat my tests  with -rc8. and report.
> > > > 
> > > Thank you, Martin. Can you help test this patch on 2.6.24-rc7?
> > > Maybe we can push it to 2.6.24 after your testing.
> > > 
> > Hi Fengguang,
> > 
> > something really bad has happened between -rc3 and -rc6.
> > Embarrassingly I did not catch that earlier :-(
> > Compared to the numbers I posted in
> > http://lkml.org/lkml/2007/10/26/208 , dd1 is now at 60 MB/sec
> > (slight plus), while dd2/dd3 suck the same way as in pre 2.6.24.
> > The only test that is still good is mix3, which I attribute to
> > the per-BDI stuff.

I suspect that the IO hardware you have is very sensitive to the color of the
physical page. I wonder, do you boot the system cleanly and then run these
tests? If so, it would be interesting to know what happens if you stress
the system first (many kernel compiles for example, basically anything that
would use a lot of memory in different ways for some time) to randomise the
free lists a bit and then run your test. You'd need to run the test
three times for 2.6.23, 2.6.24-rc8 and 2.6.24-rc8 with the patch you
identified reverted.

> > At the moment I am frantically trying to find when things went down. I
> > did run -rc8 and rc8+yourpatch. No difference to what I see with -rc6.
> > 
> > Sorry that I cannot provide any input to your patch.
> 
>  OK, the change happened between rc5 and rc6. Just following a gut feeling, I reverted
> 
> #commit 81eabcbe0b991ddef5216f30ae91c4b226d54b6d
> #Author: Mel Gorman <mel@csn.ul.ie>
> #Date:   Mon Dec 17 16:20:05 2007 -0800
> #
> #    mm: fix page allocation for larger I/O segments
> #    
> #    In some cases the IO subsystem is able to merge requests if the pages are
> #    adjacent in physical memory.  This was achieved in the allocator by having
> #    expand() return pages in physically contiguous order in situations were a
> #    large buddy was split.  However, list-based anti-fragmentation changed the
> #    order pages were returned in to avoid searching in buffered_rmqueue() for a
> #    page of the appropriate migrate type.
> #    
> #    This patch restores behaviour of rmqueue_bulk() preserving the physical
> #    order of pages returned by the allocator without incurring increased search
> #    costs for anti-fragmentation.
> #    
> #    Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> #    Cc: James Bottomley <James.Bottomley@steeleye.com>
> #    Cc: Jens Axboe <jens.axboe@oracle.com>
> #    Cc: Mark Lord <mlord@pobox.com
> #    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> #    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> diff -urN linux-2.6.24-rc5/mm/page_alloc.c linux-2.6.24-rc6/mm/page_alloc.c
> --- linux-2.6.24-rc5/mm/page_alloc.c    2007-12-21 04:14:11.305633890 +0000
> +++ linux-2.6.24-rc6/mm/page_alloc.c    2007-12-21 04:14:17.746985697 +0000
> @@ -847,8 +847,19 @@
>                 struct page *page = __rmqueue(zone, order, migratetype);
>                 if (unlikely(page == NULL))
>                         break;
> +
> +               /*
> +                * Split buddy pages returned by expand() are received here
> +                * in physical page order. The page is added to the callers and
> +                * list and the list head then moves forward. From the callers
> +                * perspective, the linked list is ordered by page number in
> +                * some conditions. This is useful for IO devices that can
> +                * merge IO requests if the physical pages are ordered
> +                * properly.
> +                */
>                 list_add(&page->lru, list);
>                 set_page_private(page, migratetype);
> +               list = &page->lru;
>         }
>         spin_unlock(&zone->lock);
>         return i;
> 
> This has brought back the good results I observed and reported.
> I do not know what to make out of this. At least on the systems I care
> about (HP/DL380g4, dual CPUs, HT-enabled, 8 GB Memory, SmartaArray6i
> controller with 4x72GB SCSI disks as RAID5 (battery protected writeback
> cache enabled) and gigabit networking (tg3)) this optimisation is a dissaster.
> 

That patch was not an optimisation, it was a regression fix against 2.6.23
and I don't believe reverting it is an option. Other IO hardware benefits
from having the allocator supply pages in PFN order. Your controller would
seem to suffer when presented with the same situation but I don't know why
that is. I've added James to the cc in case he has seen this sort of
situation before.

> On the other hand, it is not a regression against 2.6.22/23. Those had
> bad IO scaling to. It would just be a shame to loose an apparently great
> performance win.
> is

Could you try running your tests again when the system has been stressed
with some other workload first?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
