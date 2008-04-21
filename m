From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at
 ffffffffffffffff
Date: Mon, 21 Apr 2008 10:48:08 -0700 (PDT)
Message-ID: <alpine.LFD.1.10.0804211030450.2779@woody.linux-foundation.org>
References: <200804191522.54334.rjw@sisk.pl> <200804202104.24037.rjw@sisk.pl> <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org> <200804211812.16994.rjw@sisk.pl> <alpine.LFD.1.10.0804210934190.2779@woody.linux-foundation.org>
 <480CC9A4.9090503@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"Paul E. McKenney" <paulmck@us.ibm.com>,
	"David S. Miller" <davem@davemloft.net>
To: Jiri Slaby <jirislaby@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754218AbYDURte (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Apr 2008 13:49:34 -0400
In-Reply-To: <480CC9A4.9090503@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On Mon, 21 Apr 2008, Jiri Slaby wrote:
> 
> BTW. I haven't see this without suspend/resume cycle, do you, Rafael? It
> doesn't mean anything, since it needs longer time to trigger, but anyway, it
> might be a clue.

There's a separate (and very different-looking) bug-report about the atl1 
driver having problems when doing an "ifconfig down" on it. In fact, the 
problem report says:

> With this commit in tree, I can reproduce either
> a) kmalloc-2048 corruption after initscripts shutdown eth0
>         http://marc.info/?l=linux-kernel&m=120820360221261&w=2
> 
> b) or oopses at filp_close() first reported long ago
>         (sorry, can't find that email)

where that "or oopses at filp_close()" thing is somewhat interesting, 
since your original bug was about something that looked like file pointer 
corruption.

Now, I doubt you have an ATL chip, and I doubt the two are _really_ 
related in any way (the ATL bug was actually triggered by enabling 64-bit 
DMA), but the filp_close thing makes me go "hmm".

The two affected corrupted SLUB areas were the 2kB allocation (1560-byte 
ethernet packets plus skb_shared_info overhead, anyone?) and apparently 
the one that filp's are in (perhaps a 20-byte TCP ACK packet or other 
"small" packet + the skb_shared_info overhead would be a common case that 
might be in that 200-byte range?)

Maybe the ATL bug isn't ATL-specific at all, but somehow connected to 
NETIF_F_HIGHDMA. Do you have 4GB+ of RAM?

And one thing that suspend/resume does, which is not necessarily commonly 
done during normal operation, is that ifconfig down/up pattern. Maybe 
there is something broken in general there?

			Linus
