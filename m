From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
Date: Mon, 21 Apr 2008 18:14:09 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <480D1CF1.7010300@gmail.com> <480D208A.9050909@gmail.com> <200804220254.45251.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jiri Slaby <jirislaby@gmail.com>, paulmck@linux.vnet.ibm.com,
	David Miller <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, mingo@elte.hu,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
	herbert@gondor.apana.org.au,
	Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59531 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761462AbYDVBPe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Apr 2008 21:15:34 -0400
In-Reply-To: <200804220254.45251.rjw@sisk.pl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Tue, 22 Apr 2008, Rafael J. Wysocki wrote:
> > 
> > The same place, dentry.d_hash.next is 1. No slub debug clues... I think, I'll 
> > give slab a try. Any other clues?
> 
> Well, SLUB uses some per CPU data structures.  Is it possible that they get
> corrupted and which leads to the observed symptoms?

It really doesn't look like the slub allocations themselves would be 
corrupted. It very much looks like wild pointers corrupting allocations 
that themselves were fine.

The nybble pattern looked intriguing (especially as it apparently also hit 
a normal page cache page!) but obviously not everything matches that 
pattern (eg your value of 1).

What do you do to trigger this? Any particular load? Is it still just 
doing suspend/resume, or do you have something else that you are playing 
with?

Also, have you tried CONFIG_DEBUG_PAGEALLOC? That can also be a very 
powerful way to find memory corruption.

Does anybody see any other patterns? Looking at the modules linked in in 
the oopses from Zdenek, Rafael and Jiri, I don't see anything odd. You 
both all have 80211 support, maybe the corruption comes from the wireless 
layer?

Or maybe it's the x86 code changes themselves, and it really is about the 
suspend/resume sequence itself. Are all the people who see this doing 
suspends? 

		Linus
