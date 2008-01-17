From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: regression: 100% io-wait with 2.6.24-rcX
Date: Thu, 17 Jan 2008 05:52:58 -0800 (PST)
Message-ID: <400343.10983.qm@web32611.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mike Snitzer <snitzer@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>, jplatte@naasa.net,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from web32611.mail.mud.yahoo.com ([68.142.207.238]:47438 "HELO
	web32611.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751336AbYAQNw7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 17 Jan 2008 08:52:59 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

----- Original Message ----
> From: Fengguang Wu <wfg@mail.ustc.edu.cn>
> To: Martin Knoblauch <knobi@knobisoft.de>
> Cc: Mike Snitzer <snitzer@gmail.com>; Peter Zijlstra <peterz@infradead.org>; jplatte@naasa.net; Ingo Molnar <mingo@elte.hu>; linux-kernel@vger.kernel.org; "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>; Linus Torvalds <torvalds@linux-foundation.org>
> Sent: Wednesday, January 16, 2008 1:00:04 PM
> Subject: Re: regression: 100% io-wait with 2.6.24-rcX
> 
> On Wed, Jan 16, 2008 at 01:26:41AM -0800, Martin Knoblauch wrote:
> > > For those interested in using your writeback improvements in
> > > production sooner rather than later (primarily with ext3); what
> > > recommendations do you have?  Just heavily test our own 2.6.24
> +
> 
 your
> > > evolving "close, but not ready for merge" -mm writeback patchset?
> > > 
> > Hi Fengguang, Mike,
> > 
> >  I can add myself to Mikes question. It would be good to know
> a
> 
 "roadmap" for the writeback changes. Testing 2.6.24-rcX so far has
> been
> 
 showing quite nice improvement of the overall writeback situation and
> it
> 
 would be sad to see this [partially] gone in 2.6.24-final.
> Linus
> 
 apparently already has reverted  "...2250b". I will definitely repeat my
> tests
> 
 with -rc8. and report.
> 
> Thank you, Martin. Can you help test this patch on 2.6.24-rc7?
> Maybe we can push it to 2.6.24 after your testing.
> 
Hi Fengguang,

 something really bad has happened between -rc3 and -rc6. Embarrassingly I did not catch that earlier :-(

 Compared to the numbers I posted in http://lkml.org/lkml/2007/10/26/208 , dd1 is now at 60 MB/sec (slight plus), while dd2/dd3 suck the same way as in pre 2.6.24. The only test that is still good is mix3, which I attribute to the per-BDI stuff.

 At the moment I am frantically trying to find when things went down. I did run -rc8 and rc8+yourpatch. No difference to what I see with -rc6. Sorry that I cannot provide any input to your patch.

Depressed
Martin
