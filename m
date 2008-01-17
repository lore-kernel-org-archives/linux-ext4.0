From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Thu, 17 Jan 2008 09:44:35 -0800 (PST)
Message-ID: <411558.92960.qm@web32601.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mike Snitzer <snitzer@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>, jplatte@naasa.net,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from web32601.mail.mud.yahoo.com ([68.142.207.228]:37673 "HELO
	web32601.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751701AbYAQRoj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Jan 2008 12:44:39 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

----- Original Message ----
> From: Martin Knoblauch <spamtrap@knobisoft.de>
> To: Fengguang Wu <wfg@mail.ustc.edu.cn>
> Cc: Mike Snitzer <snitzer@gmail.com>; Peter Zijlstra <peterz@infradead.org>; jplatte@naasa.net; Ingo Molnar <mingo@elte.hu>; linux-kernel@vger.kernel.org; "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>; Linus Torvalds <torvalds@linux-foundation.org>
> Sent: Thursday, January 17, 2008 2:52:58 PM
> Subject: Re: regression: 100% io-wait with 2.6.24-rcX
> 
> ----- Original Message ----
> > From: Fengguang Wu 
> > To: Martin Knoblauch 
> > Cc: Mike Snitzer ; Peter
> Zijlstra
> 
 ; jplatte@naasa.net; Ingo Molnar
> ;
> 
 linux-kernel@vger.kernel.org;
> "linux-ext4@vger.kernel.org"
> 
 ; Linus
> Torvalds
> 
 
> > Sent: Wednesday, January 16, 2008 1:00:04 PM
> > Subject: Re: regression: 100% io-wait with 2.6.24-rcX
> > 
> > On Wed, Jan 16, 2008 at 01:26:41AM -0800, Martin Knoblauch wrote:
> > > > For those interested in using your writeback improvements in
> > > > production sooner rather than later (primarily with ext3); what
> > > > recommendations do you have?  Just heavily test our own 2.6.24
> > +
> > 
>  your
> > > > evolving "close, but not ready for merge" -mm writeback patchset?
> > > > 
> > > Hi Fengguang, Mike,
> > > 
> > >  I can add myself to Mikes question. It would be good to know
> > a
> > 
>  "roadmap" for the writeback changes. Testing 2.6.24-rcX so far has
> > been
> > 
>  showing quite nice improvement of the overall writeback situation and
> > it
> > 
>  would be sad to see this [partially] gone in 2.6.24-final.
> > Linus
> > 
>  apparently already has reverted  "...2250b". I will definitely
> repeat
> 
 my
> > tests
> > 
>  with -rc8. and report.
> > 
> > Thank you, Martin. Can you help test this patch on 2.6.24-rc7?
> > Maybe we can push it to 2.6.24 after your testing.
> > 
> Hi Fengguang,
> 
>  something really bad has happened between -rc3 and
> -rc6.
> 
 Embarrassingly I did not catch that earlier :-(
> 
>  Compared to the numbers I posted
> in
> 
 http://lkml.org/lkml/2007/10/26/208 , dd1 is now at 60 MB/sec
> (slight
> 
 plus), while dd2/dd3 suck the same way as in pre 2.6.24. The only
> test
> 
 that is still good is mix3, which I attribute to the per-BDI stuff.
> 
>  At the moment I am frantically trying to find when things went down.
> I
> 
 did run -rc8 and rc8+yourpatch. No difference to what I see with
> -rc6.
> 
 Sorry that I cannot provide any input to your patch.
> 

 OK, the change happened between rc5 and rc6. Just following a gut feeling, I reverted

#commit 81eabcbe0b991ddef5216f30ae91c4b226d54b6d
#Author: Mel Gorman <mel@csn.ul.ie>
#Date:   Mon Dec 17 16:20:05 2007 -0800
#
#    mm: fix page allocation for larger I/O segments
#    
#    In some cases the IO subsystem is able to merge requests if the pages are
#    adjacent in physical memory.  This was achieved in the allocator by having
#    expand() return pages in physically contiguous order in situations were a
#    large buddy was split.  However, list-based anti-fragmentation changed the
#    order pages were returned in to avoid searching in buffered_rmqueue() for a
#    page of the appropriate migrate type.
#    
#    This patch restores behaviour of rmqueue_bulk() preserving the physical
#    order of pages returned by the allocator without incurring increased search
#    costs for anti-fragmentation.
#    
#    Signed-off-by: Mel Gorman <mel@csn.ul.ie>
#    Cc: James Bottomley <James.Bottomley@steeleye.com>
#    Cc: Jens Axboe <jens.axboe@oracle.com>
#    Cc: Mark Lord <mlord@pobox.com
#    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
#    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
diff -urN linux-2.6.24-rc5/mm/page_alloc.c linux-2.6.24-rc6/mm/page_alloc.c
--- linux-2.6.24-rc5/mm/page_alloc.c    2007-12-21 04:14:11.305633890 +0000
+++ linux-2.6.24-rc6/mm/page_alloc.c    2007-12-21 04:14:17.746985697 +0000
@@ -847,8 +847,19 @@
                struct page *page = __rmqueue(zone, order, migratetype);
                if (unlikely(page == NULL))
                        break;
+
+               /*
+                * Split buddy pages returned by expand() are received here
+                * in physical page order. The page is added to the callers and
+                * list and the list head then moves forward. From the callers
+                * perspective, the linked list is ordered by page number in
+                * some conditions. This is useful for IO devices that can
+                * merge IO requests if the physical pages are ordered
+                * properly.
+                */
                list_add(&page->lru, list);
                set_page_private(page, migratetype);
+               list = &page->lru;
        }
        spin_unlock(&zone->lock);
        return i;



This has brought back the good results I observed and reported.
I do not know what to make out of this. At least on the systems I care
about (HP/DL380g4, dual CPUs, HT-enabled, 8 GB Memory, SmartaArray6i
controller with 4x72GB SCSI disks as RAID5 (battery protected writeback
cache enabled) and gigabit networking (tg3)) this optimisation is a dissaster.

 On the other hand, it is not a regression against 2.6.22/23. Those had
bad IO scaling to. It would just be a shame to loose an apparently great
performance win.
is

Cheers
Martin
