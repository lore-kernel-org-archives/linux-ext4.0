From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 1/1] x86: fix text_poke
Date: Fri, 25 Apr 2008 18:19:17 +0200
Message-ID: <20080425161916.GD3265@one.firstfloor.org>
References: <20080425.021301.193689806.davem@davemloft.net> <1209343883-7991-1-git-send-email-jirislaby@gmail.com> <alpine.LFD.1.10.0804250759260.2779@woody.linux-foundation.org> <20080425151931.GA25510@elte.hu> <20080425152650.GA894@elte.hu> <alpine.LFD.1.10.0804250830200.2779@woody.linux-foundation.org> <20080425154854.GC3265@one.firstfloor.org> <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
	Jiri Slaby <jirislaby@gmail.com>,
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
Received: from one.firstfloor.org ([213.235.205.2]:49494 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704AbYDYQNX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Apr 2008 12:13:23 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804250904560.2779@woody.linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 25, 2008 at 09:06:37AM -0700, Linus Torvalds wrote:
> 
> 
> On Fri, 25 Apr 2008, Andi Kleen wrote:
> > 
> > So all these checks can be just removed.
> 
> Quite frankly, I'd rather tighten them up. All the callers actually seem 
> to do just a single-byte one.

I think Mathieu did them to prepare for his immediate values which
need to write more bytes (although actually it would be quite
possible to have immediate values only for byte immediates too)

But that code needs much more infrastructure anyways.

> 
> So I'd suggest really tightening it up to require total natural alignment 

For the common (everything but kprobes) "other code not running"
it doesn't matter and I don't think natural alignment works for the
other cases anyways.

FWIW the original text_poke I started long ago only did bytes

> (rather than the weaker version that required that it fit in an aligned 
> unsigned long or whatever). And I'd suggest using FIXMAP's instead of 
> vmap. Maybe something like the appended (TOTALLY UNTESTED!)

Not sure how the fixmap is better. It's pretty much equivalent, isn't it?
Perhaps a little cheaper, but the code shouldn't be performance critical.

-Andi

