From: Mel Gorman <mel@csn.ul.ie>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Thu, 17 Jan 2008 22:12:21 +0000
Message-ID: <20080117221220.GC25975@csn.ul.ie>
References: <169450.15299.qm@web32606.mail.mud.yahoo.com>
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
Received: from gir.skynet.ie ([193.1.99.77]:46800 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbYAQWMX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Jan 2008 17:12:23 -0500
Content-Disposition: inline
In-Reply-To: <169450.15299.qm@web32606.mail.mud.yahoo.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On (17/01/08 13:50), Martin Knoblauch didst pronounce:
> > <mail manglement snipped>
> 
> The effect  is  defintely  depending on  the  IO  hardware. I performed the same tests
> on a different box with an AACRAID controller and there things look different.

I take it different also means it does not show this odd performance
behaviour and is similar whether the patch is applied or not?

> Basically
> the "offending" commit helps seingle stream performance on that box, while dual/triple
> stream are not affected. So I suspect that the CCISS is just not behaving well.
> 
> And yes, the tests are usually done on a freshly booted box. Of course, I repeat them
> a few times. On the CCISS box the numbers are very constant. On the AACRAID box
> they vary quite a bit.
> 
>  I can certainly stress the box before doing the tests. Please define "many" for the kernel
> compiles :-)
> 

With 8GiB of RAM, try making 24 copies of the kernel and compiling them
all simultaneously. Running that for for 20-30 minutes should be enough to
randomise the freelists affecting what color of page is used for the dd test.

> > >  OK, the change happened between rc5 and rc6. Just following a
> > > gut feeling, I reverted
> > > 
> > > #commit 81eabcbe0b991ddef5216f30ae91c4b226d54b6d
> > > #Author: Mel Gorman 
> > > #Date:   Mon Dec 17 16:20:05 2007 -0800
> > > #
> 
> > > 
> > > This has brought back the good results I observed and reported.
> > > I do not know what to make out of this. At least on the systems
> > > I care about (HP/DL380g4, dual CPUs, HT-enabled, 8 GB Memory,
> > > SmartaArray6i controller with 4x72GB SCSI disks as RAID5 (battery
> > > protected writeback cache enabled) and gigabit networking (tg3)) this
> > > optimisation is a dissaster.
> > > 
> > 
> > That patch was not an optimisation, it was a regression fix
> > against 2.6.23 and I don't believe reverting it is an option. Other IO
> > hardware benefits from having the allocator supply pages in PFN order.
> 
>  I think this late in the 2.6.24 game we just should leave things as they are. But
> we should try to find a way to make CCISS faster, as it apparently can be faster.
> 
> > Your controller would seem to suffer when presented with the same situation
> > but I don't know why that is. I've added James to the cc in case he has seen this
> > sort of situation before.
> > 
> > > On the other hand, it is not a regression against 2.6.22/23. Those
> > 
>  > had bad IO scaling to. It would just be a shame to loose an apparently
> > 
>  > great performance win.
> > 
> > Could you try running your tests again when the system has been
> > stressed with some other workload first?
> > 
> 
>  Will do.
> 

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
