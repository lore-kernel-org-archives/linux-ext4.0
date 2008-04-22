From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Tue, 22 Apr 2008 03:30:25 +0200
Message-ID: <200804220330.27034.rjw@sisk.pl>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <200804220254.45251.rjw@sisk.pl> <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jiri Slaby <jirislaby@gmail.com>, paulmck@linux.vnet.ibm.com,
	David Miller <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, mingo@elte.hu,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	herbert@gondor.apana.org.au,
	Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:38113 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761396AbYDVB3s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Apr 2008 21:29:48 -0400
In-Reply-To: <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tuesday, 22 of April 2008, Linus Torvalds wrote:
> 
> On Tue, 22 Apr 2008, Rafael J. Wysocki wrote:
> > > 
> > > The same place, dentry.d_hash.next is 1. No slub debug clues... I think, I'll 
> > > give slab a try. Any other clues?
> > 
> > Well, SLUB uses some per CPU data structures.  Is it possible that they get
> > corrupted and which leads to the observed symptoms?
> 
> It really doesn't look like the slub allocations themselves would be 
> corrupted. It very much looks like wild pointers corrupting allocations 
> that themselves were fine.
> 
> The nybble pattern looked intriguing (especially as it apparently also hit 
> a normal page cache page!) but obviously not everything matches that 
> pattern (eg your value of 1).
> 
> What do you do to trigger this? Any particular load? Is it still just 
> doing suspend/resume, or do you have something else that you are playing 
> with?

I've seen that only once, so far.  Jiri seems to be able to trigger it more often.

> Also, have you tried CONFIG_DEBUG_PAGEALLOC? That can also be a very 
> powerful way to find memory corruption.

I always have CONFIG_DEBUG_PAGEALLOC set.

> Does anybody see any other patterns? Looking at the modules linked in in 
> the oopses from Zdenek, Rafael and Jiri, I don't see anything odd. You 
> both all have 80211 support, maybe the corruption comes from the wireless 
> layer?

Well, I thought about that too.  However, I had a hang before 2.6.25-git2 that
I suspect was related (I couldn't get any information from the box, as it just
hung solid), so I'd rather suspect some x86 changes.

> Or maybe it's the x86 code changes themselves, and it really is about the 
> suspend/resume sequence itself.

It seems to be specific to x86-64, AFAICS.

> Are all the people who see this doing suspends? 

I'm not sure.

Thanks,
Rafael
