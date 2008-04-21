From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Date: Mon, 21 Apr 2008 19:19:01 +0200
Message-ID: <200804211919.03070.rjw@sisk.pl>
References: <200804191522.54334.rjw@sisk.pl> <alpine.LFD.1.10.0804210934190.2779@woody.linux-foundation.org> <480CC9A4.9090503@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"Paul E. McKenney" <paulmck@us.ibm.com>,
	"David S. Miller" <davem@davemloft.net>
To: Jiri Slaby <jirislaby@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([217.79.144.158]:35846 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856AbYDURSv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Apr 2008 13:18:51 -0400
In-Reply-To: <480CC9A4.9090503@gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Monday, 21 of April 2008, Jiri Slaby wrote:
> On 04/21/2008 06:54 PM, Linus Torvalds wrote:
> > Jiri - could you also confirm whether you are usign SLUB (which is not 
> > necessarily at all indicative of a SLUB bug itself - it's just that SLAB 
> > won't ever even merge different allocations of the same size into the same 
> > buckets, so if it's a cross-slab corruption, you'd simply never see it 
> > with SLAB).
> 
> Yeah, I'm using slub. Going to boot to slub_debug.
> 
> Thanks so far.
> 
> BTW. I haven't see this without suspend/resume cycle, do you, Rafael?

Well, I've seen it only once so far. :-)

> It doesn't mean anything, since it needs longer time to trigger, but anyway,
> it might be a clue.

I think we need some more data anyway.

Thanks,
Rafael
