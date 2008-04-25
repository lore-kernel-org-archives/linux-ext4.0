From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 10:29:36 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0804251024400.2779@woody.linux-foundation.org>
References: <20080425152650.GA894@elte.hu> <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org> <20080425154854.GC3265@one.firstfloor.org> <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org> <20080425162215.GA16273@elte.hu>
 <alpine.LFD.1.10.0804250925341.2779@woody.linux-foundation.org> <20080425164509.GB19962@elte.hu> <alpine.LFD.1.10.0804250950360.2779@woody.linux-foundation.org> <20080425170237.GA24472@elte.hu> <alpine.LFD.1.10.0804251009340.2779@woody.linux-foundation.org>
 <20080425172651.GF3265@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ingo Molnar <mingo@elte.hu>, Jiri Slaby <jirislaby@gmail.com>,
	David Miller <davem@davemloft.net>, zdenek.kabelac@gmail.com,
	rjw@sisk.pl, paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
	linux-ext4@vger.kernel.org, herbert@gondor.apana.org.au,
	penberg@cs.helsinki.fi, clameter@sgi.com,
	linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	pageexec@freemail.hu, "H. Peter Anvin" <hpa@zytor.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760447AbYDYRc0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Apr 2008 13:32:26 -0400
In-Reply-To: <20080425172651.GF3265@one.firstfloor.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Fri, 25 Apr 2008, Andi Kleen wrote:
> 
> For suspend/resume we can actually just disable all the text_poke()s.
> They are not needed because we don't expect to stay in single CPU
> mode for long after wake up and they will just be undone again.

I do agree that we might decide to just not do this at all except for the 
actual physical bootup phase (which can use early_text_poke()). There may 
not be a whole lot of point to ever play with smp_alterinatives() at any 
other time.

> I guess if it really was a problem (but really I haven't heard about it)
> the easiest fix would be to just extended system_state to SYSTEM_SUSPEND
> and then skip them if that is true. 

Our device suspend right now takes about 3.5 seconds (that's using the 
debug thing, which adds a 5-second timeout). That *is* a problem, but it's 
historically been hidden by the fact that people are happy that suspend 
works at all when it does. 

These days, we're getting to the point (I think) that a lot more people 
are going to take suspend for granted. And I'd actually like to use it as 
a sleep state for desktop like usage (let's face it, when the screen goes 
dark, the CPU should just go into suspend too if it's used as a desktop by 
non-technical users).

And for that to be useful, it needs to come up quickly. Not add another 
second on top of the already-irritating delay of the screen waking up.

Are we there yet? Hell no. But I don't think we're too far off.

			Linus
