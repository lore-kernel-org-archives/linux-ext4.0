From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 20:13:13 +0200
Message-ID: <20080425181313.GA4286@elte.hu>
References: <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org> <20080425154854.GC3265@one.firstfloor.org> <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org> <20080425162215.GA16273@elte.hu> <alpine.LFD.1.10.0804250925341.2779@woody.linux-foundation.org> <20080425164509.GB19962@elte.hu> <alpine.LFD.1.10.0804250950360.2779@woody.linux-foundation.org> <20080425170237.GA24472@elte.hu> <alpine.LFD.1.10.0804251009340.2779@woody.linux-foundation.org> <20080425175333.GA25276@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	pageexec@freemail.hu, "H. Peter Anvin" <hpa@zytor.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:38277 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932717AbYDYSN7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 14:13:59 -0400
Content-Disposition: inline
In-Reply-To: <20080425175333.GA25276@elte.hu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


* Ingo Molnar <mingo@elte.hu> wrote:

> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > > performance i dont think we should be too worried about at this 
> > > moment - this code is so rarely used that it should be driven by 
> > > robustness i think.
> > 
> > That really isn't true. This isn't done just once. It's done many 
> > thousands of times.
> > 
> > I agree that it has to be robust, but if we want to make 
> > suspend/resume be instantaneous (and we do), performance does 
> > actually matter. Yes, this is probably much less of a problem than 
> > waiting for devices, and no, I haven't timed it, but if I counted 
> > right, we'll literally be going almost ten thousand of these calls 
> > over a suspend/resume cycle.
> > 
> > That's not "rarely used".
> 
> yeah, it's done 2800 times on my box with a distro .config.
> 
> no strong feeling either way - but i dont think there's any cross-CPU 
> TLB flush done in this case within vmap()/vunmap(). Why? Because when 
> alternative_instructions() runs then we have just a single CPU in 
> cpu_online_map.
> 
> So i think it's only direct vmap()/vunmap() overhead, on a single CPU. 
> We do a kmalloc/kfree which is rather fast - sub-microsecond. We 
> install the pages in the pte's - this is rather fast as well - 
> sub-microsecond. Even assuming cache-cold lines (which they are most 
> of the time) and taken thousands of times that's at most a few 
> milliseconds IMO.
> 
> In fact, most of the actual vmap() related overhead should be 
> well-cached (the kmalloc bits) - the main cost should come from 
> trashing through all the instruction sites and modifying them.

i just did some direct measurements of alternatives_smp_switch() itself:

 alternatives took: 7374 usecs
 alternatives took: 8775 usecs
 alternatives took: 7498 usecs
 alternatives took: 8776 usecs

that's on a ~2GHz Athlon64 X2 - so not the latest hw.

i also added a sysctl to turn alternatives patching on/off, and the CPU 
offline+online cycle:

  # alternatives on:
  real    0m0.152s
  real    0m0.172s

  # alternatives off:
  real    0m0.146s
  real    0m0.168s

so it's measurable and it is in the few milliseconds range. (But there 
seems to be strong dependency on the kernel image layout or some other 
detail - compare these timings to my previous timings - they were 
radically different.)

	Ingo
