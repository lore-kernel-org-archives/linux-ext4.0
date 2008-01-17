From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Thu, 17 Jan 2008 13:50:22 -0800 (PST)
Message-ID: <169450.15299.qm@web32606.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>,
	Mike Snitzer <snitzer@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>, jplatte@naasa.net,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	James.Bottomley@steeleye.com
To: Mel Gorman <mel@csn.ul.ie>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from web32606.mail.mud.yahoo.com ([68.142.207.233]:41870 "HELO
	web32606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759880AbYAQVuX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Jan 2008 16:50:23 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

----- Original Message ----
> From: Mel Gorman <mel@csn.ul.ie>
> To: Martin Knoblauch <spamtrap@knobisoft.de>
> Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>; Mike Snitzer <snitzer@gmail.com>; Peter Zijlstra <peterz@infradead.org>; jplatte@naasa.net; Ingo Molnar <mingo@elte.hu>; linux-kernel@vger.kernel.org; "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>; Linus Torvalds <torvalds@linux-foundation.org>; James.Bottomley@steeleye.com
> Sent: Thursday, January 17, 2008 9:23:57 PM
> Subject: Re: regression: 100% io-wait with 2.6.24-rcX
> 
> On (17/01/08 09:44), Martin Knoblauch didst pronounce:
> > > > > > > > On Wed, Jan 16, 2008 at 01:26:41AM -0800,
> Martin
> 
 Knoblauch wrote:
> > > > > > > For those interested in using your writeback
> improvements
> 
 in
> > > > > > > production sooner rather than later (primarily with
> ext3);
> 
 what
> > > > > > > recommendations do you have?  Just heavily test our
> own
> 
 2.6.24
> > > > > > > evolving "close, but not ready for merge" -mm
> writeback
> 
 patchset?
> > > > > > > 
> > > > > > 
> > > > > >  I can add myself to Mikes question. It would be good to
> know
> 
 a
> > > > > 
> > > > > "roadmap" for the writeback changes. Testing 2.6.24-rcX so
> far
> 
 has
> > > > > been showing quite nice improvement of the overall
> writeback
> 
 situation and
> > > > > it would be sad to see this [partially] gone in 2.6.24-final.
> > > > > Linus apparently already has reverted  "...2250b". I
> will
> 
 definitely
> > > > > repeat my tests  with -rc8. and report.
> > > > > 
> > > > Thank you, Martin. Can you help test this patch on 2.6.24-rc7?
> > > > Maybe we can push it to 2.6.24 after your testing.
> > > > 
> > > Hi Fengguang,
> > > 
> > > something really bad has happened between -rc3 and -rc6.
> > > Embarrassingly I did not catch that earlier :-(
> > > Compared to the numbers I posted in
> > > http://lkml.org/lkml/2007/10/26/208 , dd1 is now at 60 MB/sec
> > > (slight plus), while dd2/dd3 suck the same way as in pre 2.6.24.
> > > The only test that is still good is mix3, which I attribute to
> > > the per-BDI stuff.
> 
> I suspect that the IO hardware you have is very sensitive to the
> color of the physical page. I wonder, do you boot the system cleanly
> and then run these tests? If so, it would be interesting to know what
> happens if you stress the system first (many kernel compiles for example,
> basically anything that would use a lot of memory in different ways for some
> time) to randomise the free lists a bit and then run your test. You'd need to run
> the test three times for 2.6.23, 2.6.24-rc8 and 2.6.24-rc8 with the patch you
> identified reverted.
>

 The effect  is  defintely  depending on  the  IO  hardware. I performed the same tests
on a different box with an AACRAID controller and there things look different. Basically
the "offending" commit helps seingle stream performance on that box, while dual/triple
stream are not affected. So I suspect that the CCISS is just not behaving well.

 And yes, the tests are usually done on a freshly booted box. Of course, I repeat them
a few times. On the CCISS box the numbers are very constant. On the AACRAID box
they vary quite a bit.

 I can certainly stress the box before doing the tests. Please define "many" for the kernel
compiles :-)

> > 
> >  OK, the change happened between rc5 and rc6. Just following a
> > gut feeling, I reverted
> > 
> > #commit 81eabcbe0b991ddef5216f30ae91c4b226d54b6d
> > #Author: Mel Gorman 
> > #Date:   Mon Dec 17 16:20:05 2007 -0800
> > #

> > 
> > This has brought back the good results I observed and reported.
> > I do not know what to make out of this. At least on the systems
> > I care about (HP/DL380g4, dual CPUs, HT-enabled, 8 GB Memory,
> > SmartaArray6i controller with 4x72GB SCSI disks as RAID5 (battery
> > protected writeback cache enabled) and gigabit networking (tg3)) this
> > optimisation is a dissaster.
> > 
> 
> That patch was not an optimisation, it was a regression fix
> against 2.6.23 and I don't believe reverting it is an option. Other IO
> hardware benefits from having the allocator supply pages in PFN order.

 I think this late in the 2.6.24 game we just should leave things as they are. But
we should try to find a way to make CCISS faster, as it apparently can be faster.

> Your controller would seem to suffer when presented with the same situation
> but I don't know why that is. I've added James to the cc in case he has seen this
> sort of situation before.
> 
> > On the other hand, it is not a regression against 2.6.22/23. Those
> 
 > had bad IO scaling to. It would just be a shame to loose an apparently
> 
 > great performance win.
> 
> Could you try running your tests again when the system has been
> stressed with some other workload first?
> 

 Will do.

Cheers
Martin
